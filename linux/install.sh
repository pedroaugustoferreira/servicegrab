#! /bin/bash -l
# curl -s https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/install.sh?$RANDON | bash -s --;/var/log/servicegrab/main.sh

check()
{ 
    if [ "$1" -eq "0"  ]; then echo "success"; else echo "error"; exit 1; fi
}

start()
{
    set -x
    #-------------------------------
    echo "(1) *** Arquivo cron rood ***"
    cat /etc/*rele* 2> /dev/null | egrep "CentOS Linux 7|Red Hat Enterprise Linux Server release 7" &> /dev/null
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
    cd /var/log/servicegrab
    check $?
    #-------------------------------
    echo "(3) *** Download main.sh ***"
    curl https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/main.sh?$RANDON 2> /dev/null > main.sh 
    cat main.sh |grep servicegrab
    check $?
    #-------------------------------
    echo "(4) *** chmod +x main.sh ***"
    chmod +x main.sh
    check $?
    #-------------------------------
    echo "(5) *** add crontab ***"
    cat $cronfile |grep -v "servicegrab" > /tmp/root.cron
    cat /tmp/root.cron > $cronfile
    check $?
    echo "# servicegrab" >> $cronfile
    check $?
    echo "0 6 * * * /var/log/servicegrab/main.sh &> /var/log/servicegrab/main.log" >> $cronfile
    check $?
    crontab -l |grep servicegrab
    check $?
    ls -la /var/log/servicegrab/main.sh
    check $?
}

start 2>&1 |egrep -v "for|start|grep|env|cut|echo|\+\+|sed|\[|cat|check|curl|exit"
