#!/bin/sh
#
# haproxy
#
# chkconfig:   - 85 15
# description:  HAProxy is a free, very fast and reliable solution \
#               offering high availability, load balancing, and \
#               proxying for TCP and  HTTP-based applications
# processname: haproxy
# config:      /etc/haproxy/haproxy.cfg
# pidfile:     /var/run/haproxy.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

exec="/usr/sbin/haproxy"
prog=$(basename $exec)

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

lockfile=/var/lock/subsys/haproxy

check() {
    $exec -c -V -f /etc/$prog/$prog.cfg
}

start() {
    $exec -c -q -f /etc/$prog/$prog.cfg
    if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog check."
        return 1
    fi
  echo -n $"Starting $prog: "
    # start it up here, usually something like "daemon $exec"
    daemon $exec -D -f /etc/$prog/$prog.cfg -p /var/run/$prog.pid
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    # stop it here, often "killproc $prog"
    killproc $prog
    retval=$?
    pkill -9 haproxy
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    $exec -c -q -f /etc/$prog/$prog.cfg
    if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog check."
        pkill -9 haproxy
        return 1
    fi
    stop
    start
}

reload() {
    $exec -c -q -f /etc/$prog/$prog.cfg
    if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog check."
        return 1
    fi
    echo -n $"Reloading $prog: "
    $exec -D -f /etc/$prog/$prog.cfg -p /var/run/$prog.pid -sf $(cat /var/run/$p
rog.pid)
    retval=$?
    echo
    return $retval
}

force_reload() {
    restart
}

fdr_status() {
    status $prog
}

case "$1" in
    start|stop|restart|reload)
        $1
        ;;
    force-reload)
        force_reload
        ;;
    check)
        check
        ;;
    status)
        fdr_status
        ;;
    condrestart|try-restart)
        [ ! -f $lockfile ] || restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|try-restart|reload|force-rel
oad}"
        exit 2
esac
