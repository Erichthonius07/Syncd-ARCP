import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class ControllerScreen extends StatefulWidget {
  final String gameCode;
  const ControllerScreen({super.key, required this.gameCode});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  @override
  void initState() {
    super.initState();
    // Force Landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Connect Socket (Safe Mode)
    final socket = Provider.of<SocketService>(context, listen: false);
    socket.currentGameCode = widget.gameCode;
    socket.connectIfNeeded();
  }

  @override
  void dispose() {
    // Reset to Portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketService>(context, listen: false);
    final colors = AppTheme.c(context);

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- LEFT: D-PAD ---
                Expanded(
                  flex: 3,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double size = constraints.maxHeight / 3.5;
                      if (size > 70) size = 70;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _dPadBtn(socket, "UP", Icons.arrow_upward, size, colors),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: Center(child: _dPadBtn(socket, "LEFT", Icons.arrow_back, size, colors))),
                              Expanded(child: Container()),
                              Expanded(child: Center(child: _dPadBtn(socket, "RIGHT", Icons.arrow_forward, size, colors))),
                            ],
                          ),
                          _dPadBtn(socket, "DOWN", Icons.arrow_downward, size, colors),
                        ],
                      );
                    },
                  ),
                ),

                // --- CENTER: INFO ---
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeoCard(
                        color: colors.surface,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("LOBBY", style: Theme.of(context).textTheme.labelSmall),
                            Text(
                              widget.gameCode,
                              style: const TextStyle(fontFamily: 'Pixer', fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      NeoCard(
                        onTap: () => Navigator.pop(context),
                        color: AppTheme.hotPink,
                        child: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),

                // --- RIGHT: ACTION BUTTONS ---
                Expanded(
                  flex: 3,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double size = constraints.maxHeight / 2.5;
                      if (size > 80) size = 80;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _actionBtn(socket, "B", AppTheme.hotPink, size),
                          const SizedBox(width: 20),
                          _actionBtn(socket, "A", AppTheme.matrixGreen, size),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dPadBtn(SocketService socket, String key, IconData icon, double size, SyncPalette colors) {
    return GestureDetector(
      onTapDown: (_) {
        socket.sendInput("${key}_DOWN");
      },
      onTapUp: (_) => socket.sendInput("${key}_UP"),
      child: NeoCard(
        height: size,
        // Use Dark Grey for D-Pad to look like hardware
        color: const Color(0xFF333333),
        isButton: true,
        child: Center(
          child: Icon(icon, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }

  Widget _actionBtn(SocketService socket, String key, Color color, double size) {
    return GestureDetector(
      onTapDown: (_) {
        socket.sendInput("BTN_${key}_DOWN");
      },
      onTapUp: (_) => socket.sendInput("BTN_${key}_UP"),
      child: SizedBox(
        width: size,
        child: NeoCard(
          height: size,
          color: color,
          isButton: true,
          child: Center(
            child: Text(
                key,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.4,
                    fontFamily: 'Pixer',
                    color: Colors.black
                )
            ),
          ),
        ),
      ),
    );
  }
}