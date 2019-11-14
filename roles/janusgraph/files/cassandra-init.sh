#! /bin/bash
### BEGIN INIT INFO
# Provides:          cassandra
# Required-Start:    $remote_fs $network $named $time $elasticsearch
# Required-Stop:     $remote_fs $network $named $time
# Should-Start:      ntp mdadm
# Should-Stop:       ntp mdadm
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Freakin' Cassandra
# Description:       Freakin' Cassandra
### END INIT INFO

DESC="Cassandra"
NAME=cassandra
PIDFILE=/var/run/$NAME/$NAME.pid
CASSANDRA_HOME=/usr/local/janusgraph/
RUN_AS=janus

[ -e $CASSANDRA_HOME/bin/cassandra ] || exit 1

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

export JANUSGRAPH_PID_DIR=/var/run/cassandra
export JANUSGRAPH_LOGDIR=/var/log/cassandra


case "$1" in
  start)
    su $RUN_AS -c "$CASSANDRA_HOME/bin/cassandra -p $PIDFILE"
    ;;
  stop)
    cat $PIDFILE | xargs kill
    ;;
  restart|force-reload)
    cat $PIDFILE | xargs kill
    su $RUN_AS -c "$CASSANDRA_HOME/bin/cassandra -p $PIDFILE"
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
    exit 3
    ;;
esac

# vi:ai sw=4 ts=4 tw=0 et
