-- PGPASSWORD=password psql -U postgres -h localhost -f init.sql
--DROP OUT THE TABLE AND DB FOR DEBUG PURPOSE
DROP DATABASE IF EXISTS host_agent;
DROP TABLE IF EXISTS host_usage;
DROP TABLE IF EXISTS host_info;

--Create host_agent database
CREATE DATABASE host_agent;

--Connect to the database just created.
\connect host_agent;

--Create the first table host_info
CREATE TABLE host_info
(
	id		SERIAL NOT NULL,
	hostname 	VARCHAR NOT NULL,
	cpu_number	INT2 NOT NULL,
	cpu_architecture VARCHAR NOT NULL,
	cpu_model	VARCHAR NOT NULL,
	cpu_mhz		FLOAT8 NOT NULL,
	l2_cache	INT4 NOT NULL,
	"timestamp"	TIMESTAMP NULL,
	total_mem	INT4 NULL,
	CONSTRAINT host_info_pk PRIMARY KEY (id),
	CONSTRAINT host_info_un UNIQUE (hostname)
);

--Create the second table host_usage
CREATE TABLE host_usage
(
	"timestamp"	TIMESTAMP NOT NULL,
	host_id		SERIAL NOT NULL,
	memory_free 	INT4 NOT NULL,
	cpu_idel	INT2 NOT NULL,
	cpu_kernel	INT2 NOT NULL,
	disk_io		INT4 NOT NULL,
	disk_available	INT4 NOT NULL,
	CONSTRAINT host_usage_host_info_fk  FOREIGN KEY (host_id) REFERENCES host_info (id)
);
