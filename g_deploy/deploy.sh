#!/usr/bin/env bash
#
# Job "deploy".
# Deploy a service.
#
# Parameters:
#   --service
#   --project-name
#   --deploy-version
#   --environment-type
#   --subdomain
#   --domain
#   --registry
#   --job-network-name
#   --job-images-tag-group
#   --job-images-name-group: Name of the image used as a suffix for the name of the image tag (defaults = '').
#   --job-mod-dev
#   --job-volume-prefix
#   --job-volume-prefix-service
#
write_info "# JOB: deploy"
show_help-deploy:deploy

for option in "$@"; do
    case ${option} in
        --job-images-tag-group=*)
            IMAGE_TAG_GROUP="${option#*=}"
            shift
        ;;
        --job-images-name-group=*)
            IMAGE_NAME_GROUP="${option#*=}"
            shift
        ;;
        --job-mod-dev)
            MOD_DEV=1
            shift
        ;;
        --job-network-name=*)
            export NETWORK_NAME="${option#*=}"
            shift
        ;;
        --job-volume-prefix=*)
            export VOLUME_PREFIX="${option#*=}"
            shift
        ;;
        --job-volume-prefix-service=*)
            export VOLUME_PREFIX_SERVICE="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done

export IMAGE_TAG_GROUP=${IMAGE_TAG_GROUP:-}
export IMAGE_NAME_GROUP=${IMAGE_NAME_GROUP:-}
export MOD_DEV=${MOD_DEV:-}

export NETWORK_NAME=${NETWORK_NAME:-}

export VOLUME_PREFIX_SERVICE=${VOLUME_PREFIX_SERVICE:-}
export VOLUME_PREFIX=${VOLUME_PREFIX:-}

finalOutputInfo+=("Stage: deploy / Job: deploy")
finalOutputInfo+=("Deploying the service ${SERVICE}...")
finalOutputInfo+=("")

if [ -z "${IMAGE_TAG_GROUP}" ] && [ -z "${IMAGE_NAME_GROUP}" ]; then
    finalOutputError+=("The parameters --job-images-tag-group or --job-images-name-group is not defined.");
    finalOutputError+=("");
fi
if [ -z "${PROJECT_NAME}" ]; then
    finalOutputError+=("The parameter --project-name is not defined.");
    finalOutputError+=("");
fi
if [ -z "${REGISTRY}" ]; then
    finalOutputError+=("The parameter --registry is not defined.");
    finalOutputError+=("");
fi
if [ -z "${DOMAIN}" ]; then
    finalOutputError+=("The parameter --domain is not defined.");
    finalOutputError+=("");
fi
if [ -z "${SUBDOMAIN}" ]; then
    finalOutputError+=("The parameter --subdomain is not defined.");
    finalOutputError+=("");
fi
if [ -z "${NETWORK_NAME}" ]; then
    finalOutputError+=("The parameter --job-network-name is not defined.");
    finalOutputError+=("");
fi
if [ -z "${VOLUME_PREFIX}" ] && [ -z "${VOLUME_PREFIX_SERVICE}" ]; then
    finalOutputError+=("The parameter --job-volume-prefix or --job-volume-prefix-service is not defined.");
    finalOutputError+=("");
fi

finalOutputInfo+=("Deploy in the ${NETWORK_NAME} NETWORK")
finalOutputInfo+=("Deploy with the following images: ")

if [ ! -z "${IMAGE_TAG_GROUP}" ]; then
    i=1
    for tag in ${IMAGE_TAG_GROUP[@]} ; do
        export IMAGE_TAG_$i=$tag
        echo "Construct IMAGE_TAG_$i image tag"
        ((i++))
    done
elif [ ! -z "${IMAGE_NAME_GROUP}" ]; then
    i=1
    for name in ${IMAGE_NAME_GROUP[@]} ; do
        export IMAGE_TAG_$i="${SERVICE}-$name:${CI_COMMIT_REF_NAME}"
        echo "Construct IMAGE_TAG_$i image tag"
        ((i++))
    done
fi

# we create docker-compose
FILES_TO_SED_CMD="find ./config/docker/${SUFFIX_VS}/${INFRA_ENV}/${SERVICE} -type f"
${FILES_TO_SED_CMD} | xargs -n1 sed -i "s/~~CI_COMMIT_REF_NAME~~/${CI_COMMIT_REF_NAME}/g"
${FILES_TO_SED_CMD} | xargs -n1 sed -i "s/~~SERVICE~~/${SERVICE}/g"
${FILES_TO_SED_CMD} | xargs -n1 sed -i "s/~~DOMAIN~~/${DOMAIN}/g"
${FILES_TO_SED_CMD} | xargs -n1 sed -i "s/~~SUBDOMAIN~~/${SUBDOMAIN}/g"

echo "We deploy services with application's images in ${REGISTRY} registry"
run_cmd "make -s deploy"
