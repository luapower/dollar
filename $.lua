
--seriously, there's no reason for all that qualifying of everything.

ffi = require'ffi'
bit = require'bit'
glue = require'glue'
time = require'time'
pp = require'pp'

glue.update(_G, math)
glue.update(_G, table)

cocreate = coroutine.create
cowrap = coroutine.wrap
resume = coroutine.resume
yield = coroutine.yield

format = string.format
_ = string.format
rep = string.rep --because it's used with constants mostly
char = string.char

add = table.insert
push = table.insert
pop = table.remove

traceback = debug.traceback

date = os.date --clock() and time() comes from the time module.
exit = os.exit

cast = ffi.cast

bnot = bit.bnot
shl  = bit.lshift
shr  = bit.rshift
band = bit.band
bor  = bit.bor
xor  = bit.bxor

memoize     = glue.memoize

update      = glue.update
merge       = glue.merge
attr        = glue.attr
count       = glue.count
index       = glue.index
keys        = glue.keys
sortedpairs = glue.sortedpairs

indexof = glue.indexof
append  = glue.append
extend  = glue.extend

autoload  = glue.autoload

canopen   = glue.canopen
readfile  = glue.readfile
writefile = glue.writefile
readpipe  = glue.readpipe

pack   = glue.pack
unpack = glue.unpack

string.starts  = glue.starts
string.ends    = glue.ends
string.trim    = glue.trim
string.lines   = glue.lines
string.esc     = glue.esc
string.fromhex = glue.fromhex
string.tohex   = glue.tohex

shift = glue.shift
addr  = glue.addr
ptr   = glue.ptr

inherit = glue.inherit
object  = glue.object

Windows = false
Linux = false
OSX = false
BSD = false
POSIX = false
_G[ffi.os] = true
win = Windows

--dump standard library keywords for syntax highlighting.

if not ... then
	local t = {}
	for k,v in pairs(_G) do
		if k ~= 'type' then
			t[#t+1] = k
			if type(v) == 'table' and v ~= _G and v ~= arg then
				for kk in pairs(v) do
					t[#t+1] = k..'.'..kk
				end
			end
		end
	end
	sort(t)
	print(concat(t, ' '))
end
