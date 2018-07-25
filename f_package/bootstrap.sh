#!/usr/bin/env bash
#
# Entry point of the stage "package".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: PACKAGE -------------------------" \
    "All jobs of this stage are:" \
    " - package_service: Create the package of the service for the API."

case ${JOB} in
    'package_service')
        export JOB_FILE="${STAGE_PATH}/package_service.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'package':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
