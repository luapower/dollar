 --[[

	$ | logging and error checking.

	log(severity, module, event, fmt, ...)
	note(module, event, fmt, ...)
	nolog(module, event, fmt, ...)
	dbg(module, event, fmt, ...)
	warnif(module, event, condition, fmt, ...)
	logerror(module, event, fmt, ...)
	debug.args(...) -> ...

	logging.env <- 'dev' | 'prod', etc.
	logging.filter <- {severity->true}
	logging:tofile(logfile, max_disk_size)
	logging:toserver(host, port, queue_size, timeout)

]]

require'$'
logging = require'logging'

log      = logging.log
note     = logging.note
nolog    = logging.nolog
dbg      = logging.dbg
warnif   = logging.warnif
logerror = logging.logerror

