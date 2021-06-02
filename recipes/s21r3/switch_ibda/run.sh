#!/bin/bash

OSBDET_HOME=/root/osbdet
OSBDET_LOGFILE=$OSBDET_HOME/osbdet.log
SCRIPT_PATH=$(dirname $(realpath $0))

build_module() {
  IS_INSTALLED=`$OSBDET_HOME/osbdet_builder.sh status | grep "$1" | grep KO | wc -l`

  if [ "$IS_INSTALLED" == "0" ]
  then
    printf "Skipped [Already installed]\n"
  else
    printf "Building\n"
    $OSBDET_HOME/osbdet_builder.sh build $1
    printf "[Build]\n"
  fi
}

build_modules() {
  MODULES=(foundation jupyter hadoop3 hive3 nifi superset)

  for module in ${MODULES[@]}
  do
    printf "    * Building module '$module'... "
    build_module $module
  done
}

remove_modules() {
   echo "Removing modules"
}

echo "Running 'switch_ibda' recipe:"
echo
echo "  - Building the right modules if needed... "
build_modules
echo "  - Removing unneeded modules ... "
remove_modules
echo
echo "'switch_ibda' has been executed"
