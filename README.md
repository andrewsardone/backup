backup
======

Scripts to backup to an Amazon S3 bucket via [JungleDisk](http://www.jungledisk.com/).

Contents
--------

* `backup_to_jungledisk.sh` - backup script
* `bak` - wrapper script that's copied to `/usr/local/bin`
* `rsync_exclude_home` - list of content to exclude when rsync-ing the home directory
* `rsync_exclude_music` - list of content to exclude when rsync-ing the iTunes music files
* `setup.sh` - execute to symlink the current directory and copy `bak` to `/usr/local/bin`