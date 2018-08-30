#!/bin/sh
#20180330 adding flush_logs clean more than 10 M


function random_range()
{
    if [ "$#" -lt "4" ]; then 
        echo "Usage: random_range <low> <high>"
        return
    fi
    low=$1
    range=$(($2 - $1))
    low_1=$3
    range_1=$(($4 -$3 ))
    _h=$(($low+$RANDOM % $range))
    	
	if [ "$_h" -lt "10" ]; then
	   _h=$(printf "%02d" $_h)	
	fi
	
	
    _m=$(($low_1+$RANDOM % $range_1))

        if [ "$_m" -lt "10" ]; then
           _m=$(printf "%02d" $_m)
        fi


   
#    echo $_h $_m	
}

function flush_logs()
{

##flush_logs $1(path) $2(log_file_locate)

cd $1

file=`cat $2 | grep filename | awk '{print $1}' | cut -c 11- |cut -d "'" -f 1` ## get log_file name

file_size=`du -m ${file} | awk '{print $1}'`
    
#echo $file_size

if [ "$file_size" -ge "10" ]; then   ## log_file  >= 10M
   echo "" > $file

fi

}



## delete crontab
sed -i '/p2plogin_linux_with_reply.py/d' /var/spool/cron/$USER
sed -i '/kingbus_linux.py/d' /var/spool/cron/$USER
#sed -i '/no_ip_confirm.py/d' /var/spool/cron/$USER
sed -i '/apk_linux_with_reply.py/d' /var/spool/cron/$USER

## add crontab

##call  function of p2p h_start h_end m_start m_end
random_range 1 6 1 59
echo "$_m $_h  * * * cd /root/python_dir/p2plogin && /usr/local/bin/python3.6 p2plogin_linux_with_reply.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/p2plogin' 'p2plogin_linux_with_reply.py'


##call  function of kingbus h_start h_end m_start m_end
random_range 1 6 1 59
echo "$_m $_h  * * 1 cd /root/python_dir/kingbus && /usr/local/bin/python3.6 kingbus_linux.py" >> "/var/spool/cron/$USER"

sleep 0.5

##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/kingbus' 'kingbus_linux.py'

##call  function of no-ip h_start h_end m_start m_end
#random_range 1 6 1 59
#echo "$_m $_h  * * 1 cd /root/python_dir/no_ip && /usr/local/bin/python3.6 no_ip_confirm.py" >> "/var/spool/cron/$USER"



##call  function of apk_linux_with_reply h_start h_end m_start m_end
random_range 1 6 1 59
echo "$_m $_h  * * * cd /root/python_dir/apklogin && /usr/local/bin/python3.6 apk_linux_with_reply.py" >> "/var/spool/cron/$USER"

sleep 0.5

##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/apklogin' 'apk_linux_with_reply.py'

## crontab apply
/usr/bin/crontab /var/spool/cron/$USER
