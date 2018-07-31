#!/usr/bin/env bash
#
# Job "pdepend".
# Run Pdepend tool on the source code.
#
write_info "# JOB: pdepend"
show_help-no_functional:pdepend

run_cmd "make job-analyse tools='pdepend'"
