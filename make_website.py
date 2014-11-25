"""
Sun Oct 12 11:38:18 IDT 2014
by xorpd.

A script for auto generating the xorpd's website.
"""

from mako.template import Template
from mako.lookup import TemplateLookup

import os
import shutil

import lib.utils


# The content's directory name:
CONTENT_DIR = "content"
# The output's directory name:
OUTPUT_DIR = "output"


class ExceptStaticWeber(Exception):
    pass

class ExceptInvalidExtension(ExceptStaticWeber):
    pass

def change_extension(filename,new_ext):
    """
    Change the extension of a file to be new_ext
    """
    last_dot = filename.rfind(".")
    return filename[:last_dot] + "." + new_ext

def get_extension(filename):
    """
    Get the extension of a file (What comes right after the last dot).
    """
    return filename.split(".")[-1]

def clean_empty_dirs(root_dir,ignore_prefixes=["."]):
    """
    Check the directory tree for any empty directories, or directories that
    contain only empty directories (etc.)
    Then delete any such directories.

    Do not delete inside any directories which begin with one of the
    ignore_prefixes.
    """
    # We don't get into directories which begin with
    # one of the ignore prefixes:
    for iprefix in ignore_prefixes:
        if os.path.basename(root_dir).startswith(iprefix):
            return

    files = os.listdir(root_dir)

    for f in files:
        new_root = os.path.join(root_dir,f)
        if os.path.isdir(new_root): 
            clean_empty_dirs(new_root)

    # After some deleting, we get again the list of contents.
    # Note that this will not be the same list from the first time.
    files = os.listdir(root_dir)
    if len(files) == 0:
        # If there are no files inside the directory, remove it and exit:
        os.rmdir(root_dir)


class Website():
    def __init__(self,path):
        # Load the path of the website:
        self.website_path = path

    def build_website(self):

        # Build the path of the content folder:
        content_path = os.path.join(self.website_path,CONTENT_DIR)

        # Build the path of the output folder:
        output_path = os.path.join(self.website_path,OUTPUT_DIR)

        # Directory lookup.
        # This way include or inherit directive from any of the mako templates
        # doesn't have to specify the full path.
        wlookup = TemplateLookup(directories=[content_path])

        # Remove output directory if it exists:
        # try:
        #     shutil.rmtree(output_path)
        # except FileNotFoundError:
        #     pass


        # Iterate over all files inside the content directory, to find MAKO
        # templates to render:
        for root,dirs,files in os.walk(content_path):

            # Copy to the equivalent at the output directory:
            rel_root = os.path.relpath(root,content_path)
            # Get equivalent path inside output directory:
            root_output = os.path.join(output_path,rel_root)
            # Create equivalent folder if necessary:
            if not os.path.exists(root_output):
                os.makedirs(root_output)


            for fl in files:
                # Get full path inside content directory:
                fl_path = os.path.join(root,fl)
                fl_ext = lib.utils.get_extension(fl)

                props = lib.utils.get_ext_props(fl_ext)


                if props.should_render:
                    # Build a template:
                    fl_tmp = Template(filename=fl_path,lookup=wlookup)
                    # Get the filename as target_ext extensioned file:
                    fl_with_ext = lib.utils.change_extension(fl,props.target_ext)
                    fl_with_ext_output = os.path.join(root_output,fl_with_ext)

                    # Render the template:
                    res_render = fl_tmp.render(my_filename=fl,\
                                    my_content_dir=content_path,\
                                    my_output_dir=output_path,\
                                    my_rel_dir=rel_root)

                    if props.render_output:
                        # Write the template's rendering result to a file at
                        # the output directory tree:
                        with open(fl_with_ext_output,"w") as fw:
                            fw.write(res_render)
                        continue

                if props.should_copy:
                    # We copy the file to the destination folder:
                    # Get equivalent path inside output directory:
                    fl_output = os.path.join(root_output,fl)
                    # Copy to output directory:
                    shutil.copyfile(fl_path,fl_output)
                    # Continue to the next file:
                    continue

        # Clean any empty directories inside output:
        clean_empty_dirs(output_path,ignore_prefixes=["."])


def go():
    wb = Website(".")
    wb.build_website()


if __name__ == "__main__":
    go()
