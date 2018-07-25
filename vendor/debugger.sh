#!/usr/bin/env bash
#
# Reset all files that were used for previous pipeline call for debugging or logging.

# Delete output and debug files
rm ${STDOUT_LOG_FILE} ${STDERR_LOG_FILE} 1>/dev/null 2>/dev/null || true

write_success "Success"
