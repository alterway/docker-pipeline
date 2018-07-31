#!/usr/bin/env bash
#
# Job "build_documentation".
# Build the documentation of the given service.
#
# Parameters:
#   --job-doc-group-guide: Define the groups of documentation for the guide.
#   --job-doc-group-ref: Define the groups of documentation for the references.
#
write_info "# JOB: build_documentation"
show_help-build:build_documentation

for option in "$@"; do
    case ${option} in
        --job-doc-group-guide=*)
            GROUP_DOC_FOR_GUIDE="${option#*=}"
            shift
        ;;
        --job-doc-group-ref=*)
            GROUP_DOC_FOR_REF="${option#*=}"
            shift
        ;;
        *) shift ;;
    esac
done

if [ -z "${GROUP_DOC_FOR_GUIDE:-}" ] && [ -z "${GROUP_DOC_FOR_REF:-}" ]; then
    write_error "Missing mandatory parameters."
    exit 1
fi
GROUP_DOC_FOR_GUIDE=${GROUP_DOC_FOR_GUIDE:-}
GROUP_DOC_FOR_REF=${GROUP_DOC_FOR_REF:-}

run_cmd "make job-documentation tools='sphinx-generator' groups='${GROUP_DOC_FOR_GUIDE}' groupsref='${GROUP_DOC_FOR_REF}'"
