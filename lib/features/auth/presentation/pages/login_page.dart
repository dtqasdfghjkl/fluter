import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/common/widgets/loader.dart';
import 'package:flutter_app/core/theme/app_pallete.dart';
import 'package:flutter_app/core/utils/show_snackbar.dart';
import 'package:flutter_app/core/utils/validators.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? _errorEmail;
  String? _errorPassword;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      _errorEmail = null;
      _errorPassword = null;
    });
    context.read<AuthBloc>().add(
      AuthLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    // final result = await SupabaseService().signIn(
    //   emailController.text,
    //   passwordController.text,
    // );
    // setState(() {
    //   isLoading = false;
    //   _errorEmail = result;
    // });
    // if (result == null) {
    //   // Login success, navigate to home or show success
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text('Login thành công!')));

    //   Navigator.pushReplacementNamed(context, '/');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      showSnackBar(context, state.message);
                    } else if (state is AuthSuccess) {
                      isLoading = false;
                      // Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Loader();
                    }
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign in.",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          AuthField(
                            hintText: 'Email',
                            controller: emailController,
                            validator: AuthValidators.validateEmail,
                          ),
                          const SizedBox(height: 15),
                          AuthField(
                            hintText: 'Password',
                            controller: passwordController,
                            obscureText: true,
                            validator: AuthValidators.validatePassword,
                          ),

                          const SizedBox(height: 20),
                          AuthGradientButton(login: login, text: 'Login'),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: 'Chưa có tài khoản? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Đăng ký',
                                  style: TextStyle(
                                    color: AppPallete.gradient2,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        SignUpPage.route(),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
