FROM alpine:edge

MAINTAINER Leonardo Gatica <lgatica@protonmail.com>

ENV S3_PATH=mongodb
ENV AWS_DEFAULT_REGION=us-east-1
ENV BACKUP_DIR=/backup

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY backup.sh /usr/local/bin/backup
COPY mongouri.py /usr/local/bin/mongouri

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --quiet --no-cache mongodb-tools py2-pip && \
  pip install pymongo awscli && \
  mkdir -p ${BACKUP_DIR}

CMD /usr/local/bin/entrypoint