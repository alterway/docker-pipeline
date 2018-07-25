#!/usr/bin/env bash
#
# Job "qa_all".
# Run all QA tools on the source code.
#
# Parameters:
#   --job-phpcs-error: Number of PHP_CodeSniffer errors accepted before declaring the job as status error. (defaults: 0)
#   --job-phpcs-warning: Number of PHP_CodeSniffer warnings accepted before declaring the job as status error. (defaults: 20)
#   --job-phpcpd-min-tokens: Minimum number of tokens that must be the same to declare a copy/paste snippet. (defaults: 70)
#   --job-phpcpd-min-lines: Minimum number of lines that must be the same to declare a copy/paste snippet. (defaults: 5)
#
write_info "# JOB: qa_all"
show_help-no_functional:qa_all

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
        --job-phpcpd-min-tokens=*)
            cpdMinTokens="${option#*=}"
            shift
        ;;
        --job-phpcpd-min-lines=*)
            cpdMinLines="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done
acceptedPHPCSErrors=${acceptedPHPCSErrors:-0}
acceptedPHPCSWarnings=${acceptedPHPCSWarnings:-20}
cpdMinTokens=${cpdMinTokens:-70}
cpdMinLines=${cpdMinLines:-5}

# Run all tools
write_info "Run all QA tools: phpcs, pdepend, cpd, phpmetrics."
run_cmd "make job-analyse CPD_TOKENS=${cpdMinTokens} CPD_LINES=${cpdMinLines} CS_ERRORS=${acceptedPHPCSErrors} CS_WARNING=${acceptedPHPCSWarnings} tools='phpcs-summary cpd pdepend phpmetrics'"

finalOutputInfo+=("Job success.")
