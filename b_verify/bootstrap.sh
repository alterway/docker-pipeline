#!/usr/bin/env bash
#
# Entry point of the stage "verify".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: VERIFY -------------------------" \
    "All jobs of this stage are:" \
    " - smoke: Smoke tests. Currently use PHP lint to validate the source code." \
    " - code_review: PHP_CodeSniffer execution to the source code." \
    " - verify_code_review: Execute both 'smoke' and 'code_review'."

case ${JOB} in
    'smoke')
        export JOB_FILE="${STAGE_PATH}/code_review/smoke.sh"
    ;;
    'code_review')
        export JOB_FILE="${STAGE_PATH}/code_review/code_review.sh"
    ;;
    'verify_code_review')
        export JOB_FILE="${STAGE_PATH}/verify_code_review.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'verify':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
