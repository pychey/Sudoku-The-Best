import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { app, server } from "./utils/socket.utils.js";
import "./socket/index.socket.js";

dotenv.config();

const PORT = process.env.PORT || 5001;

app.use(cors({ origin: '*' }));
app.use(express.json());

server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running at http://localhost:${PORT}`);
});