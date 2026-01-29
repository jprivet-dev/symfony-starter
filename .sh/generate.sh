#!/bin/bash
# Usage:
#   . .sh/generate.sh my_command
# or
#   source .sh/generate.sh my_command
#
# Examples:
#
#  . .sh/generate.sh api@lts
#  . .sh/generate.sh demo
#  . .sh/generate.sh easy_admin
#  . .sh/generate.sh easy_admin@lts
#  . .sh/generate.sh minimalist
#  . .sh/generate.sh minimalist@lts
#  . .sh/generate.sh webapp
#  . .sh/generate.sh webapp@lts

command=$1

make kill_current_app &&
    git switch -c "${command}-$(date +"%Y%m%d-%H%M%S")" &&
    make "${command}"
