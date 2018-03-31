#!/bin/sh

Today=`date +%Y-%m-%d`
path='/home/schema_backup'

### create back_list
/usr/bin/mysql -pXXXXXXXXX -uroot -e "SELECT schema_name FROM information_schema.SCHEMATA WHERE schema_name NOT IN('information_schema','performance_schema','sys','scheduleDB','mysql','krone')\G" | grep 'schema_name' | awk '{print $2}' > backup_list

_read_file='backup_list' ###backup db list

##find  $path/ -type f -atime 7 | grep "night_" | head -n 1 | awk '{print $8}' | xargs rm 
find $path/*.sql.gz -type f -atime +7 |  xargs  --no-run-if-empty rm 

while read line; 

do 

_path=${path}/${line}

###data &&  routines && event
/usr/bin/mysqldump -pXXXXXXXXX -uroot  -R -E $line | gzip > ${_path}_data_R_E_$Today.sql.gz
/usr/bin/mysqldump -pXXXXXXXXX -uroot  -R -E -S/var/lib/mysql-3307/mysql-3307.sock  $line  | gzip > ${_path}_3307_data_R_E_$Today.sql.gz

sleep 1


###  routines && event
/usr/bin/mysqldump -pXXXXXXXXX -uroot  -R -t -d -E $line | gzip > ${_path}_R_E_$Today.sql.gz
/usr/bin/mysqldump -pXXXXXXXXX -uroot  -R -t -d -E -S/var/lib/mysql-3307/mysql-3307.sock  $line | gzip > ${_path}_3307_R_E_$Today.sql.gz

### schema &&  routines && event

/usr/bin/mysqldump -pXXXXXXXXX -uroot  -R -d  -E $line | gzip > ${_path}_schema_R_E_$Today.sql.gz
/usr/bin/mysqldump -pXXXXXXXXX -uroot  -R -d  -E -S/var/lib/mysql-3307/mysql-3307.sock $line | gzip > ${_path}_3307_schema_R_E_$Today.sql.gz

sleep 1


#echo "$Today Clean Up  Over 7 Days archive log" >> $path/schema_backup.log

done < $_read_file


###### permission & tools
/usr/bin/mysqldump -pXXXXXXXXX -uroot   mysql | gzip > /home/schema_backup/mysql_permission_$Today.sql.gz
/usr/bin/mysqldump -pXXXXXXXXX -uroot   -S/var/lib/mysql-3307/mysql-3307.sock  mysql | gzip > /home/schema_backup/mysql_3307_permission_$Today.sql.gz
/usr/bin/mysqldump -pXXXXXXXXX -uroot   krone | gzip > /home/schema_backup/krone_$Today.sql.gz

echo "$Today Clean Up  Over 7 Days archive log" >> $path/schema_backup.log
