#!/bin/bash

#This script will check a server is available or not from a host file and stdout telegraf supported result
#1= avaialbe 0=Not Available

#Create a file hosts with all the hostnames/ip that need to be checked. 
#This script use basic ping command to check server is available or not. 
#If icmp blocked, this may return false.

#Create by Muneeb K

epoch_time=$(date +%s%N)
# Check if the hosts file exists
if [ ! -f "hosts" ]; then
  echo "Error: File 'hosts' not found."
  exit 1
fi

# Function to check if a host is reachable
is_host_reachable() {
  local host="$1"
  if ping -i 0.3 -c 1 "$host" > /dev/null 2>&1; then
    echo "server_status, hostname=$host value=1 $epoch_time"
  else
    echo "server_status, hostname=$host value=0 $epoch_time"
  fi
}

# Read each host from the file and check its status in parallel
while read -r host; do
  is_host_reachable "$host" &
done < hosts

# Wait for all backgroung jobs to finish
wait