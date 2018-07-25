#!/usr/bin/env bash
#
# Entry point of the pipeline.
# This script must take at least X arguments:
# - The name of the stage where must belong the job to run.
# - The name of the job to run.
# - The name of the service.
# - The verbosity level (enabled or disabled).
#
# It may contains other parameters if the specific called job requires some.
#
# This pipeline contains all jobs a service can call using its continuous integration process.

# Bash good practices: set options and "magic variables".
#set -o errexit
#set -o pipefail
set -o nounset
#set -o xtrace # Uncomment this to debug this script.

__version="2.0.2"
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"

# Setting dependencies
. ${__dir}/vendor/autoload.sh

write_reversed_block \
    "===================== PIPELINE BOOTSTRAP =======================" \
    "----------------------------------------------------------------" \
    "Check the following workflow:" \
    "   I. Reset debug and log files." \
    "  II. Setting the security on pipeline arguments." \
    " III. Execute stage command." \
    "  IV. Display the response."


# Reset debug and log files
write_summary "" " I. Reset debug and log files." ""
. ${__dir}/vendor/debugger.sh

# Setting and Loading variables of environment
write_summary "" " II. Setting the security on pipeline arguments." ""
. ${__dir}/vendor/security.sh

# Execute stage command
write_summary "" "III. Execute stage command." ""
. ${__dir}/vendor/stage_executor.sh

# Return Response
write_summary "" "IV. Display the response." ""
. ${__dir}/vendor/library/response.sh
