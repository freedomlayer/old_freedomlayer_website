"""
Sun Oct 12 11:38:18 IDT 2014
by xorpd.

A script for auto generating the xorpd's website.
"""

from mako.template import Template
from mako.lookup import TemplateLookup

import os
import shutil

# The content's directory name:
CONTENT_DIR = "content"
# The output's directory name:
OUTPUT_DIR = "output"

# Mako template file extension:
MAKO_EXT = "mako"
# Mako template without output:
MAKO_NO_EXT = "makon"
# HTML file extension:
HTML_EXT = "html"

# Extensions of files we copy to the output tree:
COPY_EXTS = ["html","png","gif","jpg","svg","css"]

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

def clean_empty_dirs(root_dir):
    """
    Check the directory tree for any empty directories, or directories that
    contain only empty directories (etc.)
    Then delete any such directories.
    """
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
                fl_ext = get_extension(fl)

                # If it's a mako's template, we render it and store the
                # resulting HTML file inside the output tree:
                if fl_ext in [MAKO_EXT,MAKO_NO_EXT]:
                    # Build a template:
                    fl_tmp = Template(filename=fl_path,lookup=wlookup)
                    # Get the filename as html extensioned file:
                    fl_html = change_extension(fl,HTML_EXT)
                    fl_html_output = os.path.join(root_output,fl_html)

                    # Render the template:
                    res_render = fl_tmp.render(my_filename=fl,\
                                    my_content_dir=content_path,\
                                    my_output_dir=output_path,\
                                    my_rel_dir=rel_root)

                    # We don't create output for MAKO_NO_EXT files.
                    if fl_ext == MAKO_EXT:
                        # Write the template's rendering result to an html file at
                        # the output directory tree:
                        with open(fl_html_output,"w") as fw:
                            fw.write(res_render)
                        continue

                # Check if we should copy this file to the output directory:
                if fl_ext in COPY_EXTS:
                    # Get equivalent path inside output directory:
                    fl_output = os.path.join(root_output,fl)
                    # Copy to output directory:
                    shutil.copyfile(fl_path,fl_output)
                    # Continue to the next file:
                    continue

        # Clean any empty directories inside output:
        # clean_empty_dirs(output_path)


def go():
    wb = Website(".")
    wb.build_website()


if __name__ == "__main__":
    go()
