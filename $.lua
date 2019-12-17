
--seriously, there's no reason for all that qualifying of everything.

io.stdout:setvbuf'no'
io.stderr:setvbuf'no'

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
