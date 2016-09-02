#!/bin/sh

PREFIX="${PREFIX:=/usr/local}"
BINDIR="${PREFIX}/bin"
SHAREDIR="${PREFIX}/share/outernet"
RULESFILE="${SHAREDIR}/99-sdr.rules"
RULES="/etc/udev/rules.d/99-sdr.rules"
ONDD_VERSION=2.2.0
SDR100_VERSION=1.0.4

inst_file() {
  mode="$1"
  src="$2"
  dest="$3"
  echo "Installing $src -> $dest"
  install -Dm"$mode" "$src" "$dest"
}

patch_script() {
  target="$1"
  sed -ie "s|%PREFIX%|$PREFIX|g;s|%SHAREDIR%|$SHAREDIR|g" "$target"
}

rule() {
  vid="$1"
  pid="$2"
  [ -z "$vid" ] && return
  rule='SUBSYSTEM=="usb",'
  rule="$rule ATTR{idVendor}==\"$vid\","
  rule="$rule ATTR{idProduct}==\"$pid\","
  rule="$rule MODE=\"0666\""
  echo "$rule"
}

configure_udev() {
  echo "Generating udev rules"
  printf '' > "$RULESFILE"
  while read sdrdev; do
    ids="$(echo "$sdrdev" | cut -d\; -f1)"
    vid="$(echo "$ids" | cut -d: -f1)"
    pid="$(echo "$ids" | cut -d: -f2)"
    rule "$vid" "$pid" >> "$RULESFILE"
  done < "sdrids.txt"
  echo "Linking $RULES -> $RULESFILE"
  ln -sf "$RULESFILE" "$RULES"
  udevadm control --reload
  echo "********************************************"
  echo "NOTE: You will need to reconnect your radio."
  echo "********************************************"
}

inst() {
  inst_file 755 "bin/demod.sh" "${BINDIR}/demod"
  inst_file 755 "bin/demod-presets.sh" "${BINDIR}/demod-presets"
  inst_file 755 "bin/decoder.sh" "${BINDIR}/decoder"
  inst_file 644 "presets.sh" "${SHAREDIR}/presets"
  inst_file 755 "bin/ondd-${ONDD_VERSION}" "${BINDIR}/ondd"
  inst_file 755 "bin/sdr100-${SDR100_VERSION}" "${BINDIR}/sdr100"
  inst_file 755 "bin/rtl_biast" "${BINDIR}/rtl_biast"
  inst_file 755 "sdr.d/starsdr-mirics/libmirisdr.so" \
    "${PREFIX}/sdr.d/starsdr-mirics/libmirisdr.so"
  inst_file 755 "sdr.d/starsdr-mirics/libstarsdr.so" \
    "${PREFIX}/sdr.d/starsdr-mirics/libstarsdr.so"
  inst_file 755 "sdr.d/starsdr-rtlsdr/librtlsdr.so" \
    "${PREFIX}/sdr.d/starsdr-rtlsdr/librtlsdr.so"
  inst_file 755 "sdr.d/starsdr-rtlsdr/libstarsdr.so" \
    "${PREFIX}/sdr.d/starsdr-rtlsdr/libstarsdr.so"
  inst_file 644 "sdrids.txt" "${SHAREDIR}/sdrids.txt"
  inst_file 644 "COPYING" "${SHAREDIR}/COPYING"
  inst_file 644 "ONDD_LICENSE.txt" "${SHAREDIR}/ONDD_LICENSE.txt"
  inst_file 644 "SDR100_LICENSE.txt" "${SHAREDIR}/SDR100_LICENSE.txt"
  inst_file 644 "COPYING.StarSDR" "${SHAREDIR}/COPYING.StarSDR"
  inst_file 644 "ca.crt" "${SHAREDIR}/ca.crt"

  echo "Configuring scripts"
  patch_script "${BINDIR}/demod"
  patch_script "${BINDIR}/demod-presets"
  patch_script "${BINDIR}/decoder"

  echo "---------------------------------------------------------------------"
  echo
  echo "By default radios are only accessible as root."
  echo "In order to use the radios as non-root user, udev must be configured."
  echo
  echo "---------------------------------------------------------------------"

  echo
  printf "Would you like me to configure udev for you? [y/N] "
  read config_udev

  if [ "$config_udev" = y ] || [ "$config_udev" = Y ]; then
    configure_udev
  fi

  echo "---------------------------------------------------------------------"
  echo
  echo "Choose the download and spool directories"
  echo
  echo "---------------------------------------------------------------------"

  echo
  printf "Temporary download path [/var/spool/ondd]: "
  read spooldir

  echo
  printf "Download storage path [/srv/downloads]: "
  read dldir

  [ -z "$spooldir" ] && spooldir="/var/spool/ondd"
  [ -z "$dldir" ] && dldir="/srv/downloads"

  echo
  printf "Create temporary and permanent download paths? [Y/n]"
  read mkpaths

  if [ "$mkpaths" != n ] && [ "$mkpaths" != N ]; then
    mkdir -p "$spooldir" "$dldir"
    chmod 777 "$spooldir"
    chmod 777 "$dldir"
  fi
  sed -ie "s|%CACHE%|$spooldir|g;s|%DOWNLOADS%|$dldir|g" "${BINDIR}/decoder"

  echo "Finished"
}

uninst() {
  echo "Uninstalling"
  for binary in demod demod-presets ondd sdr100; do
    rm "${BINDIR}"/${binary}
  done
	rm -rf "${SHAREDIR}"
  if [ -e "$RULES" ]; then
    rm -f "$RULES"
    udevadm control --reload
    echo "********************************************"
    echo "NOTE: You will need to reconnect your radio."
    echo "********************************************"
  fi
  echo "Finished"
}

if [ "$USER" != root ]; then
  cat <<EOF
ERROR: Permission denied
This program must be run with root permissions.
Use sudo or log in as root.
EOF
  exit 1
fi


case "$1" in
  uninstall)
    uninst
    ;;
  *)
    inst
esac

exit $?
