#!/usr/bin/env bash
#
# This script is used to load global parameters upon the arguments used when the pipeline has been called.
# Use this script as a callee of the main "bootstrap.sh" of the pipeline.
#

# Load writings functions.
. ${__dir}/vendor/library/write.sh

# Define all help screens in functions.
. ${__dir}/vendor/library/help.sh

# Add functions utilities to execute jobs and commands.
. ${__dir}/vendor/library/execute.sh

# Setting and Loading variables of environment.
. ${__dir}/vendor/library/parameters.sh

# Install packages.
. ${__dir}/vendor/library/install.sh

# Get the stage path.
case ${STAGE} in
    'prepare')
        export STAGE_PATH="${__dir}/a_prepare"
    ;;
    'verify')
        export STAGE_PATH="${__dir}/b_verify"
    ;;
    'build')
        export STAGE_PATH="${__dir}/c_build"
    ;;
    'functional')
        export STAGE_PATH="${__dir}/d_functional"
    ;;
    'no_functional')
        export STAGE_PATH="${__dir}/e_no_functional"
    ;;
    'package')
        export STAGE_PATH="${__dir}/f_package"
    ;;
    'deploy')
        export STAGE_PATH="${__dir}/g_deploy"
    ;;
    'after_script')
        export STAGE_PATH="${__dir}/h_others/after_script"
    ;;
    *)
        write_error_block "# Error in autoload of the pipeline:" \
            "Impossible to find the stage ${STAGE} in the authorized list."
        exit 1
    ;;
esac
