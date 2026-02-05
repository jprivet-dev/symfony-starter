#!/bin/bash
# Usage:
#   . .sh/generate.sh my_command
# or
#   source .sh/generate.sh my_command
#
# Examples:
#
#  . .sh/generate.sh minimalist
#  . .sh/generate.sh minimalist@lts
#
#  . .sh/generate.sh api
#  . .sh/generate.sh demo
#  . .sh/generate.sh api@lts
#  . .sh/generate.sh easy_admin
#  . .sh/generate.sh easy_admin@lts
#  . .sh/generate.sh webapp
#  . .sh/generate.sh webapp@lts

# (R)ED & RE(S)ET
R='\033[31m'
S='\033[0m'

COMMAND=$1

case "${COMMAND%@lts}" in # Remove '@lts' suffix for the check
    minimalist|api|demo|easy_admin|webapp)
        ;;
    *)
        echo -e "${R}Error: Unauthorized or unknown application: '${COMMAND}'${S}"
        echo "Allowed apps: minimalist, api, demo, easy_admin, webapp (with optional @lts)"
        # Use return instead of exit because this script is sourced
        return 1 2>/dev/null || exit 1
        ;;
esac

git switch next && \
    make kill_current_app && \
    git switch -C "${COMMAND}" && \
    make "${COMMAND}"
