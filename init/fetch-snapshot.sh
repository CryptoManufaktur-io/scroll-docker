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
    echo "Please come to CryptoManufaktur Discord to work through this."
  fi
  if [ "${__dont_rm}" -eq 0 ]; then
    rm -f "${filename}"
  fi
  if [[ ! -d "${__datadir}"/geth/chaindata ]]; then
    echo "Chaindata isn't in the expected location."
    echo "This snapshot likely won't work until the fetch script has been adjusted for it."
  fi
fi
