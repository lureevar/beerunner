#!/usr/bin/env bash

declare -gr FILE_TO_INSTALL='bin/beerunner'
declare -g INSTALL_PATH='/usr/bin'

# Help function
function _help {
    eval "cat << EOF
Usage: ./$0 OPTION
A simple script to install beerunner
Options:
    l :     Install beerunner localy
    g :     Install beerunner globaly
    u :     Uninstall beerunner
    h :     Show this help message
EOF"
}

# Private utility function
function __is_root {
    if [ "$EUID" -eq 0 ]
    then
        return 0
    fi

    return 1
}

# Functions for installing and uninstalling
function _install {
    if ! __is_root
    then
        echo "You need to be root to run this script"
        exit 1
    fi

    if [ -x "$INSTALL_PATH" ]
    then
        echo "Making the file executable"
        eval "chmod +x $FILE_TO_INSTALL"
    fi

    echo "Installing beerunner in $INSTALL_PATH"
    eval "cp $FILE_TO_INSTALL $INSTALL_PATH"
    echo "beerunner was installed successfully"
}

function _uninstall {
    if ! __is_root
    then
        echo "You need to be root to run this script"
        exit 1
    fi

    if [ -z "$INSTALL_PATH" ]
    then
        echo "beerunner is not installed"
        exit 1
    fi

    echo "Uninstalling beerunner from $INSTALL_PATH"
    eval "rm -f $INSTALL_PATH"
    echo "beerunner was unistalled successfully"
}

# Testing arguments
if [ "$#" -eq 0 ]
then
    echo "Missing option argument (try h)"
    exit 1
fi

# Main of the program
case "$1" in
    'l') INSTALL_PATH='/usr/local/bin' ; _install ;;
    'g') INSTALL_PATH='/usr/bin' ; _install ;;
    'u') INSTALL_PATH=$(which beerunner) ; _uninstall ;;
    'h') _help ; exit 0
esac
