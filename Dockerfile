FROM alpine:3.22

MAINTAINER Leonardo Gatica <lgatica@protonmail.com>

RUN apk add --update --no-cache mongodb-tools py-pip && \
  pip install --break-system-packages pymongo awscli && \
  mkdir /backup

ENV S3_PATH=mongodb AWS_DEFAULT_REGION=us-east-1

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY backup.sh /usr/local/bin/backup
COPY mongouri.py /usr/local/bin/mongouri

VOLUME /backup

CMD [ "/usr/local/bin/entrypoint" ]
