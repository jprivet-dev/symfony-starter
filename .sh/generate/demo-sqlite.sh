#!/bin/bash
# This script allows you to test and generate a sample application in new branch, with one commit per step.
#
# Usage:
#   . .sh/demo-sqlite.sh
# or
#   source .sh/demo-sqlite.sh

# --- new branch ---

git switch -c demo-sqlite-"$(date +"%Y%m%d-%H%M%S")"

# --- clone_symfony_demo ---

make clone_symfony_demo
git add . && git commit -m "make clone_symfony_demo"

# --- clone_symfony_docker ---

make clone_symfony_docker
git add . && git commit -m "make clone_symfony_docker"

make git_apply f=common/compose-var-mapping.patch
git add . && git commit -m "make git_apply f=common/compose-var-mapping.patch"

make git_apply f=common/compose-DATABASE_URL.patch
git add . && git commit -m "make git_apply f=common/compose-DATABASE_URL.patch"

make build

make up_detached runtime permissions
git checkout .env.local.demo

make git_apply f=common/docker-entrypoint-clean-composer.patch
git add . && git commit -m "make git_apply f=common/docker-entrypoint-clean.patch"

# --- sqlite ---

make git_apply f=sqlite/compose-doctrine-bundle.patch
git add . && git commit -m "make git_apply f=sqlite/compose-doctrine-bundle.patch"

make git_apply f=sqlite/dockerfile-sqlite.patch
git add . && git commit -m "make git_apply f=sqlite/dockerfile-sqlite.patch"

make restart

# --- end ---

make permissions
