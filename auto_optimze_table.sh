#!/bin/sh

##install percona toolkit 
#!/bin/sh

##install percona toolkit 
##sh auto_optimze_table.sh  payment_pool_uft8mb4
_user='root'
_pwd='PWD'
_db=$1
alter_files='alter_table_list'
alter_log='alter_info.log'

process_num=`ps -ef | grep $0 | grep -v 'grep' | wc -l`


if [ $process_num -eq 2 ] ; then

/usr/bin/mysql -p${_pwd} -u${_user} -e "SELECT CONCAT('/usr/bin/pt-online-schema-change --user=${_user} --password=${_pwd} --alter ENGINE=InnoDB D=',table_schema,',t=',table_name,' --execute') as t FROM information_schema.tables  WHERE engine='InnoDB'  AND table_schema NOT REGEXP('information_schema|mysql|performance_schema') order by table_name;" |  grep 'pt-online-schema-change' | grep ${_db} > ${alter_files}


echo "" > ${alter_log}

while read line 
do


        $line >> ${alter_log}


done  < ${alter_files}


else

        echo "process is runing!!!"


fi

