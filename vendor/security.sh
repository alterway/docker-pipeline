#!/usr/bin/env bash
#
# Apply security checks on arguments to be sure everything is correctly defined before running the job.

if [ -z ${SERVICE} ] ; then
    write_error_block "Error in the security checker: The parameter SERVICE is not defined." \
        "You must define it with the '--service' flag in your pipeline call."
    exit 1
fi

if [ -z "${CI_COMMIT_REF_NAME}" ]; then
    write_error_block "Error in the security checker: The parameter CI_COMMIT_REF_NAME is not defined." \
        "You must define it as an environment variable."
    exit 1
fi

if [ -z "${REGISTRY}" ]; then
    write_error_block "Error in the security checker: The parameter REGISTRY is not defined." \
        "You must define it with the '--registry' flag in your pipeline call."
    exit 1
fi

write_success "Success"
