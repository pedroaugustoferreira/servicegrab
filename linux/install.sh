#! /bin/bash -l
# curl -s https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/install.sh | bash -s --

mkdir /var/log/servicegrab 2> /dev/null
cd /var/log/servicegrab
curl -O https://raw.githubusercontent.com/pedroaugustoferreira/servicegrab/master/linux/main.sh
chmod +x main.sh
cat /var/spool/cron/tabs/root |grep -v "servicegrab" > /tmp/root.cron
cat /tmp/root.cron > /var/spool/cron/tabs/root
echo "0 6 * * * /var/log/servicegrab/main.sh &> /var/log/servicegrab/main.log" >> /var/spool/cron/tabs/root
