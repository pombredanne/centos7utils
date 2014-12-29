#!/usr/bin/env bash

# Any extra argument causes the output to be quieter
QUIET=${1}

function die() {
    echo "FATAL ERROR: $1"
    exit 2
}

function msg() {
    if [[ "${QUIET}" != "" ]] ; then
        return
    fi
    echo ${1}
}

LATEST_PYTHON_VERSION=`curl -s https://www.python.org/ftp/python/ | grep 'href="3' | cut -d / -f 1 | cut -d '"' -f 2 | sort -V | tail -n 1 || die "Couldn't determine latest version of python."`

if which python3 &>/dev/null ; then
    INSTALLED_PYTHON_VERSION=`python3 -c "import sys; print('.'.join([str(x) for x in sys.version_info[0:3]]))"`
else
    INSTALLED_PYTHON_VERSION='None'
fi

if [[ "${LATEST_PYTHON_VERSION}" == "${INSTALLED_PYTHON_VERSION}" ]] ; then
    msg "The latest version of Python (${LATEST_PYTHON_VERSION}) is already installed."
    exit 0
fi


# Actually install the latest version of Python 3
BUILD_DIR=`mktemp -d || die "Failed mktemp -d"`
pushd ${BUILD_DIR} || die "Failed pushd"
wget http://python.org/ftp/python/${LATEST_PYTHON_VERSION}/Python-${LATEST_PYTHON_VERSION}.tar.xz || die "Couldn't download tarball for Python ${LATEST_PYTHON_VERSION}"
tar Jxvf Python-${LATEST_PYTHON_VERSION}.tar.xz || die "Couldn't untar Python${LATEST_PYTHON_VERSION}"
cd Python-${LATEST_PYTHON_VERSION} || die "Couldn't cd into the Python directory."
./configure || die "Failed ./configure"
make -j9 || die "Failed make -j9"
make install || die "Failed make install"
cd .. && rm -rf Python* || die "Failed cleaning up python files"
hash -r || die "Failed hash -r"
popd || die "Failed popd"
rmdir ${BUILD_DIR} || die "Failed cleaning up tmpdir"

echo "Successfully installed Python ${LATEST_PYTHON_VERSION}"
exit 0
