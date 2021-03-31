#! /bin/bash -l
# Online 
# crontab -l ;curl -s https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/install.sh?$RANDON | bash -s --;/var/log/servicegrab/main.sh; ls -la /var/log/servicegrab/ 

# Offline
# sh install.sh;/var/log/servicegrab/main.sh; ls -la /var/log/servicegrab/ 

cd /var/log/servicegrab

remove="*_$(date --date='-2 month' "+%m")_*"
ls $remove 2> /dev/null |grep -v "^01_"| awk '{print "rm -rf "$1}' | sh

gzip -f *.txt 2> /dev/null

comandos=( "lvs" "crontab -l" "cat /etc/passwd" "cat /etc/resolv.conf" "cat /etc/hosts" "chkconfig --list" "docker ps" "docker ps -a" "iptables -S" "iptables -L" "lspci" "last -w" "uptime" "df -h" "mount" "ps -ef" "ifconfig" "fdisk -l" "systemctl" "systemctl status" "dmidecode" "rpm -qa" "free -g" "netstat -tulpn" "uname -a" "pstree" "lsblk" "lsof -i -P" "cat /proc/meminfo" )

dt=$(date "+%d_%m_%Y_")

for i in "${comandos[@]}"
do
	$i > $dt$(echo $i|tr -d " "|tr -s "/" "-").txt
done
[root@j027vcon20p01 inst_service_grab]# cat install.sh 
#! /bin/bash -l
# crontab -l ;curl -s https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/install.sh?$RANDON | bash -s --;/var/log/servicegrab/main.sh; ls -la /var/log/servicegrab/ 

check()
{ 
    if [ "$1" -eq "0"  ]; then echo "success"; else echo "error"; exit 1; fi
}

start()
{
    set -x
    #-------------------------------
    echo "(1) *** Arquivo cron rood ***"
    cat /etc/*rele* 2> /dev/null | egrep "Ubuntu|Oracle Linux 6|Red Hat Enterprise Linux 8|CentOS release 6|CentOS Linux 7|Red Hat Enterprise Linux Server release 7" &> /dev/null
    if [ "$?" -eq "0"  ]; then
        cronfile=/var/spool/cron/root
    fi

    if [ -z "$cronfile" ];
    then
       echo "SO nao identificado"
       exit 1
    fi
    check $?
    #-------------------------------
    echo "(2) *** Criando pasta /var/log/servicegrab ***"
    echo "---Criando pasta /var/log/servicegrab"
    mkdir /var/log/servicegrab 2> /dev/null
    #-------------------------------
    echo "(4) *** chmod +x main.sh + copy main.sh /var/log/servicegrab ***"
    chmod +x main.sh
    check $?
    cp -p main.sh /var/log/servicegrab/
    check $?
    cd /var/log/servicegrab
    check $?
    #-------------------------------
    echo "(5) *** add crontab ***"
    crontab -l &> $HOME/crontab.$RANDOM
    cat $cronfile |grep -v "servicegrab" > /tmp/root.cron
    cat /tmp/root.cron > $cronfile
    check $?
    echo "# servicegrab" >> $cronfile
    check $?
    echo "0 6 * * * /var/log/servicegrab/main.sh &> /var/log/servicegrab/main.log" >> $cronfile
    check $?
    crontab -l |grep servicegrab
    check $?
    chmod 700 /var/log/servicegrab/main.sh
    check $?
    ls -la /var/log/servicegrab/main.sh
    check $?
    /var/log/servicegrab/main.sh
    ls -la /var/log/servicegrab
}

start 2>&1 |egrep -v "for|start|grep|env|cut|echo|\+\+|sed|\[|cat|check|curl|exit"
