#!/bin/bash

OSBDET_HOME=/root/osbdet
OSBDET_LOGFILE=$OSBDET_HOME/osbdet.log
SCRIPT_PATH=$(dirname $(realpath $0))

echo "Running 'SP1' recipe:"
printf "  - Fixing Hadoop3 installation... "
cp $SCRIPT_PATH/core-site.xml /opt/hadoop3/etc/hadoop/core-site.xml
chown osbdet:osbdet /opt/hadoop3/etc/hadoop/core-site.xml
cp $SCRIPT_PATH/mapred-site.xml /opt/hadoop3/etc/hadoop/mapred-site.xml
chown osbdet:osbdet /opt/hadoop3/etc/hadoop/mapred-site.xml
cp $SCRIPT_PATH/yarn-site.xml /opt/hadoop3/etc/hadoop/yarn-site.xml
chown osbdet:osbdet /opt/hadoop3/etc/hadoop/yarn-site.xml
printf "[Done]\n"
printf "  - Fixing Hive3 installation... "
echo export HIVE_AUX_JARS_PATH=/opt/hive3/lib > /opt/hive3/conf/hive-env.sh
chmod u+x /opt/hive3/conf/hive-env.sh
printf "[Done]\n"
printf "  - Installing Tweepy... "
python3 -m pip install tweepy >> $OSBDET_LOGFILE 2>&1
printf "[Done]\n"
printf "  - Fixing compatibility issues with Python libraries... "
apt-get remove -y python3-chardet python3-urllib3 --purge >> $OSBDET_LOGFILE 2>&1
apt autoremove -y >> $OSBDET_LOGFILE 2>&1
python3 -m pip install requests >> $OSBDET_LOGFILE 2>&1
printf "[Done]\n"
