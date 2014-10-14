#!/bin/bash
### BEGIN INIT INFO
# Provides:          inittest
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       inittest test
### END INIT INFO

PROG_PATH=inittest
PROG_LOG=/var/log/inittest

function date_get() {
   date +"%F %T:%S"
}

case "${1}" in
   start)
      PROG_PID=$(ps ax | grep inittest | grep "\-s" | awk '{print $1}')
      if [[ $PROG_PID -eq 0 ]]; then
         $PROG_PATH -s &>> $PROG_LOG & echo "Starting" $!
         echo "Started `date_get` PID $!" >> $PROG_LOG
         sleep 1
      else
         echo "Service is running $PROG_PID"
      fi
      ;;

   stop)
      PROG_PID=$(ps ax | grep inittest | grep "\-s" | awk '{print $1}') || 0
      if [[ $PROG_PID -ne 0 ]]; then
         echo "Stopping $PROG_PID"
         echo "Stopped `date_get` $PROG_PID" >> $PROG_LOG
         kill -9 $PROG_PID &>> $PROG_LOG
         sleep 1
      else
         echo "Service is not running."
      fi
      ;;

   status)
      PROG_PID=$(ps ax | grep inittest | grep "\-s" | awk '{print $1}')
      if [[ $PROG_PID -ne 0 ]]; then
         echo "Service is running" $PROG_PID
      else
         echo "Service is not running."
      fi
      ;;

   restart)
      ${0} stop
      sleep 1
      ${0} start
      ;;

   *)
      echo "Usage: ${0} {start|stop|restart}"
      exit 1
      ;;
esac

exit 0

# End inittest