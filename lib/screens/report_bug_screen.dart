import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class ReportBugScreen extends StatelessWidget {
  const ReportBugScreen({super.key});

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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("BUG REPORT", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Subject Input
                const Text("SUBJECT", style: TextStyle(fontFamily: 'Pixer', fontSize: 18)),
                const SizedBox(height: 8),
                const NeoCard( // Added const
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "e.g. Game crashed on load",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description Input
                const Text("DETAILS", style: TextStyle(fontFamily: 'Pixer', fontSize: 18)),
                const SizedBox(height: 8),
                const Expanded( // Added const
                  child: NeoCard(
                    color: Colors.white,
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Describe what happened...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Submit
                NeoCard(
                  color: AppTheme.hotPink,
                  isButton: true,
                  onTap: () {
                    // Mock Submit
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Report Sent! Thanks for helping.")),
                    );
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text("SEND REPORT", style: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Colors.white)),
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