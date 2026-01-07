import 'package:flutter/material.dart';
import 'package:sudoku_the_best/data/repository/player_repository.dart';
import 'package:sudoku_the_best/models/game_result_data.dart';
import 'package:sudoku_the_best/models/game_state.dart';
import 'package:sudoku_the_best/models/player.dart';
import 'package:sudoku_the_best/ui/screens/game_screen/game_screen.dart';
import 'package:sudoku_the_best/ui/screens/home_tabs/friend_tab.dart';
import 'package:sudoku_the_best/ui/screens/home_tabs/home_tab.dart';
import 'package:sudoku_the_best/ui/screens/home_tabs/profile_tab.dart';
import 'package:sudoku_the_best/ui/widgets/add_friend_dialog.dart';
import 'package:sudoku_the_best/ui/widgets/duel_mode_dialog.dart';
import 'package:sudoku_the_best/ui/widgets/play_mode_dialog.dart';

class HomePage extends StatefulWidget {
  final Player? initialPlayer;

  const HomePage({super.key, this.initialPlayer});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late Player? currentPlayer;

  @override
  void initState() {
    super.initState();
    if (widget.initialPlayer != null) {
      currentPlayer = widget.initialPlayer;
    } else {
      _loadPlayer();
    }
  }

  Future<void> _loadPlayer() async {
    final repository = PlayerRepository();
    final player = await repository.loadPlayerById("p1"); 
    if (player != null) {  
      setState(() { 
        currentPlayer = player;
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
    setState(() {
      currentPlayer!.profile.updateAfterGame(
        difficulty: difficulty,
        isWin: isWin,
        elapsedSeconds: elapsedSeconds,
      );
    });
  }

  Future<void> handleAddFriend() async {
    final name = await showAddFriendDialog(context); 
    if (name != null && currentPlayer != null) {
      try {
        final updatedPlayer = await currentPlayer!.addFriend(name);

        setState(() {
          currentPlayer = updatedPlayer; 
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
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
      FriendTab(friends: currentPlayer!.friends, onAddFriendClick: handleAddFriend),
      ProfileTab(player: currentPlayer!)
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title:  const Text('Sudoku the BEST'),
      // ),
      body: SafeArea(
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
