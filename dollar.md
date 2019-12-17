
## `require'$'`

Requires the minimum amount of modules that every Lua application seems to
need and makes a lot of symbols global. Run the script standalone with
`luajit $.lua` to get a listing of all the symbols (which you should paste
into your editor config file to for syntax highlighting).

Libraries don't use this module in an attempt to lower dependency count,
avoid polluting the global namespace and improve readability. Apps don't care
about all that and would rather establish a base vocabulary to use everywhere,
so they might welcome this module.

What libraries usually do instead of loading this module:

   * require the ffi module every goddamn time (and maybe the bit module).
   * copy-paste a few tools from [glue] to avoid bringing in the whole kitchen.
	* put used symbols into locals (also for speed when code is interpreted).

