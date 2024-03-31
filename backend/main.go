package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/labstack/echo/v5"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/models"
)

func MyMap[T, V any](ts []T, fn func(*T) V) []V {
	result := make([]V, len(ts))
	for i, t := range ts {
		result[i] = fn(&t)
	}
	return result
}

type queryLikedResponse struct {
	Successful bool              `json:"successful"`
	ErrMsg     string            `json:"err_msg,omitempty"`
	Liked      []json.RawMessage `json:"liked,omitempty"`
}

func queryLiked(c echo.Context) error {
	logger := app.Logger()
	record, sucsess := c.Get(apis.ContextAuthRecordKey).(*models.Record)
	if !sucsess {
		return c.JSON(404, queryLikedResponse{
			Successful: false,
			ErrMsg:     "Can't get cast to model, error",
		})
	}

	userLikedIds, success := record.Get("liked").([]string)
	if !success {
		return c.JSON(404, queryLikedResponse{
			Successful: false,
			ErrMsg:     "Can't get liked id's",
		})
	}

	ids := MyMap(userLikedIds, func(id *string) interface{} {
		return id
	})

	likedRecipes, err := app.Dao().
		FindRecordsByExpr("recipies", dbx.In("id", ids...))

	if err != nil {
		return c.JSON(402, queryLikedResponse{
			Successful: false,
			ErrMsg:     fmt.Sprintf("Can't get liked recipies, got error: %s", err.Error()),
		})
	}

	logger.Info(fmt.Sprintf("Type of likedRecipies is: %v\n", likedRecipes))

	mapToMap := func(r **models.Record) json.RawMessage {
		jsonStr, _ := (**r).MarshalJSON()
		return jsonStr
	}

	return c.JSON(200, queryLikedResponse{
		Successful: true,
		Liked:      MyMap(likedRecipes, mapToMap),
	})
}

type queryCreatedResponse struct {
	Successful bool              `json:"successful"`
	ErrMsg     string            `json:"err_msg,omitempty"`
	Created    []json.RawMessage `json:"liked,omitempty"`
}

func queryCreated(c echo.Context) error {
	logger := app.Logger()
	record, sucsess := c.Get(apis.ContextAuthRecordKey).(*models.Record)
	if !sucsess {
		return c.JSON(404, queryCreatedResponse{
			Successful: false,
			ErrMsg:     "Can't get cast to model, error",
		})
	}

	createdRecipies, err := app.Dao().
		FindRecordsByExpr("recipies", dbx.In("creator", record.Id))

	if err != nil {
		return c.JSON(402, queryCreatedResponse{
			Successful: false,
			ErrMsg:     fmt.Sprintf("Can't get created recipies, got error: %s", err.Error()),
		})
	}

	logger.Info(fmt.Sprintf("likedRecipies are: %v\n", createdRecipies))

	mapToMap := func(r **models.Record) json.RawMessage {
		jsonStr, _ := (**r).MarshalJSON()
		return jsonStr
	}

	return c.JSON(200, queryCreatedResponse{
		Successful: true,
		Created:    MyMap(createdRecipies, mapToMap),
	})
}

type CreateRecipieIngridient struct {
	Name string `json:"name,omitempty"`
}

type CreateRecipieStep struct {
	Text string `json:"text,omitempty"`
}

type CreateRecipieRequestBody struct {
	Title       string                    `json:"title,omitempty"`
	Description string                    `json:"description,omitempty"`
	Ingridients []CreateRecipieIngridient `json:"ingridients,omitempty"`
	Steps       []CreateRecipieStep       `json:"steps,omitempty"`
}

type CreateRecipieResponse struct {
	Sucsess bool   `json:"sucsess,omitempty"`
	ErrMsg  string `json:"err_msg,omitempty"`
}

func createRecipie(c echo.Context) error {
	logger := app.Logger()
	auth, sucsess := c.Get(apis.ContextAuthRecordKey).(*models.Record)
	if !sucsess {
		return c.JSON(404, queryCreatedResponse{
			Successful: false,
			ErrMsg:     "Can't get cast to model, error",
		})
	}

	var reqBody CreateRecipieRequestBody
	err := c.Bind(&reqBody)
	if err != nil {
		return c.JSON(402, queryCreatedResponse{
			Successful: false,
			ErrMsg:     fmt.Sprintf("Unable to parse request body, error: %s", err.Error()),
		})
	}

	recipiesRecord, _ := app.Dao().FindCollectionByNameOrId("recipies")
	recipie := models.NewRecord(recipiesRecord)
	recipie.Load(map[string]any{
		"title":       reqBody.Title,
		"description": reqBody.Description,
		"creator":     auth.Id,
	})

	daoWOHooks := app.Dao().WithoutHooks()
	daoWOHooks.Save(recipie)

	ingridientsRecord, _ := app.Dao().FindCollectionByNameOrId("ingridients")
	ingridientsIds := MyMap(reqBody.Ingridients, func(ing *CreateRecipieIngridient) string {
		ingridient := models.NewRecord(ingridientsRecord)
		ingridient.Load(map[string]any{
			"name":    ing.Name,
			"recipie": recipie.Id,
		})
		daoWOHooks.Save(ingridient)

		return ingridient.Id
	})
	recipie.Set("ingridients", ingridientsIds)

	cookingStepsRecord, _ := app.Dao().FindCollectionByNameOrId("cookingsteps")
	cookingStepsIds := MyMap(reqBody.Steps, func(step *CreateRecipieStep) string {
		s := models.NewRecord(cookingStepsRecord)
		s.Load(map[string]any{
			"text":    step.Text,
			"recipie": recipie.Id,
		})
		daoWOHooks.Save(s)

		return s.Id
	})
	recipie.Set("steps", cookingStepsIds)
	daoWOHooks.Save(recipie)

	logger.Info("Triggering create hooks")
	dao := app.Dao()
	dao.AfterCreateFunc(dao, recipiesRecord)
	dao.AfterCreateFunc(dao, ingridientsRecord)
	dao.AfterCreateFunc(dao, cookingStepsRecord)

	return c.JSON(200, CreateRecipieResponse{
		Sucsess: true,
	})
}

var app *pocketbase.PocketBase

// TODO: better logging
func main() {
	app = pocketbase.New()

	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		e.Router.AddRoute(echo.Route{
			Method:  http.MethodGet,
			Path:    "/api/query-liked-recipies",
			Handler: queryLiked,
			Middlewares: []echo.MiddlewareFunc{
				apis.ActivityLogger(app),
				apis.RequireRecordAuth("users"),
			},
		})

		e.Router.AddRoute(echo.Route{
			Method:  http.MethodGet,
			Path:    "/api/query-created-recipies",
			Handler: queryCreated,
			Middlewares: []echo.MiddlewareFunc{
				apis.ActivityLogger(app),
				apis.RequireRecordAuth("users"),
			},
		})

		e.Router.AddRoute(echo.Route{
			Method:  http.MethodPost,
			Path:    "/api/create-recipie",
			Handler: createRecipie,
			Middlewares: []echo.MiddlewareFunc{
				apis.ActivityLogger(app),
				apis.RequireRecordAuth("users"),
			},
		})

		return nil
	})

	app.OnModelAfterCreate().Add(func(e *core.ModelEvent) error {
		// is ok since models.BaseModel is first in the struct models.Collection
		fmt.Println("Create on tags: ", e.Model.(*models.Collection).Name)
		return nil
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
