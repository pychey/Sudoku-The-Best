export const handlePlaceCorrect = (socket, io, data, rooms) => {
    const roomId = socket.data.roomId;
    const room = rooms.get(roomId);
    const player = room.players.find(p => p.socketId === socket.id);
    const { row, col, number, newScore } = data;
    
    player.score = newScore;
    
    io.to(roomId).emit('cell-placed-correct', {
        playerId: socket.id,
        playerUsername: player.username,
        row,
        col,
        number,
        newScore
    });
};

export const handlePlaceWrong = (socket, io, data, rooms) => {
    const roomId = socket.data.roomId;
    const room = rooms.get(roomId);
    const player = room.players.find(p => p.socketId === socket.id);
    const { newMistakes } = data;

    player.mistakes = newMistakes;
    
    io.to(roomId).emit('mistake-made', {
        playerId: socket.id,
        playerUsername: player.username,
        newMistakes
    });
};

export const handleLeaveGame = (socket, io, rooms) => {
    const roomId = socket.data.roomId;
    const room = rooms.get(roomId);
    const opponent = room.players.find(p => p.socketId !== socket.id);

    io.to(opponent.socketId).emit('opponent-leave');
    
    room.isGameOver = true;
    setTimeout(() => {
        rooms.delete(roomId);
    }, 5000);
} 