#!/usr/bin/env bash
set -euo pipefail

if [ "${MPT_NODE}" = "true" ]; then
  __mpt="--scroll-mpt"
else
  __mpt=""
fi

exec "$@" ${__mpt} ${EXTRAS}
