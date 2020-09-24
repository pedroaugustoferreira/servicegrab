#! /bin/bash -l
cd /var/log/servicegrab

remove="*_$(date --date='-1 month' "+%m")_*"
ls $remove 2> /dev/null |grep -v "^01_"| awk '{print "rm -rf "$1}' | sh

gzip -f *.txt 2> /dev/null

comandos=( "last -w" "uptime" "df -h" "mount" "ps -ef" "ifconfig" "fdisk -l" "systemctl" "systemctl status" "dmidecode" "rpm -qa" "free -g" "netstat -nlp" "uname -a" "dmesg -c" "pstree" "lsblk" "lsof -i -P" "cat /proc/meminfo" )

dt=$(date "+%d_%m_%Y_")

for i in "${comandos[@]}"
do
	$i > $dt$(echo $i|tr -d " "|tr -s "/" "-").txt
done
