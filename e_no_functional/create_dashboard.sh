#!/usr/bin/env bash
#
# Job "create_dashboard".
# Create the dashboard grouping all results of the analysis done.
#
write_info "# JOB: create_dashboard"
show_help-no_functional:create_dashboard

run_cmd "make dashboard"
write_info "Dashboard created."
finalOutputInfo+=("Dashboard created.")

write_info "List of files in the current build."
write_info `find {,data/build/${SERVICE}/current/logs/*}`
