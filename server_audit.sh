#!/bin/bash

# Get the hostname of the server
HOSTNAME=$(hostname)

# Get the current date and time
DATE=$(date)

# Create a new file to store the server audit output
OUTPUT_FILE="server.txt"
touch "$OUTPUT_FILE"

# Print the hostname and date to the output file
echo "Server Audit Report for $HOSTNAME" >> "$OUTPUT_FILE"
echo "Generated on: $DATE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the system information to the output file
echo "System Information:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
uname -a >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/os-release >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the list of installed packages to the output file
echo "Installed Packages:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
dpkg-query -l >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the list of running processes to the output file
echo "Running Processes:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
ps aux >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the network information to the output file
echo "Network Information:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
ip addr >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the disk usage information to the output file
echo "Disk Usage Information:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
df -h >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the list of users to the output file
echo "List of Users:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/passwd >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the list of groups to the output file
echo "List of Groups:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/group >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the list of open ports to the output file
echo "Open Ports:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
netstat -tuln >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the log entries to the output file
echo "Log Entries:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
tail /var/log/syslog >> "$OUTPUT_FILE"
