--[[

	Daemon API.
	Written by Cosmin Apreutesei. Public Domain.

	daemon(...) -> app

	app_name     app codename (the name of your main Lua module).
	debug.env    app environment ('dev').
	<app_name>_conf.lua optional app config file loaded by the daemon() call.
	var_dir      r/w persistent data dir (base_dir).
	tmp_dir      r/w persistent temp dir (base_dir/tmp/app_name).
	cmd          {name->f} place to add command-line handlers.

]]

require'$fs'
require'$log'

--init -----------------------------------------------------------------------

function daemon(...)

	local app = {}
	cmd = {}

	function app:init()

		--cd to base_dir so that we can use relative paths for everything.
		local exe_dir = fs.exedir()
		local base_dir = exe_dir..(ffi.abi'win' and [[\..\..]] or '/../..')
		check('fs', 'cd', fs.cd(base_dir), 'could not change dir to %s', base_dir)

		var_dir = var_dir or indir(base_dir, app_name..'-var')
		tmp_dir = tmp_dir or indir('tmp', app_name)

		mkdir(var_dir)
		mkdir(tmp_dir)

		--open the logfile.
		local logfile = indir(var_dir, app_name..'.log')
		logging:tofile(logfile)

		--require an optional config file.
		pcall(require, app_name..'_conf')

		return self
	end

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

	function app:run_cmd(f, ...)
		return f(...)
	end

	function app:run(...)
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

	if not arg[0] then --caller module loaded with require().
		app_name = assert(app_name or (...)) --app module name received as arg#1
	else --caller module loaded from cmdline (as main script).
		app_name = assert(app_name or arg[0]:match'([^/\\%.]+)%.?[^%.]*$')
		--consider this module loaded so that other app submodules that
		--require it at runtime don't try to load it again.
		package.loaded[app_name] = app
	end

	return app

end
