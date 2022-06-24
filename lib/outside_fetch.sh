#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR

source ${BASEDIR}/cfg.txt


cd "${BASEDIR}"
# get all repos
while read tsd_repos github_repos; do
  echo "processing repo" ${tsd_repos} ${github_repos}  
  gdir=${tsd_repos##*/}
  if [ ! -d ${gdir} ]; then
    printf "cloning ${github_repos} (${gdir})\n"
    git clone ${github_repos} ${gdir}
  fi
  (
    cd ${gdir}
    git remote set-url origin_github ${github_repos} 2>/dev/null || git remote add origin_github ${github_repos}
    git remote set-url origin_tsd ${tsd_repos} 2>/dev/null || git remote add origin_tsd ${tsd_repos}
    git pull ${github_repos} $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  )
done < <( cat ${BASEDIR}/cfg_repos.txt | grep -v "^#" | grep ".")

cd /tmp

# make output file
md5str=$(find ${BASEDIR} -type f | xargs cat | md5sum)
fn_out_tgz="gitio_${TSD_PROJECT}_$(date +"%y%m%d-%H")_${md5str:0:7}.tar.gz"
tar cfz ${fn_out_tgz} -C ${BASEDIR}/.. ${BASEDIR##*/}

printf "\ncreated: /tmp/${fn_out_tgz}  (upload to TSD; extract; run ./inside_push)\n\n"

