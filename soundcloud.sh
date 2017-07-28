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
	command -v pip2 >/dev/null 2>&1 || { echo >&2 "PIP for Python 2.7 is not installed. Install pip."; exit 1; }
	command -v ia >/dev/null 2>&1 || { echo >&2 "Internet Archive tools not installed."; IA_TOOLS_SETUP="yes"; }
	command -v youtube-dl >/dev/null 2>&1 || { echo >&2 "Youtube-DL not installed."; YOUTUBE-DL_SETUP="yes"; }
}
