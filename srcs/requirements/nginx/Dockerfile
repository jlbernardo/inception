# Determines the OS image to build upon
FROM alpine:3.20.6

# Installs Nginx, OpenSSL and OpenRC without saving the sources in cache
# Generates a self-signed SSL certificate for HTTPS
RUN	apk update && apk upgrade && apk add --no-cache nginx openssl openrc; \
    openssl req -newkey rsa:2048 -nodes -keyout /etc/nginx/julberna.42.fr.key -x509 -days 365 \
    -out /etc/nginx/julberna.42.fr.crt -subj "/C=BR/ST=SP/L=SãoPaulo/O=42sp/CN=julberna.42.fr"

# Exposes port 443, the standard port for https
EXPOSE 443

# Starts the container and runs nginx in foreground as global config
CMD	["nginx", "-g", "daemon off;"]
