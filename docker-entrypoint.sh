#!/usr/bin/env bash
set -euo pipefail

if [ "${MPT_NODE}" = "true" ]; then
  __mpt="--scroll-mpt --gcmode archive"
else
  __mpt=""
fi

#shellcheck disable=SC2086
exec "$@" ${__mpt} ${EXTRAS}
