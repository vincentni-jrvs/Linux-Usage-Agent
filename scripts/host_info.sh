#!/bin/bash
hostName=$1
port=$2
dbname=$3
user=$4
pw=$5

myid=$(PGPASSWORD=$pw psql -U $user -h $hostName -d $dbname -c "select count(*) from host_info" |  tail -n3 | head -1 )
echo $myid > id.txt
hostname=$(hostname -f)
cpu_model=$(lscpu | grep 'Model name' | awk -F': *' '{print $2}')
cpu_number=$(lscpu | grep -m 1 'CPU(s)' | awk -F': *' '{print $2}')
cpu_architecture=$(lscpu | grep -m 1 'Architecture' | awk -F': *' '{print $2}')
cpu_mhz=$(lscpu | grep -m 1 'CPU MHz' | awk -F': *' '{print $2}')
l2_cache=$(lscpu | grep -m 1 'L2 cache' | awk -F': *' '{print $2}'| sed 's/[^0-9]*//g')
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
total_mem=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)


PGPASSWORD=$pw psql -U $user -h $hostName -d $dbname -c "insert into host_info
values('$myid','$hostname','$cpu_number','$cpu_architecture','$cpu_model','$cpu_mhz','$l2_cache','$timestamp','$total_mem')"
