#!/usr/bin/env node

const path = require('path');
const { spawn } = require('child_process');

// Get the absolute path to the server.js file
const serverPath = path.join(__dirname, '..', 'server.js');

// Check if unsafe mode is requested
const isUnsafe = process.argv.includes('--unsafe');

// Start the server in a way that Cursor can communicate with it
const server = spawn('node', [serverPath], {
    stdio: 'inherit',
    env: {
        ...process.env,
        CURSOR_MCP: 'true',
        UNSAFE_MODE: isUnsafe ? 'true' : 'false'
    }
});

// Handle process signals
process.on('SIGTERM', () => {
    server.kill('SIGTERM');
});

process.on('SIGINT', () => {
    server.kill('SIGINT');
});

// Forward exit
server.on('exit', (code) => {
    process.exit(code);
}); 