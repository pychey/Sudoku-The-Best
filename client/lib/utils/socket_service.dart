import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  
  static const String serverUrl = 'http://localhost:5001';

  void connect() {
    if (socket != null && socket!.connected) {
      print('Already Connected to Server');
      return;
    }

    socket = IO.io(serverUrl , 
      IO.OptionBuilder()
        .setTransports(['websocket']).build());

    socket!.onConnect((_) {
      print('Connected to Server');
    });

    socket!.onDisconnect((_) {
      print('Disconnected from Server');
    });

    socket!.onConnectError((error) {
      print('Connection Error: $error');
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }

  void joinMatchmaking(String difficulty, String username, List<List<int>> board, List<List<int>> solvedBoard) {
    socket?.emit('join-matchmaking', {
      'difficulty': difficulty,
      'username': username,
      'board': board,
      'solvedBoard': solvedBoard
    });
  }

  void leaveMatchmaking(String difficulty) {
    socket?.emit('leave-matchmaking', {
      'difficulty': difficulty
    });
  }

  void placeCorrect(int row, int col, int number, int newScore) {
    socket?.emit('place-correct', {
      'row': row,
      'col': col,
      'number': number,
      'newScore': newScore
    });
  }

  void placeWrong(int newMistakes) {
    socket?.emit('place-wrong', {
      'newMistakes': newMistakes
    });
  }

  void leaveGame() {
    socket?.emit('leave-game');
  }

  void onMatchmakingJoined(Function(dynamic) callback) {
    socket?.on('matchmaking-joined', callback);
  }

  void onMatchFound(Function(dynamic) callback) {
    socket?.on('match-found', callback);
  }

  void onCellPlacedCorrect(Function(dynamic) callback) {
    socket?.on('cell-placed-correct', callback);
  }

  void onMistakeMade(Function(dynamic) callback) {
    socket?.on('mistake-made', callback);
  }

  void onOpponentLeave(Function(dynamic) callback) {
    socket?.on('opponent-leave', callback);
  }

  void onOpponentDisconnected(Function(dynamic) callback) {
    socket?.on('opponent-disconnected', callback);
  }

  void onGameError(Function(dynamic) callback) {
    socket?.on('game-error', callback);
  }

  void removeAllListeners() {
    socket?.off('matchmaking-joined');
    socket?.off('match-found');
    socket?.off('cell-placed-correct');
    socket?.off('mistake-made');
    socket?.off('opponent-disconnected');
    socket?.off('opponent-leave');
    socket?.off('game-error');
  }
}

// ignore_for_file: avoid_print, library_prefixes