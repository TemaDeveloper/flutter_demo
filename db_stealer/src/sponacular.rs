use std::fmt;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct Recipe {
    vegetarian: bool,
    vegan: bool,
    gluten_free: Option<bool>,
    dairy_free: Option<bool>,
    very_healthy: Option<bool>,
    cheap: Option<bool>,
    very_popular: Option<bool>,
    sustainable: Option<bool>,
    low_fodmap: Option<bool>,
    ready_in_minutes: Option<u32>,
    servings: Option<u32>,
    weight_watcher_smart_points: Option<u32>,
    preparation_minutes: Option<i32>,
    cooking_minutes: Option<i32>,
    aggregate_likes: Option<u32>,
    health_score: Option<u32>,
    price_per_serving: Option<f64>,
    summary: String,
    title: String,
    #[serde(default)]
    cuisines: Vec<String>,
    #[serde(default)]
    dish_types: Vec<String>,
    #[serde(default)]
    diets: Vec<String>,
    #[serde(default)]
    occasions: Vec<String>,

    id: u32,
    #[serde(default)]
    source_name: String,
    #[serde(default)]
    source_url: String,
    image: String,
    spoonacular_score: Option<f64>,
    #[serde(default)]
    spoonacular_source_url: String,
}

impl Recipe {
    fn to_csv_str(&self) -> String {
        format!("{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",\"{}\",{},{},{},{},{},{}",
            self.vegetarian,
            self.vegan,
            self.gluten_free
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.dairy_free
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.very_healthy
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.cheap
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.very_popular
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.sustainable
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.low_fodmap
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.ready_in_minutes
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.servings
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.weight_watcher_smart_points
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.preparation_minutes
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.cooking_minutes
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.aggregate_likes
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.health_score
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.price_per_serving
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.summary.replace(",", ";"),
            self.title.replace(",", ";"),
            self.cuisines.join(";"),
            self.dish_types.join(";"),
            self.diets.join(";"),
            self.occasions.join(";"),
            self.id,
            self.source_name.replace(",", ";"),
            self.source_url,
            self.image,
            self.spoonacular_score
                .map(|v| v.to_string())
                .unwrap_or("none".to_string()),
            self.spoonacular_source_url
        )
    }
}

pub fn recipe_csv_header() -> &'static str {
    "vegetarian,vegan,gluten_free,dairy_free,very_healthy,cheap,very_popular,sustainable,low_fodmap,ready_in_minutes,servings,weight_watcher_smart_points,preparation_minutes,cooking_minutes,aggregate_likes,health_score,price_per_serving,summary,title,cuisines,dish_types,diets,occasions,id,source_name,source_url,image,spoonacular_score,spoonacular_source_url"
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Response {
    #[serde(skip)]
    pub idx: usize,
    pub results: Vec<Recipe>,
}

impl fmt::Display for Response {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let str_rep = self
            .results
            .iter()
            .enumerate()
            .map(|(i, recp)| {
                format!(
                    "{},{}\n",
                    i + self.idx,
                    recp.to_csv_str(),
                )
            })
            .collect::<Vec<_>>()
            .join("");
        write!(f, "{}", str_rep)?;
        Ok(())
    }
}
