#! /bin/bash
### BEGIN INIT INFO
# Provides:          elasticsearch
# Required-Start:    $remote_fs $network $named $time
# Required-Stop:     $remote_fs $network $named $time
# Should-Start:      ntp mdadm
# Should-Stop:       ntp mdadm
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: search engine
# Description:       Elasticsearch is a search engine, yo
### END INIT INFO

DESC="Elasticsearch"
NAME=elasticsearch
PIDFILE=/var/run/$NAME/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
ES_HOME=/usr/local/janusgraph/elasticsearch
RUN_AS=janus
WAIT_FOR_START=10
FD_LIMIT=100000

[ -e $ES_HOME/bin/elasticsearch ] || exit 1

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Export JAVA_HOME, if set.
[ -n "$JAVA_HOME" ] && export JAVA_HOME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
#. /lib/lsb/init-functions

#
# Function that returns 0 if process is running, or nonzero if not.
#
# The nonzero value is 3 if the process is simply not running, and 1 if the
# process is not running but the pidfile exists (to match the exit codes for
# the "status" command; see LSB core spec 3.1, section 20.2)
#
CMD_PATT="Des.path.conf=.*/elasticsearch/config"
is_running()
{
    if [ -f $PIDFILE ]; then
        pid=`cat $PIDFILE`
        grep -Eq "$CMD_PATT" "/proc/$pid/cmdline" 2>/dev/null && return 0
        return 1
    fi
    return 3
}

#
# Function that starts the daemon/service
#
do_start()
{
    # Return
    #   0 if daemon has been started
    #   1 if daemon was already running
    #   2 if daemon could not be started

    ulimit -l unlimited
    ulimit -n "$FD_LIMIT"

    su $RUN_AS -c "$ES_HOME/bin/elasticsearch -p $PIDFILE -d"
}

#
# Function that stops the daemon/service
#
do_stop()
{
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred
    if [ -f $PIDFILE ]; then
        pid=`cat $PIDFILE`
        grep -Eq "$CMD_PATT" "/proc/$pid/cmdline" 2>/dev/null && kill $pid
        RET=$?
    else
      RET=1
    fi
    rm -f "$PIDFILE"
    return $RET
}

case "$1" in
  start)
        [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
        do_start
        case "$?" in
                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  stop)
        [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
        do_stop
        case "$?" in
                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  restart|force-reload)
        log_daemon_msg "Restarting $DESC" "$NAME"
        do_stop
        case "$?" in
          0|1)
                do_start
                case "$?" in
                        0) log_end_msg 0 ;;
                        1) log_end_msg 1 ;; # Old process is still running
                        *) log_end_msg 1 ;; # Failed to start
                esac
                ;;
          *)
                # Failed to stop
                log_end_msg 1
                ;;
        esac
        ;;
  status)
    is_running
    stat=$?
    case "$stat" in
      0) log_success_msg "$DESC is running" ;;
      1) log_failure_msg "could not access pidfile for $DESC" ;;
      *) log_success_msg "$DESC is not running" ;;
    esac
    exit "$stat"
    ;;
  *)
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload|status}" >&2
        exit 3
        ;;
esac

:

# vi:ai sw=4 ts=4 tw=0 et
