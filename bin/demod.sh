#!/bin/sh

# Paths
DEVICE_ID_DB="%PREFIX%/share/outernet/sdrids.txt"
STARSDR_PATH="%PREFIX%/sdr.d"

fail() {
  msg="$*"
  echo "ERROR: demod: $msg"
  exit 1
}

radio_devices() {
  lsusb | cut -d " " -f 6 | tr A-F a-f | while read -r dev_id; do
    grep "$dev_id" "$DEVICE_ID_DB" | cut -d ";" -f 2
  done
}

get_radio() {
  radios="$(radio_devices)"
  nradios=$(echo "$RADIOS" | wc -c)
  [ "$nradios" = 1 ] && echo "$radios"
}

delmod() {
  modname="$1"
  echo "Attempting to remove driver '$modname'"
  sudo rmmmod -f "$modname"
}

killmod() {
  modname="$1"
  lsmod | grep -q "$modname" && delmod "$modname"
}

rtlsdr_demod() {
  killmod "rtl2830"
  killmod "rtl2832"
  killmod "dvb_usb_rtl128xxu"
  rtl_biast -b 1
  sdr100 "$@"
}

mirics_demod() {
  killmod "miri_sdr"
  sdr100 "$@"
}

radio="$(get_radio)"

# Sanity checks
[ -d "$STARSDR_PATH" ] || fail "StarSDR is not installed"
[ -z "$radio" ] && fail "No usable radio detected"

export LD_LIBRARY_PATH="$STARSDR_PATH/starsdr-$radio"

"${radio}_demod" "$@"
