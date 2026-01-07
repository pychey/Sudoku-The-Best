import { handleLeaveGame, handlePlaceCorrect, handlePlaceWrong } from "../services/game.service.js";

const handleGameEvents = (socket, io, rooms) => {
    socket.on('place-correct', (data) => handlePlaceCorrect(socket, io, data, rooms));
    socket.on('place-wrong', (data) => handlePlaceWrong(socket, io, data, rooms));
    socket.on('leave-game', () => handleLeaveGame(socket, io, rooms));
}

export default handleGameEvents;