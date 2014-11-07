<%inherit file="/blog_post.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Very basic GDB commands",\
    "date": "2014-09-05 11:20",\
    "author": "xorpd",\
    "tags": ["meta","tech-struggle","gdb"]}
%>
</%def>

<%block name="blog_post_body" filter="self.filters.mdown">

GDB is a very powerful debugger that comes with most linux distrubutions. You
will want to study it for a while if you are going to write assembly code on
the linux platform.

It takes some time to study the first GDB commands, however don't be
intimidated by the black console. Invest the time to study the basic commands.
It really worth it.

If you are just starting out with gdb, the following basic commands might be
useful for you.

## Getting some information:
Getting information about the entry point (And some more): 
This is very useful if you want to put a breakpoint in the beginning of the
program:

	:::bash
	info files

Viewing the registers:

	:::bash
	info registers
Or for specific register:

	:::bash
	info registers regname

If you want to view the disassembly of the current location, you may use the
following command to get a cool assembly window:

	:::bash
	layout asm

It happens to me sometimes that the view is messed up after some stepping
around the code. If that happens to you, you could use the 

	:::bash
	refresh
command to refresh the view.

Another way to view the current instruction (And a few more following
instructions) is to use:

	:::bash
	x/10i $pc

This one will show the next 10 instructions from the current program counter.
Pretty useful.

## Breakpoints:
Setting a breakpoint:

	:::bash
	break *0x800000

View list of breakpoints:

	:::bash
	info breakpoints

Deleting a breakpoint:

	:::bash
	delete (breakpoint_number)
or the shortcut:

	:::bash
	d (breakpoint number)

## Controlling debugee:
Running:

	:::bash
	run

Continuing the program:

	:::bash
	continue

Stepping into: (This one will get into functions)

	:::bash
	stepi
	si

Stepping over: (This one will skip functions)

	:::bash
	nexti
	ni

</%block>
