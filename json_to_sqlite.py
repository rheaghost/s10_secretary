import json
import sqlite3
import os

def convert_logs(json_file):
    # 1. Load the JSON data
    if not os.path.exists(json_file):
        print(f"Error: {json_file} not found.")
        return

    with open(json_file, 'r') as f:
        data = json.load(f)

    # 2. Connect to (or create) the SQLite database
    conn = sqlite3.connect('secretary_history.db')
    cursor = conn.cursor()

    # 3. Create the table structure
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS chat_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT,
            role TEXT,
            prompt TEXT,
            response TEXT
        )
    ''')

    # 4. Insert the data
    for entry in data:
        cursor.execute('''
            INSERT INTO chat_logs (timestamp, role, prompt, response)
            VALUES (?, ?, ?, ?)
        ''', (entry['timestamp'], entry['role'], entry['prompt'], entry['response']))

    conn.commit()
    conn.close()
    print(f"Successfully converted {len(data)} logs to secretary_history.db")

if __name__ == "__main__":
    # Change this to match the name of the file you download
    convert_logs('secretary_logs.json')
