#!/usr/bin/env bash
#
# Entry point of the stage "build".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: BUILD -------------------------" \
    "All jobs of this stage are:" \
    " - build_vendor: Build the vendor folder using composer." \
    " - build_documentation: Build the documentation of the given service."

case ${JOB} in
    'build_vendor')
        export JOB_FILE="${STAGE_PATH}/build_vendor.sh"
    ;;
    'build_documentation')
        export JOB_FILE="${STAGE_PATH}/build_documentation.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'build':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
