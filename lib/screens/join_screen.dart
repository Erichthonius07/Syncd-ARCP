import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';
import 'guest_lobby_screen.dart'; // Import the new screen

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final colors = AppTheme.c(context);

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 32, color: Theme.of(context).iconTheme.color),
                ),
                const SizedBox(height: 40),
                Text("ENTER CODE", style: Theme.of(context).textTheme.displayLarge),
                Text("Ask your host for the ID", style: Theme.of(context).textTheme.bodyMedium),

                const Spacer(),

                NeoCard(
                  color: Theme.of(context).cardColor,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Pixer', fontSize: 40),
                    decoration: const InputDecoration(border: InputBorder.none, hintText: "____"),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),

                const Spacer(),

                // CONNECT BUTTON FIX
                NeoCard(
                  onTap: () {
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text("Enter a code!")));
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connecting to ${controller.text}...")));

                    // Simulate Network Delay then Navigate
                    Future.delayed(const Duration(seconds: 1), () {
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => GuestLobbyScreen(lobbyCode: controller.text))
                        );
                      }
                    });
                  },
                  color: colors.success, // Green for Go
                  isButton: true,
                  child: const Center(
                    child: Text("CONNECT ->", style: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}