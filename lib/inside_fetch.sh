#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR

cd "${BASEDIR}"
# get all repos
while read tsd_repos github_repos; do
  echo "processing repo" ${tsd_repos} ${github_repos}  
  gdir=${tsd_repos##*/}
  if [ ! -d ${gdir} ]; then
    printf "cloning ${github_repos} (${gdir})\n"
    git clone ${tsd_repos} ${gdir}
  fi
  (
    cd ${gdir}
    git remote set-url origin_github ${github_repos} 2>/dev/null || git remote add origin_github ${github_repos}
    git remote set-url origin_tsd ${tsd_repos} 2>/dev/null || git remote add origin_tsd ${tsd_repos}
    git pull ${tsd_repos} master
  )
done < <( cat ${BASEDIR}/cfg_repos.txt | grep -v "^#" | grep ".")

cd /tmp
project=${USER%-*}

# make output file
md5str=$(find ${BASEDIR} -type f | xargs cat | md5sum)
fn_out_tgz="gitio_${project}_$(date +"%y%m%d-%H")_${md5str:0:7}.tar.gz"
tar cfz ${fn_out_tgz} -C ${BASEDIR}/.. ${BASEDIR##*/}

fn_exp=/tsd/${project}/data/durable/file-export/${fn_out_tgz}
mv ${fn_out_tgz} ${fn_exp} 

printf "\ncreated: ${fn_exp}  (export from TSD; extract; run ./outside_push)\n\n"

