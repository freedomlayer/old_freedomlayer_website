from lib import utils

import os
import time
import datetime

## Extensions for mako and HTML:
MAKO_EXT = "mako"
HTML_EXT = "html"

## The time format:
TIME_FORMAT = "%Y-%m-%d %H:%M"

def fix_dates(entries):
    """
    Fix dates inside entries
    """
    for e in entries:
        raw_date = e["props"]["post_metadata"]["date"]
        tstruct = time.strptime(raw_date,TIME_FORMAT)
        dt = datetime.datetime.fromtimestamp(time.mktime(tstruct))
        e["props"]["post_metadata"]["date"] = dt


def sort_entries_by(entries,field,reverse=False):
    """
    Sort all the entries by a field field.
    """
    entries.sort(key=lambda x:x["props"]["post_metadata"][field],\
            reverse=reverse)


def get_entries(context,dir_name,sort_field=None,reverse=False):
    """
    Get the list of entries (From dir dir_name) after fixing the time format
    and some sorting.
    """
    entries = utils.inspect_directory(context,dir_name,["post_metadata"])
    fix_dates(entries)
    if sort_field is not None:
        sort_entries_by(entries,sort_field,reverse)
    return entries

