#!/bin/bash
# -- SOUNDCLOUD ARCHIVE SCRIPT --
# written by ev1l0rd
# under the MIT License
# archives an entire soundcloud user to archive.org

function usage() {
	cat <<EOF
	Usage: $0 SOUNDCLOUD_USER

	SOUNDCLOUD_USER is an URL leading to a Soundcloud profile.

EOF
}

function dependency_check() {
	command -v pip2 >/dev/null 2>&1 || { echo >&2 "PIP for Python 2.7 is not installed. Install pip for Python 2.7, then re-run this script."; exit 1; }
	command -v ia >/dev/null 2>&1 || { echo >&2 "Internet Archive tools not installed."; IA_TOOLS_SETUP="yes"; }
	command -v youtube-dl >/dev/null 2>&1 || { echo >&2 "Youtube-DL not installed."; YOUTUBE-DL_SETUP="yes"; }
	
}

function dependency_fix() {
	if [["YOUTUBE-DL_SETUP" == "yes"]] {
		sudo pip install youtube-dl
		echo "youtube-dl installed. Continuing."
	}
	if [["IA_TOOLS_SETUP" == "yes"]] {
		sudo pip install internetarchive
		echo "Internet Archive Tools installed. Please run 'ia configure', then re-run this script."
		exit 0
	}
}

function create_temp_dir() {
	#shortened version of https://stackoverflow.com/a/34676160/4666756
	curdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	temp_dir=`mktemp -d -p "$curdir"`
	if [[ ! "$temp_dir" || ! -d "$temp_dir" ]]; then
	  echo "Could not create temporary directory."
	  exit 1
	fi
}

function clean() {
	rm -rf $temp_dir
	echo "Temporary directory removed"
}

function youtubedl_download() {
	cd $temp_dir
	youtube-dl --write-description --write-info-json --write-thumbnail $1
	#these config options basically archive all but comments.
}

trap clean EXIT
