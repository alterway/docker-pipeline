#!/usr/bin/env bash
#
# This script is used to set global variables upon the arguments used when the pipeline has been called.
# Use this script as a callee of "autoload.sh" of the pipeline.
#

# Define variables that must be set using options
export STAGE=''
export JOB=''
export SERVICE=''

JOB_OPTIONS=()

# Setting arrays for outputs
finalOutputInfo=()
finalOutputError=()

for option in "$@"; do
    case ${option} in
        -h|--help)
            show_help
            exit 0
        ;;
        -h=*|--help=*)
            jobName="${option#*=}"
            jobHelp="show_help-${jobName}"
            if [ -n "$(type -t ${jobHelp})" ] && [ "$(type -t ${jobHelp})" = function ]; then
                ${jobHelp}
                exit 0
            elif [ -z "${jobName}" ]; then
                show_help
                exit 0
            else
                write_error "No help provided for job ${jobName}." "Try ${__file} --help to see the usages."
                exit 1
            fi
        ;;
        -j=*|--job=*)
            stageAndJob="${option#*=}"          # ${stageAndJob} must be a string like "stage:job"
            if [ $(( $(expr index "${stageAndJob}" ":") )) = 0 ]; then
                write_error "Job format of '${stageAndJob}' is not allowed." \
                    "You must use the format 'stage:job'." \
                    "Try ${__file} --help to see the usages."
                exit 1
            fi
            export STAGE="${stageAndJob%:*}"    # ${STAGE} is the string before the ":"
            export JOB="${stageAndJob#*:}"      # ${JOB} is the string after the ":"
            shift
        ;;
        -l|--list)
            show_job_list
            exit 0
        ;;
        -r=*|--registry=*)
            export REGISTRY="${option#*=}"
            shift
        ;;
        -dm=*|--domain=*)
            export DOMAIN="${option#*=}"
            shift
        ;;
        -sdm=*|--subdomain=*)
            export SUBDOMAIN="${option#*=}"
            shift
        ;;
        -pn=*|--project-name=*)
            export PROJECT_NAME="${option#*=}"
            shift
        ;;
        -s=*|--service=*)
            export SERVICE="${option#*=}"
            shift
        ;;
        -dv=*|--deploy-version=*)
            export SUFFIX_VS="${option#*=}"
            shift
        ;;
        -e=*|--environment-type=*)
            export ENVIRONMENT_TYPE="${option#*=}"
            shift
        ;;
        -p=*|--php-cmd=*)
            export PHP_NAME_VALUE="${option#*=}"
            shift
        ;;
        -ps=*|--php-cmd-analyse-source=*)
            export ANALYSE_PATH="${option#*=}"
            shift
        ;;
        -pt=*|--php-cmd-analyse-target=*)
            export ANALYSE_PROJET_ENV="${option#*=}"
            shift
        ;;
        -c=*|--ci-build-ref-name=*)
            export CI_COMMIT_REF_NAME="${option#*=}"
            shift
        ;;
        -U=*|--UCP=*)
            export LABEL_UCP="${option#*=}"
            shift
        ;;
        -v|--verbose)
            export VERBOSE=1
        ;;
        -V|--version)
            write_info_block "Version of the pipeline is ${__version}."
            exit 0
        ;;
        -1=*|--log-stdout=*)
            export STDOUT_LOG_FILE="${option#*=}"
            shift
        ;;
        -2=*|--log-stderr=*)
            export STDERR_LOG_FILE="${option#*=}"
            shift
        ;;
        -R=*|--runner-type=*)
            export RUNNER_TYPE="${option#*=}"
            shift
        ;;
        --job-*)
            JOB_OPTIONS+=("${option}")
            shift
        ;;
        *)
            write_error "Unknown option -- '${option}'." "Try ${__file} --help to see the usages."
            exit 1
        ;;
    esac
done

if [ -z "${STAGE}" ] || [ -z "${JOB}" ]; then
    write_error "Fatal error: Missing the job. Use option -j or --job to define it." \
        "Try ${__file} --help to see the usages."
    exit 1
elif [ -z "${SERVICE}" ]; then
    write_error "Fatal error: Missing the service. Use option -s or --service to define it." \
        "Try ${__file} --help to see the usages."
    exit 1
fi

# Build useful variables using those defined now.
export STDOUT_LOG_FILE=${STDOUT_LOG_FILE:-/tmp/.pipeline.stdout.log} # Variable that can be overwritten by option -1 or --log-stdout.
export STDERR_LOG_FILE=${STDERR_LOG_FILE:-/tmp/.pipeline.stderr.log} # Variable that can be overwritten by option -2 or --log-stderr.
export VERBOSE=${VERBOSE:-1}                          # Variable that can be overwritten by option -v or --verbose.

export PROJECT_NAME=${PROJECT_NAME:-}                 # Name of the project
export SUFFIX_VS=${SUFFIX_VS:-swarm}
export ENVIRONMENT_TYPE=${ENVIRONMENT_TYPE:-preprod}  # Variable that can be overwritten by option -e or --environment-type.
export INFRA_ENV="${SERVICE}-${ENVIRONMENT_TYPE}"

export CI_COMMIT_REF_NAME=$(slugify "${CI_COMMIT_REF_NAME:-}")
export PHP_NAME_VALUE=${PHP_NAME_VALUE:-cmd}          # Variable that can be overwritten by option -p or --php-cmd.

export LABEL_UCP=${LABEL_UCP:-}                       # Variable that can be overwritten by option -U or --UCP. ex: --UCP="com.docker.ucp.access.label=prod"
export REGISTRY=${REGISTRY:-hub.alterway.fr/build}
export DOMAIN=${DOMAIN:-}
export SUBDOMAIN=${SUBDOMAIN:-}
