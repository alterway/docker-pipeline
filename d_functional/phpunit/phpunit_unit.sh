#!/usr/bin/env bash
#
# Job "phpunit_unit".
# Execute all unit tests that must cover the application.
#
# Parameters:
#   --job-phpunit-error: Number of PHPUnit errors accepted before declaring the job as status error (defaults = 30).
#   --job-phpunit-failure: Number of PHPUnit failures accepted before declaring the job as status error (defaults = 30).
#
write_info "# JOB: phpunit_unit"
show_help-functional:phpunit_unit

for option in "$@"; do
    case ${option} in
        --job-phpunit-error=*)
            acceptedPHPUnitErrors="${option#*=}"
            shift
        ;;
        --job-phpunit-failure=*)
            acceptedPHPUnitFailures="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done

acceptedPHPUnitErrors=${acceptedPHPUnitErrors:-30}
acceptedPHPUnitFailures=${acceptedPHPUnitFailures:-30}

run_cmd "make job-test-integration group=unit"

phpunit_summary=$(cat "${STDOUT_LOG_FILE}" | grep -i "test" | tail -1)
write_info "PHPUnit Summary: ${phpunit_summary}"

# If the summary line starts with "OK", then it was 100% with no warnings.
if [ "OK" = ${phpunit_summary:0:2} ]; then
    finalOutputInfo+=("Stage: functional / Job: phpunit_unit")
    finalOutputInfo+=("No errors found on unit tests.")
    finalOutputInfo+=("")
else
    if [[ ${phpunit_summary} == *Errors:* ]]; then found_errors=$(( $(echo ${phpunit_summary} | grep -E "Errors: [0-9]+" -o | cut -d' ' -f2-) )); else found_errors=0; fi
    if [[ ${phpunit_summary} == *Failures:* ]]; then found_failures=$(( $(echo ${phpunit_summary} | grep -E "Failures: [0-9]+" -o | cut -d' ' -f2-) )); else found_failures=0; fi
    if [[ ${phpunit_summary} == *Skipped:* ]]; then found_skipped=$(( $(echo ${phpunit_summary} | grep -E "Skipped: [0-9]+" -o | cut -d' ' -f2-) )); else found_skipped=0; fi
    if [[ ${phpunit_summary} == *Incomplete:* ]]; then found_incomplete=$(( $(echo ${phpunit_summary} | grep -E "Incomplete: [0-9]+" -o | cut -d' ' -f2-) )); else found_incomplete=0; fi
    if [[ ${phpunit_summary} == *Risky:* ]]; then found_risky=$(( $(echo ${phpunit_summary} | grep -E "Risky: [0-9]+" -o | cut -d' ' -f2-) )); else found_risky=0; fi
    if [[ ${phpunit_summary} == *Tests:* ]]; then nb_tests=$(( $(echo ${phpunit_summary} | grep -E "Tests: [0-9]+" -o | cut -d' ' -f2-) )); else nb_tests=0; fi

    finalOutputInfo+=("Stage: functional / Job: phpunit_unit")
    finalOutputInfo+=("PHPUnit summary: ${phpunit_summary}")
    finalOutputInfo+=("")

    if [[ ${found_failures} -gt ${acceptedPHPUnitFailures} ]]; then
        finalOutputError+=("Stage: functional / Job: phpunit_unit")
        finalOutputError+=("Only ${acceptedPHPUnitFailures} failures are accepted while ${found_failures} found.");
    fi
    if [[ ${found_errors} -gt ${acceptedPHPUnitErrors} ]]; then
        finalOutputError+=("Stage: functional / Job: phpunit_unit")
        finalOutputError+=("Only ${acceptedPHPUnitErrors} errors are accepted while ${found_errors} found.");
    fi
    if [ ${nb_tests} -eq 0 ]; then
        finalOutputError+=("Stage: functional / Job: phpunit_unit")
        finalOutputError+=("No tests executed.")
    fi
fi
