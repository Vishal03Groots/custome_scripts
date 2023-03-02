#!/bin/bash

WEB_DIR="/var/www/html"
REPORT_FILE="report.txt"

# Create a new report file or overwrite an existing one
> "$REPORT_FILE"

# Find files with suspicious extensions
find "$WEB_DIR" -type f \( -name "*.php" -o -name "*.js" -o -name "*.sh" \) \
  -exec grep -q "eval(" {} \; -exec echo "{}: suspicious" \; \
  | tee -a "$REPORT_FILE"

# Find files with suspicious contents
find "$WEB_DIR" -type f -exec grep -l -E "base64_decode|str_rot13|gzinflate" {} + \
  | xargs echo | sed 's/ /, /g' | xargs -I{} echo '{}: suspicious' \
  | tee -a "$REPORT_FILE"

Explanation:

    The script defines the path to the WordPress directory to be checked (WEB_DIR) and the name of the report file to be generated (REPORT_FILE).
    It uses the find command to locate files with suspicious extensions
