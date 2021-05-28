#! /bin/bash -l
cd /var/log/servicegrab

find /var/log/servicegrab/ -type f  ! -name "01_*" -mtime +60 -exec rm -f {} \;

gzip -f *.txt 2> /dev/null

comandos=("netstat -rn" "route -n" "lvs" "crontab -l" "cat /etc/passwd" "cat /etc/resolv.conf" "cat /etc/hosts" "chkconfig --list" "docker ps" "docker ps -a" "iptables -S" "iptables -L" "lspci" "last -w" "uptime" "df -h" "mount" "ps -ef" "ifconfig" "fdisk -l" "systemctl" "systemctl status" "dmidecode" "rpm -qa" "free -g" "netstat -tulpn" "uname -a" "pstree" "lsblk" "lsof -i -P" "cat /proc/meminfo" )

dt=$(date "+%d_%m_%Y_")

for i in "${comandos[@]}"
do
		$i > $dt$(echo $i|tr -d " "|tr -s "/" "-"|tr -s "\" "-").txt
done
