centos7utils
============

Random helpful scripts for dealing with CentOS 7 (or any RHEL-7-like distro)

`install_latest_python3.sh`
---------------------------------

**Usage** `./install_latest_python3.sh`

**Description** A bash script which downloads and installs the latest default
cpython implementation from python.org and installs it in the default location
(/usr/local).  The script assumes you have the necessary development tools
installed (gcc, make, etc.).  This will overwrite any python with the same
major and minor version installed in the same location.  So 3.4.2 would replace
3.4.1, but not 3.3.5.
