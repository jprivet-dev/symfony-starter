#!/bin/bash
# This script allows you to test and generate a sample application, with one commit per step.
#
# Usage:
#   . .sh/example-minimalist.sh
# or
#   source .sh/example-minimalist.sh

make clone_symfony_docker
git add . && git commit -m "make clone_symfony_demo"

make _patch_var_log_mapping
git add . && git commit -m "make _patch_var_log_mapping"

make build up_detached
git add . && git commit -m "make up_detached"

make runtime
make permissions
make images
make info
