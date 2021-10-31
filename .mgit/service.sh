
[ "$SERVICE" ] || { echo "\$SERVICE not set"; exit 1; }
CMD="./luajit $SERVICE.lua"
VAR_DIR=$SERVICE-var
PID=$VAR_DIR/$SERVICE.pid
LOG=$VAR_DIR/$SERVICE.log

running() {
	local pid="$(cat $PID 2>/dev/null)"
	[ "$pid" ] || return 1
	ps --no-headers -o command -p $pid | grep -q "$CMD"
}

main() {
	if [ "$1" == start ]; then
		running && { echo "Already running (pid $(cat $PID))."; return 1; }
		[ -f "$PID" ] && { echo "Stale pid file found."; }
		$CMD 2>&1 >> $LOG &
		echo "$!" > $PID
		running && echo "Started. PID: $(cat $PID)." || { echo "Failed to start."; return 1; }
	elif [ "$1" == stop ]; then
		running || { echo "Not running."; return 1; }
		local pid="$(cat $PID)"
		echo -n "Killing pid $pid..."
		kill $pid
		running && { echo "Failed."; return 1; } || { echo "OK."; rm $PID; }
	elif [ "$1" == restart ]; then
		"$0" stop && "$0" start
	elif [ ! "$1" -o "$1" == status ]; then
		running && echo "Running. PID: $(cat $PID)." || echo "Not running."
	elif [ "$1" == log ]; then
		tail -f $LOG 2>/dev/null
	elif [ "$1" == fg ]; then
		$CMD
	else
		echo "Usage: $0 [start | stop | restart | status | log | fg]"
	fi
}

main "$@"
