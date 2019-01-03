#!/bin/sh
#20180830 adding flush_logs clean more than 10 M
#20180903 adding random_range of week

function random_range()
{
    if [ "$#" -lt "8" ]; then 
        echo "Usage: random_range <low> <high>"
        return
    fi
    low=$1
    range=$(($2 - $1))
    low_1=$3
    range_1=$(($4 -$3 +1)) ##1~59
    low_2=$5
    range_2=$(($6 -$5 +1)) ##1~7
    low_3=$7
    range_3=$(($8 -$7 +1)) ##1~7

    _h=$(($low+$RANDOM % $range)) ## for hours
    	
	if [ "$_h" -lt "10" ]; then
	   _h=$(printf "%02d" $_h)	
	fi
	
	
    _m=$(($low_1+$RANDOM % $range_1))  ## for minutes 

        if [ "$_m" -lt "10" ]; then
           _m=$(printf "%02d" $_m)
        fi

    _w=1
    _w1=1

    while [ "$_w" -eq "$_w1" ]
    do
       _w=$(($low_2+$RANDOM % $range_2))  ## for week

          if [ "$_w" -lt "10" ]; then
             _w=$(printf "%01d" $_w)
          fi

       _w1=$(($low_3+$RANDOM % $range_3))  ## for week

          if [ "$_w1" -lt "10" ]; then
             _w1=$(printf "%01d" $_w1)
          fi
    done
   
#    echo $_h $_m	
}

function flush_logs()
{

##flush_logs $1(path) $2(log_file_locate)

cd $1

file=`cat $2 | grep filename | awk '{print $1}' | cut -c 11- |cut -d "'" -f 1` ## get log_file name

#echo $file 
file_size=`du -m ${file} | awk '{print $1}'`
    
#echo $file_size

if [ "$file_size" -ge "10" ]; then   ## log_file  >= 10M
   echo "" > $file

fi

}

_random_list="1 5 1 59 1 7 1 7"

## delete crontab
sed -i '/p2plogin_linux_with_reply.py/d' /var/spool/cron/$USER
sed -i '/kingbus_linux.py/d' /var/spool/cron/$USER
sed -i '/no_ip_confirm.py/d' /var/spool/cron/$USER
sed -i '/apk_linux_with_reply.py/d' /var/spool/cron/$USER
sed -i '/p2plogin_linux_with_reply_drama.py/d' /var/spool/cron/$USER
sed -i '/p2plogin_linux_with_reply_software.py/d' /var/spool/cron/$USER
sed -i '/awa_linux_with_reply.py/d' /var/spool/cron/$USER

## add crontab

##call  function of p2p h_start h_end m_start m_end w_start w_end
random_range $_random_list 
echo "$_m $_h  * * * cd /root/python_dir/p2plogin && /usr/local/bin/python3.6 p2plogin_linux_with_reply.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/p2plogin' 'p2plogin_linux_with_reply.py'


##call  function of kingbus h_start h_end m_start m_end w_start w_end
random_range $_random_list
echo "$_m $_h  * * 1 cd /root/python_dir/kingbus && /usr/local/bin/python3.6 kingbus_linux.py" >> "/var/spool/cron/$USER"

sleep 0.5

##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/kingbus' 'kingbus_linux.py'

##call  function of no-ip h_start h_end m_start m_end  by month-day per-month/12
random_range $_random_list
echo "$_m $_h  9 * * cd /root/python_dir/no_ip && /usr/local/bin/python3.6 no_ip_confirm.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/no_ip' 'no_ip_confirm.py'


##call  function of apk_linux_with_reply h_start h_end m_start m_end w_start w_end
random_range $_random_list
echo "$_m $_h  * * * cd /root/python_dir/apklogin && /usr/local/bin/python3.6 apk_linux_with_reply.py" >> "/var/spool/cron/$USER"

sleep 0.5

##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/apklogin' 'apk_linux_with_reply.py'


## call  function of drama h_start h_end m_start m_end w_start w_end
random_range $_random_list
echo "$_m $_h  * * $_w,$_w1 cd /root/python_dir/p2plogin && /usr/local/bin/python3.6 p2plogin_linux_with_reply_drama.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/p2plogin' 'p2plogin_linux_with_reply_drama.py'


## call  function of software h_start h_end m_start m_end w_start w_end
random_range $_random_list
echo "$_m $_h  * * $_w,$_w1 cd /root/python_dir/p2plogin && /usr/local/bin/python3.6 p2plogin_linux_with_reply_software.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/p2plogin' 'p2plogin_linux_with_reply_software.py'

## call  function of awabest  h_start h_end m_start m_end w_start w_end
random_range $_random_list
echo "$_m $_h  * * * cd /root/python_dir/awabest && /usr/local/bin/python3.6 awa_linux_with_reply.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/awabest' 'awa_linux_with_reply.py'



## crontab apply
/usr/bin/crontab /var/spool/cron/$USER
