#!/bin/sh

PREFIX="${PREFIX:=/usr/local}"
BINDIR="${PREFIX}/bin"
SHAREDIR="${PREFIX}/share/outernet"
RULESFILE="${SHAREDIR}/99-sdr.rules"
RULES="/etc/udev/rules.d/99-sdr.rules"
ONDD_VERSION=2.2.0
SDR100_VERSION=1.0.4
INST_STYLE="normal"
VERSION="1.0a3"

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

readopt() {
  prompt="$1"
  default_value="$2"
  if [ "$INST_STYLE" = "quick" ]; then
    val="$default_value"
    return
  fi
  echo
  printf "$prompt"
  read val
  [ -z "$val" ] && val="$default_value"
}

is_yes() {
  val="$1"
  [ "$val" != n ] && [ "$val" != N ]
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
  echo "$VERSION" > "${SHAREDIR}/version"

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

  readopt "Would you like to configure udev? [Y/n] " "y"
  config_udev="$val"
  if is_yes "$config_udev"; then
    configure_udev
  fi

  echo "---------------------------------------------------------------------"
  echo
  echo "Choose cache and download paths"
  echo
  echo "---------------------------------------------------------------------"

  readopt "Download cache path [/var/spool/ondd]: " "/var/spool/ondd"
  spooldir="$val"

  readopt "Download storage path [/srv/downloads]: " "/srv/downloads"
  dldir="$val"

  readopt "Create download paths? [Y/n] " "y"
  mkpaths="$val"

  if is_yes "$mkpaths"; then
    mkdir -p "$spooldir" "$dldir"
    chmod 777 "$spooldir"
    chmod 777 "$dldir"
    echo "Created download paths"
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
  quick)
    INST_STYLE="quick"
    inst
    ;;
  *)
    inst
esac

exit $?
