# Installation instructions when building locally (March 2023)

# optional first parameter: debug build

RELEASE_TIMESTAMP=$(date +%Y-%m-%d)

RELEASE_INC_VERSION=$(cat Updates/build_version.txt)
RELEASE_INC_VERSION=$((RELEASE_INC_VERSION+1))

RELEASE_TYPE="canary"

RELEASE_VERSION="2.0.6.${RELEASE_INC_VERSION}"
RELEASE_NAME="${RELEASE_VERSION}_${RELEASE_TYPE}_${RELEASE_TIMESTAMP}"

RELEASE_FILE_NAME="duplicati-${RELEASE_NAME}"

export RUNTMP=$HOME
bash -x Installer/bundleduplicati.sh $RELEASE_FILE_NAME $1
cd Installer/OSX
bash -x make-dmg.sh $RUNTMP/$RELEASE_FILE_NAME
mkdir -p $RUNTMP/artifacts
mv *.dmg $RUNTMP/artifacts
mv *.pkg $RUNTMP/artifacts
cd ../..
