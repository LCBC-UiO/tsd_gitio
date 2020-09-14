#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR

source ${BASEDIR}/cfg.txt



# get all repos
while read tsd_repos github_repos; do
  echo "processing repo" ${tsd_repos} ${github_repos}  
  gdir=${tsd_repos##*/}
  echo $gdir
  if [ ! -d ${gdir} ]; then
    printf "cloning ${github_repos} (${gdir})\n"
    git clone --bare ${github_repos} ${gdir}
  fi
  (
    cd ${gdir}
    git remote set-url origin_github ${github_repos} 2>/dev/null || git remote add origin_github ${github_repos}
    origin_tsd=${TSD_GIT_SERVER}/${tsd_repos}
    git remote set-url origin_tsd ${origin_tsd} 2>/dev/null || git remote add origin_tsd ${origin_tsd}
  )
done < <( cat ${BASEDIR}/cfg_repos.txt | grep -v "^#")

cd /tmp

# make output file
md5str=$(find ${BASEDIR} -type f | xargs cat | md5sum)
fn_out_tgz="gitexport_${TSD_PROJECT}_$(date +"%y%m%d-%H")_${md5str:0:7}.tar.gz"
tar cfz ${fn_out_tgz} -C ${BASEDIR}/.. ${BASEDIR##*/}

echo /tmp/${fn_out_tgz}
echo "done"

