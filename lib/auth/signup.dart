import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/auth/varification.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final textFieldFocusNode = FocusNode();
  final myController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  bool _obscured = true;

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
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: _buildSignUpContent(context),
      ),
    );
  }

  Widget _buildSignUpContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBackButton(context),
        const Text('Welcome!',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        const Text('Create a new account to get a lot of recipes'),
        const SizedBox(height: 16),
        _buildTextField(emailController, 'Email'),
        const SizedBox(height: 16),
        _buildTextField(nameController, 'Name'),
        const SizedBox(height: 16),
        _buildPasswordField(),
        const SizedBox(height: 8),
        _buildSignUpButton(context),
        const Text('or sign up with', style: TextStyle(fontSize: 16.0)),
        _buildSocialSignUpOptions(),
        _buildLoginPrompt(context),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24.0),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      );

  Widget _buildTextField(TextEditingController controller, String hint) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ReusableTextField(controller: controller, hint: hint),
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

  Widget _buildSignUpButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ReusableButton(
          buttonText: 'Sign Up',
          navigate: () => Navigator.push(
              context, CupertinoPageRoute(builder: (_) => VerifyEmailScreen())),
        ),
      );

  Widget _buildSocialSignUpOptions() => const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

  Widget _buildLoginPrompt(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already have an account?'),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Log in!',
              style: TextStyle(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                      .themeData
                      .colorScheme
                      .onPrimary),
            ),
          ),
        ],
      );
}
