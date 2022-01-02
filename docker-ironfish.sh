#!/bin/bash
set -euo pipefail

script_root="$(cd "$(dirname "$(readlink "$([[ "${OSTYPE}" == linux* ]] && echo "-f")" "$0")")"; pwd)"
source "${script_root}/lib/utils.sh"

require ts "Please install ts: apt install moreutils"

LOGS_DIR="${HOME}/.ironfish/logs"

TS_FORMAT='%Y-%m-%d %H:%M:%.S '

if [ $# -eq 0 ]; then
  LOG_FILE="${LOGS_DIR}/node.log"
elif [ "$1" == "miners:start" ]; then
  # Too much spam
  #LOG_FILE="${LOGS_DIR}/miner.log"
  LOG_FILE="/dev/null"
else
  LOG_FILE="${LOGS_DIR}/other.log"
fi

mkdir -p "${LOGS_DIR}"
docker run --rm --tty --interactive --network host --volume "${HOME}/.ironfish:/root/.ironfish" ghcr.io/iron-fish/ironfish:latest $* | ts "${TS_FORMAT}" | tee -a "${LOG_FILE}"

