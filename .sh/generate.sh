#!/bin/bash
# Usage:
#   . .sh/generate.sh my_command
# or
#   source .sh/generate.sh my_command

command=$1

make kill_current_app &&
    git switch -c "${command}-$(date +"%Y%m%d-%H%M%S")" &&
    make "${command}"
