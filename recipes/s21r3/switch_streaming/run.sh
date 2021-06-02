#!/bin/bash

OSBDET_HOME=/root/osbdet
OSBDET_LOGFILE=$OSBDET_HOME/osbdet.log
SCRIPT_PATH=$(dirname $(realpath $0))

build_module() {
  echo "switch_streaming.build_module DEBUG [`date +"%Y-%m-%d %T"`] Building module '$1'" >> $OSBDET_LOGFILE
  IS_INSTALLED=`$OSBDET_HOME/osbdet_builder.sh status | grep "$1" | grep KO | wc -l`

  if [ "$IS_INSTALLED" == "0" ]
  then
    echo "switch_streaming.build_module DEBUG [`date +"%Y-%m-%d %T"`] Module '$1' is already built" >> $OSBDET_LOGFILE
    printf "Skipped [Already installed]\n"
  else
    printf "Building "
    $OSBDET_HOME/osbdet_builder.sh build $1 > /dev/null 2>&1
    printf "[Build]\n"
    echo "switch_streaming.build_module DEBUG [`date +"%Y-%m-%d %T"`] Module '$1' has been built" >> $OSBDET_LOGFILE
  fi
}

remove_module() {
  echo "switch_streaming.remove_module DEBUG [`date +"%Y-%m-%d %T"`] Removing module '$1'" >> $OSBDET_LOGFILE
  IS_INSTALLED=`$OSBDET_HOME/osbdet_builder.sh status | grep "$1" | grep KO | wc -l`

  if [ "$IS_INSTALLED" == "1" ]
  then
    echo "switch_streaming.remove_module DEBUG [`date +"%Y-%m-%d %T"`] Module '$1' is already removed" >> $OSBDET_LOGFILE
    printf "Skipped [Not available]\n"
  else
    printf "Removing "
    $OSBDET_HOME/osbdet_builder.sh remove $1 > /dev/null 2>&1
    printf "[Removed]\n"
    echo "switch_streaming.remove_module DEBUG [`date +"%Y-%m-%d %T"`] Module '$1' has been removed" >> $OSBDET_LOGFILE
  fi
}

build_modules() {
  MODULES=(foundation jupyter truckssim kafka2 spark3 mariadb superset)

  for module in ${MODULES[@]}
  do
    printf "    * Building module '$module'... "
    build_module $module
  done
}

remove_modules() {
  MODULES=(mongodb44 hadoop3 hive3 nifi)

  for module in ${MODULES[@]}
  do
    printf "    * Removing module '$module'... "
    remove_module $module
  done
}

echo "switch_streaming DEBUG [`date +"%Y-%m-%d %T"`] Start cooking the 'switch_streaming' recipe" >> $OSBDET_LOGFILE
echo "Running 'switch_streaming' recipe:"
echo
echo "  - Building the right modules if needed... "
build_modules
echo "  - Removing unneeded modules ... "
remove_modules
echo
echo "'switch_streaming' has been executed"
echo "switch_streaming DEBUG [`date +"%Y-%m-%d %T"`] The 'switch_streaming' has been cooked" >> $OSBDET_LOGFILE
