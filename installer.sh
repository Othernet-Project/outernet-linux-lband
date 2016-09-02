#!/bin/sh

PREFIX="${PREFIX:=/usr/local}"
BINDIR="${PREFIX}/bin"
SHAREDIR="${PREFIX}/share/outernet"
CRTDIR="/etc/outernet"
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
  sed -ie "s|%PREFIX%|$PREFIX|g" "$target"
}

inst() {
  inst_file 755 "bin/demod.sh" "${BINDIR}/demod"
  inst_file 755 "bin/demod-presets.sh" "${BINDIR}/demod-presets"
  inst_file 755 "decoder.sh" "${BINDIR}/decoder"
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
  inst_file 644 "ca.crt" "${CRTDIR}/ca.crt"
  echo "Configuring scripts"
  patch_script "${BINDIR}/demod"
  patch_script "${BINDIR}/demod-presets"
  echo "Finished"
}

uninst() {
  echo "Uninstalling"
  for binary in demod demod-presets ondd sdr100; do
    rm "${BINDIR}"/${binary}
  done
	rm -rf "${SHAREDIR}"
  rm -rf "${CRTDIR}"
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
