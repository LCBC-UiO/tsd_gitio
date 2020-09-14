# TSD GitIO

Transfering a lot of repos into/from TSD? Can't keep track where your latest code is?  
This tool helps you sycing your repos by pulling all of them and creating a single archive for easy upload/download.

## Quick start

### Init (only once)

Clone this repo and run bootstrap
```
git clone https://github.com/LCBC-UiO/tsd_gitio
tsd_gitio/bin/init gitio_p23
```
where `gitio_p23` is the name of a new folder that you want to use.

### Config (only once)

`cd gitio_p23` and edit `cfg.txt` and `cfg_repos.txt`. The latter contains the git URLs inside and outside TSD for all repos

### Importing to TSD

  * outside TSD: run `outside_fetch`
  * upload the archive to TSD
  * inside TSD: extract and run `inside_push`
  
### Exporting to TSD
  * inside TSD: run `inside_fetch`
  * export the archive from TSD
  * outside TSD: extract and run `outside_push`
  
## Changing Git URLs

If you want to change the location of a repository after the init.

  * edit `config_repos.txt`
  * run `update`
