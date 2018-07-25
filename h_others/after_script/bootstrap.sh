#!/usr/bin/env bash
#
# Entry point of the stage "after_script".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: AFTER SCRIPT -------------------------" \
    "All jobs of this stage are:" \
    " - clean_up: Clean all unused containers and images." \
    " - make_documentation: Create and save the documentation of the service." \
    " - prepare_esb: Create rabbitMQ configuration of the service."

case ${JOB} in
    'clean_up')
        export JOB_FILE="${STAGE_PATH}/clean_up.sh"
    ;;
    'make_documentation')
        export JOB_FILE="${STAGE_PATH}/make_documentation.sh"
    ;;
    'prepare_esb')
        export JOB_FILE="${STAGE_PATH}/prepare_esb.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'after_script':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
