<%inherit file="/blog_post.makoa"/>

<%def name="post_metadata()">
<%
	return {\
	"title": "Compiling vim with python3 support",\
	"date": "2014-09-05 11:46",\
	"author": "xorpd",\
	"tags": ["meta","vim","tech-struggle"]}
%>
</%def>

<%block name="blog_post_body" filter="self.utils.mdown">

First Get checkinstall. It will allow us to install vim in an ordered fashion.
If we ever want to remove this vim version, we could do it easily. (As opposed
to just doing "make install", and then you are on your own if you want to
remove this program in the future).

	:::bash
	sudo apt-get install checkinstall

We also need mercurial, to be able to download vim's source:

	:::bash
	sudo apt-get install mercurial

Next we get some packages that might be needed for the compilation process:

	:::bash
	sudo apt-get install python-dev python3-dev ruby ruby-dev
	libx11-dev libxt-dev libgtk2.0-dev libncurses5 ncurses-dev

Now get the lateset version of vim:

	:::bash
	hg clone https://vim.googlecode.com/hg/ vim

Next we configure:
(Note that here one should choose if he wants to have python3 support or
python 2 support. Because of some limitations it is not possible to have
both of them.)

<%text>
	:::bash
	./configure \
    --enable-perlinterp \
    --enable-python3interp \
    --enable-rubyinterp \
    --enable-cscope \
    --enable-gui=auto \
    --enable-gtk2-check \
    --enable-gnome-check \
    --with-features=huge \
    --enable-multibyte \
    --with-x \
    --with-compiledby="xorpd" \
    --with-python3-config-dir=/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu \
    --prefix=/opt/vim74
</%text>

Next we compile:

	:::bash
	make

Now it is a good time to test the result. Don't install it yet, because you
might still want to fix some things.

	:::bash
	make test

Even if all the tests passed, make sure that you do have python3 support.
Go to the src folder (./vim/src), and invoke the new vim binary from there.

	:::bash
	./vim
Then invoke inside vim:

	:::vim
	:echo has('python3')

If you get 1, it's all good.

We install the package using:

	:::bash
	sudo checkinstall

Of some strange reason, I have to change the name of the package to 
something which is not "vim". "vim74_compiled" will do, for example. (If I
don't change it, I get an error message from checkinstall).

Finally, we create a shortcut:

	:::bash
	sudo ln -s /opt/vim74/bin/vim /usr/bin/vim

Happy vimming!

More tips regarding this subject could be found here on the following links:
(Much of the information that could be found in this article relies on the
information from those links)

[vim's documentation](http://vimdoc.sourceforge.net/htmldoc/usr_90.html)
<br/>
[Hulk Angry Hulk Smash's blog](http://kowalcj0.wordpress.com/2013/11/19/how-to-compile-and-install-latest-version-of-vim-with-support-for-x11-clipboard-ruby-python-2-3/)
</%block>
