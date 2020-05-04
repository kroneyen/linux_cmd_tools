#!/bin/sh

source /root/DB_data/.env
Today=`date +%Y-%m-%d`
path='/root/DB_data/schema_backup'

### create back_list
/usr/bin/mysql -p${_bck_wd} -u${_bck} -e "SELECT schema_name FROM information_schema.SCHEMATA WHERE schema_name NOT IN('information_schema','performance_schema','sys','mysql','test')\G" | grep 'schema_name' | awk '{print $2}' > backup_list


_read_file='backup_list' ###backup db list

##find  $path/ -type f -atime 7 | grep "night_" | head -n 1 | awk '{print $8}' | xargs rm 

find $path/*.sql.gz -type f -mtime +7 |  xargs  --no-run-if-empty rm 

#echo $backup_list | while read line; 
 while read line; 

do 

_path=${path}/${line}

###data &&  routines && event
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R  -E --single-transaction  --quick $line | gzip > ${_path}_data_R_E_$Today.sql.gz

sleep 1


###  routines && event
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -t -d -E $line | gzip > ${_path}_R_E_$Today.sql.gz

### schema &&  routines && event

/usr/bin/mysqldump -p${_bck_wd} -u${_bck}  -R -d -E  $line | gzip > ${_path}_schema_R_E_$Today.sql.gz

sleep 1


#echo "$Today Clean Up  Over 7 Days archive log" >> $path/schema_backup.log

done  < $_read_file

###### permission & tools
/usr/bin/mysqldump -p${_bck_wd} -u${_bck}   mysql | gzip > $path/mysql_permission_$Today.sql.gz

echo "$Today Clean Up  Over 7 Days archive log" >> $path/schema_backup.log
