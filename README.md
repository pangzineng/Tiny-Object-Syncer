# Tiny-Object-Syncer

## Description

Run this docker image and mount to a local directory to sync any new files stored in that directory to specified (S3-compatible) cloud object storage.

This image is based on `https://github.com/minio/mc` and `https://linux.die.net/man/1/inotifywait` 

## Usage

### Environment Variables

#### Mandatory

- `COS_ENDPOINT`: the full url/endpoint (including http or https) of the cloud object storage
- `COS_ACCESS_KEY`: the access key of the cloud object storage
- `COS_SECRET_KEY`: the secret key of the cloud object storage, this key pair must have access to the specified bucket(s)
- `COS_DEFAULT_BUCKET`: the default bucket to sync the local files to
- `MONITOR_DIR`: the directory to monitor for new files (**default to be /home**), you should mount local storage to the dir you specified here

#### Optional

- `MONITOR_EXCLUDE_REGEX`: the optional regular expression to exclude some of the files in the minitored directory from being synced
- `USE_ROOT_AS_BUCKET`: if set (regardless of value), it will takes the root directory **under** `MONITOR_DIR` as the name of the bucket (e.g. `/home/dir1/dir2/file.txt` will be synced to bucket `dir1` with path `dir2/file.txt`)
- `ENABLE_DEBUG_LOG`: if set (regardless of value), it will print log message to stdout/console when a file was synced to cloud

### Example

1. start the syncer
```
docker run                              \
  -e COS_ENDPOINT=http://localhost:9000 \
  -e COS_ACCESS_KEY=minio               \
  -e COS_SECRET_KEY=miniosecret         \
  -e COS_DEFAULT_BUCKET=demo            \
  -e ENABLE_DEBUG_LOG=true              \
  -v /tmp/tos:/home                     \
  pangzineng/tiny-object-syncer:master
```

2. write file to the mounted directory
```
cp model.zip /tmp/tos/dir2/dir3/
```

3. see the debug log, sync success
```
File: '/home/dir2/dir3/model.zip' to be synced to: 'tos/demo/dir2/dir3/model.zip'
`/home/dir2/dir3/model.zip` -> `tos/demo/dir2/dir3/model.zip`
Total: 85.01 KiB, Transferred: 85.01 KiB, Speed: 135.77 KiB/s
File: '/home/dir2/dir3/model.zip' synced to: 'tos/demo/dir2/dir3/model.zip'
```