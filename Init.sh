#!/bin/ash
# Sourced by Activate.ps1 busybox mode.
# PATH and venv are already configured
# so do NOT re-configure them here.
# This file is only for ash interactive-shell
# personalization (prompt, aliases, etc.)

alias ll='ls -alF'
alias la='ls -A'
alias cls='clear'

printf "\033[1;32mWelcome to the BusyBox interactive shell at %s!\033[0m\n" "$PWD"
