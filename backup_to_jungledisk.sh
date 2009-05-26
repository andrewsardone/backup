#!/usr/bin/env bash

date
if [ -a /Volumes/JungleDisk ]; then
	echo "--- Backing up music"
	pushd /Users/Shared/iTunes\ Music/
	rsync -avvz --size-only --delete --exclude-from $HOME/.backup/rsync_exclude_music . /Volumes/JungleDisk/Backup/music/
	echo "--- Backed up music"
	popd
	pushd $HOME
	echo "--- Backing up $HOME"
	rsync -avvs --size-only --delete --exclude-from $HOME/.backup/rsync_exclude_home . /Volumes/JungleDisk/Backup/andrew/
	echo "--- Backed up $HOME"
	popd
else
	echo "JungleDisk not mounted"
fi
echo " "