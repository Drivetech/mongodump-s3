#!/bin/sh

OPTIONS=`python /usr/local/bin/mongouri`
BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"

# Run backup
mongodump ${OPTIONS} ${ADDITIONAL_OPTIONS} -o ${BACKUP_DIR}

# Upload backup
aws s3 cp "${BACKUP_DIR}/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"

# Delete backup files
if [ -n "${MAX_BACKUPS}" ]; then
  while [ $(ls ${BACKUP_DIR} -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
  do
    BACKUP_TO_BE_DELETED=$(ls ${BACKUP_DIR} -w 1 | sort | head -n 1)
    rm -rf ${BACKUP_DIR}/${BACKUP_TO_BE_DELETED}
  done
else
  rm -rf ${BACKUP_DIR}/*
fi
