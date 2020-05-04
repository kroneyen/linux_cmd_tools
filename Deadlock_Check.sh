#!/bin/sh

source /root/DB_data/.env

Today=`date +"%Y-%m-%d %H:%M"`
D_log='innodb_status.log'
D_temp='Deadlock_temp.txt'

Deadlock_Qry=`mysql -p${_f_pwd} -u${_f_usr} -hlocalhost -e 'show engine innodb status\G' | grep -A 1000 "LATEST DETECTED DEADLOCK"  | grep -B 1000 "WE ROLL BACK TRANSACTION" > ${D_temp}`
Deadlock_id=`cat $D_temp | grep -A 2 'LATEST DETECTED DEADLOCK' | awk '{print $3}' | tail -n 1`
mail_group=$_mail_group


if [ -e $D_log ] ; then 
       
   log_Deadlock_id=`cat $D_log | grep -A 2 'LATEST DETECTED DEADLOCK' | awk '{print $3}' | tail -n 1`

   if [ "$Deadlock_id" != "$log_Deadlock_id" ] ;then

     mail -s "$HOSTNAME Mysql Deadlock Issue $Today" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=${_smtp_auth_user}" -S "smtp-auth-password=${_smtp_auth_password}" -S "from=${_from}" -S "ssl-verify=ignore" -S "nss-config-dir=/root/DB_data/.certs" $mail_group  < $D_temp
     cat $D_temp > $D_log
   else
      echo "Innodb Without Deadlock"
   fi


else 
   
   check_temp_len=`wc ${D_temp}  | awk '{print $2}'`         
   if [ $check_temp_len -gt 1  ] ; then
        mail -s "$HOSTNAME Mysql Deadlock Issue $Today" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=${_smtp_auth_user}" -S "smtp-auth-password=${_smtp_auth_password}" -S "from=${_from}" -S "ssl-verify=ignore" -S "nss-config-dir=/root/DB_data/.certs" $mail_group  < $D_temp
     
       cat $D_temp > $D_log
   fi
  

fi
