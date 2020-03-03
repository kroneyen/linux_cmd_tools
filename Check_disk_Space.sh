#!/bin/bash
 
toemail="xxxxxxx@gmail.com"
alert=50
 
df -H | grep -vE '^Filesystem|tmpfs' | awk '{ print $5 " " $6 }' | grep "/" | head -n 1 | while read output;
do
        usepercent=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
        partition=$(echo $output | awk '{ print $2 }' )
        if [ $usepercent -ge $alert ]; then

             echo "$(date): $(hostname) Disk Space Alert: \"$partition ($usepercent%)\"" | mail -s "$(hostname) Disk Space Alert Over $alert" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=ingeniousinc2016@gmail.com" -S "smtp-auth-password=Qwer2016" -S "from=ingeniousinc2016@gmail.com" -S "ssl-verify=ignore" -S "nss-config-dir=/etc/pki/nssdb/.certs" $toemail  
#           echo "$(date): $(hostname) Disk Space Alert: \"$partition ($usepercent%)\"" | mail -s "$(hostname) Disk Space Alert Over $alert" -S "smtp-use-starttls=yes" -S "sntp-auth=login" -S "smtp=smtp.gmail.com:587"  -S "smtp-auth-user=rd@1-pay.co" -S "smtp-auth-password=mg66=FBh" -S "from=rd@1-pay.co" -S "ssl-verify=ignore" -S "nss-config-dir=/etc/pki/nssdb/.certs" $toemail 
        fi
done

#### adding certificate
#echo -n | openssl s_client -starttls smtp -connect smtp.gmail.com:587 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /root/DB_data/.certs/gmail.crt
#certutil -A -n "Google Internet Authority" -t "P,P,P" -d /root/DB_data/.certs -i /root/DB_data/.certs/gmail.crt
#certutil -L -d /etc/pki/nssdb/.certs 
