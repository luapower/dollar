
-- "Seriously, there's no need for all that qualifying of everything" - Fartman

ffi  = require'ffi'
bit  = require'bit'
glue = require'glue'
time = require'time'
pp   = require'pp'
pr   = require'inspect'

floor       = math.floor
ceil        = math.ceil
min         = math.min
max         = math.max
abs         = math.abs
sqrt        = math.sqrt
ln          = math.log
sin         = math.sin
cos         = math.cos
tan         = math.tan
rad         = math.rad
deg         = math.deg
random      = math.random
randomseed  = math.randomseed
clamp       = glue.clamp
round       = glue.round
snap        = glue.snap
lerp        = glue.lerp
sign        = glue.sign
strict_sign = glue.strict_sign
nextpow2    = glue.nextpow2
repl        = glue.repl

concat      = table.concat
catargs     = glue.catargs
insert      = table.insert
remove      = table.remove
shift       = glue.shift
add         = table.insert
push        = table.insert
pop         = table.remove
del         = table.remove
cat         = table.concat
ins         = table.insert
rem         = table.remove
append      = glue.append
extend      = glue.extend
sort        = table.sort
indexof     = glue.indexof
map         = glue.map
pack        = glue.pack
unpack      = glue.unpack
reverse     = glue.reverse
binsearch   = glue.binsearch
sortedarray = glue.sortedarray

empty       = glue.empty
update      = glue.update
merge       = glue.merge
attr        = glue.attr
count       = glue.count
index       = glue.index
keys        = glue.keys
sortedkeys  = glue.sortedkeys
sortedpairs = glue.sortedpairs

--make these globals because they're usually used with a string literal as arg#1.
format      = string.format
fmt         = string.format
_           = string.format
rep         = string.rep
char        = string.char
esc         = glue.esc
subst       = glue.subst
names       = glue.names

string.starts  = glue.starts
string.ends    = glue.ends
string.trim    = glue.trim
string.pad     = glue.pad
string.lpad    = glue.lpad
string.rpad    = glue.rpad
string.lines   = glue.lines
string.outdent = glue.outdent
string.esc     = glue.esc
string.fromhex = glue.fromhex
string.tohex   = glue.tohex
string.subst   = glue.subst

collect = glue.collect

cocreate    = coroutine.create
cowrap      = coroutine.wrap
resume      = coroutine.resume
yield       = coroutine.yield

noop     = glue.noop
pass     = glue.pass

memoize    = glue.memoize
tuple      = glue.tuple
tuples     = glue.tuples
weaktuples = glue.weaktuples

assertf  = glue.assert

bnot = bit.bnot
shl  = bit.lshift
shr  = bit.rshift
band = bit.band
bor  = bit.bor
xor  = bit.bxor

C       = ffi.C
cast    = ffi.cast
sizeof  = ffi.sizeof
typeof  = ffi.typeof
Windows = false
Linux   = false
OSX     = false
BSD     = false
POSIX   = false
_G[ffi.os] = true
win     = Windows
addr    = glue.addr
ptr     = glue.ptr

module   = glue.module
autoload = glue.autoload

inherit  = glue.inherit
object   = glue.object
before   = glue.before
after    = glue.after
override = glue.override
gettersandsetters = glue.gettersandsetters

trace = function() print(debug.traceback()) end
traceback = debug.traceback

--OS API bindings

date   = os.date
clock  = os.clock
time.install() --replace os.date and os.time.
sleep  = time.sleep
time   = glue.time --replace time module with the uber-time function.
day    = glue.day
sunday = glue.sunday
month  = glue.month
year   = glue.year

canopen     = glue.canopen
readfile    = glue.readfile
writefile   = glue.writefile
replacefile = glue.replacefile
readpipe    = glue.readpipe

fpcall = glue.fpcall
fcall  = glue.fcall

exit = os.exit

freelist = glue.freelist

i8p = glue.i8p
i8a = glue.i8a
u8p = glue.u8p
u8a = glue.u8a

buffer   = glue.buffer
dynarray = glue.dynarray

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

return {with = function(s)
	for _,s in ipairs(names(s)) do
		require('$'..s)
	end
end}
