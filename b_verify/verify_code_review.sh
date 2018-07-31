#!/usr/bin/env bash
#
# Run both jobs "smoke" and "code_review".
#

execute_job "${STAGE_PATH}/code_review/smoke.sh" "${JOB_OPTIONS[@]:-}"
execute_job "${STAGE_PATH}/code_review/code_review.sh" "${JOB_OPTIONS[@]:-}"
