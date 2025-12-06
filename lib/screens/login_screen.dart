import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../widgets/cyber_loader.dart';
import '../theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isRegistering = false;

  void _handleAuth() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    String? error;

    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 1500));

    if (_isRegistering) {
      error = await authService.register(username, password);
      if (error == null) {
        setState(() {
          _isRegistering = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: AppTheme.matrixGreen, content: Text("Account Created! Please Login.")),
        );
        return;
      }
    } else {
      error = await authService.login(username, password);
    }

    if (error == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(error)),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final questionColor = isDark ? Colors.grey : Colors.grey[700];
    final actionColor = colors.actionLibrary;

    return Scaffold(
      // FIX: Prevents the background from resizing weirdly
      resizeToAvoidBottomInset: true,
      body: DotGridBackground(
        child: SafeArea(
          // FIX: LayoutBuilder detects available space
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  // FIX: Forces the content to be at least as tall as the screen
                  // enabling Spacers to work when keyboard is closed,
                  // and scrolling to work when keyboard is open.
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.cyberYellow,
                              border: Border.all(width: 4, color: Colors.black),
                              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
                            ),
                            child: const Text(
                              "SYNC'D",
                              style: TextStyle(fontFamily: 'Pixer', fontSize: 48, color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 40),

                          Text(
                            _isRegistering ? "CREATE ACCOUNT" : "WELCOME BACK",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 20),

                          // Inputs
                          NeoCard(
                            color: Theme.of(context).cardColor,
                            child: TextField(
                              controller: _usernameController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: const InputDecoration(
                                hintText: "USERNAME",
                                border: InputBorder.none,
                                icon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          NeoCard(
                            color: Theme.of(context).cardColor,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: const InputDecoration(
                                hintText: "PASSWORD",
                                border: InputBorder.none,
                                icon: Icon(Icons.lock),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Login Button
                          NeoCard(
                            color: _isRegistering ? AppTheme.electricBlue : AppTheme.hotPink,
                            isButton: true,
                            onTap: _isLoading ? null : _handleAuth,
                            child: Center(
                              child: _isLoading
                                  ? CyberLoader(size: 24, color: Colors.black)
                                  : Text(
                                  _isRegistering ? "REGISTER" : "PRESS START",
                                  style: const TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Colors.black)
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Toggle
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRegistering = !_isRegistering;
                                _usernameController.clear();
                                _passwordController.clear();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isRegistering ? "Already have an account? " : "New player? ",
                                  style: TextStyle(fontFamily: 'Pixer', fontSize: 14, color: questionColor),
                                ),
                                Text(
                                  _isRegistering ? "LOGIN" : "CREATE",
                                  style: TextStyle(
                                    fontFamily: 'Pixer', fontSize: 14,
                                    color: actionColor, fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: actionColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Push content up when keyboard shows
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}