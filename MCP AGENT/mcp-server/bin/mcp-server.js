#!/usr/bin/env node

const path = require('path');
const findProcess = require('find-process');
const { spawn } = require('child_process');

// Get the absolute path to the server.js file
const serverPath = path.join(__dirname, '..', 'server.js');

async function startServer(unsafe = false) {
    try {
        // Check if server is already running
        const processes = await findProcess('port', 5001);
        if (processes.length > 0) {
            console.log('MCP Server is already running on port 5001');
            return;
        }

        // Start the server as a detached process
        const server = spawn('node', [serverPath], {
            detached: true,
            stdio: 'inherit',
            env: {
                ...process.env,
                UNSAFE_MODE: unsafe ? 'true' : 'false'
            }
        });

        // Unref the child process so parent can exit
        server.unref();

        console.log('MCP Server started successfully');
        console.log('To stop the server, run: mcp-server stop');
    } catch (error) {
        console.error('Failed to start MCP Server:', error);
    }
}

async function stopServer() {
    try {
        const processes = await findProcess('port', 5001);
        if (processes.length > 0) {
            processes.forEach(proc => {
                process.kill(proc.pid);
            });
            console.log('MCP Server stopped');
        } else {
            console.log('No running MCP Server found');
        }
    } catch (error) {
        console.error('Failed to stop MCP Server:', error);
    }
}

// Handle command line arguments
const args = process.argv.slice(2);
const command = args[0];
const isUnsafe = args.includes('--unsafe');

switch (command) {
    case 'stop':
        stopServer();
        break;
    case 'start':
    default:
        startServer(isUnsafe);
        break;
} 