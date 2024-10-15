# Determines the OS image to build upon
FROM alpine:3.16

# Environment variables to be imported from .env and used inside the container
# ARG is used when the variables will be used when building the image, but not after it starts
# ENV is used to pass variables that will stay in the environment of the already built image
ARG DB_NAME \
    DB_USER \
    DB_PASS

# Installs MariaDB and MariaDB-client without saving the sources in cache
# The client allows you to interact with a MariaDB database server and
# provides a CLI that can execute SQL statements
RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client

# Creates the directory "mysqld", used by  MySQSL to store PID files
# Gives all users read, write and execute permissions, needed by MySQL server
# Creates the file "docker.cnf" and write the echo statements to it
#	These configure MySQL to skip hostname and IP address caching, and to
#	listen on all interfaces (0.0.0.0) instead of just the localhost interface
# Modifies the file "mariadb-server.cnf", enabling networking for the MySQL
#	server, which is disabled by default in the MariaDB server configuration
RUN mkdir /var/run/mysqld; \
	chmod 777 /var/run/mysqld; \
	{ echo '[mysqld]'; \
	  echo 'skip-host-cache'; \
	  echo 'skip-name-resolve'; \
	  echo 'bind-address=0.0.0.0'; \
	} | tee /etc/my.cnf.d/docker.cnf; \
	sed -i "s|skip-networking|skip-networking=0|g" \
		/etc/my.cnf.d/mariadb-server.cnf

# Initializes de MySQL data directory, specifying the user and the data directory
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Exposes port 3306, the standard port for MySQL
EXPOSE 3306

# Sets the default user within the container to "mysql"
USER mysql

# Copies the file "create_db.sh" from the host to the container
COPY requirements/mariadb/conf/create_db.sh

# Defines the executable and the parameters to be run when the container starts
ENTRYPOINT ["sh", "create_db.sh"]

# Specifies the default command to be executed if no arguments are provided when
# running the container. It starts the MySQL server process and skips the log errors
CMD ["/usr/bin/mysqld", "--skip-log-error"]
