#!/bin/sh

##install percona toolkit 

alter_files='/root/alter_table_list'
alter_log='/root/alter_info.log'

process_num=`ps -ef | grep "auto_optimze_table.sh" | grep -v "grep" | wc -l`

if [ $process_num -eq 2 ] ; then

mysql -p123qweasd -uroot -e "SELECT CONCAT('pt-online-schema-change --user=root --password=123qweasd --alter ENGINE=InnoDB D=',table_schema,',t=',table_name,' --execute') as t FROM information_schema.tables  WHERE engine='InnoDB'  AND table_schema NOT REGEXP('information_schema|mysql|performance_schema');" |  grep 'pt-online-schema-change'  > ${alter_files}

echo "" > ${alter_log}

while read line 
do


	$line >> ${alter_log}


done  < ${alter_files}


else 

	echo "process is runing!!!"


fi




