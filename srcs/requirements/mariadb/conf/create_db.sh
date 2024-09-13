#!bin/sh

# Checks if the directory doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
	
	# Recursively changes the ownership of the directory and its contents
	# to the mysql user and group, ensuring MySQL service can access and
	# modify the database files
	chown -R mysql:mysql /var/lib/mysql

	# Initializes the database, specifying the base directory, the data directory,
	# the user, and the RPM package information, creating the necessary database
	# structures and configuration files
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

	# Creates a temp file and, if it fails, returns with a failure status
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi
fi

# Checks if the directory doesn't exists
if [ ! -d "/var/lib/mysql/wordpress"]; then
	
	# Creates a temporary SQL script
	cat << EOF > /tmp/create_db.sql
# Uses "mysql" database
USE mysql;

# Flushes privileges to ensure changes take effect
FLUSH PRIVILEGES;

# Deletes users with empty usernames
DELETE FROM mysql.user WHERE User='';

# Drops the test database, if it exists
DROP DATABASE test;

# Deletes entries related to the test database from "mysql.db" table
DELETE FROM mysql.db WHERE Db='test';

# Deletes root users with hosts other than the specified ones
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# Sets the password for the root user on localhost
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';

# Creates a database with UTF-8 character set and collation
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;

# Creates a user with specified password
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';

# Grants all privileges on the wordpress database to the created user
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';

# Flushes privileges again
FLUSH PRIVILEGES;
EOF
	# Runs the created SQL script using the mysqld command and deletes it afterwards
	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
	rm -f /tmp/create_db.sql
fi
