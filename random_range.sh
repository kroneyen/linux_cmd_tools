#!/bin/sh
#20180830 adding flush_logs clean more than 10 M
#20180903 adding random_range of week
#20190103 adding random_list && get_no_ip_date 

function random_range()
{
    if [ "$#" -lt "8" ]; then 
        echo "Usage: random_range <low> <high>"
        return
    fi
    low=$1
    range=$(($2 - $1 +1)) ## 0-5
    low_1=$3
    range_1=$(($4 -$3 +1)) ##10~59
    low_2=$5
    range_2=$(($6 -$5 +1)) ##1~7
    low_3=$7
    range_3=$(($8 -$7 +1)) ##1~7
    ## for hour
    _h=$(($low+$RANDOM % $range)) ## for hours
    	
	if [ "$_h" -lt "10" ]; then
	   _h=$(printf "%02d" $_h)	
	fi
	
    ## for minute
    _m=$(($low_1+$RANDOM % $range_1))  ## for minutes 

        if [ "$_m" -lt "10" ]; then
           _m=$(printf "%02d" $_m)
        fi
    
    ## for week
    _w=1
    _w1=1
   
    while [ "$_w" -ge "$_w1" ]
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

if [ -f "$file" ];then ## check file is exist 

   #echo $file 
   file_size=`du -m ${file} | awk '{print $1}'`
    
   #echo $file_size

   if [ "$file_size" -ge "10" ]; then   ## log_file  >= 10M
       echo "" > $file

   fi

fi

}


## get no ip flush date 
function get_no_ip_date() 
{
   cd $1

   file=`cat $2 | grep filename | awk '{print $1}' | cut -c 11- |cut -d "'" -f 1` ## get log_file name
   ## get date for log file  

      if [ -f "$file" ];then ## check log file is exist 

         _get_file_date=`tail -n5 $file  | grep 'user all done!!' | sort -r -n | head -n1 | awk '{print $1}'`
         _nd=`date -d "${_get_file_date} 24 days" +%d`  ##after 23 days
      
      else ### the check file not existed
              _nd=`date -d "24 days" +%d`
      fi

}



## _random_list format : h_start h_end m_start m_end w_start w_end w1_start w1_end
_random_list="0 5 10 59 1 7 1 7"

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
## execute kingbus with sys argv : kingbus_linux.py 2019/02/22 2019/02/25 (default 0 0 )
random_range $_random_list
echo "$_m $_h  * * 1 cd /root/python_dir/kingbus && rm -rf *.png && /usr/local/bin/python3.6 kingbus_linux.py 0 0" >> "/var/spool/cron/$USER"

sleep 0.5

##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/kingbus' 'kingbus_linux.py'

##call  function of no-ip h_start h_end m_start m_end  by month-day per-month/12
get_no_ip_date '/root/python_dir/no_ip' 'no_ip_confirm.py'
random_range $_random_list
echo "$_m $_h  $_nd * * cd /root/python_dir/no_ip && /usr/local/bin/python3.6 no_ip_confirm.py" >> "/var/spool/cron/$USER"

sleep 0.5
##call function flush_logs(path log_file_locate)
flush_logs '/root/python_dir/no_ip' 'no_ip_confirm.py'

##call  function of apk_linux_with_reply h_start h_end m_start m_end w_start w_end
random_range $_random_list
echo "#$_m $_h  * * * cd /root/python_dir/apklogin && /usr/local/bin/python3.6 apk_linux_with_reply.py" >> "/var/spool/cron/$USER"

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
