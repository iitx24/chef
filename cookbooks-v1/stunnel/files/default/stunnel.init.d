#!/bin/bash
#
# stunnel      This shell script takes care of starting and stopping
#              stunnel
#
# chkconfig: 345 80 30
# description:  Secure tunnel

# processname: stunnel
# config: /etc/stunnel/stunnel.conf
# pidfile: /var/run/stunnel.pid

DEFAULTPIDFILE="/var/run/stunnel.pid"
DAEMON=/usr/local/bin/stunnel
NAME=stunnel
DESC="SSL tunnels"
FILES="/etc/stunnel/*.conf"
OPTIONS=""

ulimit -n 4096

get_pids() {
   local file=$1
   if test -f $file; then
     CHROOT=`grep "^chroot" $file|sed "s;.*= *;;"`
     PIDFILE=`grep "^pid" $file|sed "s;.*= *;;"`
     if [ "$PIDFILE" = "" ]; then
       PIDFILE=$DEFAULTPIDFILE
     fi
     if test -f $CHROOT/$PIDFILE; then
       cat $CHROOT/$PIDFILE
     fi
   fi
}

startdaemons() {
  if ! [ -d /var/run/stunnel ]; then
    rm -rf /var/run/stunnel
    install -d -o root -g root /var/run/stunnel
  fi
  for file in $FILES; do
    if test -f $file; then
      ARGS="$file $OPTIONS"
      PROCLIST=`get_pids $file`
      if [ "$PROCLIST" ] && kill -0 $PROCLIST 2>/dev/null; then
        echo -n "[Already running: $file] "
      elif $DAEMON $ARGS; then
        echo -n "[Started: $file] "
      else
        echo "[Failed: $file]"
        echo "You should check that you have specified the pid= in you configuration file"
        exit 1
      fi
    fi
  done;
}

killdaemons()
{
  for file in $FILES; do
    PROCLIST=`get_pids $file`
    if [ "$PROCLIST" ] && kill -0 $PROCLIST 2>/dev/null; then
       kill $PROCLIST
       echo -n "[stopped: $file] "
    fi
  done
}

if [ "x$OPTIONS" != "x" ]; then
  OPTIONS="-- $OPTIONS"
fi

# Source stunnel configuration.
if [ -f /etc/sysconfig/stunnel ] ; then
 . /etc/sysconfig/stunnel
fi

test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        startdaemons
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        killdaemons
        echo "$NAME."
        ;;
#force-reload does not send a SIGHUP, since SIGHUP is interpreted as a
#quit signal by stunnel. I reported this problem to upstream authors.
  force-reload|restart)
        echo -n "Restarting $DESC: "
        killdaemons
        sleep 5
        startdaemons
        echo "$NAME."
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|force-reload|restart}" >&2
        exit 1
        ;;
esac

exit 0
