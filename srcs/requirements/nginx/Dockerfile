# Determines the OS image to build upon
FROM	alpine:3.20

# Installs Nginx without saving the sources in cache
RUN	apk update && apk upgrade && apk add --no-cache nginx

# Exposes port 443, the standard port for https
EXPOSE	443

# Starts the container and runs nginx in foreground as global config
CMD	["nginx", "-g", "daemon off;"]
