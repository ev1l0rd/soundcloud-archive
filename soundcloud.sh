#!/bin/bash
# -- SOUNDCLOUD ARCHIVE SCRIPT --
# written by ev1l0rd
# under the MIT License
# archives an entire soundcloud user to archive.org

function usage() {
	cat <<EOF
	Usage: $0 SOUNDCLOUD_USER

	SOUNDCLOUD_USER is an URL leading to a Soundcloud profile (MUST BE HTTPS).
	
	e.g. https://soundcloud.com/jimquisiton

EOF
}

function dependency_check() {
	command -v pip2 >/dev/null 2>&1 || { echo >&2 "PIP for Python 2.7 is not installed. Install pip for Python 2.7, then re-run this script."; exit 1; }
	command -v ia >/dev/null 2>&1 || { echo >&2 "Internet Archive tools not installed."; IA_TOOLS_SETUP="yes"; }
	command -v youtube-dl >/dev/null 2>&1 || { echo >&2 "Youtube-DL not installed."; YOUTUBEDL_SETUP="yes"; }
	
}

function dependency_fix() {
	if [[ "$YOUTUBEDL_SETUP" == "yes" ]]; then {
		sudo pip install youtube-dl
		echo "youtube-dl installed. Continuing."
	} fi
	if [[ "$IA_TOOLS_SETUP" == "yes" ]]; then {
		sudo pip install internetarchive
		echo "Internet Archive Tools installed. Please run 'ia configure', then re-run this script."
		exit 0
	} fi
}

function create_temp_dir() {
	#shortened version of https://stackoverflow.com/a/34676160/4666756
	curdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	temp_dir=$(mktemp -d -p "$curdir")
	if [[ ! "$temp_dir" || ! -d "$temp_dir" ]]; then
	  echo "Could not create temporary directory."
	  exit 1
	fi
}

function clean() {
	rm -rf "$temp_dir"
	echo "Temporary directory removed"
}

function youtubedl_download() {
	cd "$temp_dir" || exit 1
	youtube-dl --write-description --write-thumbnail --write-info-json "$SOUNDCLOUD_URL"
	#these config options archive the thumbnail and description
	cd "$curdir" || exit 1
}

function ia_upload() {
	USER_URL="${SOUNDCLOUD_URL#https://soundcloud.com/}"
	ia upload "$USER_URL-soundcloud" "$temp_dir" --metadata="mediatype:audio" --metadata="collection:opensource_audio" --metadata="noindex:true"
	#items are noindex by default, so one can set the description and other xml data later.
}


#taken from https://unix.stackexchange.com/a/25947/178657
#cannot put this in function, since you cannot check for pos. params in a function
if [ $# -eq 0 ]; then
	echo "No URL given."
	usage
	exit 1
fi

SOUNDCLOUD_URL=$1
dependency_check
dependency_fix
create_temp_dir
youtubedl_download
ia_upload
clean

trap clean EXIT
