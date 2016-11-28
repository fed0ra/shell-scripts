#!/bin/sh
bakpath=/data/backup/mysql
[  ! -d $bakpath ] && mkdir -p $bakpath
#mysqldump -uroot -pPassword -B xxx |gzip>$bakpath/xxx_$(date +%F).sql.gz

#--single-transaction只适用于事务表
mysqldump -uroot -pPassword -B -F --single-transaction  xxx | gzip>$bakpath/xxx_$(date +%F).sql.gz

#mysqldump -uroot -pPassword -B -F -S /data/mysql/3306/mysql.sock --single-transaction  xxx | gzip>$bakpath/xxx_$(date +%F).sql.gz

find $backup_dir -name "*.sql.gz" -mtime +45 |xargs rm -rf
