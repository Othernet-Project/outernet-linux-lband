#!/bin/sh

PREFIX="%PREFIX%"
PRESETS_FILE="$PREFIX/share/outernet/presets"
PRESETS_URL="https://raw.githubusercontent.com/Outernet-Project/outernet-linux-lband/master/presets.sh"

. "$PRESETS_FILE"

usage() {
  cat <<EOF
Usage: 
  $0 PROFILE
  $0 update

parameters:

  PROFILE   name of the tuner profile
  update    fetch the latest profiles

supported profiles:

  americas  North and South Americas
  euraf     Europe, Africa, Middle East
  apac      Asia, Pacific
EOF
exit 0
}

updateprofiles() {
  #printf "Fetching the profiles... "
  printf "Fetching update from $PRESETS_URL: "
  if wget --no-check-certificate -q "$PRESETS_URL" -O "$PRESETS_FILE"; then
    echo "OK"
  else
    echo "FAIL"
  fi
}

rundemod() {
  demod $ARGS
}

[ -z "$1" ] && usage

case "$1" in
  americas)
    ARGS="$AMERICAS"
    rundemod
    ;;
  euraf)
    ARGS="$EURAF"
    rundemod
    ;;
  apac)
    ARGS="$APAC"
    rundemod
    ;;
  update)
    updateprofiles
    ;;
  *)
    echo "ERROR: Unknown profile: $1"
    usage
esac
