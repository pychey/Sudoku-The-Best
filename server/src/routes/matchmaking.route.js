import { joinMatchmaking, leaveMatchmaking } from "../services/matchmaking.service.js";

const handleMatchMakingEvents = (socket, io, rooms) => {
    socket.on('join-matchmaking', (data) => joinMatchmaking(socket, io, data, rooms));
    socket.on('leave-matchmaking', (data) => leaveMatchmaking(socket, data));
}

export default handleMatchMakingEvents;