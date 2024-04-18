#!/bin/bash
#

DATE=$(date -I)
TARGET=wekan_database_backup_"$DATE"

docker stop wekan-app
docker exec wekan-db rm -rf /data/dump
docker exec wekan-db mongodump -o /data/dump
docker cp wekan-db:/data/dump "/tmp/$TARGET"
docker start wekan-app

tar -czf /mnt/matt/wekan_backups/wekan_backup_$DATE.tgz -C /tmp "$TARGET"
rm -r "/tmp/$TARGET"

# To restore:
# docker stop wekan-app
# docker exec wekan-db rm -rf /data/dump
# docker cp dump wekan-db:/data/
# docker exec wekan-db mongorestore --drop --dir=/data/dump
# docker start wekan-app
