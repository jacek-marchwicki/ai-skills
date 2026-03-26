#!/bin/bash

# Usage: ./download_screenshot.sh <ClassName> <TestMethodName> [output_file]

CLASS_NAME=$1
TEST_NAME=$2
OUTPUT_FILE=${3:-.output.png}

if [ -z "$CLASS_NAME" ] || [ -z "$TEST_NAME" ]; then
    echo "Usage: $0 <ClassName> <TestMethodName> [output_file]"
    exit 1
fi

# Find the latest screenshot file matching the pattern on the device
PATTERN="/sdcard/Pictures/screenshots/${CLASS_NAME}_${TEST_NAME}-failure-*"
FILE_PATH=$(adb shell ls -t "$PATTERN" 2>/dev/null | head -n 1 | tr -d '\r')

if [ -z "$FILE_PATH" ]; then
    echo "No screenshot found for ${CLASS_NAME}_${TEST_NAME}"
    exit 1
fi

echo "Found screenshot: $FILE_PATH"

# Pull the file to the local directory
adb pull "$FILE_PATH" "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Screenshot successfully downloaded to $OUTPUT_FILE"
else
    echo "Failed to download screenshot"
    exit 1
fi
