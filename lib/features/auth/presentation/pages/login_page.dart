import 'package:flutter/material.dart';
import 'package:flutter_app/core/common/widgets/loader.dart';
import 'package:flutter_app/core/utils/show_snackbar.dart';
import 'package:flutter_app/core/utils/validators.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
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
                      setState(() {
                        isLoading = false;
                        _errorEmail = state.message;
                      });
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
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: _errorEmail,
                            ),
                            validator: AuthValidators.validateEmail,
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              errorText: _errorPassword,
                            ),
                            obscureText: true,
                            validator: AuthValidators.validatePassword,
                          ),
                          const SizedBox(height: 16),
                          // 👉 SizedBox chiếm toàn bộ phần còn lại
                          // Expanded(
                          //   child: Container(
                          //     constraints: const BoxConstraints(minHeight: 100),
                          //     color: Colors.grey[200], // để dễ thấy vùng chiếm
                          //     child: const Center(
                          //       child: Text('Vùng chiếm toàn bộ phần còn lại'),
                          //     ),
                          //   ),
                          // ),
                          ElevatedButton(
                            onPressed: isLoading ? null : login,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Login'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/signup',
                              );
                            },
                            child: const Text('Chưa có tài khoản? Đăng ký'),
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
