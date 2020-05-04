#!/bin/bash

source /root/DB_data/.env
mail_group=$_mail_group
alert=80

df -H | grep -vE '^Filesystem|tmpfs' | awk '{ print $5 " " $6 }' | grep "/" | head -n 1 | while read output;
do
        usepercent=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
        partition=$(echo $output | awk '{ print $2 }' )
        if [ $usepercent -ge $alert ]; then

              echo "$(date): $(hostname) Disk Space Alert: \"$partition Use ($usepercent%)\"" | mail -s "$(hostname) Disk Space Alert Over $alert" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=${_smtp_auth_user}" -S "smtp-auth-password=${_smtp_auth_password}" -S "from=${_from}" -S "ssl-verify=ignore" -S "nss-config-dir=/root/DB_data/.certs" $mail_group
        fi
done
#### adding certificate
#echo -n | openssl s_client -starttls smtp -connect smtp.gmail.com:587 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /root/DB_data/.certs/gmail.crt
#certutil -A -n "Google Internet Authority" -t "P,P,P" -d /root/DB_data/.certs -i /root/DB_data/.certs/gmail.crt
#certutil -L -d /root/DB_data/.certs/gmail.crt
