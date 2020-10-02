#!/bin/bash
### BEGIN INIT INFO
# Provides:          mongod-config
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description:
# Description:       mongod-config
### END INIT INFO

. /etc/rc.d/init.d/functions

CONFIGFILE="/etc/mongod-config.conf"
OPTIONS=" -f $CONFIGFILE"
SYSCONFIG="/etc/sysconfig/mongod-config"
NUMACTL_ARGS="--interleave=all"
mongod=${MONGOD-/usr/bin/mongod}

MONGO_USER=mongod
MONGO_GROUP=mongod

if [ -f "$SYSCONFIG" ]; then
    . "$SYSCONFIG"
fi

if which numactl >/dev/null 2>/dev/null && numactl $NUMACTL_ARGS ls / >/dev/null 2>/dev/null
then
  NUMACTL="numactl $NUMACTL_ARGS"
else
  NUMACTL=""
fi

start()
{
  if /bin/ps awux|/bin/grep /usr/bin/mongod|/bin/grep configsvr |/bin/grep -v grep
  then
    echo -n $"Mongod-config is running: "
    RETVAL=$?
    echo
  else
    echo -n $"Starting mongod-config: "
    ulimit -n 25000

    daemon --user "$MONGO_USER" --check $mongod "$NUMACTL $mongod $OPTIONS $MONGODOPTIONS --configsvr"

    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/mongod-config
  fi
}

stop()
{
  echo -n $"Stopping mongod-config: "
  P=`/bin/ps awux|/bin/grep /usr/bin/mongod|/bin/grep configsvr |/bin/grep -v grep|/bin/awk '{print $2 }'`
  if ! test -z "$P"; then
     /bin/kill $P
  fi
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/mongod-config
}

restart () {
	stop
	start
}

checkstatus() {
        R=`/bin/ps awux|/bin/grep /usr/bin/mongod|/bin/grep configsvr |/bin/grep -v grep`
        if test -z "$R"; then
                echo "mongod-config stopped"
                RETVAL=3
        else
                echo "mongod-config running ($R)"
                RETVAL=0
        fi
}

logrotate() {
        R=`/bin/ps awux|/bin/grep /usr/bin/mongod|/bin/grep configsvr |/bin/grep -v grep|/bin/awk '{print $2 }'`
        if test -z "$R"; then
                echo "mongod-config not running"
                RETVAL=3
        else
		kill -USR1 $R
                RETVAL=0
        fi
}


ulimit -n 12000
RETVAL=0

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart|reload|force-reload)
    restart
    ;;
  condrestart)
    [ -f /var/lock/subsys/mongod-config ] && restart || :
    ;;
  status)
    checkstatus
    ;;
  logrotate)
    logrotate
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart|reload|force-reload|condrestart}"
    RETVAL=1
esac

exit $RETVAL
