import 'package:flutter/material.dart';
import 'package:sudoku_the_best/data/repository/player_repository.dart';
import 'package:sudoku_the_best/models/entities/player.dart';
import 'package:sudoku_the_best/ui/tabs/friend_tab.dart';
import 'package:sudoku_the_best/ui/tabs/home_tab.dart';
import 'package:sudoku_the_best/ui/tabs/profile_tab.dart';

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

  void _goToFriendsTab() {
    setState(() {
      _currentIndex = 1; 
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
      HomeTab(onGoToFriends: _goToFriendsTab, player: currentPlayer!),
      FriendTab(friends: friends),
      ProfileTab()
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
