import 'package:flutter/material.dart';
import 'package:sudoku_the_best/data/repository/player_repository.dart';
import 'package:sudoku_the_best/models/game_result_data.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/models/player_profile.dart'; 
import 'package:sudoku_the_best/ui/screens/game_screen/game_screen.dart';
import 'package:sudoku_the_best/ui/screens/home_tabs/friend_tab.dart';
import 'package:sudoku_the_best/ui/screens/home_tabs/home_tab.dart';
import 'package:sudoku_the_best/ui/screens/home_tabs/profile_tab.dart';
import 'package:sudoku_the_best/ui/widgets/duel_mode_dialog.dart';
import 'package:sudoku_the_best/ui/widgets/play_mode_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Player? currentPlayer;
  List<Player> friends = [];

  @override
  void initState() {
    super.initState();
    _loadPlayer();
  }

  Future<void> _loadPlayer() async {
    final repository = PlayerRepository();
    final player = await repository.loadPlayerById("p1"); 

    if (player != null) {
      final friendPlayers = await repository.loadPlayersByIds(player.friendIds);
  
      setState(() { 
        currentPlayer = player;
        friends = friendPlayers;
      });
    }    
  }

  Future<void> _handlePlaySolo(BuildContext context) async {
    final difficulty = await showPlayModeDialog(context);

    if (difficulty == null) return;

    final resultData = await Navigator.push<GameResultData>(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(difficulty: difficulty),
      ),
    );

    if (resultData == null || currentPlayer == null) return;
    
    switch(resultData.result) {
      case GameResult.quit:
        print('QUIT');
        
        break;

        case GameResult.completed:
          _updateProfileAfterGame(difficulty, true, resultData.elapsedSeconds);
          break;

        case GameResult.failed:
          _updateProfileAfterGame(difficulty, false, resultData.elapsedSeconds);
          break;
    }
  }

  void _handlePlayDuel(DuelMode mode) {
    switch (mode) {
      case DuelMode.online:
        print('Lg online');
        break;
      case DuelMode.friend:
        setState(() {
          _currentIndex = 1; 
        });
        break;
    }
  }

  void _updateProfileAfterGame(Difficulty difficulty, bool isWin, int elapsedSeconds) {
    final profile = currentPlayer!.profile;

    setState(() {
      profile.gamesPlayed[difficulty] = (profile.gamesPlayed[difficulty] ?? 0) + 1;

      if (isWin) {
        profile.gamesCompleted[difficulty] = (profile.gamesCompleted[difficulty] ?? 0) + 1;

        final bestTime = profile.bestTimes[difficulty] ?? 0;
        if (bestTime == 0 || elapsedSeconds < bestTime) {
          profile.bestTimes[difficulty] = elapsedSeconds;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {  
    if (currentPlayer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tabs = [
      HomeTab(
        onPlaySolo: () => _handlePlaySolo(context),
        onPlayDuel: _handlePlayDuel,
        player: currentPlayer!
      ),
      FriendTab(friends: friends),
      ProfileTab(profile: currentPlayer?.profile ?? PlayerProfile(
        gamesPlayed: {},
        gamesCompleted: {},
        bestTimes: {},
      ))
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title:  const Text('Sudoku the BEST'),
      // ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: false, 
        child: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
