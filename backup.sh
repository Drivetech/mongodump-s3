#!/usr/bin/env sh

OPTIONS=`python /usr/local/bin/mongouri`
OPTIONS="$OPTIONS $EXTRA_OPTIONS"
DEFAULT_BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"
BACKUP_NAME=${BACKUP_NAME:-$DEFAULT_BACKUP_NAME}
LOCAL_BACKUP_ROOT_FOLDER="backup"
LOCAL_DUMP_LOCATION="$LOCAL_BACKUP_ROOT_FOLDER/dump"

notify() {
  if [ "${SLACK_URI}" ]; then
    message="$BACKUP_NAME has been backed up  at s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
    if [ "${1}" != "0" ]; then
      message="Unable to backup $BACKUP_NAME at s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}. See Logs."
    fi
    curl -X POST --data-urlencode "payload={\"text\": \"$message\"}" $SLACK_URI
  fi
}

# Run backup
mongodump ${OPTIONS} -o "${LOCAL_DUMP_LOCATION}"
status=$?
if [ "${status}" -eq "1" ]; then
  echo "ERROR: Mongodump failed."
  notify 1
  exit 1
fi

# Compress backup
tar -cvzf "${LOCAL_BACKUP_ROOT_FOLDER}/${BACKUP_NAME}" "${LOCAL_DUMP_LOCATION}"

# Upload backup
aws s3 cp "${LOCAL_BACKUP_ROOT_FOLDER}/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
status=$?
echo $status
if [ "${status}" != "0" ]; then
  echo "ERROR: AWS Upload failed."
  notify 1
  exit 1
fi

notify 0

# Delete temp files
rm -rf "${LOCAL_DUMP_LOCATION}"

# Delete backup files
if [ -n "${MAX_BACKUPS}" ]; then
  while [ $(ls ${LOCAL_BACKUP_ROOT_FOLDER} -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
  do
    BACKUP_TO_BE_DELETED=$(ls /backup -w 1 | sort | head -n 1)
    rm -rf ${LOCAL_BACKUP_ROOT_FOLDER}/${BACKUP_TO_BE_DELETED}
  done
else
  rm -rf ${LOCAL_BACKUP_ROOT_FOLDER}/*
fi