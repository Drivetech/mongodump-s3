#!/bin/sh

OPTIONS=`python /usr/local/bin/mongouri`
BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"

# Run backup
mongodump ${OPTIONS} -o /tmp/dump
# Compress backup
cd /tmp/ && tar -cvzf "/tmp/${BACKUP_NAME}" dump
# Upload backup
aws s3 cp "/tmp/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
# Delete backup
rm -rf /tmp/dump "/tmp/${BACKUP_NAME}"
