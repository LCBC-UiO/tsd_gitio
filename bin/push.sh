#!/usr/bin/env bash

set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )/.." && pwd )"; readonly BASEDIR

if [ "$(basename $0)" == "push_outside" ]; then
  echo po
fi