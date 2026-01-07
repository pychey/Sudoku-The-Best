import { faker } from '@faker-js/faker';

const matchmakingQueues = {
    easy: [],
    medium: [],
    hard: []
};

export const joinMatchmaking = (socket, io, data, rooms) => {
    const { difficulty, username, board, solvedBoard } = data;
    
    const queue = matchmakingQueues[difficulty];
    
    queue.push({
        socketId: socket.id,
        username,
        board,
        solvedBoard,
    });
    
    socket.emit('matchmaking-joined', {
        message: 'Searching for Opponent...',
    });
    
    console.log(`Player ${username} joined ${difficulty} queue. Queue size: ${queue.length}`);
    
    if (queue.length >= 2) {
        const player1 = queue.shift();
        const player2 = queue.shift();
        
        createMatch(io, player1, player2, difficulty, rooms);
    }
};

export const leaveMatchmaking = (socket, data) => {
    const { difficulty } = data;
    
    const queue = matchmakingQueues[difficulty];
    
    const index = queue.findIndex(p => p.socketId === socket.id);
    if (index !== -1) {
        queue.splice(index, 1);
        socket.emit('matchmaking-left', { message: 'Matchmaking Cancelled' });
    }
};

function createMatch(io, player1, player2, difficulty, rooms) {
    const roomId = faker.string.alphanumeric(6).toUpperCase();
    
    const { board, solvedBoard } = player1;
    
    const room = {
        roomId,
        difficulty,
        board,
        solvedBoard,
        players: [
            {
                socketId: player1.socketId,
                username: player1.username,
                score: 0,
                mistakes: 0,
            },
            {
                socketId: player2.socketId,
                username: player2.username,
                score: 0,
                mistakes: 0,
            }
        ],
        isGameOver: false
    };
    
    rooms.set(roomId, room);
    
    const socket1 = io.sockets.sockets.get(player1.socketId);
    const socket2 = io.sockets.sockets.get(player2.socketId);
    
    if (socket1 && socket2) {
        socket1.join(roomId);
        socket2.join(roomId);
        
        socket1.data.roomId = roomId;
        socket2.data.roomId = roomId;
        
        io.to(roomId).emit('match-found', {
            roomId,
            difficulty,
            board,
            solvedBoard,
            opponent: {
                [player1.socketId]: player2.username,
                [player2.socketId]: player1.username
            }
        });
        
        console.log(`Match created: ${player1.username} vs ${player2.username} (${difficulty})`);
    }
}