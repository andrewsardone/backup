#/usr/bin/env bash
# Usage: ./backup
# Executes a backup of my system. It will ensure only one backup is running at
# once. Handy for one-off full-system backups or for scheduling via a job
# runner.

set -e

function check_dependency() {
  command -v $1 >/dev/null 2>&1 || {
    echo >&2 "${1} is required. Please install."
    exit 1
  }
}

# echo but with a the date & time prefixed on the line
function techo() {
  echo $(date +"%Y-%m-%d %T") $@
}

check_dependency restic
base_path=`dirname $0`
env_file="$base_path/restic.env"
files_list="$base_path/restic.files"
pid_file="$base_path/tmp/backup.pid"

# Set up PID file for a simple lock to prevent duplicate backups running
# simultaneously.
if [ -f "$pid_file" ]; then
  if ps -p $(cat $pid_file) > /dev/null; then
    techo "File $pid_file exists. Another backup is probably already in progress."
    exit 1
  else
    techo $(date +"%Y-%m-%d %T") "File $pid_file exists but process "$(cat $pid_file)" not found. Removing PID file."
    rm $pid_file
  fi
fi
echo $$ > "$pid_file"

techo "Backup start"
source "$env_file"
restic backup \
  --files-from="$files_list" \
  --tag automated
techo "Backup finished"

rm "$pid_file"
