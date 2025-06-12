#!/usr/bin/env bash
set -euo pipefail

# Set verbosity
shopt -s nocasematch
case ${LOG_LEVEL} in
  error)
    __verbosity="--verbosity 1"
    ;;
  warn)
    __verbosity="--verbosity 2"
    ;;
  info)
    __verbosity="--verbosity 3"
    ;;
  debug)
    __verbosity="--verbosity 4"
    ;;
  trace)
    __verbosity="--verbosity 5"
    ;;
  *)
    echo "LOG_LEVEL ${LOG_LEVEL} not recognized"
    __verbosity=""
    ;;
esac

if [ -n "${L2GETH_P2P_BOOTNODES}" ]; then
  __bootnodes="--bootnodes=${L2GETH_P2P_BOOTNODES}"
else
  __bootnodes=""
fi

if [ "${MPT_NODE}" = "true" ]; then
  __mpt="--scroll-mpt --gcmode archive --syncmode full"
else
  __mpt=""
fi

#shellcheck disable=SC2086
exec "$@" ${__verbosity} ${__bootnodes} ${__mpt} ${EXTRAS}
