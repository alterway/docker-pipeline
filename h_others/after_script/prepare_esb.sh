#!/usr/bin/env bash

#
# Job "prepare_esb".
# RabbitMQ configuration execution.
#
# Parameters:
#   --job-esb-option: additional esb hing options
#
write_info "# JOB: prepare_esb"
show_help-after_script:prepare_esb

for option in "$@"; do
    case ${option} in
        --job-esb-option=*)
            OPTIONS_ESB="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done
OPTIONS_ESB=${OPTIONS_ESB:-}

run_cmd "make prepare-esb OPTIONS_ESB=${OPTIONS_ESB}"

ifNoConnection=$(cat "${STDOUT_LOG_FILE}" | grep -Ec '.*Connection refused.*' || true);

if [[ $ifNoConnection -eq 0 ]]; then
    finalOutputInfo+=("Stage: after_script / Job: rmq_existed")
    finalOutputInfo+=("RabbitMQ found is correctly launched")
    finalOutputInfo+=("")
else
    finalOutputError+=("Fatal error: The rmq_existed has failed.");
    finalOutputError+=("RabbitMQ is not running !!!");
fi