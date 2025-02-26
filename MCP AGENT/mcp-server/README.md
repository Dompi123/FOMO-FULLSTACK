# MCP Server for Cursor IDE

A universal MCP (Message Control Protocol) server implementation for Cursor IDE that enables system-wide terminal command execution and file system access.

## Features

- 🌍 **Universal File Access**: Access files anywhere on your system
- 🔒 **Smart Security**: Protection for sensitive system files
- 🚀 **Global Command**: Run from any directory
- 🔄 **Process Management**: Auto-detection of running instances
- 📁 **Directory Operations**: List, read, and get info about files/directories
- ⚡ **Background Operation**: Runs as a detached process

## Prerequisites

- Node.js (v14 or higher)
- npm (v6 or higher)

## Installation

### Global Installation (Recommended)
```bash
# Navigate to the mcp-server directory
cd mcp-server

# Install dependencies
npm install

# Install globally
npm run install-global
```

### Local Installation
```bash
# Navigate to the mcp-server directory
cd mcp-server

# Install dependencies
npm install
```

## Usage

### Global Commands
After global installation, you can use these commands from any directory:

```bash
# Start the server
mcp-server start
# or simply
mcp-server

# Stop the server
mcp-server stop
```

### Local Usage
If not installed globally:
```bash
cd mcp-server
npm start
```

## Cursor IDE Configuration

1. Open Cursor IDE Settings
2. Navigate to Features > MCP Servers
3. Click "Add new MCP server"
4. Configure as follows:
   - Name: "Local MCP Server"
   - Type: "command"
   - Command: `mcp-server start`

## API Endpoints

### File Operations
- `POST /read-file`
  ```json
  {
    "path": "/path/to/file/or/directory"
  }
  ```
  Returns file content or directory listing

- `POST /file-info`
  ```json
  {
    "path": "/path/to/file"
  }
  ```
  Returns file metadata

### Command Execution
- `POST /execute`
  ```json
  {
    "command": "ls /some/directory"
  }
  ```
  Executes whitelisted commands

### Health Check
- `GET /health`
  Returns server status and information

## Supported Commands

The following commands are whitelisted for security:
- File Operations: `ls`, `pwd`, `cat`, `find`
- Text Processing: `grep`, `head`, `tail`, `wc`
- File Analysis: `sort`, `uniq`, `diff`, `file`
- System Info: `du`, `df`

## Security Features

- ✅ Protected system paths (`.ssh`, Keychains, etc.)
- ✅ Command whitelisting
- ✅ Input validation
- ✅ Path traversal protection
- ✅ Buffer limits for large files

## Technical Details

- Default port: 5001
- Process management: Automatic detection of running instances
- CORS: Configured for development (customizable)
- Error handling: Comprehensive error messages

## Troubleshooting

1. **Port in Use**
   ```bash
   # Stop any running instance
   mcp-server stop
   # Start new instance
   mcp-server start
   ```

2. **Process Not Found**
   ```bash
   # Check if server is running
   curl http://localhost:5001/health
   ```

3. **Permission Issues**
   - Ensure proper file permissions
   - Check protected paths configuration

## License

ISC

## Contributing

Feel free to submit issues and enhancement requests! 