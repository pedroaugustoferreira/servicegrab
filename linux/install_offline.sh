#! /bin/bash -l
# Online 
# crontab -l ;curl -s https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/install.sh?$RANDON | bash -s --;/var/log/servicegrab/servicegrab.sh; ls -la /var/log/servicegrab/ 

# Offline
# sh install.sh;/var/log/servicegrab/servicegrab.sh; ls -la /var/log/servicegrab/ 

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
    echo "(4) *** chmod +x servicegrab.sh + copy servicegrab.sh /var/log/servicegrab ***"
    chmod +x servicegrab.sh
    check $?
    cp -p servicegrab.sh /var/log/servicegrab/
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
    echo "0 6 * * * /var/log/servicegrab/servicegrab.sh &> /var/log/servicegrab/servicegrab.log" >> $cronfile
    check $?
    crontab -l |grep servicegrab
    check $?
    chmod 700 /var/log/servicegrab/servicegrab.sh
    check $?
    ls -la /var/log/servicegrab/servicegrab.sh
    check $?
    /var/log/servicegrab/servicegrab.sh
    ls -ltrh /var/log/servicegrab
}

start 2>&1 |egrep -v "for|start|grep|env|cut|echo|\+\+|sed|\[|cat|check|curl|exit"
