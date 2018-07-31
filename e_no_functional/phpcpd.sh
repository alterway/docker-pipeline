#!/usr/bin/env bash
#
# Job "phpcpd".
# PHP Copy/Paste Detector execution to the source code.
#
# Parameters:
#   --job-phpcpd-min-tokens: Minimum number of tokens that must be the same to declare a copy/paste snippet. (defaults: 70)
#   --job-phpcpd-min-lines: Minimum number of lines that must be the same to declare a copy/paste snippet. (defaults: 5)
#
write_info "# JOB: phpcpd"
show_help-no_functional:phpcpd

for option in "$@"; do
    case ${option} in
        --job-phpcpd-min-tokens=*)
            minTokens="${option#*=}"
            shift
        ;;
        --job-phpcpd-min-lines=*)
            minLines="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done
minTokens=${minTokens:-70}
minLines=${minLines:-5}

run_cmd "make job-analyse CPD_TOKENS=${minTokens} CPD_LINES=${minLines} tools='cpd'"
