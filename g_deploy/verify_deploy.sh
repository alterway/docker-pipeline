#!/usr/bin/env bash
#
# Job "Verify deploy".
# Verify if containers of a specific service are deployed.
#
write_info "# JOB: Vérify deploy"
show_help-deploy:verify_deploy

finalOutputInfo+=("Stage: deploy / Job: Verify")
finalOutputInfo+=("Verify if containers of the service ${SERVICE} are deployed...")
finalOutputInfo+=("")

docker ps -a |grep ${SERVICE}
docker network ls
docker volume ls
