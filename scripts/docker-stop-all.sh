#!/bin/bash
# Stop all running Docker containers at once (use with caution!).
#
# Usage:
#   . script/docker-stop-all.sh
# or
#   source script/docker-stop-all.sh

docker stop $(docker ps -a -q)
