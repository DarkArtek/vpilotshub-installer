#!/bin/bash

CDN_URL="https://cdn.ahd-creative.agency"
CDN_PURGE_LINK="https://cdn.ahd-creative.agency/purgeCache?url=https://cdn.ahd-creative.agency"
CDN_DIR=${1:-"installer/test"}
LOCAL_DIR=${2:-"./dist"}

MAX_RETRY=5

upload() {
  DEST="$CDN_URL/$CDN_DIR/$(basename -- "$1")"
  echo "Syncing file: $1"
  echo "Destination: $DEST"
  # Try to upload the file up to MAX_RETRY times before failing.
  counter=0
  until curl --fail -X PUT -H "X-AHD-Access-Key: $CLOUDFLARE_WORKER_PASSWORD" -T "$1" "$DEST"
  do
    sleep 1
    [[ counter -eq $MAX_RETRY ]] && echo "Failed to upload file '$1'" >&2 && exit 1
    echo "Trying again. Try #$counter"
    ((counter++))
  done
  echo ""; echo ""
}

# Upload all the files
for FILE in "$(LOCAL_DIR)"/*; do
  upload "$FILE"
done

# Purge after all uploads that the files are somewhat in sync.
echo "Purging Cache"
for FILE in "$(LOCAL_DIR)"/*; do
  DEST="$CDN_PURGE_LINK/$CDN_DIR/$(basename -- "$FILE")"
  echo "Purging cache for file: $FILE"
  echo "Purge URL: $DEST"
  curl -X GET -H "X-AHD-Access-Key: $CLOUDFLARE_WORKER_PASSWORD" -H "Content-Length: 0" "$DEST"
done