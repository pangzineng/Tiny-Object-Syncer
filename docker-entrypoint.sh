#!/bin/bash

## configure minio/mc
tos_name="tos"
mc config host add ${tos_name} "${COS_ENDPOINT}" "${COS_ACCESS_KEY}" "${COS_SECRET_KEY}"
echo "configuration setup ready"

moni_dir=${MONITOR_DIR:-/home}
## monitor, recursive, quiet
inotifywait -m -r -q \
  --exclude "${MONITOR_EXCLUDE_REGEX:-$^}" \
  -e close_write -e moved_to \
  --format '%w%f' \
  "${moni_dir}" | while read file; do
    if [ -n "$USE_ROOT_AS_BUCKET" ]
    then
      tos_target="${tos_name}${file/$moni_dir/}"
    else
      tos_target="${tos_name}/${COS_DEFAULT_BUCKET}${file/$moni_dir/}"
    fi
    if [ -n "$ENABLE_DEBUG_LOG" ]
    then
        echo "File: '${file}' to be synced to: '${tos_target}'"
    fi
    mc cp "${file}" "${tos_target}"
    if [ -n "$ENABLE_DEBUG_LOG" ]
    then
        echo "File: '${file}' synced to: '${tos_target}'"
    fi
  done