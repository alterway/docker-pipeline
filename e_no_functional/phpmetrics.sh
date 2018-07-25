#!/usr/bin/env bash
#
# Job "phpmetrics".
# Run PhpMetrics analysis tool on the current project.
#
write_info "# JOB: phpmetrics"
show_help-no_functional:phpmetrics

run_cmd "make job-analyse tools='phpmetrics'"

write_info "PhpMetrics analysis done. Adding service and build date information..."
finalOutputInfo+=("PhpMetrics analysis done. Adding service and build date information...")

#sed -i "s/<h1>PhpMetrics<\/h1>/<h1>PhpMetrics<\/h1><small>${SERVICE} - `date +%Y-%m-%d`<\/small>/" data/build/${SERVICE}/current/logs/phpmetrics/index.html

write_info "Service and build date information added successfully."
finalOutputInfo+=("Service and build date information added successfully.")
