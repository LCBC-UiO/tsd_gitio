#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR

cd "${BASEDIR}"
# get all repos
while read tsd_repos github_repos; do
  gdir=${tsd_repos##*/}
  echo "updating repo ${gdir}" ${tsd_repos} ${github_repos}  
  if [ -d ${gdir} ]; then
   (
      cd ${gdir}
      git remote set-url origin_github ${github_repos} 2>/dev/null || git remote add origin_github ${github_repos}
      git remote set-url origin_tsd ${tsd_repos} 2>/dev/null || git remote add origin_tsd ${tsd_repos}
    )
  fi
done < <( cat ${BASEDIR}/cfg_repos.txt | grep -v "^#")
