#!/usr/bin/env bash
#
# Job "create_network".
# Create a docker network.
#
# Parameters:
#   --service
#   --job-network-name
#   --job-network-driver
#   --job-network-subnet
#   --job-network-encrypt
#   --job-network-labels
#   --job-network-attachable
#   --job-network-delete
#
write_info "# JOB: Create network"
show_help-deploy:create_network

for option in "$@"; do
    case ${option} in
        --job-network-name=*)
            export NETWORK_NAME="${option#*=}"
            shift
        ;;
        --job-network-driver=*)
            export NETWORK_DRIVER="${option#*=}"
            shift
        ;;
        --job-network-subnet=*)
            export NETWORK_SUBNET="${option#*=}"
            shift
        ;;
        --job-network-encrypt)
            export NETWORK_ENCRYPT="--opt encrypted=true"
            shift
        ;;
        --job-network-labels=*)
            export NETWORK_LABELS="${option#*=}"
            shift
        ;;
        --job-network-attachable)
            export NETWORK_ATTACHABLE="--attachable"
            shift
        ;;
        --job-network-delete)
            export NETWORK_DELETE=1
            shift
        ;;
        *) shift ;;
    esac
done

export NETWORK_NAME=${NETWORK_NAME:-}
export NETWORK_DRIVER=${NETWORK_DRIVER:-overlay}
export NETWORK_SUBNET=${NETWORK_SUBNET:-}
export NETWORK_ENCRYPT=${NETWORK_ENCRYPT:-}
export NETWORK_LABELS=${NETWORK_LABELS:-}             # Variable that can be overwritten by option -U or --UCP. ex: --network-labels="--label com.docker.ucp.access.label=prod"
export NETWORK_ATTACHABLE=${NETWORK_ATTACHABLE:-}
export NETWORK_DELETE=${NETWORK_DELETE:-0}

finalOutputInfo+=("Stage: deploy / Job: Create network")
finalOutputInfo+=("Creating a docker network...")
finalOutputInfo+=("")

if [ -z "${NETWORK_NAME}" ]; then
    finalOutputError+=("The parameter --job-network-name is not defined.");
    finalOutputError+=("");
fi

# erase all volumes that have to been mounted
if [ ${NETWORK_DELETE} -eq 1 ]; then
    docker network rm ${NETWORK_NAME}
fi

# we create network
#if [ ! "$(docker network ls | grep -w ${NETWORK_NAME})" ]; then
echo "we create the ${NETWORK_NAME} network"
(docker network create ${NETWORK_ENCRYPT} --driver=${NETWORK_DRIVER} ${NETWORK_ATTACHABLE} ${NETWORK_SUBNET} ${NETWORK_LABELS} --label com.docker.stack.namespace=${PROJECT_NAME} ${NETWORK_NAME})  || true ;
#fi
