import 'package:flutter/material.dart';

// ✅ 1. CONVERT to a StatefulWidget to manage the text field's state
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  // ✅ 2. CREATE a controller to read the text field's value
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _joinGame() {
    if (_controller.text.isNotEmpty) {
      // In a real app, you would send this code to a server.
      // For now, we'll just show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text('Joining game with code: ${_controller.text}...'),
        ),
      );
      // You could navigate to a "Lobby" screen here
    } else {
      // Show an error if the field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: const Text('Please enter a game code.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.connect_without_contact,
              size: 80,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 20),
            Text(
              'Enter a game code to join your friends.',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller, // ✅ 3. ASSIGN the controller
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 24,
                letterSpacing: 8,
              ),
              decoration: InputDecoration(
                hintText: 'GAME CODE',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                  letterSpacing: 4,
                ),
                filled: true,
                fillColor: Colors.black.withAlpha(51),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinGame, // ✅ 4. CALL the join logic
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}