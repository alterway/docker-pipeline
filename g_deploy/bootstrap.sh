#!/usr/bin/env bash
#
# Entry point of the stage "deploy".
# List the jobs accessible from this stage and execute the given job.
#

write_info "------------------------- STAGE: DEPLOY -------------------------" \
    "All jobs of this stage are:" \
    " - deploy: All jobs that have to be execute before or after deploying a service." \

case ${JOB} in
    'delete_service')
        export JOB_FILE="${STAGE_PATH}/delete_service.sh"
    ;;
    'delete_down')
        export JOB_FILE="${STAGE_PATH}/delete_down.sh"
    ;;
    'create_config')
        export JOB_FILE="${STAGE_PATH}/create_config.sh"
    ;;
    'create_volume')
        export JOB_FILE="${STAGE_PATH}/create_volume.sh"
    ;;
    'create_network')
        export JOB_FILE="${STAGE_PATH}/create_network.sh"
    ;;
    'deploy')
        export JOB_FILE="${STAGE_PATH}/deploy.sh"
    ;;
    'prepare_services')
        export JOB_FILE="${STAGE_PATH}/prepare_services.sh"
    ;;
    'verify_deploy')
        export JOB_FILE="$STAGE_PATH/verify_deploy.sh"
    ;;
    *)
        write_error_block "# Error in the stage 'deploy':" \
            "Impossible to find the job ${JOB} in the authorized list."
        exit 1
    ;;
esac

# Execute job command.
execute_job ${JOB_FILE} "${JOB_OPTIONS[@]:-}"
