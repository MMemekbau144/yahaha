#!/bin/bash
uuid=$(cat /etc/trojan/uuid.txt)
source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
echo "please add domain"
exit 0;
else
domain=$IP
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password: " -e user
		user_EXISTS=$(grep -i $user /etc/trojan/akun.conf | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo "Akun sudah ada, silahkan masukkan password lain."
			exit 1
		fi
	done
read -p "Expired (days): " masaaktif
sed -i '/"'""$user""'"$/a\,"'""$user""'"' /etc/trojan/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "\n### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan
service cron restart
trojanlink="trojan://${user}@${domain}:445"
clear
echo -e ""
echo -e "--------------Trojan------------"
echo -e "Remarks        : ${user}"
echo -e "Host/IP        : ${domain}"
echo -e "port           : 445"
echo -e "Key            : ${user}" 
echo -e "link           : ${trojanlink}"
echo -e "---------------------------------"
echo -e "Expired On     : $exp"
