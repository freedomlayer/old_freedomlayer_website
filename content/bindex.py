from lib import utils

import os
import time
import datetime

## Extensions for mako and HTML:
MAKO_EXT = "mako"
HTML_EXT = "html"

## The name of blogs directory:
BLOGS_DIR = "blog"

## The time format:
TIME_FORMAT = "%Y-%m-%d %H:%M"

def fix_dates(b_entries):
    """
    Parse dates of blog entries
    """
    for be in b_entries:
        raw_date = be["props"]["post_metadata"]["date"]
        tstruct = time.strptime(raw_date,TIME_FORMAT)
        dt = datetime.datetime.fromtimestamp(time.mktime(tstruct))
        be["props"]["post_metadata"]["date"] = dt

    
def sort_by_dates(b_entries):
    """
    Sort the blog entries by date.
    """
    b_entries.sort(key=lambda x:x["props"]["post_metadata"]["date"],reverse=True)


def get_blog_entries(context):
    """
    Get the list of blog entries after fixing the time format and some
    sorting.
    """
    b_entries = utils.inspect_directory(context,BLOGS_DIR,["post_metadata"])
    fix_dates(b_entries)
    sort_by_dates(b_entries)
    return b_entries
