#!/usr/bin/env bash
#
# This script is used to define helps and documentation for the whole pipeline and all jobs.
# Use this script as a callee of "autoload.sh" of the pipeline.
#

__file=${__file:-pipeline/bootstrap.sh}

show_help()
{
    echo -e "Usage: ${__file} -j|--job=JOB -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "  -d, --database-type\n\tSet the database(s) type(s) in the pipeline context." \
        "Can be 'orm', 'odm', 'couchdb' or a combination of those. Defaults to 'orm'.\n"
    echo -e "  -e, --environment-type\n\tSet the environment(s) type(s) in the pipeline context." \
        "Can be 'local', 'development', 'preprod' or 'prod'. Defaults to 'preprod'.\n"
    echo -e "  -h, --help\n\tDisplay this help screen." \
        "You can ask help for a specific job by giving its name in this option (--help=stage:job).\n"
    echo -e "  -j, --job\n\tName of the job the pipeline must execute. Format must be 'stage:job' (Ex: verify:smoke).\n"
    echo -e "  -l, --list\n\tDisplay the list of jobs.\n"
    echo -e "  -p, --php-cmd\n\tName of the PHP command to use through the whole pipeline. Defaults to 'cmd'.\n"
    echo -e "  -r, --registry\n\tCombined with option --environment-type." \
        "URL of the hub registry where all docker images are stored.\n" \
    echo -e "  -s, --service\n\tName of the service that defines the context execution of the pipeline.\n"
    echo -e "  -nl, ----network-labels\n\tnetwork labels."\
        "Used to add labels to the network." \
        "Exemple '--label com.docker.ucp.access.label=ucp-prod'.\n"
    echo -e "  -v, --verbose\n\tNot implemented yet.\n"
    echo -e "  -V, --version\n\tDisplay the version of the pipeline executed.\n"
    echo -e "  -1, --log-stdout\n\tLog file used for all output to stdout in all executed jobs." \
        "Defaults to '/tmp/.pipeline.stdout.log'.\n"
    echo -e "  -2, --log-stderr\n\tLog file used for all output to stderr in all executed jobs." \
        "Defaults to '/tmp/.pipeline.stderr.log'.\n"
    echo -e "  -R, --runner-type\n\tSet the runner type used." \
         "Can be 'dmz', 'dtpp'.\n"
    echo
    echo -e "Some jobs may require or use specific variables." \
        "Try option -h=JOB or --help=JOB with JOB as the job name to have more information about this job.\n"
}

show_help-prepare:pre_build_hook()
{
    echo -e "Usage: ${__file} -j|--job=prepare:pre_build_hook -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Install the Git submodules of the given service.\n"
}

show_help-verify:code_review()
{
    echo -e "Usage: ${__file} -j|--job=verify:code_review -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: PHP_CodeSniffer execution to the source code.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-phpcs-error\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHP_CodeSniffer errors accepted before declaring the job as status error." \
        "Defaults to 0.\n"
    echo -e "  --job-phpcs-warning\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHP_CodeSniffer warnings accepted before declaring the job as status error." \
        "Defaults to 20.\n"
}

show_help-verify:smoke()
{
    echo -e "Usage: ${__file} -j|--job=verify:smoke -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Smoke tests. Currently use PHP lint to validate the source code.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-phplint-error\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Number of errors accepted before declaring the job as status error." \
        "Defaults to 0.\n"
}

show_help-verify:verify_code_review()
{
    echo -e "Usage: ${__file} -j|--job=verify:verify_code_review -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Run both jobs 'verify:smoke' and 'verify:code_review'.\n"
    echo -e "Job verify:code_review\n"
    show_help-verify:code_review
    echo -e "Job verify:smoke\n"
    show_help-verify:smoke
}

show_help-build:build_documentation()
{
    echo -e "Usage: ${__file} -j|--job=build:build_documentation -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Build the documentation of the given service.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-doc-group-guide\n\t" \
        "\033[31mRequired\033[0m\n\t" \
        "Define the groups of documentation for the guide.\n"
    echo -e "  --job-doc-group-ref\n\t" \
        "\033[31mRequired\033[0m\n\t" \
        "Define the groups of documentation for the references.\n"
}

show_help-build:build_vendor()
{
    echo -e "Usage: ${__file} -j|--job=build:build_vendor -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Build the vendor folder using composer.\n"
}

show_help-functional:phpunit_functional()
{
    echo -e "Usage: ${__file} -j|--job=functional:phpunit_functional -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Execute the functional unit tests.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-phpunit-error\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHPUnit errors accepted before declaring the job as status error." \
        "Defaults to 30.\n"
    echo -e "  --job-phpunit-failure\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHPUnit failures accepted before declaring the job as status error." \
        "Defaults to 30.\n"
}

show_help-functional:phpunit_unit()
{
    echo -e "Usage: ${__file} -j|--job=functional:phpunit_unit -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Execute all unit tests that must cover the application.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-phpunit-error\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHPUnit errors accepted before declaring the job as status error." \
        "Defaults to 30.\n"
    echo -e "  --job-phpunit-failure\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHPUnit failures accepted before declaring the job as status error." \
        "Defaults to 30.\n"
}

show_help-no_functional:php_analysis()
{
    echo -e "Usage: ${__file} -j|--job=no_functional:php_analysis -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Run analysis metrics on PHP source code.\n"
}

show_help-no_functional:create_dashboard()
{
    echo -e "Usage: ${__file} -j|--job=no_functional:create_dashboard -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create the dashboard grouping all results of the analysis done.\n"
}
show_help-no_functional:phpmetrics()
{
    echo -e "Usage: ${__file} -j|--job=no_functional:phpmetrics -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Run PhpMetrics analysis tool on the current project.\n"
}

show_help-no_functional:phpcpd()
{
    echo -e "Usage: ${__file} -j|--job=no_functional:phpcpd -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: PHP Copy/Paste Detector execution to the source code.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-phpcpd-min-tokens\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Minimum number of tokens that must be the same to declare a copy/paste snippet." \
        "Defaults to 70.\n"
    echo -e "  --job-phpcpd-min-lines\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Minimum number of lines that must be the same to declare a copy/paste snippet." \
        "Defaults to 5.\n"
}

show_help-no_functional:pdepend()
{
    echo -e "Usage: ${__file} -j|--job=no_functional:pdepend -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Run Pdepend tool on the source code.\n"
}

show_help-no_functional:qa_all()
{
    echo -e "Usage: ${__file} -j|--job=no_functional:qa_all -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Run all QA tools on the source code.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-phpcs-error\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHP_CodeSniffer errors accepted before declaring the job as status error." \
        "Defaults to 0.\n"
    echo -e "  --job-phpcs-warning\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Number of PHP_CodeSniffer warnings accepted before declaring the job as status error." \
        "Defaults to 20.\n"
    echo -e "  --job-phpcpd-min-tokens\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Minimum number of tokens that must be the same to declare a copy/paste snippet." \
        "Defaults to 70.\n"
    echo -e "  --job-phpcpd-min-lines\n\t" \
        "\033[33mOptional\033[0m\n\t" \
        "Minimum number of lines that must be the same to declare a copy/paste snippet." \
        "Defaults to 5.\n"
}

show_help-package:package_service()
{
    echo -e "Usage: ${__file} -j|--job=package:package_service -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create the package of the service for the UI.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-image-tag\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Tag of the image used as a suffix for the name of the image tag." \
        "Defaults to an empty string.\n"
    echo -e "  --job-image-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Name of the image used as a suffix for the name of the image tag." \
        "Defaults to an empty string.\n"
    echo -e "  --job-image-path\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Path of the Dockerfile used to create image." \
        "Defaults to an empty string.\n"
    echo -e "  --job-image-build-arg\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "build args used to create image." \
        "Defaults to an empty string.\n"
}

show_help-deploy:delete_service()
{
    echo -e "Usage: ${__file} -j|--job=deploy:delete_service -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Delete all containers of a service..\n"
    echo -e "Additional parameters:"
    echo -e "  --project-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The project name." \
        "Defaults to an empty string.\n"
    echo -e "  --deploy-version\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Version type to deploy (v2|v3)." \
        "Defaults to an empty string.\n"
    echo -e "  --environment-type\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Environment ttype value." \
        "Defaults to an empty string.\n"
    echo -e "  --subdomain\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Subdomain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --domain\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Domain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --registry\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Domain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network name." \
        "Defaults to an empty string.\n"
    echo -e "  --job-images-tag-group\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of the complet image tag names." \
        "Defaults to an empty string.\n"
    echo -e "  --job-images-name-group\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of the image names used to create complet list of tags." \
        "Defaults to an empty string.\n"
    echo -e "  --job-mod-dev\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Deploy with the mod dev." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix path name used to deploy container with the v2 strategy." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix-service\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix service path name used to deploy container with the v3 strategy." \
        "Defaults to an empty string.\n"
}

show_help-deploy:create_network()
{
    echo -e "Usage: ${__file} -j|--job=deploy:deploy -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create a docker network.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-network-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network name." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-driver\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network driver." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-subnet\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network subnet." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-encrypt\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network encryot." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-labels\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network label." \
        "Defaults to an empty string.\n"
    echo -e "  ---job-network-attachable\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Set the network attachable." \
        "Defaults to an empty string.\n"
    echo -e "  ---job-network-delete\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Set to 1 to delete network before create it." \
        "Defaults to not delete it before.\n"
}

show_help-deploy:create_config()
{
    echo -e "Usage: ${__file} -j|--job=deploy:deploy -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create a docker config.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-config-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The config name." \
        "Defaults to an empty string.\n"
    echo -e "  --job-config-file\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The config full path file." \
        "Defaults to an empty string.\n"
    echo -e "  ---job-config-delete\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Set to 1 to delete config before create it." \
        "Defaults to not delete it before.\n"
}

show_help-deploy:create_volume()
{
    echo -e "Usage: ${__file} -j|--job=deploy:create_volume -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create volumes with good user used in deploy container.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-volume-prefix\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix path name used to deploy container with the v2 strategy." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix-service\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix service path name used to deploy container with the v3 strategy." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-mount\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of volume paths that have to be created before mount theme" \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-uid\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "UID value to assigned to the volume prefix path" \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-gid\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "GID value to assigned to the volume prefix path" \
        "Defaults to an empty string.\n"
}

show_help-deploy:deploy()
{
    echo -e "Usage: ${__file} -j|--job=deploy:deploy -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Deploy a container of the a service.\n"
    echo -e "Additional parameters:"
    echo -e "  --project-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The project name." \
        "Defaults to an empty string.\n"
    echo -e "  --deploy-version\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Version type to deploy (v2|v3)." \
        "Defaults to an empty string.\n"
    echo -e "  --environment-type\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Environment ttype value." \
        "Defaults to an empty string.\n"
    echo -e "  --subdomain\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Subdomain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --domain\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Domain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --registry\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Domain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network name." \
        "Defaults to an empty string.\n"
    echo -e "  --job-images-tag-group\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of the complet image tag names." \
        "Defaults to an empty string.\n"
    echo -e "  --job-images-name-group\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of the image names used to create complet list of tags." \
        "Defaults to an empty string.\n"
    echo -e "  --job-mod-dev\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Deploy with the mod dev." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix path name used to deploy container with the v2 strategy." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix-service\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix service path name used to deploy container with the v3 strategy." \
        "Defaults to an empty string.\n"
}

show_help-deploy:prepare_services()
{
    echo -e "Usage: ${__file} -j|--job=deploy:prepare_services -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Execute the prepare-services target of the makefile due to execute commands from php containers of a service..\n"
    echo -e "Additional parameters:"
    echo -e "  --project-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The project name." \
        "Defaults to an empty string.\n"
    echo -e "  --deploy-version\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Version type to deploy (v2|v3)." \
        "Defaults to an empty string.\n"
    echo -e "  --environment-type\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Environment ttype value." \
        "Defaults to an empty string.\n"
    echo -e "  --subdomain\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Subdomain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --domain\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Domain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --registry\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Domain value of the host service." \
        "Defaults to an empty string.\n"
    echo -e "  --job-network-name\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The network name." \
        "Defaults to an empty string.\n"
    echo -e "  --job-images-tag-group\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of the complet image tag names." \
        "Defaults to an empty string.\n"
    echo -e "  --job-images-name-group\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "List of the image names used to create complet list of tags." \
        "Defaults to an empty string.\n"
    echo -e "  --job-mod-dev\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Deploy with the mod dev." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix path name used to deploy container with the v2 strategy." \
        "Defaults to an empty string.\n"
    echo -e "  --job-volume-prefix-service\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Volume prefix service path name used to deploy container with the v3 strategy." \
        "Defaults to an empty string.\n"
}

show_help-deploy:verify_deploy()
{
    echo -e "Usage: ${__file} -j|--job=deploy:verify_deploy -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Verify if containers of a specific service are deployed.\n"
}

show_help-after_script:clean_up()
{
    echo -e "Usage: ${__file} -j|--job=after_script:clean_up -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Clean all unused containers and images.\n"
}

show_help-after_script:make_documentation()
{
    echo -e "Usage: ${__file} -j|--job=after_script:make_documentation -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create and save the documentation of the service.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-make-doc-type-service\n\t" \
        "\033[31mRequired\033[0m\n\t" \
        "The name of the group of services the documentation must be part of.\n" \
        "Accepted values are 'Other', 'Business', 'Cms' or 'Core'.\n"
    echo -e "  --job-make-doc-platform\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "The platform used for the deployment of the documentation." \
        "Defaults to 'web'.\n"
}

show_help-after_script:prepare_esb()
{
    echo -e "Usage: ${__file} -j|--job=after_script:prepare_esb -s|--service=SERVICE [-lvV][-dehIprU12=]\n"
    echo -e "Description: Create RabbitMQ configuration.\n"
    echo -e "Additional parameters:"
    echo -e "  --job-esb-option\n\t"\
        "\033[33mOptional\033[0m\n\t" \
        "Label to add esb phing option like -Dproject.esb.port=<value>." \
        "\n"
}

show_job_list()
{
    # Find all job scripts in the pipeline by name
    jobList=$(find bin/pipeline -regextype posix-extended -regex '^.*/?[a-z]_.*/.+\.sh$' | \
        # Display them for treatment
        xargs -n1 | \
        # Remove the bootstrap.sh scripts that are not jobs but only entry points of jobs.
        grep -v 'bootstrap.sh' | \
        # Keep only the stages (with sorted prefix) and the path to the jobs in each stages.
        grep -E '[a-z]_[^/]+/.+' -o | \
        # Sort stages by business intelligence based on the stages' prefixes.
        sort | \
        # Remove the prefixes.
        sed s/^[a-z]_// | \
        # Remove specific "others" stages.
        sed s:others/:: | \
        # Remove extensions.
        sed s/.sh//)

    write_success_block "==================== List of jobs ===================="

    for job in ${jobList[@]}; do
        jobName="${job%%/*}:${job##*/}"
        write_warning "${jobName}"
    done

    write_default "" \
        "To have more information about a job, type '--help=JOB_NAME'." \
        "To display the general help, type '--help'."
}
