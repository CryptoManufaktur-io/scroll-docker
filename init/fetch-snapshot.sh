#!/usr/bin/env bash
set -euo pipefail

__datadir=/var/lib/l2geth
__project_name="Scroll Docker"
 
# Prep l2geth datadir
if [ -n "${SNAPSHOT}" ] && [ ! -d "${__datadir}/geth/chaindata/" ]; then
  __dont_rm=0
  mkdir -p "${__datadir}"/snapshot
  cd "${__datadir}"/snapshot
  eval "__url=${SNAPSHOT}"
# We assign by eval
# shellcheck disable=SC2154
  aria2c -c -x6 -s6 --auto-file-renaming=false --conditional-get=true --allow-overwrite=true "${__url}"
  filename=$(echo "${__url}" | awk -F/ '{print $NF}')
  if [[ "${filename}" =~ \.tar\.zst$ ]]; then
    pzstd -c -d "${filename}" | tar xvf - -C "${__datadir}"
  elif [[ "${filename}" =~ \.tar\.gz$ || "${filename}" =~ \.tgz$ ]]; then
    tar xzvf "${filename}" -C "${__datadir}"
  elif [[ "${filename}" =~ \.tar$ ]]; then
    tar xvf "${filename}" -C "${__datadir}"
  elif [[ "${filename}" =~ \.lz4$ ]]; then
    lz4 -d "${filename}" | tar xvf - -C "${__datadir}"
  else
    __dont_rm=1
    echo "The snapshot file has a format that ${__project_name} can't handle."
    echo "Please open a github issue to work through this."
  fi
  if [ "${__dont_rm}" -eq 0 ]; then
    rm -f "${filename}"
  fi
  # try to find the directory
  __search_dir="chaindata"
  __base_dir="${__datadir}/"
  __found_path=$(find "$__base_dir" -type d -path "*/$__search_dir" -print -quit)
  if [ "${__found_path}" = "${__base_dir}chaindata" ]; then
    echo "Found chaindata in root directory, moving it to geth folder"
    mkdir -p "$__base_dir/geth"
    mv "$__found_path" "$__base_dir/geth"
  elif [ -n "$__found_path" ]; then
    __geth_dir=$(dirname "$__found_path")
    __geth_dir=${__geth_dir%/chaindata}
    if [ "${__geth_dir}" = "${__base_dir}geth" ]; then
       echo "Snapshot extracted into ${__geth_dir}/chaindata"
    else
      echo "Found a geth directory at ${__geth_dir}, moving it."
      mv "$__geth_dir" "$__base_dir"
      rm -rf "$__geth_dir"
    fi
  fi
  if [[ ! -d "${__datadir}"/geth/chaindata ]]; then
    echo "Chaindata isn't in the expected location."
    echo "This snapshot likely won't work until the fetch script has been adjusted for it."
  fi
fi
