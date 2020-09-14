#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR
cd ${BASEDIR}

#list dirs
for dir in $(ls -d */); do
  echo ${dir}...
  cd ${BASEDIR}/${dir} && git push origin_github
done
