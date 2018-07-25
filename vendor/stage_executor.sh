#!/usr/bin/env bash
#
# Execute the bootstrap.sh of the given stage

. ${STAGE_PATH}/bootstrap.sh

if [ ${#finalOutputError[@]} -ge 1 ]; then
    write_error "Error"
else
    write_success "Success"
fi
