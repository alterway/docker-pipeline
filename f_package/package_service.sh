#!/usr/bin/env bash
#
# Job "package_service".
# Create the package of the service for the API.
#
# Parameters:
#   --job-image-name: Name of the image used as a suffix for the name of the image tag (defaults = '').
#
write_info "# JOB: package_service"
show_help-package:package_service

for option in "$@"; do
    case ${option} in
        --job-image-tag=*)
            IMAGE_TAG="${option#*=}"
            shift
        ;;
        --job-image-name=*)
            IMAGE_NAME="${option#*=}"
            shift
        ;;
        --job-image-path=*)
            IMAGE_PATH="${option#*=}"
            shift
        ;;
        --job-image-build-arg=*)
            IMAGE_BUILD="${option#*=}"
            shift
        ;;
        --job-image-path-copy)
            export IMAGE_PATH_COPY=1
            shift
        ;;
        --job-image-path-build=*)
            export IMAGE_PATH_BUILD="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done

IMAGE_TAG=${IMAGE_TAG:-}
IMAGE_NAME=${IMAGE_NAME:-}
IMAGE_PATH=${IMAGE_PATH:-}
IMAGE_BUILD=${IMAGE_BUILD:-}
IMAGE_PATH_COPY=${IMAGE_PATH_COPY:-0}
IMAGE_PATH_BUILD=${IMAGE_PATH_BUILD:-}

if [ -z "${IMAGE_PATH}" ]; then
    IMAGE_PATH=config/docker/image/${IMAGE_NAME}
fi

if [ -z "${IMAGE_PATH_BUILD}" ]; then
    IMAGE_PATH_BUILD=${IMAGE_PATH}
fi

if [ -z "${IMAGE_TAG}" ]; then
    export IMAGE_TAG="${SERVICE}-${IMAGE_NAME}:${CI_COMMIT_REF_NAME}"
fi

finalOutputInfo+=("Stage: package / Job: package_service")
finalOutputInfo+=("Creating ${IMAGE_TAG} image...")
finalOutputInfo+=("")

if [ -z "${IMAGE_TAG}" ]; then
    finalOutputError+=("Stage: package / Job: package_service")
    finalOutputError+=("Fail to create the image ${image_tag}.");
    finalOutputError+=("");
fi

# copy repository of the dockerfile to root
if [ ${IMAGE_PATH_COPY} -eq 1 ] && [ ! -z "${IMAGE_PATH_BUILD}" ]; then
    cp -R ${IMAGE_PATH}/* ${IMAGE_PATH_BUILD}
fi

echo "delete the image"
(docker rmi -f ${REGISTRY}/${IMAGE_TAG}) || true
# docker pull $(awk '/^FROM[ \t\r\n\v\f]/ { print /:/ ? $2 : $2":latest" }' Dockerfile)
echo "done"

if [ -z "${LABEL_UCP}" ]; then
    echo "LABEL_UCP is unset building image without label";
    echo "...cmd : docker build ${IMAGE_BUILD} -t ${REGISTRY}/${IMAGE_TAG} ${IMAGE_PATH_BUILD}"
    docker build ${IMAGE_BUILD} -t ${REGISTRY}/${IMAGE_TAG} ${IMAGE_PATH_BUILD}
    echo "done"
else
    echo "LABEL_UCP is set to '$LABEL_UCP' building image with this label";
    echo "...cmd : docker build ${IMAGE_BUILD} --build-arg ucp_label=${LABEL_UCP} --label ${LABEL_UCP} -t ${REGISTRY}/${IMAGE_TAG} ${IMAGE_PATH_BUILD}"
    docker build ${IMAGE_BUILD} --build-arg ucp_label=${LABEL_UCP} --label ${LABEL_UCP} -t ${REGISTRY}/${IMAGE_TAG} ${IMAGE_PATH_BUILD}
    echo "done"
fi

echo "push the image"
echo "... cmd: docker push ${REGISTRY}/${IMAGE_TAG}"
(docker push ${REGISTRY}/${IMAGE_TAG}) || true
echo "done"
