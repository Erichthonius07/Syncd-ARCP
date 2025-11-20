import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Text("FEEDBACK", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                  ],
                ),
                const SizedBox(height: 40),

                // Rating
                const Center( // Added const
                  child: NeoCard(
                    color: AppTheme.cyberYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [ // Removed const from list, added to items implicitly
                        Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star, size: 40, color: Colors.black),
                        Icon(Icons.star_border, size: 40, color: Colors.black),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Text("YOUR THOUGHTS?", style: TextStyle(fontFamily: 'Pixer', fontSize: 18)),
                const SizedBox(height: 8),

                const Expanded( // Added const
                  child: NeoCard(
                    color: Colors.white,
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "We love hearing from you...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                NeoCard(
                  color: AppTheme.electricBlue,
                  isButton: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Feedback Received!")),
                    );
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text("SUBMIT", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}