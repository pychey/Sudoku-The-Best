import 'package:flutter/material.dart';
import 'package:sudoku_the_best/data/repository/player_repository.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/models/player_profile.dart';
import 'package:sudoku_the_best/ui/screens/home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _startGame() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _loading = true;
    });

    final repo = PlayerRepository();
    Player? player = await repo.loadPlayerByUsername(username);

    if (player == null) {
      // Create a new player
      player = Player(
        playerId: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        friends: [],
        profile: PlayerProfile.newProfile(),
      );
      print('Created new player: ${player.username}');
    }

    setState(() {
      _loading = false;
    });

    // Navigate to HomePage with the player
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(initialPlayer: player!)),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _startGame,
                      child: const Text('Start Game'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
