import handleGameEvents from "../routes/game.route.js";
import handleMatchMakingEvents from "../routes/matchmaking.route.js";
import { io } from "../utils/socket.utils.js";

const connectedUsers = new Set();
const rooms = new Map();

io.on('connection', (socket) => {
    connectedUsers.add(socket.id);
    console.log('Player connected:', socket.id);
    console.log('Online:', connectedUsers.size);
    
    handleMatchMakingEvents(socket, io, rooms);
    handleGameEvents(socket, io, rooms);
    
    socket.on('disconnect', () => {
        connectedUsers.delete(socket.id);
        console.log('Player disconnected:', socket.id);
        console.log('Online players:', connectedUsers.size);
        
        const roomId = socket.data.roomId;
        if (!roomId) return;
        
        const room = rooms.get(roomId);
        if (!room || room.isGameOver) return;
        
        const disconnectedPlayer = room.players.find(p => p.socketId === socket.id);
        const otherPlayer = room.players.find(p => p.socketId !== socket.id);
        
        if (disconnectedPlayer && otherPlayer) {
            const io = socket.server;
            io.to(otherPlayer.socketId).emit('opponent-disconnected', {
                message: `${disconnectedPlayer.username} disconnected`
            });
            
            room.isGameOver = true;
            setTimeout(() => {
                rooms.delete(roomId);
            }, 5000);
        }
    });
});