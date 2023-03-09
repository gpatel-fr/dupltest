#!/bin/bash
# zip all files needed for installers 
# ripped from build-release.sh
# must be run from root duplicati source
# first parameter: zip path to generate
# extended to debug builds (optional second parameter)
# the env variable RUNTMP should point to temp dir

# directory where files are stored
UPDATE_SOURCE="${RUNTMP}/tmpinstduplicati"
# zip output to be used by the installers
ZIPRESULT="${RUNTMP}/$1"
BUILDTYPE="Release"
if [ "$2" == "debug" ]; then BUILDTYPE="Debug"; fi

if [ -e "${UPDATE_SOURCE}" ]; then rm -rf "${UPDATE_SOURCE}"; fi
if [ -f "${ZIPRESULT}" ]; then rm -rf "${ZIPRESULT}"; fi

mkdir -p "${UPDATE_SOURCE}"

cp -R Duplicati/GUI/Duplicati.GUI.TrayIcon/bin/$BUILDTYPE/* "${UPDATE_SOURCE}"
cp -R Duplicati/Server/webroot "${UPDATE_SOURCE}"

# We copy some files for alphavss manually as they are not picked up by xbuild
mkdir "${UPDATE_SOURCE}/alphavss"
for FN in Duplicati/Library/Snapshots/bin/$BUILDTYPE/AlphaVSS.*.dll; do
	cp "${FN}" "${UPDATE_SOURCE}/alphavss/"
done

# Fix for some support libraries not being picked up
for BACKEND in Duplicati/Library/Backend/*; do
	if [ -d "${BACKEND}/bin/$BUILDTYPE/" ]; then
		cp "${BACKEND}/bin/$BUILDTYPE/"*.dll "${UPDATE_SOURCE}"
	fi
done

# Install the assembly redirects for all Duplicati .exe files
find "${UPDATE_SOURCE}" -maxdepth 1 -type f -name Duplicati.*.exe -exec cp Installer/AssemblyRedirects.xml {}.config \;

# Clean some unwanted build files
for FILE in "control_dir" "Duplicati-server.sqlite" "Duplicati.debug.log" "updates"; do
	if [ -e "${UPDATE_SOURCE}/${FILE}" ]; then rm -rf "${UPDATE_SOURCE}/${FILE}"; fi
done

# Clean the localization spam from Azure
for FILE in "de" "es" "fr" "it" "ja" "ko" "ru" "zh-Hans" "zh-Hant"; do
	if [ -e "${UPDATE_SOURCE}/${FILE}" ]; then rm -rf "${UPDATE_SOURCE}/${FILE}"; fi
done

# Clean debug files, if any
rm -rf "${UPDATE_SOURCE}/"*.mdb;
rm -rf "${UPDATE_SOURCE}/"*.pdb;

# Remove all library docs files
rm -rf "${UPDATE_SOURCE}/"*.xml;

# Remove all .DS_Store and Thumbs.db files
find  . -type f -name ".DS_Store" | xargs rm -rf
find  . -type f -name "Thumbs.db" | xargs rm -rf

# bundle everything info a zip file
pushd "${UPDATE_SOURCE}"
7z a -tzip -r "${ZIPRESULT}"
popd
rm -rf "${UPDATE_SOURCE}"
