#!/bin/bash
# This script allows you to test and generate a sample application, with one commit per step.
#
# Usage:
#   . .sh/example-api.sh
# or
#   source .sh/example-api.sh

make clone_symfony_docker
git add . && git commit -m "make clone_symfony_demo"

make _patch_var_log_mapping
git add . && git commit -m "make _patch_var_log_mapping"

make build

make up_detached
make runtime permissions
git add . && git commit -m "make up_detached"

make require_api
make runtime permissions
git add . && git commit -m "make require_api"

make images
make info
