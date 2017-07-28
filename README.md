## soundcloud-archive tool

A simple shell script that will archive all soundcloud tracks from a single user, along with all the json data, description and thumbnails. It will likely only work on Linux due to mktemp having different flags on macOS.

Grabs the publicly available 128kbps MP3 streams for each item using youtube-dl.

After that, it will publish all data to an archive.org item.

Made because [Jason Scott is forced to drop any official ArchiveTeam effort to save SoundCloud](https://twitter.com/textfiles/status/888093838107189249) ^[archive.is](http://archive.is/KrO14). This script is obviously not affiliated with ArchiveTeam (think it oughta be clear, but I'm saying this anyway).

Can be run multiple times, even while the previous script is running, generally without issues as `mktemp` is used to create a temporary directory that is removed after running the script.

### Installation

- Install pip for python 2.7 through your package manager, or from source.
- Clone this repository.

### Dependencies

Except for `pip2`, dependencies should be automatically satisfied upon running the script if it detects they are missing. If that fails, install these packages (`internetarchive` and `youtube-dl` should be installed through `pip2`).

- `pip2`
- `internetarchive`
- `youtube-dl`

If `internetarchive` is missing, the script will exit after installing it, instructing you to run `ia configure`. You will need to give your email and password for the internet archive when running it. If you don't have an account at the Internet Archive yet, you can [register for free](https://archive.org/account/login.createaccount.php). If `internetarchive` is already installed, I assume you have already ran `ia configure` (if you haven't done so, run it, otherwise the script will bork!)

### Usage

        Usage: ./soundcloud.sh SOUNDCLOUD_USER
 
        SOUNDCLOUD_USER is an URL leading to a Soundcloud profile (MUST BE HTTPS).
        
        e.g. https://soundcloud.com/jimquisiton

Items uploaded to archive.org will have the following metadata ($soundclouduser is the soundcloud username):

- Identifier: $soundclouduser-soundcloud
- Mediatype: audio
- Collection: opensource_audio
- noindex: true

Media files will be derived into different formats after uploading by archive.org.

These settings cannot be changed at the moment without editing the script.

Structure on archive.org will contain the full path on disk when uploading the data. This might cause you to accidentically doxx yourself. If you do not feel safe using this, clone to `/tmp` and run from there.

## License

    soundcloud.sh
    Copyright (C) 2017  Valentijn "Ev1l0rd"

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

