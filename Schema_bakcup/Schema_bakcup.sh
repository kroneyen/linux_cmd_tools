#!/bin/sh

source ./.env

Today=`date +%Y-%m-%d`
path='/home/schema_backup'

### create back_list
/usr/bin/mysql -p${_bck_wd} -u${_bck} -e "SELECT schema_name FROM information_schema.SCHEMATA WHERE schema_name NOT IN('information_schema','performance_schema','sys','scheduleDB','mysql','krone')\G" | grep 'schema_name' | awk '{print $2}' > backup_list

_read_file='backup_list' ###backup db list

##find  $path/ -type f -atime 7 | grep "night_" | head -n 1 | awk '{print $8}' | xargs rm 
find $path/*.sql.gz -type f -mtime +7 |  xargs  --no-run-if-empty rm 

while read line; 

do 

_path=${path}/${line}

### find out _History  table  &&  ignore backup 
_ignore_table=`/usr/bin/mysql -p${_bck_wd} -u${_bck} $line -e "SELECT GROUP_CONCAT( ' --ignore-table=',DATABASE() ,'.' , table_name  SEPARATOR '   ' ) as ss FROM information_schema.tables WHERE table_schema = DATABASE()  AND table_name LIKE '%_History'\G" | grep 'ss' | awk '{print substr($0,4)}'`


if [[ "$_ignore_table" != " NULL" ]] ;then

      line="${line}${_ignore_table}"
      #echo "${line}  ${_ignore_table}"

fi


###data &&  routines && event
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -E $line | gzip > ${_path}_data_R_E_$Today.sql.gz
#/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -E -S/var/lib/mysql-3307/mysql-3307.sock  $line  | gzip > ${_path}_3307_data_R_E_$Today.sql.gz

sleep 1


###  routines && event
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -t -d -E $line | gzip > ${_path}_R_E_$Today.sql.gz
#/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -t -d -E -S/var/lib/mysql-3307/mysql-3307.sock  $line | gzip > ${_path}_3307_R_E_$Today.sql.gz

### schema &&  routines && event

/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -d  -E $line | gzip > ${_path}_schema_R_E_$Today.sql.gz
#/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -d  -E -S/var/lib/mysql-3307/mysql-3307.sock $line | gzip > ${_path}_3307_schema_R_E_$Today.sql.gz

sleep 1


#echo "$Today Clean Up  Over 7 Days archive log" >> $path/schema_backup.log

done < $_read_file


###### permission & tools
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}   mysql | gzip > /home/schema_backup/mysql_permission_$Today.sql.gz
#/usr/bin/mysqldump -p${_bck_wd} -u${_bck}   -S/var/lib/mysql-3307/mysql-3307.sock  mysql | gzip > /home/schema_backup/mysql_3307_permission_$Today.sql.gz
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}   krone | gzip > /home/schema_backup/krone_$Today.sql.gz

echo "$Today Clean Up  Over 7 Days archive log" >> $path/schema_backup.log
