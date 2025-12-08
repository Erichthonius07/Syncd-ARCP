import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
// Assuming CyberLoader is a custom widget you have, if not, use CircularProgressIndicator
// import '../widgets/cyber_loader.dart';
import '../theme.dart';
import '../services/socket_service.dart'; // Import SocketService
import '../providers/auth_provider.dart'; // Use AuthProvider instead of direct AuthService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Using AuthProvider's loading state is better, but local state works for the toggle animation
  bool _isRegistering = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuth() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please fill all fields")
        ),
      );
      return;
    }

    // Use the Provider to handle auth state
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String? error; // Null means success

    if (_isRegistering) {
      // Register Logic
      final result = await authProvider.register(username, "placeholder@email.com", password);
      // Note: Your UI doesn't have an email field yet, passing placeholder or you can add the field.
      // Ideally, update UI to ask for email if registering.

      if (result == "Success") {
        setState(() {
          _isRegistering = false; // Switch to login mode after success
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Account Created! Please Login.")
            ),
          );
        }
        return;
      } else {
        error = result;
      }
    } else {
      // Login Logic
      final success = await authProvider.login(username, password);
      if (!success) {
        error = "Invalid credentials or connection failed";
      }
    }

    if (mounted) {
      if (error == null) {
        // --- LOGIC FROM 1st BLOCK: Connect WebSocket ---
        final token = authProvider.token;
        if (token != null) {
          Provider.of<SocketService>(context, listen: false).connect(token);
        }

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider for loading state
    final isLoading = context.watch<AuthProvider>().isLoading;

    final colors = AppTheme.c(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final questionColor = isDark ? Colors.grey : Colors.grey[700];
    final actionColor = colors.actionLibrary;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DotGridBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
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
                            isButton: !isLoading,
                            onTap: isLoading ? null : _handleAuth,
                            child: Center(
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.black)
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