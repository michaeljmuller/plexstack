#!/bin/bash

# this script clears out all the configuration and working files for all the containers

thisDir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

function resetDir() {
    find "$1" ! -name .gitignore -type f -exec rm -fv {} +
}

resetDir $thisDir/radarr/config
resetDir $thisDir/radarr/movies
resetDir $thisDir/sonarr/config
resetDir $thisDir/sonarr/tv
resetDir $thisDir/sabnzbd/config
resetDir $thisDir/sabnzbd/downloads
resetDir $thisDir/sabnzbd/incomplete-downloads
resetDir $thisDir/plex/config
