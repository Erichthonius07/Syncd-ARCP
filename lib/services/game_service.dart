import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../app_icons.dart';


class GameService with ChangeNotifier {
  final List<Game> _games = [
    Game(name: 'Doom', icon: AppIcons.skull),
    Game(name: 'Halo', icon: AppIcons.helmet),
    Game(name: 'Valorant', icon: Icons.sports_esports_outlined),
    Game(name: 'Poker', icon: Icons.casino_outlined),
  ];

  List<Game> get games => _games;
}