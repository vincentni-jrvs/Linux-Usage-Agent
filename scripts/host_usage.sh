#! /bin/bash

#Setup arguments
psql_host=$1
port=$2
db_name=$3
user_name=$4
password=$5


get_host_id() {
	hostid=$(cat ~/host_id)
}

#Helper function
get_vmstat_value() {
	value=$(vmstat $1 --unit m| tail -n1 | awk -v temp=$2 '{print $temp}' | xargs)
	#echo "value=$value"
}

get_memory_free() {
	get_vmstat_value "" "4"
	memory_free=$value
}

get_cpu_idle() {
	get_vmstat_value "" "15"
	cpu_idle=$value
}

get_cpu_kernel() {
	get_vmstat_value "" "14"
	cpu_kernel=$value
}

get_disk_io() {
	get_vmstat_value "-d" "10"
	disk_io=$value
}


#Step 1: parse data and setup variables
get_host_id
get_memory_free
get_cpu_idle
get_cpu_kernel
get_disk_io
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
disk_available=$(df -BM --output=avail "$PWD" | tail -n1 | sed 's/[^0-9]*//g')

#Step 2: construct INSERT statement
insert_stmt=$(cat <<-END
INSERT INTO host_usage VALUES('${timestamp}','${hostid}',${memory_free},${cpu_idle},${cpu_kernel},${disk_io},${disk_available});
END
)
#echo $insert_stmt

#Step 3: Execute INSERT statement
export PGPASSWORD=$password
psql -h $psql_host -p $port -U $user_name -d $db_name -c "$insert_stmt"
sleep 1
