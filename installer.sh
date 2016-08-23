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
  inst_file 755 "demod.sh" "${BINDIR}/demod"
  inst_file 755 "demod-presets.sh" "${BINDIR}/demod-presets"
  inst_file 755 "decoder.sh" "${BINDIR}/decoder"
  inst_file 644 "presets.sh" "${SHAREDIR}/presets"
  inst_file 755 "ondd-${ONDD_VERSION}" "${BINDIR}/ondd"
  inst_file 755 "sdr100-${SDR100_VERSION}" "${BINDIR}/sdr100"
  inst_file 644 "sdrids.txt" "${SHAREDIR}/sdrids.txt"
  inst_file 644 "COPYING" "${SHAREDIR}/COPYING"
  inst_file 644 "ONDD_LICENSE.txt" "${SHAREDIR}/ONDD_LICENSE.txt"
  inst_file 644 "SDR100_LICENSE.txt" "${SHAREDIR}/SDR100_LICENSE.txt"
  inst_file 644 "ca.crt" "${CRTDIR}/ca.crt"
  echo "Configuring scripts"
  patch_script "${BINDIR}/demod"
  patch_script "${BINDIR}/demod-presets"
  echo "Finished"
}

uninst() {
  echo "Uninstalling"
	rm "${BINDIR}"/{demod,demod-presets,ondd,sdr100}
	rm -rf "${SHAREDIR}"
  rm -rf "${CRTDIR}"
  echo "Finished"
}


case "$1" in
  install)
    inst
    ;;
  uninstall)
    uninst
    ;;
  *)
    echo "ERROR: invalid command"
    exit 1
esac

exit $?
