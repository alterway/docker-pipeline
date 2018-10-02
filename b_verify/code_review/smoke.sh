#!/usr/bin/env bash
#
# Job "smoke".
# Smoke tests. Currently use PHP lint to validate the source code.
#
# Parameters:
#   --job-phplint-error: Number of errors accepted before declaring the job as status error. (defaults: 0)
#
write_info "# JOB: smoke"
show_help-verify:smoke

for option in "$@"; do
    case ${option} in
        --job-phplint-error=*)
            acceptedPHPLintErrors="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done
acceptedPHPLintErrors=${acceptedPHPLintErrors:-0}

run_cmd "make verify-normal"

nbErrors=$(cat "${STDOUT_LOG_FILE}" | (grep -E '[0-9]+ ERRORS' -o || true) | grep -E '[0-9]+' -o || true)

if [ ! -z ${nbErrors} ]; then
    finalOutputInfo+=("Stage: verify / Job: smoke")
    finalOutputInfo+=("PHP lint found ${nbErrors} error(s).")
    finalOutputInfo+=("")

    if [[ ${nbErrors} -gt ${acceptedPHPLintErrors} ]]; then
        finalOutputError+=("Stage: verify / Job: smoke")
        finalOutputError+=("Error: Only ${acceptedPHPLintErrors} errors are accepted.");
        finalOutputError+=("A total of ${nbErrors} have been found.");
    fi

else
    finalOutputError+=("Fatal error: The job has failed.");
    finalOutputError+=("Look the STDERR content for more information.");
fi
