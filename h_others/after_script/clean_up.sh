#!/usr/bin/env bash
#
# Job "clean_up".
# Clean all unused containers and images.
#
write_info "# JOB: clean_up"
show_help-after_script:clean_up

#  List all docker containers and images information.
run_cmd 'docker images'
run_cmd 'docker ps -a'
run_cmd 'docker network ls'
run_cmd 'env | grep DOCKER'

# Remove intermediate containers.
write_info "Remove intermediate containers."
for container in $(docker ps -a | grep _dilpreprod_ | awk '{ print $1 }'); do
    docker stop ${container}
    docker rm -f ${container}
done 2>/dev/null 1>/dev/null

# Remove exited containers.
write_info "Remove exited containers."
for container in $(docker ps -a --filter status=exited --filter status=dead | grep ${SERVICE}); do
    docker rm -f ${container}
done 2>/dev/null 1>/dev/null

# Remove unused images.
write_info "Remove unused images."
for container in $(docker images --no-trunc | grep '<none>' | awk '{ print $3 }'); do
    docker rmi -f ${container}
done 2>/dev/null 1>/dev/null
