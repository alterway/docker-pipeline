#!/usr/bin/env bash
#
# Entry point of the stage "prepare".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: PREPARE -------------------------" \
    "All jobs of this stage are:" \
    " - pre_build_hook: Install the Git submodules of the given service."

case ${JOB} in
    'pre_build_hook')
        export JOB_FILE="${STAGE_PATH}/pre_build_hook.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'prepare':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
