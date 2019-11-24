#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="$( cd "$( dirname $0 )" && pwd )"; readonly BASEDIR

source ${BASEDIR}/cfg.txt

# make temp dir
tmpdir=$( mktemp -d --suffix=".gitexport" )
echo ${tmpdir}
mkdir ${tmpdir}/gitexport

# get all repos
while read tsd_repos github_repos; do
  echo "processing repo" ${tsd_repos} ${github_repos}  
  cd ${tmpdir}/gitexport
  git clone ${TSD_GIT_SERVER}/${tsd_repos}
  # add repo destination
  cd ${tsd_repos##*/}
  git remote add origin_github ${github_repos}
done < <( cat ${BASEDIR}/cfg_repos.txt | grep -v "^#")

# write outside-tsd script
cd ${tmpdir}/gitexport
cat > push_github.sh << EOI
#!/usr/bin/env bash

# exit on error
set -ETeuo pipefail

declare BASEDIR; BASEDIR="\$( cd "\$( dirname \$0 )" && pwd )"; readonly BASEDIR
cd \${BASEDIR}

#list dirs
for dir in \$(ls -d */); do
  cd \${BASEDIR}/\${dir} && git push origin_github
done
EOI

cd ${tmpdir}

# make output file
md5str=$(find gitexport/ -type f | xargs cat | md5sum)
fn_out_tgz="gitexport_$(date +"%y%m%d-%H")_${md5str:0:7}.tar.gz"
tar cfz ${fn_out_tgz} gitexport
# copy to tsd export folder
cp ${fn_out_tgz} /tsd/p33/data/durable/file-export/

# clean up

echo "cleaning up.."
rm -rf ${tmpdir}
echo "done"

