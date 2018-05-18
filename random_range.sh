#!/bin/sh

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


## delete crontab
sed -i '/p2plogin_linux.py/d' /var/spool/cron/$USER
sed -i '/kingbus_linux.py/d' /var/spool/cron/$USER
sed -i '/no_ip_confirm.py/d' /var/spool/cron/$USER

## add crontab

##call  function of p2p h_start h_end m_start m_end
random_range 1 6 1 59
echo "$_m $_h  * * * cd /root/python_dir/p2plogin && /usr/local/bin/python3.6 p2plogin_linux.py" >> "/var/spool/cron/$USER"

sleep 0.5

##call  function of kingbus h_start h_end m_start m_end
random_range 1 6 1 59
echo "$_m $_h  * * 1 cd /root/python_dir/kingbus && /usr/local/bin/python3.6 kingbus_linux.py" >> "/var/spool/cron/$USER"

sleep 0.5

##call  function of no-ip h_start h_end m_start m_end
random_range 1 6 1 59
echo "$_m $_h  * * 1 cd /root/python_dir/no_ip && /usr/local/bin/python3.6 no_ip_confirm.py" >> "/var/spool/cron/$USER"



## crontab apply
/usr/bin/crontab /var/spool/cron/$USER
