#!/usr/bin/env bash
#
# Entry point of the stage "no_functional".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: NO FUNCTIONAL -------------------------" \
    "All jobs of this stage are:" \
    " - php_analysis: Run analysis metrics on PHP source code." \
    " - create_dashboard: Create the dashboard grouping all results of the analysis done." \
    " - phpmetrics: Run PhpMetrics analysis tool on the current project." \
    " - phpcpd: PHP Copy/Paste Detector execution to the source code." \
    " - pdepend: Run Pdepend tool on the source code." \
    " - qa_all: Run all QA tools on the source code."

case ${JOB} in
    'php_analysis')
        export JOB_FILE="${STAGE_PATH}/php_analysis.sh"
    ;;
    'create_dashboard')
        export JOB_FILE="${STAGE_PATH}/create_dashboard.sh"
    ;;
    'phpmetrics')
        export JOB_FILE="${STAGE_PATH}/phpmetrics.sh"
    ;;
    'phpcpd')
        export JOB_FILE="${STAGE_PATH}/phpcpd.sh"
    ;;
    'pdepend')
        export JOB_FILE="${STAGE_PATH}/pdepend.sh"
    ;;
    'qa_all')
        export JOB_FILE="${STAGE_PATH}/qa_all.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'no_functional':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
