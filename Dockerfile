FROM alpine:latest

# Installiere git und bash
RUN apk add --no-cache git bash

# Arbeitsverzeichnis
WORKDIR /app

# Skript kopieren
COPY get.sh .

# Skript ausführbar machen
RUN chmod +x get.sh

ENTRYPOINT ["./get.sh"]

