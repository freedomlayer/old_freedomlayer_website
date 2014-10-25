# Static Weber
---------------

A static website generator for developers.
Written in Python, and uses the Mako templating library extensively.

## Motivation

I used other python based website generators before, but I felt the lack of
control. I wanted to be able to have the power of a website generator engine,
but still be able to add my own python code, or my custom HTML and CSS wherever
I want. 

I wanted a static website generator for programmers, but it was hard
for me to find one. So I created Static Weber.

## General Info

To use this you will have to know a bit about Mako and Python, and also a bit
about HTML and CSS (Just a bit), though it will give you much more power
flexibility than the usual static website generators out there.

Features:
- Basic Blog
- Syntax Highlighting with Pygments. (You should supply your own highlight css)
- Markdown blocks
- Python scripting
- Mako templating. Specifically, you get page inheritance, which is great.

## Show me an example of an output website:

I wrote my website: http://www.xorpd.net with this template.
In fact, this template was invented for my website.

I know some people are not going to use a website generator if it can not
generate a "beauuutifuuul" website, so here you have your example :)

## Building a website in 1 minute

First clone this repository.

Next you will need to install mako and markdown:
(I recommend to do it in virtualenv if you have one.)

	pip install mako
	pip install markdown

Now to build the website, run:

	python3 website_tool.py build

Then you have the compiled website in the output folder.
To view it, just click on index.html

To deploy, usually you will invoke:
	
	python3 website_tool.py deploy "commit_message"

Currently it works with github pages. You could change it to do something else.

## Required reading

To really understand what is going on here, you should read a bit of Mako
documentation (It's not so long), and know some python. I also assume that you
know some HTML and CSS.

The Mako documentation could be found here:
http://docs.makotemplates.org/en/latest/


## How does it work?

website_tool.py is just a wrapper for make_website.py, which builds the
website. I will explain here briefly how make_website.py builds the website. We
will call it the builder from now on.

The builder will go over all the files inside the content folder, and it
will create the output directory tree according to the contents directory
tree. It distinguishes between a few types of files:

- Files that will just be copied to the output folder, in the exact relative
  location. Those are pictures, css files etc. No transform is applied for
  these files.

- .mako files. Those files will be rendered as Mako templates. The html result
  will be saved in the output folder.

- .makoa files. (Mako Abstract) Those are "Abstract" Mako templates. They will
  not be rendered by the builder. Those files are useful for inheritance and
  similar things.

- .makon files. (Mako No output) Those files will be rendered as Mako templates
  by the engine, however their output will not be saved in the output directory
  tree. Those files could be useful if you want to create some special file
  using a python script.

## Included files and folders

- lib directory contains utility functions and the general inspectable.mako mako
  template, which all pages inherit from. If you just want to build your
  website, you shouldn't touch this directory.

- blog directory contains all the blog posts. They all inherit from the
  blog_post.makoa Mako template.

- page.makoa - This is the base page template. It inherits from inspectable,
  and all your pages will inherit from page.makoa. If you want to put anything
  like google analytics, page.makoa is the place.

- blog_index.mako and bindex.makoa both build the blog index. You can edit
  blog_index.mako to coustomize the way it looks like, but generally you
  shouldn't touch bindex.makoa, which is the engine to get the blog posts list.

- blog_post.makoa: Inherit from page.makoa. blog_post.makoa is the base
  template for all blog posts inside the blog directory.

- code_highligt.css is the code highlighting css. You can change it with
  another one. There are some nice ones you could find with a simple google
  search.

- page_style.css is the main css for page.mako. It will apply to all your
  pages.

- web_page.makoa inherits from page.makoa. Some pages inherit from 
  web_page.makoa, instead of inheriting from page.makoa directly.

- pics directory contains an example picture. You could add any other pictures
  as you wish, or even create other directories with other names.

- pages directory: Contains various pages. They inherit from web_page.makoa.


## Important utils functions

Should be documented. 

Utils file is pretty short. For now just read it and try
to understand what is going on in there.

