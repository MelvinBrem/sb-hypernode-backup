#!/usr/bin/env bash

COLOR_DEFAULT_TEXT="\033[0;39m"
COLOR_RED="\033[0;91m"
COLOR_WARNING="\033[0;93m"
COLOR_BLUE="\033[0;96m"

echo -e "${COLOR_RED}This is a red text${COLOR_DEFAULT_TEXT}"
echo -e "${COLOR_WARNING}This is a warning text${COLOR_DEFAULT_TEXT}"
echo -e "${COLOR_BLUE}This is a blue text${COLOR_DEFAULT_TEXT}"