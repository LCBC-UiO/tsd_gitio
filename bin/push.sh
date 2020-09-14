#!/usr/bin/env bash

set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR

origin=

if [ "$(basename $0)" == "outside_push" ]; then
  origin=origin_github
fi
if [ "$(basename $0)" == "inside_push" ]; then
  origin=origin_tsd
fi

[ ! -z "$origin" ] || { printf "error undefined origin\n" >&2; exit 1 ; }

cd ${BASEDIR}

#list dirs
for dir in $(ls -d */); do
  echo ${dir}...
  cd ${BASEDIR}/${dir} && git pull ${origin} master && git push ${origin}
done
