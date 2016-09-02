#!/bin/sh

ONDD_CACHE="${ONDD_DATA:=%CACHE%}"
ONDD_DATA="${ONDD_DATA:=%DOWNLOADS%}"
CERT_PATH="%SHAREDIR%/ca.crt"


usage() {
  exit_code="$1"
  cat <<EOF
Usage: $0 [-c CACHE_DIR] [-o OUTPUT_DIR]

Options:
  -h    show this message and quit
  -c    set cache directory to specified path
  -o    set output directory to specified path

Additional notes:

  Instead of using the -c and -o options,
  ONDD_CACHE and ONDD_DATA environment 
  variables can be also used.

EOF
exit "$exit_code"
}

fail() {
  msg="$1"
  echo "ERROR: decoder: $msg"
  exit 1
}

while getopts "o:c:" opt; do
  case "$opt" in
    h)
      usage 0
      ;;
    o)
      ONDD_DATA="$OPTARG"
      ;;
    c)
      ONDD_CACHE="$OPTARG"
      ;;
    *)
      echo "ERROR: unrecognized option $opt"
      usage 1
      ;;
  esac
done

mkdir -p "$ONDD_CACHE"
mkdir -p "$ONDD_DATA"
mkdir -p /tmp/run

ondd -V -D /tmp/run/ondd.data -c "$ONDD_CACHE" -o "$ONDD_DATA" \
  --cert-file "$CERT_PATH"
