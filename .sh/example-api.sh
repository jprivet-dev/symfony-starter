#!/bin/bash
# This script allows you to test and generate a sample application in new branch, with one commit per step.
#
# Usage:
#   . .sh/example-api.sh
# or
#   source .sh/example-api.sh

# --- new branch ---

git switch -c example-api-"$(date +"%Y%m%d-%H%M%S")"

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

# --- postgresql ---

make require a=symfony/orm-pack
git add . && git commit -m "make require a=symfony/orm-pack"

make git_apply f=postgresql/compose-ports-5432.patch
git add . && git commit -m "make git_apply f=postgresql/compose-ports-5432.patch"

make git_apply f=postgresql/env-DATABASE_URL.patch
git add . && git commit -m "make git_apply f=postgresql/env-DATABASE_URL.patch"

make restart

# --- api ---

make require_api runtime permissions
git add . && git commit -m "make require_api"

make restart
