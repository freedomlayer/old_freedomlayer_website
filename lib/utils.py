"""
Utils file for static_weber.
"""

import os
import json

from mako.template import Template
from mako.lookup import TemplateLookup


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


def _get_extension(filename):
    """
    Get the extension of a file (What comes right after the last dot).
    """
    return filename.split(".")[-1]


def _change_extension(filename,new_ext):
    """
    Change the extension of a file to be new_ext
    """
    last_dot = filename.rfind(".")
    return filename[:last_dot] + "." + new_ext


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
            if not _get_extension(fl) == MAKO_EXT:
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
            fl_rel_html = _change_extension(fl_rel,HTML_EXT)
            entry["link_addr"] = os.path.join(dir_name,fl_rel_html)
            entry["props"] = {}
            for prop in props:
                entry["props"][prop] = inspect_temp(context,fl_path,prop)
            res_entries.append(entry)

    return res_entries

