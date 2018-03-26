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
    range_1=$4	
    _h=$(($low+$RANDOM % $range))
    	
	if [ "$_h" -lt "10" ]; then
	   _h=$(printf "%02d" $_h)	
	fi
	
	
    low_1=$3
    range_1=$4
    _m=$(($low_1+$RANDOM % $range_1))

        if [ "$_m" -lt "10" ]; then
           _m=$(printf "%02d" $_m)
        fi


   
#    echo $_h $_m	
}

##call  function h_start h_end m_start m_end
random_range 1 6 1 59

## delete crontab
sed -i '/p2plogin_linux.py/d' /var/spool/cron/$USER

## add crontab
echo "$_m $_h  * * * cd /root/python_dir && /usr/local/bin/python3.6 p2plogin_linux.py" >> "/var/spool/cron/$USER"

## crontab apply
/usr/bin/crontab /var/spool/cron/$USER
