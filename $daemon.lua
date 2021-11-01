--[[

	Daemon API.
	Written by Cosmin Apreutesei. Public Domain.

	daemon(app_name) -> app

	app_name     app codename (the name of your main Lua module).
	debug.env    app environment ('dev').
	APP_conf.lua optional app config file loaded by the daemon() call.
	var_dir      r/w persistent data dir (base_dir).
	tmp_dir      r/w persistent temp dir (base_dir/tmp/app_name).
	cmd          {name->f} place to add command-line handlers.

]]

require'$fs'
require'$log'

--init -----------------------------------------------------------------------

function daemon(app_name)

	local app = {}
	cmd = {}

	_G.app_name = assert(app_name)

	--consider this module loaded so that other app submodules that
	--require it at runtime don't try to load it again.
	package.loaded[app_name] = app

	--cd to base_dir so that we can use relative paths for everything.
	local base_dir = fs.exedir()
	if not package.loaded.bundle_loader then
		--standalone luajit exe. files are in luapower dir at ../..
		base_dir = indir(indir(base_dir, '..'), '..')
	end
	_G.var_dir = rawget(_G, 'var_dir') or path.normalize(indir(base_dir, app_name..'-var'))
	_G.tmp_dir = rawget(_G, 'tmp_dir') or path.normalize(indir(indir(base_dir, 'tmp'), app_name))

	--r:run_cmdequire an optional config file.
	pcall(require, app_name..'_conf')

	function cmd.help(usage)
		if usage then
			io.stderr:write('Usage: '..app_name..' '..usage..'\n')
		else
			print'Options:'
			print('   -v   verbose')
			print('   -d   debug')
			print'Commands:'
			for k,v in sortedpairs(cmd) do
				print('   '..(k:gsub('_', '-')))
			end
		end
	end

	function app:run_cmd(f, ...) --stub
		return f(...)
	end

	function app:run(...)

		if ... == app_name then --caller module loaded with require()
			return app
		end

		check('fs', 'cd', fs.cd(base_dir), 'could not change dir to %s', base_dir)
		mkdir(var_dir)
		mkdir(tmp_dir)

		--open the logfile.
		local logfile = indir(var_dir, app_name..'.log')
		logging:tofile(logfile)

		logging.verbose = app_name
		local i = 1
		local f
		while true do
			local s = select(i, ...)
			i = i + 1
			if s == '-v' then
				logging.verbose = true
			elseif s == '-d' then
				logging.debug = true
			else
				f = s and cmd[s:gsub('-', '_')] or cmd.help
				break
			end
		end
		return self:run_cmd(f, select(i, ...))
	end

	return app

end
