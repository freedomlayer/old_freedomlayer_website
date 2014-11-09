from lib import utils

import os
import time
import datetime

## Extensions for mako and HTML:
MAKO_EXT = "mako"
HTML_EXT = "html"

## The name of articles directory:
ARTICLES_DIR = "articles"

## The time format:
TIME_FORMAT = "%Y-%m-%d %H:%M"

def fix_dates(a_entries):
    """
    Parse dates of article entries
    """
    for be in a_entries:
        raw_date = be["props"]["post_metadata"]["date"]
        tstruct = time.strptime(raw_date,TIME_FORMAT)
        dt = datetime.datetime.fromtimestamp(time.mktime(tstruct))
        be["props"]["post_metadata"]["date"] = dt

    
def sort_by_numbers(a_entries):
    """
    Sort the article entries by date.
    """
    a_entries.sort(key=lambda x:x["props"]["post_metadata"]["number"])


def get_articles(context):
    """
    Get the list of blog entries after fixing the time format and some
    sorting.
    """
    a_entries = utils.inspect_directory(context,ARTICLES_DIR,["post_metadata"])
    fix_dates(a_entries)
    sort_by_numbers(a_entries)
    return a_entries
