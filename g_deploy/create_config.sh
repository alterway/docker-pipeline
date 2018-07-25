#!/usr/bin/env bash
#
# Job "create_config".
# Create a docker config.
#
# Parameters:
#   --service
#   --job-config-name
#   --job-config-delete
#
write_info "# JOB: Create config"
show_help-deploy:create_config

for option in "$@"; do
    case ${option} in
        --job-config-name=*)
            export CONFIG_NAME="${option#*=}"
            shift
        ;;
        --job-config-file=*)
            export CONFIG_FILE="${option#*=}"
            shift
        ;;
        --job-config-delete)
            export CONFIG_DELETE=1
            shift
        ;;
        *) shift ;;
    esac
done

export CONFIG_NAME=${CONFIG_NAME:-}
export CONFIG_NAME=${CONFIG_FILE:-}
export CONFIG_DELETE=${CONFIG_DELETE:-0}

finalOutputInfo+=("Stage: deploy / Job: Create config")
finalOutputInfo+=("Creating a docker config...")
finalOutputInfo+=("")

if [ -z "${CONFIG_NAME}" ]; then
    finalOutputError+=("The parameter --job-config-name is not defined.");
    finalOutputError+=("");
fi

# erase all volumes that have to been mounted
if [ ${CONFIG_DELETE} -eq 1 ]; then
    docker config rm ${CONFIG_NAME}
fi

# we create config
#if [ ! "$(docker config ls | grep -w ${CONFIG_NAME})" ]; then
echo "we create the ${CONFIG_NAME} network"
(docker config create ${CONFIG_NAME} ${CONFIG_FILE} )  || true ;
#fi
