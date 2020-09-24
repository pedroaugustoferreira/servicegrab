#! /bin/bash -l
# curl -s https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/install.sh | bash -s --

cat /etc/*rele*|egrep "CentOS Linux 7|Red Hat Enterprise Linux Server release 7" &> /dev/null
if [ "$?" -eq "0"  ]; then
    cronfile=/var/spool/cron/root
fi

if [ -z "$cronfile" ];
then
   echo "SO nao identificado"
   exit 1
fi

mkdir /var/log/servicegrab 2> /dev/null
cd /var/log/servicegrab
curl -O https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/main.sh
chmod +x main.sh

cat $cronfile |grep -v "servicegrab" > /tmp/root.cron &> /dev/null

cat /tmp/root.cron > $cronfile &> /dev/null
echo "# servicegrab" >> $cronfile
echo "0 6 * * * /var/log/servicegrab/main.sh &> /var/log/servicegrab/main.log" >> $cronfile

crontab -l |grep servicegrab
ls -la /var/log/servicegrab/
