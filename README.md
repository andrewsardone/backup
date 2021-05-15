# backup

A set of configuration files and scripts to backup my MacBook Pro. The
backup program of choice is [restic] and the backup destination is [Wasabi].
Which files to backup is defined by the list within `restic.files`.

## Usage

First, install [restic]. Then, clone the repository and run `backup.sh`.

### Set up atuomatic backup

Install a simple cron job:

```
make install
```

[restic]: https://restic.net/
[Wasabi]: https://wasabi.com/
