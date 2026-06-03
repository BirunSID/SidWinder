import os
import sys
import struct
import json
import subprocess

# CURRENT_DIR is .../src
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

# ROOT_DIR is the main folder (one level up from src)
ROOT_DIR = os.path.dirname(CURRENT_DIR)

# Explicitly locate our engine and config in their new folders
YTDLP_PATH = os.path.join(ROOT_DIR, 'bin', 'yt-dlp.exe')
CONFIG_PATH = os.path.join(ROOT_DIR, 'config', 'yt-dlp.conf')

def get_message():
    raw_length = sys.stdin.buffer.read(4)
    if not raw_length:
        return None
    message_length = struct.unpack('@I', raw_length)[0]
    message = sys.stdin.buffer.read(message_length).decode('utf-8')
    return json.loads(message)

try:
    data = get_message()
    if data and 'url' in data:
        url = data['url']
        # Execute the binary in the bin folder, and load the config from the config folder
        cmd = f'start cmd.exe /k "cd /d \"{ROOT_DIR}\" && \"{YTDLP_PATH}\" --config-location \"{CONFIG_PATH}\" \"{url}\""'
        subprocess.Popen(cmd, shell=True)
except Exception as e:
    pass