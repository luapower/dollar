--[[

	$ | logging and error checking.

	log()
	note()
	nolog()
	warnif()
	check()

	verbose
	logtofile

]]

require'$'
local errors = require'errors'

verbose = false
logtofile = noop --fw. decl.

function log(severity, topic, action, fmt, ...)
	if severity == '' and not verbose then return end
	local env1 = app_env:sub(1, 1)
	local date = date('%Y-%m-%d %H:%M:%S', time())
	local msg = fmt and _(tostring(fmt), ...):gsub('\r?\n', '\n                                             ')
	local entry = _('%s %s %-6s %-6s %-8s %s\n', env1, date, severity or '', topic or '', action or '', msg or '')
	if severity ~= '' then
		logtofile(entry)
	end
	if severity ~= '' or verbose then
		io.stderr:write(entry)
		io.stderr:flush()
	end
end

function note(...) return log('note', ...) end
function nolog(...) return log('', ...) end

function warnif(topic, action, cond, ...)
	if not cond then return end
	log('WARN', topic, action, ...)
end

function check(errorclass, action, v, ...)
	assert(type(errorclass) == 'string' or errors.is(errorclass))
	assert(type(action) == 'string')
	if v then return v end
	local e = errors.new(errorclass, ...)
	log('ERROR', e.classname, action, e.message)
	e.logged = true --prevent duplicate logging of the error on a catch-all handler.
	errors.raise(e)
end

