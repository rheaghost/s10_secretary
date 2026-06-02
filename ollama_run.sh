#!/bin/bash

echo "Cleaning up old sessions..."

# 1. Kill the 'ollama' binary specifically (not the script name)
# We use pgrep to find the actual IDs of the 'ollama' program
# and exclude the script's own ID ($$) to prevent suicide.
pgrep -f "ollama serve" | grep -v $$ | xargs kill -9 2>/dev/null

# 2. Kill the Python server safely
pkill -f "python3 -m http.server" 2>/dev/null

# 3. Give the system a moment to clear the RAM
sleep 2

echo "Starting Ollama (Low-Heat Mode)..."
export OLLAMA_ORIGINS="*" 
export OLLAMA_NUM_THREAD=2
export OLLAMA_HOST="0.0.0.0:11434"
echo "Starting Ollama (Low-Heat Mode)..."
export OLLAMA_ORIGINS="*"
export OLLAMA_NUM_THREAD=2
export OLLAMA_HOST="0.0.0.0:11434"
ollama serve &


echo "Starting Web UI Server..."
python3 -m http.server 8080 &

echo "-------------------------------------------"
echo "AI STATION IS READY"
echo "URL: http://$(ifconfig | grep -oP 'inet \K[\d.]+' | head -n 1):8080/ai_chat.html"
echo "-------------------------------------------"
