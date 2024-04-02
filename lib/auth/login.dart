import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';
import 'package:flutter_application_1/red_popup.dart';

enum LoginStatus {
  none, // find good name for starting state
  waiting,
  success,
  requiresVerification,
  error,
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final textFieldFocusNode = FocusNode();
  final UserProvider _userProvider = UserProvider();

  LoginStatus _loginStatus = LoginStatus.none;
  bool _obscured = true;

  Future<void> _tryLoginEmailPass() async {
    setState(() => _loginStatus = LoginStatus.waiting);
    try {
      final loginResult = await context
          .read<UserProvider>()
          .loginEmailPass(emailController.text, passController.text);
      if (loginResult == AuthResponse.success) {
        _userProvider.setEmail(emailController.text);
        _userProvider.setPassword(passController.text);

        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (_) => const HomePage()));
        _userProvider.setLoggedInStatus(true);

      } else {
        setState(() => _loginStatus = LoginStatus.error);
        _handleLoginError(loginResult);
      }
    } catch (e) {
      setState(() => _loginStatus = LoginStatus.error);
      ErrorPopup(
              text: 'An unexpected error occurred: $e',
              duration: const Duration(seconds: 4))
          .show(context);
    }
  }


  void _handleLoginError(AuthResponse response) {
    String errorMessage = 'Something went wrong, try again later';
    switch (response) {
      case AuthResponse.incorrectPassOrEmail:
        errorMessage = 'Email or Password is not correct';
        break;
      case AuthResponse.otherError:
        break;
      default:
        break;
    }
    ErrorPopup(text: errorMessage, duration: const Duration(seconds: 4))
        .show(context);
  }

  void _changeObscure() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loginStatus == LoginStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => const HomePage(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      );
    }
    return Scaffold(
      appBar: null,
      body: SafeArea(child: _buildLoginContent()),
    );
  }

  Widget _buildLoginContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBackButton(),
        _buildLoginHeader(),
        _buildEmailField(),
        _buildPasswordField(),
        _buildLoginButton(),
        _buildAlternativeLoginOptions(),
        _buildSignUpPrompt(),
      ],
    );
  }

  Widget _buildBackButton() => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24.0),
            color: Provider.of<ThemeProvider>(context)
                .themeData
                .colorScheme
                .onBackground,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );

  Widget _buildLoginHeader() => const Column(
        children: [
          Text('Hello Again!',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins")),
          Text('Welcome back, we missed you tons'),
        ],
      );

  Widget _buildEmailField() => Padding(
        padding: const EdgeInsets.all(20),
        child: ReusableTextField(controller: emailController, hint: 'Email'),
      );

  Widget _buildPasswordField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Provider.of<ThemeProvider>(context)
                .themeData
                .colorScheme
                .onBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: passController,
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                      .themeData
                      .colorScheme
                      .primary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: _changeObscure,
                    child: Icon(
                      _obscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 24,
                      color: Provider.of<ThemeProvider>(context, listen: false)
                          .themeData
                          .colorScheme
                          .primary,
                    ),
                  ),
                ),
                obscureText: _obscured,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
          ),
        ),
      );

  Widget _buildLoginButton() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ReusableButton(
                  buttonText: 'Login', navigate: _tryLoginEmailPass),
            ),
            const SizedBox(height: 16),
            const Text('or login with', style: TextStyle(fontSize: 16.0)),
          ],
        ),
      );

  Widget _buildAlternativeLoginOptions() => const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            ReusableCard(
              assetPath: 'assets/images/img_facebook_round.png',
              cardColor: Colors.white,
            ),
            SizedBox(width: 16),
            ReusableCard(
              assetPath: 'assets/images/img_google.png',
              cardColor: Colors.white,
            ),
          ],
        ),
      );

  Widget _buildSignUpPrompt() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Doesn’t have an account?'),
          TextButton(
            onPressed: () => Navigator.push(context,
                CupertinoPageRoute(builder: (_) => const SignUpPage())),
            child: Text('Sign up!',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Provider.of<ThemeProvider>(context, listen: false)
                      .themeData
                      .colorScheme
                      .onPrimary,
                )),
          ),
        ],
      );
}
