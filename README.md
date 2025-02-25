# MCP Server for Cursor IDE

A secure local MCP (Message Control Protocol) server for Cursor IDE that enables terminal command execution and file access.

## Features

- Secure local-only access
- Terminal command execution
- File reading capabilities
- Built-in security measures
- Health check endpoint

## Installation

1. Make sure you have Node.js installed
2. Clone or download this repository
3. Install dependencies:
```bash
npm install
```

## Usage

1. Start the server:
```bash
npm start
```

2. The server will run on `http://localhost:5000`

3. In Cursor IDE:
   - Go to Settings > Features > MCP Servers
   - Click "Add new MCP server"
   - Select "Command" option
   - Enter name: "Local MCP Server"
   - Command: `node /Users/saeidrafiei/Desktop/mcp-server/server.js`
   - Click "Add"

## API Endpoints

- `GET /health` - Check server status
- `POST /execute` - Execute terminal commands
- `POST /read-file` - Read file contents

## Security Features

- Local-only access (127.0.0.1 and ::1)
- Command validation and sanitization
- Path traversal protection
- Request timeout limits
- Dangerous command prevention

## Note

This server is designed for local development use only. Do not expose it to the public internet. 