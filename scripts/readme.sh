#!/bin/bash
# This script updates the Makefile commands in the README.md file.
# We use a `while` loop to process the file line by line, which is a more robust approach than `sed`.
# `sed` can cause issues with special characters and line endings,
# making this method more reliable and portable across different systems.
#
# Usage:
#   . readme.sh
# or
#   source readme.sh

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G='\033[32m'
R='\033[31m'
Y='\033[33m'
S='\033[0m'

# Define markers and files
START_MARKER="<!-- MAKEFILE_COMMANDS_START -->"
END_MARKER="<!-- MAKEFILE_COMMANDS_END -->"
README_FILE="README.md"
TEMP_FILE="temp_readme.md"

# Check if markers are present
if ! grep -q "${START_MARKER}" "${README_FILE}"; then
    printf " ${R}⨯${S} Error: The start marker '${START_MARKER}' was not found in '${README_FILE}'.\n"
    exit 1
fi

if ! grep -q "${END_MARKER}" "${README_FILE}"; then
    printf " ${R}⨯${S} Error: The end marker '${END_MARKER}' was not found in '${README_FILE}'.\n"
    exit 1
fi

# Get Makefile help and clean it
MAKEFILE_HELP=$(make 2>/dev/null | tr -d '\r' | sed 's/\x1b\[[0-9;]*m//g')

if [ -z "$MAKEFILE_HELP" ]; then
    printf " ${R}⨯${S} Error: Unable to run 'make'. Ensure the Makefile is valid.\n"
    exit 1
fi

# Use a temporary file for the new README content
touch "${TEMP_FILE}"

# Process the README line by line
BLOCK_FOUND=0
while IFS= read -r line; do
    if [[ "${line}" == "${START_MARKER}" ]]; then
        BLOCK_FOUND=1
        echo "${line}" >> "${TEMP_FILE}"
        echo "" >> "${TEMP_FILE}"
        echo '```' >> "${TEMP_FILE}"
        echo "$MAKEFILE_HELP" >> "${TEMP_FILE}"
        echo '```' >> "${TEMP_FILE}"
        echo "" >> "${TEMP_FILE}"
        continue
    fi

    if [[ "${line}" == "${END_MARKER}" ]]; then
        BLOCK_FOUND=0
        echo "${line}" >> "${TEMP_FILE}"
        continue
    fi

    if [[ "$BLOCK_FOUND" -eq 0 ]]; then
        echo "${line}" >> "${TEMP_FILE}"
    fi
done < "${README_FILE}"

# Replace the original file with the new one
mv "${TEMP_FILE}" "${README_FILE}"

printf " ${G}✔${S} README.md has been updated successfully with Makefile commands.\n"
