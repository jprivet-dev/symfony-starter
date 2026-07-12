#!/bin/bash
# ------------------------------------------------------------------
# Script: replace_block.sh
# Description: Replaces a text block delimited by markers in a file
#              with the content of another file, preserving position.
#              If no source file is provided, the block is cleared.
# Usage: ./replace_block.sh -m "marker" -t "target_file" [-s "source_file"] [-i index]
# ------------------------------------------------------------------

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
INDEX=1
SOURCE=""

# 1. Parse Arguments
while getopts "m:t:s:i:" opt; do
  case $opt in
    m) MARKER="$OPTARG" ;;
    t) TARGET="$OPTARG" ;;
    s) SOURCE="$OPTARG" ;;
    i) INDEX="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

if [ -z "$INDEX" ]; then
    INDEX=1
fi

# 2. Validation
if [ -z "$MARKER" ] || [ -z "$TARGET" ]; then
    echo -e "${RED}Error: Missing arguments.${NC}"
    echo "Usage: $0 -m <marker> -t <target> [-s <source>] [-i <index>]"
    exit 1
fi

if [ ! -f "$TARGET" ]; then
    echo -e "${RED}Error: Target file '$TARGET' not found.${NC}"; exit 1;
fi

if [ -n "$SOURCE" ] && [ ! -f "$SOURCE" ]; then
    echo -e "${RED}Error: Source file '$SOURCE' not found.${NC}"; exit 1;
fi

START_MARKER="###> $MARKER ###"
END_MARKER="###< $MARKER ###"

if [ -n "$SOURCE" ]; then
    echo -e " ${GREEN}📝 Updating block '$MARKER' (Index: $INDEX) in $TARGET...${NC}"
else
    echo -e " ${GREEN}🧹 Clearing block '$MARKER' (Index: $INDEX) in $TARGET...${NC}"
fi

# 3. Find Line Numbers
# Find Nth occurrence of the start marker
START_LINE=$(grep -nF "$START_MARKER" "$TARGET" | sed -n "${INDEX}p" | cut -d: -f1)

if [ -z "$START_LINE" ]; then
    echo -e "${RED}Error: Start marker '$START_MARKER' not found at index $INDEX in $TARGET${NC}"
    exit 1
fi

# Find the first end marker AFTER the start line
END_LINE=$(grep -nF "$END_MARKER" "$TARGET" | awk -F: -v start="$START_LINE" '$1 > start {print $1; exit}')

if [ -z "$END_LINE" ]; then
    echo -e "${RED}Error: End marker '$END_MARKER' missing or misplaced in $TARGET${NC}"
    exit 1
fi

# 4. Capture Indentation (from the line of the start marker)
INDENT=$(sed -n "${START_LINE}s/^\([[:space:]]*\).*/\1/p" "$TARGET")

# 5. Process Replacement
TMP_FILE=$(mktemp)

# A. Content BEFORE the block
head -n $((START_LINE - 1)) "$TARGET" > "$TMP_FILE"

# B. The New Block (Wrapped with markers and indentation)
echo "${INDENT}${START_MARKER}" >> "$TMP_FILE"
if [ -n "$SOURCE" ]; then
    cat "$SOURCE" >> "$TMP_FILE"
fi
echo "${INDENT}${END_MARKER}" >> "$TMP_FILE"

# C. Content AFTER the block
tail -n +$((END_LINE + 1)) "$TARGET" >> "$TMP_FILE"

# 6. Overwrite Target
mv "$TMP_FILE" "$TARGET"
