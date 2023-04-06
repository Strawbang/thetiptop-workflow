#!/bin/sh

n_date=$(date +%Y-%m-%d)
nFiles=`sudo ls /var/d-backup | wc -l`
limit=10

if [ $nFiles -ge $limit ]; then
        nFiles=$(($nFiles - ($limit - 1)))
        find /var/d-backup -type f -printf '%T+ %p\n' | sort | head -n ${nFiles} | awk '{print $2}' | xargs rm -f
fi

backup_file=/var/d-backup/docker_bckp_${n_date}.zip
log_file=/var/sync-logs/sync-${n_date}.log
touch $log_file

zip -r $backup_file /var/docker -x /var/docker/data/nexus/**\* /var/docker/data/elasticsearch/**\* &&
docker run --rm \
--volume /config/rclone/:/config/rclone \
--volume /data:/data:shared \
--volume /var/d-backup:/var/d-backup:shared  \
--volume /var/sync-logs:/var/sync-logs:shared  \
--cap-add SYS_ADMIN \
--device /dev/fuse \
--security-opt apparmor:unconfined \
rclone/rclone:latest sync \
--log-file $log_file \
--log-level INFO \
/var/d-backup  backup-drive:Backup &&
docker run --rm \
--volume /config/rclone/:/config/rclone \
--volume /data:/data:shared \
--volume /var/sync-logs:/var/sync-logs:shared  \
--cap-add SYS_ADMIN \
--device /dev/fuse \
--security-opt apparmor:unconfined \
rclone/rclone:latest sync  \
"/var/sync-logs"  "backup-drive:Sync Logs"
