const express = require('express');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const cors = require('cors');
const os = require('os');

// Ensure stdout and stderr are properly handled
process.stdout.setEncoding('utf8');
process.stderr.setEncoding('utf8');

const app = express();

// Security middleware
app.use(express.json());
// More permissive CORS settings
app.use(cors({
    origin: '*', // Allow all origins for Cursor
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['*']
}));

// Log startup message for Cursor
console.log('MCP Server initializing...');

// Reduced list of protected paths
const PROTECTED_PATHS = [
    '/etc/shadow',
    '/etc/sudoers',
    '/var/lib/docker'
];

// Input validation middleware
const validateInput = (req, res, next) => {
    const { command, path: filePath } = req.body;
    
    // Only validate file paths, not commands
    if (filePath) {
        if (typeof filePath !== 'string') {
            return res.status(400).json({ error: 'Invalid file path format' });
        }
        
        const normalizedPath = path.normalize(filePath);
        const isProtected = PROTECTED_PATHS.some(protectedPath => 
            normalizedPath.startsWith(protectedPath)
        );
        
        if (isProtected) {
            return res.status(403).json({ error: 'Access denied: Protected system path' });
        }
    }
    
    next();
};

// Terminal Command Execution
app.post('/execute', validateInput, (req, res) => {
    const { command } = req.body;
    console.log('Executing command:', command);
    console.log('UNSAFE_MODE:', process.env.UNSAFE_MODE);
    console.log('Environment:', process.env);
    
    // In unsafe mode, execute any command
    if (process.env.UNSAFE_MODE === 'true') {
        console.log('Running in UNSAFE mode');
        exec(command, { 
            timeout: 15000, // Increased timeout
            maxBuffer: 1024 * 1024 * 5 // 5MB buffer
        }, (error, stdout, stderr) => {
            if (error) {
                console.error('Execution error:', error);
                console.error('Command:', command);
                console.error('Stderr:', stderr);
                return res.status(500).json({ error: error.message || stderr });
            }
            res.json({ output: stdout });
        });
        return;
    }
    
    console.log('Running in SAFE mode');
    // In safe mode, only allow whitelisted commands
    const allowedCommands = [
        'ls', 'pwd', 'echo', 'cat', 'find',
        'grep', 'head', 'tail', 'wc', 'sort',
        'uniq', 'diff', 'file', 'du', 'df'
    ];
    
    const commandBase = command.split(' ')[0];
    if (!allowedCommands.includes(commandBase)) {
        return res.status(403).json({ error: 'Command not allowed' });
    }
    
    exec(command, { 
        timeout: 5000,
        maxBuffer: 1024 * 1024
    }, (error, stdout, stderr) => {
        if (error) {
            console.error('Execution error:', error);
            return res.status(500).json({ error: stderr });
        }
        res.json({ output: stdout });
    });
});

// File Reading with directory listing
app.post('/read-file', validateInput, (req, res) => {
    const { path: filePath } = req.body;
    const resolvedPath = path.resolve(filePath);
    
    fs.stat(resolvedPath, (err, stats) => {
        if (err) {
            console.error(`File stat error: ${err}`);
            return res.status(500).json({ error: err.message });
        }
        
        if (stats.isDirectory()) {
            fs.readdir(resolvedPath, { withFileTypes: true }, (err, files) => {
                if (err) {
                    console.error(`Directory read error: ${err}`);
                    return res.status(500).json({ error: err.message });
                }
                
                const fileList = files.map(file => ({
                    name: file.name,
                    isDirectory: file.isDirectory(),
                    path: path.join(resolvedPath, file.name)
                }));
                
                res.json({ type: 'directory', contents: fileList });
            });
        } else {
            fs.readFile(resolvedPath, 'utf8', (err, data) => {
                if (err) {
                    console.error(`File read error: ${err}`);
                    return res.status(500).json({ error: err.message });
                }
                res.json({ type: 'file', content: data });
            });
        }
    });
});

// File information endpoint
app.post('/file-info', validateInput, (req, res) => {
    const { path: filePath } = req.body;
    const resolvedPath = path.resolve(filePath);
    
    fs.stat(resolvedPath, (err, stats) => {
        if (err) {
            console.error(`File stat error: ${err}`);
            return res.status(500).json({ error: err.message });
        }
        
        res.json({
            size: stats.size,
            isDirectory: stats.isDirectory(),
            created: stats.birthtime,
            modified: stats.mtime,
            accessed: stats.atime,
            mode: stats.mode
        });
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy',
        timestamp: new Date().toISOString(),
        platform: process.platform,
        nodeVersion: process.version,
        uptime: process.uptime()
    });
});

// ListTools endpoint for Cursor
app.get('/ListTools', (req, res) => {
    const tools = [
        {
            name: 'terminal',
            description: 'Execute terminal commands',
            parameters: {
                command: {
                    type: 'string',
                    description: 'The command to execute'
                }
            }
        },
        {
            name: 'file_system',
            description: 'Read and write files',
            parameters: {
                path: {
                    type: 'string',
                    description: 'File path'
                },
                content: {
                    type: 'string',
                    description: 'File content'
                }
            }
        }
    ];
    res.json({ tools });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal server error' });
});

const PORT = process.env.PORT || 9999;
app.listen(PORT, () => {
    const message = {
        status: 'ready',
        port: PORT,
        pid: process.pid,
        workspace: process.cwd(),
        timestamp: new Date().toISOString()
    };
    
    // Log in a format Cursor can parse
    console.log('MCP_SERVER_READY=' + JSON.stringify(message));
    console.log(`MCP Server running on http://localhost:${PORT}`);
    console.log(`Working directory: ${process.cwd()}`);
    console.log(`Platform: ${process.platform}`);
    console.log(`Node version: ${process.version}`);
}); 