#!/bin/bash
# This script allows you to test and generate a sample application in new branch, with one commit per step.
#
# Usage:
#   . .sh/example-demo.sh
# or
#   source .sh/example-demo.sh

# --- new branch ---

git switch -c example-demo-"$(date +"%Y%m%d-%H%M%S")"

# --- clone_symfony_demo ---

make clone_symfony_demo
git add . && git commit -m "make clone_symfony_demo"

# --- clone_symfony_docker ---

make clone_symfony_docker
git add . && git commit -m "make clone_symfony_demo"

make git_apply f=common/compose-var-mapping.patch
git add . && git commit -m "make git_apply f=common/compose-var-mapping.patch"

make git_apply f=common/compose-DATABASE_URL.patch
git add . && git commit -m "make git_apply f=common/compose-DATABASE_URL.patch"

make build

make up_detached runtime permissions
git add . && git commit -m "make up_detached"

make git_apply f=common/docker-entrypoint-clean.patch
git add . && git commit -m "make git_apply f=common/docker-entrypoint-clean.patch"

# --- sqlite ---

make _patch_sqlite_base
git add . && git commit -m "make _patch_sqlite_base"

make build

make up_detached runtime permissions
git add . && git commit -m "make up_detached"

# --- end ---

make images
make info
