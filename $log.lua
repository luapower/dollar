--[[

	$ | logging and error checking.

	log(severity, module, event, fmt, ...)
	note(module, event, fmt, ...)
	nolog(module, event, fmt, ...)
	dbg(module, event, fmt, ...)
	warnif(module, event, condition, fmt, ...)
	logerror(module, event, fmt, ...)
	debug.args(...) -> ...

	app_env <- 'dev' | 'prod', etc.
	debug.nolog <- {severity->true}
	debug.logtofile <- f(s)
	debug.logtodb <- f(t)

]]

require'$'

attr(debug, 'nolog')
app_env = app_env or 'dev'

local names = setmetatable({}, {__mode = 'k'}) --{[obj]->name}

function debug.name(obj, name)
	names[obj] = name
end

debug.name(coroutine.running(), 'TM')

local function has_fields(v)
	return type(v) == 'table' or type(v) == 'cdata'
end

local function debug_type(v)
	return has_fields(v) and v.type or type(v)
end

local prefixes = {
	thread = 'T',
	['function'] = 'f',
}

local function debug_prefix(v)
	return has_fields(v) and v.debug_prefix or prefixes[debug_type(v)]
end

local ids_db = {} --{type->{last_id=,[obj]->id}}

local function debug_id(v)
	local type = debug_type(v)
	local ids = ids_db[type]
	if not ids then
		ids = setmetatable({}, {__mode = 'k'})
		ids_db[type] = ids
	end
	local id = ids[v]
	if not id then
		id = (ids.last_id or 0) + 1
		ids.last_id = id
		ids[v] = id
	end
	return debug_prefix(v)..id
end

local function debug_arg(v)
	if type(v) == 'boolean' then
		return 'Y' or 'N'
	elseif v == nil or type(v) == 'number' then
		return tostring(v)
	elseif type(v) == 'string' then
		return v
			:gsub('\r\n', '\n')
			:gsub('\n%s*$', '')
			:gsub('[%z\1-\9\11-\31\128-\255]', '.') or ''
	else --table, function, thread, cdata
		return names[v]
			or (getmetatable(v) and getmetatable(v).__tostring and tostring(v))
			or (type(v) == 'table' and not v.type and not v.debug_prefix and pp.format(v))
			or debug_id(v)
	end
end

function debug.args(...)
	if select('#', ...) == 1 then
		return debug_arg((...))
	end
	local args = pack(...)
	for i=1,args.n do
		args[i] = debug_arg(args[i])
	end
	return unpack(args)
end

function log(severity, module, event, fmt, ...)
	if debug.nolog[severity] then return end
	local env1 = app_env:upper():sub(1, 1)
	local time = time()
	local date = date('%Y-%m-%d %H:%M:%S', time)
	local msg = fmt and _(fmt, debug.args(...))
	local entry = _('%s %s %-6s %-6s %-8s %s\n', env1, date,
		severity, module or '', event or '',
		msg and msg:gsub('\r?\n', '\n                                    ') or '')
	if severity ~= '' then
		if debug.logtofile then
			debug.logtofile(entry)
		end
		if debug.logtodb then
			debug.logtodb{
				env = app_env, time = time,
				severity = severity, module = module, event = event,
				message = msg,
			}
		end
	end
	io.stderr:write(entry)
	io.stderr:flush()
	return ...
end

function note(...) return log('note', ...) end
function nolog(...) return log('', ...) end
function dbg(...) return log('', ...) end

function warnif(module, event, cond, ...)
	if not cond then return end
	log('WARN', module, event, ...)
end

function logerror(module, event, ...)
	log('ERROR', module, event, ...)
end

if not ... then

	local sock = require'sock'
	local fs = require'fs'

	local s1 = sock.tcp()
	local s2 = sock.tcp()
	local t1 = coroutine.create(function() end)
	local t2 = coroutine.create(function() end)

	dbg('test', '%s %s %s %s\nanother thing', s1, s2, t1, t2)

end
