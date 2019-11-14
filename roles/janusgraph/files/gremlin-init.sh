#! /bin/bash
### BEGIN INIT INFO
# Provides:          gremlin
# Required-Start:    $remote_fs $network $named $time $elasticsearch
# Required-Stop:     $remote_fs $network $named $time
# Should-Start:      ntp mdadm
# Should-Stop:       ntp mdadm
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Tinkerpop-compliant graph database API
# Description:       Tinkerpop-compliant graph database API
### END INIT INFO

DESC="Gremlin"
NAME=gremlin
PIDFILE=/var/run/$NAME/$NAME.pid
GREMLIN_HOME=/usr/local/janusgraph/
RUN_AS=janus

[ -e $GREMLIN_HOME/bin/gremlin-server.sh ] || exit 1

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

export JANUSGRAPH_PID_DIR=/var/run/gremlin
export JANUSGRAPH_LOGDIR=/var/log/gremlin

su $RUN_AS -c "$GREMLIN_HOME/bin/gremlin-server.sh $1"

# vi:ai sw=4 ts=4 tw=0 et
