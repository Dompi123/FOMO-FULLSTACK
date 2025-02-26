// Direct launcher for Cursor IDE
const express = require('express');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const cors = require('cors');

const app = express();

// Cursor IDE specific logging
console.log('Cursor MCP Server starting...');

app.use(express.json());
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

// Basic command execution
app.post('/execute', (req, res) => {
    const { command } = req.body;
    exec(command, (error, stdout, stderr) => {
        if (error) return res.status(500).json({ error: stderr });
        res.json({ output: stdout });
    });
});

// Basic file reading
app.post('/read-file', (req, res) => {
    const { path: filePath } = req.body;
    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ content: data });
    });
});

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'healthy' });
});

const PORT = 5001;
app.listen(PORT, () => {
    console.log(`CURSOR_MCP_READY={"port":${PORT},"pid":${process.pid}}`);
}); 