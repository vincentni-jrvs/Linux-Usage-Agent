
## Introduction
Linux Usage Agent monitors the cluster resources by recording the resource data into a database. It helps the user to analysis and optimize the resource usage when developing. 

## Architecture and Design

Table Structure of Host_info 
|ID|HOSTNAME|CPU_NUMBER|CPU_ARCHITECTURE|CPU_MODEL|CPU_MHZ|L2_CACHE|TIMESTAMP|TOTAL_MEMORY|

Table Structure of Host_usage
|TIMESTAMP|HOST_ID|MEMORY_FREE|CPU_IDLE|CPU_KERNEL|DISK_IO|DISK_AVAILABLE|

int.sql
1) Check and drop database and its table
2) Create a new database <host_agent>
3) Create a new table <host_info>
4) Create a new table <host_usage>

host_info.sh
1) bind input connection information to some variable for later usage
2) gather system information, cpu information and total memory. Store gathered information as local variable.
3) prepared insert statement by placing each local variable in proper place of the insert statement.
4) Connect to PostgreSQL and send the prepared insert statement.

host_usage.sh
1) bind input connection information to some variable for later usage
2) gather cpu usage and memory usage and store as local variable.
3) prepared insert statement by placing each local variable in proper place of the insert statement.
4) Connect to PostgreSQL and send the prepared insert statement.

## Usage
1) Run init.sql to create database <host_agent> and two new table <host_info> and <host_usage>
	Example command: PGPASSWORD=password psql -U postgres -h localhost -f init.sql
2) Run host_info.sh bas
h script to gather information about the host. Then the data will be send to proper PostgreSQL database base on input command.
	Command: bash <script_path>/host_info.sh <hostname> <port> <database name> <username> <password>
	Example Command: bash ./host_info.sh localhost 5432 host_agent postgres password
3) OPTION 1: Manually run host_usage.sh to gather information about CPU usage and memory of the host.
	Command: bash <script_path>/host_usage.sh <hostname> <port> <database name> <username> <password>
	Example Command: bash ./host_usage.sh localhost 5432 host_agent postgres password
4) OPTION 2: Setup crontab to trigger host_usage every minute.
	Command: 	crontab -e
			Insert following text
			* * * * * bash <script_path>/host_usage.sh <hostname> <port> <database name> <username> <password>
	Example crontab line: * * * * * bash ./host_usage.sh localhost 5432 host_agent postgres password

## Improvment
1) Run lscpu once only to record all required information.
2) Set host id as enviroment variable instead of local text file.
3) host_usage should only run vmstat at most twice.
