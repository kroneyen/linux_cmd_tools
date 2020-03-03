#!/bin/sh

Today=`date +"%Y-%m-%d %H:%M"`
D_log='innodb_status.log'
D_temp='Deadlock_temp.txt'

Deadlock_Qry=`mysql -pflush_user -uflush_user -hlocalhost -e 'show engine innodb status\G' | grep -A 1000 "LATEST DETECTED DEADLOCK"  | grep -B 1000 "WE ROLL BACK TRANSACTION" > ${D_temp}`
Deadlock_id=`cat $D_temp | grep -A 2 'LATEST DETECTED DEADLOCK' | awk '{print $3}' | tail -n 1`
mail_group='krone.yen@ingeniousinc.co lenny@ingeniousinc.co eric.chung@ingeniousinc.co'
#mail_group='krone.yen@ingeniousinc.co'


if [ -e $D_log ] ; then 
       
   log_Deadlock_id=`cat $D_log | grep -A 2 'LATEST DETECTED DEADLOCK' | awk '{print $3}' | tail -n 1`

   if [ "$Deadlock_id" != "$log_Deadlock_id" ] ;then

     mail -s "$HOSTNAME Mysql Deadlock Issue $Today" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=rd@1-pay.co" -S "smtp-auth-password=mg66=FBh" -S "from=rd@1-pay.co" -S "ssl-verify=ignore" -S "nss-config-dir=/root/DB_data/.certs" $mail_group  < $D_temp
     cat $D_temp > $D_log
   else
      echo "Innodb Without Deadlock"
   fi


else 
   
   check_temp_len=`wc ${D_temp}  | awk '{print $2}'`         
   if [ $check_temp_len -gt 1  ] ; then
        mail -s "$HOSTNAME Mysql Deadlock Issue $Today" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=rd@1-pay.co" -S "smtp-auth-password=mg66=FBh" -S "from=rd@1-pay.co" -S "ssl-verify=ignore" -S "nss-config-dir=/root/DB_data/.certs" $mail_group  < $D_temp
     
       cat $D_temp > $D_log
   fi
  

fi
