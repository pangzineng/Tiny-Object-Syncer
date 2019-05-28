FROM minio/mc:latest

## install inotify
RUN apk --update upgrade && \
  apk add --update inotify-tools && \
  rm -rf /var/cache/apk/*

COPY . .

## overwrite the entrypoint of minio/mc to shell
ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]