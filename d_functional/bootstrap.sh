#!/usr/bin/env bash
#
# Entry point of the stage "functional".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: FUNCTIONAL -------------------------" \
    "All jobs of this stage are:" \
    " - phpunit_unit: Execute all unit tests that must cover the application." \
    " - phpunit_functional: Execute the functional unit tests."

case ${JOB} in
    'phpunit_unit')
        export JOB_FILE="${STAGE_PATH}/phpunit/phpunit_unit.sh"
    ;;
    'phpunit_functional')
        export JOB_FILE="${STAGE_PATH}/phpunit/phpunit_functional.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'functional':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
