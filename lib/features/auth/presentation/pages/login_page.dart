import 'package:flutter/material.dart';
import '../../data/supabase_service.dart';
import '../../utils/validators.dart';

class LoginPage extends StatefulWidget {
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
    final result = await SupabaseService().signIn(
      emailController.text,
      passwordController.text,
    );
    setState(() {
      isLoading = false;
      _errorEmail = result;
    });
    if (result == null) {
      // Login success, navigate to home or show success
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login thành công!')));

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Login')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(
                child: Form(
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
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text('Chưa có tài khoản? Đăng ký'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
