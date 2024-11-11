#!/usr/bin/env bash

COLOR_DEFAULT_TEXT="\033[0;39m"
COLOR_RED="\033[0;91m"
COLOR_ORANGE="\033[0;93m"
COLOR_GREEN="\033[0;92m"
COLOR_BLUE="\033[0;96m"

source ./library/check_env.sh

printf "${COLOR_BLUE}What do you want to do?${COLOR_DEFAULT_TEXT}\n"
printf "${COLOR_GREEN}1) Create a backup${COLOR_DEFAULT_TEXT}\n"
printf "${COLOR_GREEN}2) Restore a backup${COLOR_DEFAULT_TEXT}\n"
printf "${COLOR_BLUE}> "
read -r RESPONSE
case "$RESPONSE" in
1)
    source ./library/create_backup.sh
    ;;
2)
    source ./library/restore_backup.sh
    ;;
*)
    exit 1
    ;;
esac
