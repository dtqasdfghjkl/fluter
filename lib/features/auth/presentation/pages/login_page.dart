import 'package:flutter/material.dart';
import '../../data/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? error;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final result = await SupabaseService().signIn(
      emailController.text,
      passwordController.text,
    );
    setState(() {
      isLoading = false;
      error = result;
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
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    if (error != null)
                      Text(error!, style: const TextStyle(color: Colors.red)),

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
          );
        },
      ),
    );
  }
}
