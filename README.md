# TSD GitIO

Transfering a lot of repos into/from TSD? Can't keep track where your latest code is?  
This tool helps you syncing your repos by pulling all of them and creating a single archive for easy upload/download.

## Quick start

### Init (only once)

Clone this repo and run init
```
git clone https://github.com/LCBC-UiO/tsd_gitio
tsd_gitio/bin/init gitio_p23
```
where `gitio_p23` is the name of a new folder that you want to use.

### Config (only once)

`cd gitio_p23` and edit `cfg.txt` and `cfg_repos.txt`. The latter contains both git URLs (inside and outside TSD) for all repos.

### Importing to TSD

  * outside TSD: run `./outside_fetch`
  * upload the archive to TSD
  * inside TSD: extract and run `./inside_push`
  
### Exporting from TSD
  * inside TSD: run `./inside_fetch`
  * export the archive from TSD
  * outside TSD: extract and run `./outside_push`

### Tip: Having your password cached
Saves you from retyping your password when connecting by http(s).
Add the following lines to your `~/.gitconfig`:
```
[credential]
	helper = cache --timeout=86400
```

## Changing Git URLs

If you want to change the location of a repository after the init.

  * edit `cfg_repos.txt`
  * run `update`

(Folder names are derived from the "inside" URLs, so you might have to rename the folders accordingly.)
