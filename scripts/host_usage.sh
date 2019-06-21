#!/bin/bash
##Local variable
hostName=$1
port=$2
dbname=$3
user=$4
pw=$5

#Gather information about memory usage and cpu usage
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
hostid=$(cat /home/centos/dev/jrvs/bootcamp/host_agent/scripts/id.txt)
memory_free=$(vmstat | tail -n1 | awk '{print $4}')
cpu_idle=$(vmstat | tail -n1 | awk '{print $15}')
cpu_kernel=$(vmstat | tail -n1 | awk '{print $14}')
disk_io=$(vmstat -d | tail -n1 | awk '{print $10}')
disk_available=$(df -BM --output=avail "$PWD" | tail -n1 | sed 's/[^0-9]*//g')
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

##Push insert statement to psql
PGPASSWORD=$pw psql -U $user -h $hostName -d $dbname -c "insert into host_usage values ('$timestamp','$hostid','$memory_free',$cpu_idle,'$cpu_kernel','$disk_io','$disk_available');"
