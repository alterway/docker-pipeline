#!/usr/bin/env bash
#
# This script is used to display the result of the jobs that were run giving all information and errors.
# Use this script as a callee of "bootstrap.sh" of the pipeline.
#
# We display the content of the STDOUT and the STDERR of the job, if they exist.
# Then, display the information fetched from the job that ran.
# Finally, display the errors fetched from the job that ran, if there are.
#
# In case of errors, the process (called "build") is stopped with a error code status.
#

# Display log contents if exist.
if [ -f "${STDOUT_LOG_FILE}" ]; then
    write_default_block \
        "*****************************************************************" \
        "****                    CONTENT OF STDOUT                    ****" \
        "*****************************************************************"
    cat "${STDOUT_LOG_FILE}"
fi

if [ -f "${STDERR_LOG_FILE}" ]; then
    write_default_block \
        "*****************************************************************" \
        "****                    CONTENT OF STDERR                    ****" \
        "*****************************************************************"
    cat "${STDERR_LOG_FILE}"
fi

write_default "" ""

# Write info
if [ ${#finalOutputInfo[@]} -ge 1 ]; then
    write_info_block "- - - - - - - - - - - - - INFORMATION - - - - - - - - - - - - -"
    write_info "" "${finalOutputInfo[@]}"
fi

# Write errors
if [ ${#finalOutputError[@]} -ge 1 ]; then
    write_error_block "- - - - - - - - - - - - - - ERRORS - - - - - - - - - - - - - -"
    write_error "" "${finalOutputError[@]}" ""

    write_error_block "# ERRORS! The job has encountered some errors."
    write_default ""
    exit 1
fi

write_success_block "# SUCCESS! The job has been passed successfully."
write_default ""
