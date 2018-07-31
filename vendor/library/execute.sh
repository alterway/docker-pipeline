#!/usr/bin/env bash
#
# Library of functions useful for executing jobs and commands.
# Use this script as a callee of "autoload.sh" of the pipeline.
#

# Define a function that will try to call a specific job in the service, if exists
execute_job()
{
    JOB_FILE=${1:-}

    if [ -z "${JOB_FILE}" ] ; then
        write_error_block "The parameter JOB_FILE does not exist." \
            "You need to call the function 'execute_job' using the pipeline workflow with good STAGE and JOB."
        exit 1
    fi

    # We reload the specific command name about service if file exist
    if [ -f "${JOB_FILE}_${SERVICE}.sh" ]; then
        write_info "Overloading of file ${JOB_FILE}.sh succeed." \
            "The JOB_FILE is now ${JOB_FILE}_${SERVICE}.sh."
        export JOB_FILE="${JOB_FILE}_${SERVICE}.sh"
    fi

    # Verify the existence of the job file.
    if [ ! -f "${JOB_FILE}" ]; then
        write_error_block "The parameter JOB_FILE ${JOB_FILE} references a file that does not exist."
        exit 1
    fi

    shift

    # We execute the command
    write_info "Executing the job: ${JOB_FILE}."
    . ${JOB_FILE}
}

# Take a command in argument and add this command in the information data array before running it.
run_cmd()
{
    CMD=${1:-}

    write_info "# Command: ${CMD}"
    echo "# Command: ${CMD} \r\n" >>${STDOUT_LOG_FILE}
    echo "# Command: ${CMD} \r\n" >>${STDERR_LOG_FILE}
    bash -c "${CMD} 1>>${STDOUT_LOG_FILE} 2>>${STDERR_LOG_FILE} || true"
    echo "# End--- \r\n" >>${STDOUT_LOG_FILE}
    echo "# End--- \r\n" >>${STDERR_LOG_FILE}
}

# slugify
slugify()
{
    if [ ! -z "$1" ]; then
        echo "$1" | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z
    else
        echo "";
    fi
}
