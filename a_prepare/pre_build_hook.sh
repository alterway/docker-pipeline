#!/usr/bin/env bash
#
# Job "pre_build_hook".
# Install the Git submodules of the given service.
#

write_info "# JOB: pre_build_hook"
show_help-prepare:pre_build_hook

run_cmd "make install-git-submodules"

if [ "$(ls -A config/phing)" ]; then
    finalOutputInfo+=("The directory 'config/phing' is created successfully.")
else
    finalOutputError+=("The directory 'config/phing' is empty.")
fi
