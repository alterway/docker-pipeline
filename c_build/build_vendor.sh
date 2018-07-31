#!/usr/bin/env bash
#
# Job "build_vendor".
# Build the vendor folder using composer.
#
write_info "# JOB: build_vendor"
show_help-build:build_vendor

run_cmd "make prepare-composer-install OPTIONS_COMP=--no-dev"

if [ -d www/vendor ]; then
    finalOutputInfo+=("Stage: build / Job: build_vendor")
    finalOutputInfo+=("The vendor is correctly built.")
    finalOutputInfo+=("")
else
    finalOutputError+=("Stage: build / Job: build_vendor")
    finalOutputError+=("The vendor directory is empty.")
    finalOutputError+=("")
fi
