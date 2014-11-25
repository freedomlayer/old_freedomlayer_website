"""
Utils file for static_weber.
"""

import os
import json

from mako.template import Template
from mako.lookup import TemplateLookup

import collections

# Mako template file extension:
MAKO_EXT = "mako"
# Mako template without output:
MAKO_NO_EXT = "makon"
# Mako abstract template (Not rendered):
MAKO_ABSTRACT_EXT = "makoa"
# HTML file extension:
HTML_EXT = "html"

# Extensions of files we copy to the output tree:
COPY_EXTS = ["html","png","gif","jpg","svg","css"]


def get_extension(filename):
    """
    Get the extension of a file (What comes right after the last dot).
    """
    return filename.split(".")[-1]


def change_extension(filename,new_ext):
    """
    Change the extension of a file to be new_ext
    """
    last_dot = filename.rfind(".")
    return filename[:last_dot] + "." + new_ext

def get_ext_props(fl_ext):
    """
    Get the relevant properties for a given extension.
    Generally, extension will be one of the following:
    .mako           -- Rendered into HTML.
    .makoa          -- Not rendered.
    .makon          -- Rendered but output is discarded.
    .mako_XXX       -- Rendered into file of extension XXX with the same name.
    .jpg,.png,...   -- Copied directly to destination.
    """

    props = \
        collections.namedtuple('props',\
            ['should_render','should_copy','target_ext','output_expected'])

    # Set defaults:
    props.should_render = False
    props.should_copy = False
    props.target_ext = None
    props.render_output = False

    if "_" in fl_ext:
        ext_parts = fl_ext.split("_")
        if len(ext_parts) > 2:
            # There are too many parts:
            raise ExceptInvalidExtension(fl_path)
        if ext_parts[0] != MAKO_EXT:
            # Strange first part:
            raise ExceptInvalidExtension(fl_path)

        props.should_render = True
        props.should_copy = False
        props.target_ext = ext_parts[1]
        props.render_output = True

    elif fl_ext == MAKO_EXT:
        props.should_render = True
        props.should_copy = False
        props.target_ext = HTML_EXT
        props.render_output = True

    elif fl_ext == MAKO_NO_EXT:
        props.should_render = True
        props.should_copy = False
        props.target_ext = None
        props.render_output = False

    elif fl_ext == MAKO_ABSTRACT_EXT:
        props.should_render = False
        props.should_copy = False
        props.target_ext = None
        props.render_output = False

    elif fl_ext in COPY_EXTS:
        props.should_render = False
        props.should_copy = True
        props.target_ext = fl_ext
        props.render_output = True

    # Sanity checks:
    assert not (props.should_copy and props.should_render)
    assert not ((props.target_ext is None) and props.render_output)

    return props

def get_my_dest_path(context):
    """
    Get the destination path of the current file (The asking file).
    The resulting path will be relative the output/ dir.
    """
    fl = context["my_filename"]
    fl_ext = get_extension(fl)
    props = get_ext_props(fl_ext)

    # If there isn't going to be any output,
    # we return None.
    if props.target_ext is None:
        return None

    # Build new filename with new extension:
    target_fl = change_extension(fl,props.target_ext)

    # Join the relative directory and the target file name:
    target_rel_path = os.path.join(context["my_rel_dir"],target_fl)

    return os.path.normpath(target_rel_path)


def rel_file_link(context,file_path):
    """
    Create a relative link to a file.
    file_path is the relative path of the file, with respect to the content
    directory.
    """
    cur_path = os.path.join(context['my_output_dir'],context['my_rel_dir'])
    file_path = os.path.join(context['my_output_dir'],file_path)
    href_addr = os.path.relpath(file_path,cur_path)
    return os.path.normpath(href_addr)

def inspect_temp(context,file_path,key):
    """
    Inspect a template to get some metadata.
    Basically it runs self.${key}() at the template side and returns
    the result.
    """
    # Render the template with inspect=True to get the blog entry's
    # metadata.
    fl_tmp = Template(filename=file_path,lookup=context.lookup)
    res_inspect = fl_tmp.render(inspect=key)
    metadata = json.loads(res_inspect)

    return metadata

def inspect_directory(context,dir_name,props):
    """
    Get metadata from all files inside a directory.
    """
    MAKO_EXT = "mako"
    HTML_EXT = "html"

    res_entries = []

    dir_path = os.path.join(context['my_content_dir'],\
            context['my_rel_dir'],dir_name)

    # Iterate over all files inside the blog:
    for root,dirs,files in os.walk(dir_path):
        for fl in files:
            if not get_extension(fl) == MAKO_EXT:
                # We only care about files with mako extension.
                continue

            # Path of file:
            fl_path = os.path.join(root,fl)
            # Absolute path:
            fl_abs = os.path.abspath(fl_path)
            # Get relative path of file inside the dir_name directory tree:
            fl_rel = os.path.relpath(fl_path,dir_path)

            # Add to list:
            entry = {}
            fl_rel_html = change_extension(fl_rel,HTML_EXT)
            entry["link_addr"] = os.path.join(dir_name,fl_rel_html)
            entry["props"] = {}
            for prop in props:
                entry["props"][prop] = inspect_temp(context,fl_path,prop)
            res_entries.append(entry)

    return res_entries

