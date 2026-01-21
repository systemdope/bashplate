#!/usr/bin/env bash

# Script Information ##########################################################
#
# This information may also appear in the Script Metadata section.
#
# Script Name: hello
# Description: hello - is a script template with a number of useful features
# - error handling
# - argument processing
# - temporary directory and files
# - TODO config file
# - TODO logging
# - TODO debug
# - cleanup upon exit
#
# Author:
# Email:
# Project Homepage: https://github.com/systemdope/bash_template

# Notes #######################################################################
#
# Notes can be added here as well as any script-wide todo items.
#
# TODO place here all todo items with script-wide relevance
# TODO try to keep the todo items grouped and ordered in a reasonable manner
# TODO use FIXME codetags to document bugs or poorly-implemented code
# TODO sparingly use XXX codetags to highlight critical or important issues
# TODO debug by surrounding code blocks with -x and +x to see commands
# TODO debug script via 'bash -x hello.sh' to see executed commands
# TODO style inline comments with two leading spaces  # like this
# TODO style headers with "#" to column 79
# TODO style headers with one blank line above
# TODO style headers with one blank line or empty comment line below

# Error Handling ##############################################################

# Bash Settings. See 'man bash' for more information
set -o errexit  # -e: exit immediately if a pipeline fails
set -o nounset  # -u: during command expansion, unset variables cause an errors
set -o pipefail  # the return value is equal to the  value of the last command

# Signal Traps
trap cleanup ERR
#trap cleanup EXIT  # do not trap EXIT, call cleanup explicitly
trap cleanup SIGTERM
trap cleanup SIGINT  # generated on ctrl-c

# Metadata Constants ##########################################################
#
# # Information about this script, held in constants.

SCRIPT_NAME="hello"
SCRIPT_VERSION="0.0.1"
SCRIPT_LICENSE="gplv3"
SYSTEM_DOPE_VERSION="0.0.1"
SCRIPT_HOMEPAGE="https://github.com/systemdope/bash_template"
DESCRIPTION="Template for SystemDope bash scripts"
AUTHOR_NAME=""
AUTHOR_EMAIL=""

# Global Variables ############################################################

CONFIG_PATH=""
GREETING="Hello, World!"  # default greeting
TMP_DIR=""

# Usage #######################################################################
#
# Use a variable, so usage info can appear above function declarations.

USAGE="Usage: ${SCRIPT_NAME} [OPTION]...
Description: ${DESCRIPTION}
Example: ${SCRIPT_NAME}
Output:

Commands:

Flags:
  -c, --config=CONFIG_PATH  define config file path
  -g, --greeting=GREETING   defing GREETING
  -h, --help                print this help message
      --license             print license information
  -v, --version             print this script's name and version

Author: ${AUTHOR_NAME}
Source: ${SCRIPT_HOMEPAGE}"  # notice the closing quote on the last line here

# Function Declarations #######################################################
#
# Tip: List all functions/descriptions via "grep Description hello.sh"
# TODO improve how functions return/exit

# Description: permaloop - loops forever, for testing and debugging
# Arguments: none
# Returns: none
function permaloop {
	while true; do
		printf "This loop runs forever... Press Ctrl + C to stop.\n"
		sleep 1
	done
}

# Description: cleanup - performs multiple tasks before script exit
#		- remove temporary files
#		- kill background processes
#		TODO release file locks
#		TODO close open files
#		TODO error reporting
# Arguments: none
# Returns: 0 if successful, non-zero otherwise
function cleanup {
	printf "cleaning up...\n"
	# Remove Temporary Directory
	if [[ -d "${TMP_DIR}" ]]; then
		rm -rf "${TMP_DIR}"
	else
		printf "no directory ${TMP_DIR}\n"
	fi
	exit
}

# Description: usage - displays usage information
# Arguments: none
# Returns: none
function usage {
	printf "${USAGE}\n"
	exit 0
}

# Argument Processing #########################################################
#
# TODO create argument processing function(s)

while [[ $# -gt 0 ]]; do  # $# is the number of script arguments
	case "${1}" in
	# Flag Arguments
		-c|--config)
			shift
			if [[ $# -gt 0 ]]; then
				CONFIG_PATH="${1}"
			else
				printf "missing argument\n"
				exit 1
			fi
			shift
			;;
		-g|--greeting)
			shift
			if [[ $# -gt 0 ]]; then
				GREETING="${1}"
			else
				printf "missing argument\n"
				exit 1
			fi
			shift
			;;
		-h|--help)
			usage
			#printf "${USAGE}\n"
			exit
			;;
		--license)
			printf "${SCRIPT_LICENSE}\n"
			exit
			;;
		-v|--version)
			printf "${SCRIPT_NAME} ${SCRIPT_VERSION}\n"
			exit
			;;
	# Non-flag Arguments
		*)
			printf "Unknown command: ${1}\n"
			exit
			;;
	esac
done

# Main Logic ##################################################################

# Create a temporary directory
TMP_DIR=$(mktemp -d) || { echo "Failed to create directory"; exit 1; }

# Create a temporary file within the temporary directory
touch "${TMP_DIR}/greet.txt"

# Send greeting to temporary file then read from file and print
printf "${GREETING}" >  "${TMP_DIR}/greet.txt"
printf "GREETING: "  # Print the contents of the greeting file
cat "${TMP_DIR}/greet.txt"
printf "\n"

# TODO read and process config file
printf "CONFIG_PATH: ${CONFIG_PATH}\n"

permaloop

exit 0

# The funciton 'cleanup' will be executed at the very end upon exit
