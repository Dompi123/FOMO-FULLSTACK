#!/bin/bash
export CURSOR_MCP=true
export UNSAFE_MODE=true
export NODE_ENV=development

# Change to the script's directory
cd "$(dirname "$0")"

# Start the MCP server
node ./bin/cursor-mcp.js 