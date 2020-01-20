#!/bin/sh

Today=`date +"%Y-%m-%d %H:%M"`
D_log='innodb_status.log'
D_temp='Deadlock_temp.txt'

Deadlock_Qry=`mysql -pflush_user -uflush_user -hlocalhost -e 'show engine innodb status\G' | grep -A 1000 "LATEST DETECTED DEADLOCK"  | grep -B 1000 "WE ROLL BACK TRANSACTION"`
Deadlock_id=`echo $Deadlock_Qry  | awk '{print $7}'`
mail_group="krone.huang@gmail"

echo $Deadlock_Qry > $D_temp

if [ -e $D_log ] ; then

   log_Deadlock_id=`cat $D_log | grep -A 2 'LATEST DETECTED DEADLOCK' | tail -n 1 | awk '{print $7}'`

   if [ "$Deadlock_id" != "$log_Deadlock_id" ] ;then

     mail -s "Mysql Deadlock Issue $Today" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=ingeniousinc2016@gmail.com" -S "smtp-auth-password=Qwer2016" -S "from=ingeniousinc2016@gmail.com" -S "ssl-verify=ignore" -S "nss-config-dir=/etc/pki/nssdb/.certs" $mail_group  < $D_temp
     echo $Deadlock_Qry > $D_log
   else
      echo "Innodb Without Deadlock"
   fi


else


     mail -s "Mysql Deadlock Issue $Today" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=ingeniousinc2016@gmail.com" -S "smtp-auth-password=Qwer2016" -S "from=ingeniousinc2016@gmail.com" -S "ssl-verify=ignore" -S "nss-config-dir=/etc/pki/nssdb/.certs" $mail_group  < $D_temp

      echo $Deadlock_Qry > $D_log

fi
