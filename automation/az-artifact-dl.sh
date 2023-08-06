#!/bin/bash

E_BADARGS=85

function sample_usage ()
{
  echo "Usage: `basename $0` output_directory artifact_name artifact_version_name feed_name org_name project_name"
  echo "Example: `basename $0` ~/tmp/blah_setup blah_debian blah_debian_version debian_feed_name my_org_name blah_project"
}

if [ -n "$1" ]
then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    sample_usage
    exit 0
  fi
elif [[ $# -ne 6 ]]; then
    echo "Illegal number of parameters" >&2
    sample_usage
    exit 2
fi  

# If az login or az devops login haven't been used, all az devops commands 
# will try to sign in using a PAT stored in the AZURE_DEVOPS_EXT_PAT environment variable.
# To use a PAT, set the AZURE_DEVOPS_EXT_PAT environment variable at the process level.

if [ ! -z ${AZURE_DEVOPS_EXT_PAT+x} ]; then
    echo "INFO variable AZURE_DEVOPS_EXT_PAT already defined";
else
    echo "ERROR env variable AZURE_DEVOPS_EXT_PAT must be defined";
    exit 1
fi

wd=$1
artifact_name=$2 # e.g. swift_deb
artifact_version_name=$3 # e.g. swift_deb_version
feed_name=$4 # hydro_forecast_deb
org_name=$5 # ${org_name}
project_name=$6

current_version_dir=${wd}/setup_version_current
setup_version_dir=${wd}/setup_version
version_dir=${wd}/version/latest

mkdir -p $current_version_dir
mkdir -p $setup_version_dir
mkdir -p $version_dir

if [ ! -f ${current_version_dir}/version.txt ]; then
    echo "0.0.1" > ${current_version_dir}/version.txt
fi

# vercomp: license: cc-by-sa 
# credits: https://stackoverflow.com/a/4025065
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

_download_version () {

    az artifacts universal download --organization ${org_name} --scope project --project "${project_name}" --feed "${feed_name}" --name "${artifact_version_name}" --version "*" --path ${setup_version_dir}

    if [ $? == 0 ]; then
        return 0;
    else
        echo "FAILED: setup_version download";
        return 1;
    fi
}

_download_setup () {

    az artifacts universal download --organization ${org_name} --scope project --project "${project_name}" --feed "${feed_name}" --name "${artifact_name}" --version "*" --path ${version_dir}

    if [ $? == 0 ]; then
        return 0;
    else
        echo "FAILED: version download";
        return 1;
    fi
}

_download_version
if [ ! $? == 0 ]; then
    exit 1;
fi

currentver=`cat ${current_version_dir}/version.txt`
newver=`cat ${setup_version_dir}/version.txt`

# remove carriage return and spaces; 
# work around for https://github.com/csiro-hydroinformatics/config-utils/issues/2
currentver=`echo ${currentver} | tr -d '\r' | tr -d ' '`
newver=`echo ${newver} | tr -d '\r' | tr -d ' '`

vercomp $currentver $newver
case $? in
    0) op='=';;
    1) op='>';;
    2) op='<';;
esac

if [[ $op = '=' ]]
then
    echo "Version number on disk ${currentver} is already the remote version ${newver}"
    echo "Stopping the download and exiting"
    #exit 0;
else
    if [[ $op = '>' ]]
    then
        echo "Version number on disk ${currentver} is newer than the remote version ${newver}!."
        echo "Stopping the download and exiting"
        #exit 0;
    else
        echo "Version number on disk ${currentver} is older than the remote version ${newver}!."
        echo "Downloading..."
        if [ ! -z "$(ls -A ${version_dir})" ]; then
            # not empty; clean up
            rm ${version_dir}/*.*;
        fi
        _download_setup
        if [ ! $? == 0 ]; then
            echo "Download of version ${newver} failed!"
            exit 1;
        else
            echo "Download of version ${newver} complete."
            # and we end up by setting the current version.
            echo $newver > ${current_version_dir}/version.txt
            exit 0;
        fi
    fi
fi