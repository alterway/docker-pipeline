#!/usr/bin/env bash
#
# Job "create_volume".
# Create ad docker volumes with good user used in deploy container.
#
# Parameters:
#   --service
#   --job-volume-prefix
#   --job-volume-prefix-service
#   --job-volume-mount
#   --job-volume-mount-delete
#   --job-volume-uid
#   --job-volume-gid
#
write_info "# JOB: create volume"
show_help-deploy:create_volume

for option in "$@"; do
    case ${option} in
        --job-volume-prefix=*)
            export VOLUME_PREFIX="${option#*=}"
            shift
        ;;
        --job-volume-prefix-service=*)
            export VOLUME_PREFIX_SERVICE="${option#*=}"
            shift
        ;;
        --job-volume-mount=*)
            export VOLUME_MOUNT="${option#*=}"
            shift
        ;;
        --job-volume-mount-delete)
            export VOLUME_MOUNT_DELETE=1
            shift
        ;;
        --job-volume-uid=*)
            export VOLUME_UID="${option#*=}"
            shift
        ;;
        --job-volume-gid=*)
            export VOLUME_GID="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done

export VOLUME_PREFIX_SERVICE=${VOLUME_PREFIX_SERVICE:-}
export VOLUME_PREFIX=${VOLUME_PREFIX:-}
export VOLUME_MOUNT=${VOLUME_MOUNT:-}
export VOLUME_MOUNT_DELETE=${VOLUME_MOUNT_DELETE:-0}
export VOLUME_UID=${VOLUME_UID:-1000}
export VOLUME_GID=${VOLUME_GID:-1000}

finalOutputInfo+=("Stage: create_volume / Job: create_volume")
finalOutputInfo+=("Creating a docker volumes ...")
finalOutputInfo+=("")

#
if [ -z "${VOLUME_PREFIX}" ] && [ -z "${VOLUME_PREFIX_SERVICE}" ]; then
    finalOutputError+=("The parameter --job-volume-prefix or --job-volume-prefix-service is not defined.");
    finalOutputError+=("");
fi
if [ -z "${VOLUME_MOUNT}" ]; then
    finalOutputError+=("The parameter --job-volume-mount is not defined.");
    finalOutputError+=("");
fi

# erase all volumes that have to been mounted
if [ ${VOLUME_MOUNT_DELETE} -eq 1 ]; then
    for volume in ${VOLUME_MOUNT}; do
        echo "Deleting $volume volume..."

        docker run --rm -v ${VOLUME_PREFIX}:${VOLUME_PREFIX} --name ${SERVICE}-${CI_COMMIT_REF_NAME} -w ${VOLUME_PREFIX} alpine sh -c "(rm -rf $volume/*) || true"
    done
fi

# create the VOLUME_PREFIX path with specific UID in the runner in order to mount VOLUME_PREFIX with specific UID in container
docker run --rm -v ${VOLUME_PREFIX}:${VOLUME_PREFIX} --name ${SERVICE}-${CI_COMMIT_REF_NAME} -w ${VOLUME_PREFIX} alpine sh -c "(mkdir -p ${VOLUME_MOUNT}) || true"
docker run --rm -v ${VOLUME_PREFIX}:${VOLUME_PREFIX} --name ${SERVICE}-${CI_COMMIT_REF_NAME} alpine sh -c "(chown -R ${VOLUME_UID}:${VOLUME_GID} ${VOLUME_PREFIX}) || true"

# test
for volume in ${VOLUME_MOUNT}; do
    echo "The ${volume} repository view..."
    docker run --rm -v ${VOLUME_PREFIX}:${VOLUME_PREFIX} --name ${SERVICE}-${CI_COMMIT_REF_NAME} -w ${VOLUME_PREFIX} alpine sh -c "(ls -al ${volume}) || true"
done
