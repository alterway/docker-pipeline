#!/usr/bin/env bash
#
# Job "code_review".
# PHP_CodeSniffer execution to the source code.
#
# Parameters:
#   --job-phpcs-error: Number of PHP_CodeSniffer errors accepted before declaring the job as status error. (defaults: 0)
#   --job-phpcs-warning: Number of PHP_CodeSniffer warnings accepted before declaring the job as status error. (defaults: 20)
#   --job-phpcs-ruleset-file: Path of a specific CodeSniffer ruleset file
#
write_info "# JOB: code_review"
show_help-verify:code_review

for option in "$@"; do
    case ${option} in
        --job-phpcs-error=*)
            acceptedPHPCSErrors="${option#*=}"
            shift
        ;;
        --job-phpcs-warning=*)
            acceptedPHPCSWarnings="${option#*=}"
            shift
        ;;
        --job-phpcs-ruleset-file=*)
            export CS_RULESET="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done
acceptedPHPCSErrors=${acceptedPHPCSErrors:-0}
acceptedPHPCSWarnings=${acceptedPHPCSWarnings:-20}

run_cmd "make job-analyse-static CS_ERRORS=${acceptedPHPCSErrors} CS_WARNING=${acceptedPHPCSWarnings} tools='cs-summary'"

nbErrors=$(cat "${STDOUT_LOG_FILE}" | (grep -E '[0-9]+ error' -o || true) | grep -E '[0-9]+' -o || true)
nbWarnings=$(cat "${STDOUT_LOG_FILE}" | (grep -E '[0-9]+ warning' -o || true) | grep -E '[0-9]+' -o || true)

if [ ! -z ${nbErrors} ] && [ ! -z ${nbWarnings} ]; then

    finalOutputInfo+=("Stage: verify / Job: code_review")
    finalOutputInfo+=("PHP_CodeSniffer found ${nbErrors} error(s).")
    finalOutputInfo+=("PHP_CodeSniffer found ${nbWarnings} warning(s).")
    finalOutputInfo+=("")

    if [[ ${nbErrors} -gt ${acceptedPHPCSErrors} ]]; then
        finalOutputError+=("Stage: verify / Job: code_review")
        finalOutputError+=("Error: Only ${acceptedPHPCSErrors} errors are accepted.");
        finalOutputError+=("A total of ${nbErrors} have been found.");
    fi
    if [[ ${nbWarnings} -gt ${acceptedPHPCSWarnings} ]]; then
        finalOutputError+=("Stage: verify / Job: code_review")
        finalOutputError+=("Error: Only ${acceptedPHPCSWarnings} warnings are accepted.");
        finalOutputError+=("A total of ${nbWarnings} have been found.");
    fi
else
    finalOutputError+=("Fatal error: The job has failed.");
    finalOutputError+=("Look the STDERR content for more information.");
    finalOutputError+=("A total of ${nbErrors} have been found.");
    finalOutputError+=("A total of ${nbWarnings} have been found.");
fi
