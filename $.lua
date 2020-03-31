
--seriously, there's no reason for all that qualifying of everything.

ffi = require'ffi'
bit = require'bit'
glue = require'glue'
time = require'time'
pp = require'pp'

local function import(t)
	for k,v in pairs(t) do
		rawset(_G, k, v) --compat. with strict.lua
	end
end
import(math)
import(table)

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

time.install() --replace os.date and os.time.
date = os.date
clock = os.clock
sleep = time.sleep
time = glue.time --replace time module with the uber-time function.

exit = os.exit

cast = ffi.cast

Windows = false
Linux   = false
OSX     = false
BSD     = false
POSIX   = false
_G[ffi.os] = true
win = Windows

bnot = bit.bnot
shl  = bit.lshift
shr  = bit.rshift
band = bit.band
bor  = bit.bor
xor  = bit.bxor

memoize     = glue.memoize

noop = glue.noop
pass = glue.pass

update      = glue.update
merge       = glue.merge
attr        = glue.attr
count       = glue.count
index       = glue.index
keys        = glue.keys
sortedpairs = glue.sortedpairs
map         = glue.map

indexof = glue.indexof
append  = glue.append
extend  = glue.extend

module    = glue.module
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
esc            = glue.esc --because it's used with constants mostly.
string.fromhex = glue.fromhex
string.tohex   = glue.tohex
string.subst   = glue.subst

shift = glue.shift
addr  = glue.addr
ptr   = glue.ptr

inherit = glue.inherit
object  = glue.object
before   = glue.before
after    = glue.after
override = glue.override

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
