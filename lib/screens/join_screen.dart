import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';
import 'guest_lobby_screen.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController codeController = TextEditingController();
  int selectedSlot = 1;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Important
      body: DotGridBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
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

                          const SizedBox(height: 24),

                          NeoCard(
                            color: Theme.of(context).cardColor,
                            child: TextField(
                              controller: codeController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'Pixer', fontSize: 40),
                              decoration: const InputDecoration(border: InputBorder.none, hintText: "____"),
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),

                          const SizedBox(height: 24),
                          Text("SELECT PLAYER SLOT", style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 12),

                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Disable grid scroll, let page scroll
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.5,
                            children: List.generate(4, (index) {
                              final slot = index + 1;
                              final isSelected = selectedSlot == slot;
                              return GestureDetector(
                                onTap: () => setState(() => selectedSlot = slot),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? colors.success : colors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 2,
                                      color: isSelected ? colors.success : colors.outline,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "P$slot",
                                      style: TextStyle(
                                        fontFamily: 'Pixer',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.black : Theme.of(context).textTheme.bodyLarge!.color,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const Spacer(),

                          NeoCard(
                            onTap: () {
                              if (codeController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text("Enter a code!")));
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GuestLobbyScreen(
                                    lobbyCode: codeController.text,
                                    playerSlot: selectedSlot,
                                  ),
                                ),
                              );
                            },
                            color: colors.success,
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
            },
          ),
        ),
      ),
    );
  }
}