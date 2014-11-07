import markdown
from mako import filters

def mdown(context,text):
    """
    Convert mdown text to html.
    This is a filter.
    """
    return markdown.markdown(text,\
        extensions=['markdown.extensions.codehilite'])


MATHJAX_DELIMITERS = {r'$$':r'$$',\
                      r'\[':r'\]',\
                      r'\(':r'\)'}

def get_first_delim(text,delims):
    """
    We want to find the first delimiter inside the current text.
    It could be one of a few delimiters (that are in the delims list), so
    we search for all of the beginnig delimiters, and pick the first one
    that we find.
    """
    # Initialize found locations of delimiters:
    locs = []
    for (ds,de) in delims.items():
        loc = text.find(ds)
        # Check if the delimiter ds was found:
        if loc < 0:
            continue

        locs.append((loc,ds))
    
    if len(locs) == 0:
        return None

    # Return the first found delimiter, together with his location.
    return min(locs,key=lambda x:x[0])

def mdown_math_raw_lst(context,text,\
        delims=MATHJAX_DELIMITERS):
    """
    Handle markdown text with mathjax inside.
    We first separate the markdown from the mathjax,
    Then we convert the markdown parts into HTML.

    This function returns a list with all those parts.
    Every element in the list is a tuple. The first element in the tuple is
    either 'text' or 'math'. The second element contains final html text, or
    math html accordingly.

    This function doesn't provide final output, as we still have to stitch
    paragraphs to allow inline math.

    delims is a dictionary of all possible delimiters for math.
    Every element of the list is a tuple. The first element in the tuple is the
    beginning delimiter, and the second element in the tuple is the ending
    delimiter.
    """

    # Initialize result list:
    res_lst = []
    # Remove whitespaces from beginning and ending:
    text = text.strip()

    while len(text) > 0:
        res = get_first_delim(text,delims)
        if res is None:
            # Apply markdown to all the text that is left:
            res_lst.append({'type':'text',\
                            'content':mdown(context,text)})
            # Empty text:
            text = ""
            continue

        # Get the first delimiter and its location:
        loc_start,ds = res

        if loc_start > 0:
            # Add the text until loc_start to the res_lst:
            res_lst.append({'type':'text',\
                        'content':mdown(context,text[:loc_start])})

        # Find the ending delimiter:
        de = delims[ds]
        loc_end = text.find(de,loc_start + len(ds))
        # We expect it to have an ending:
        if loc_end < 0:
            raise ExceptNoClosingDelimiter(ds)

        # Get a chunk of math. (Without the delimiters):
        math_chunk = text[loc_start + len(ds):loc_end]
        # HTML escape the math chunk:
        math_chunk_h = filters.html_escape(math_chunk)
        # Add the math chunk together with the original delimiters to the
        # result list:
        res_lst.append({'type':'math',\
                        'delim':ds,\
                        'content':ds + math_chunk_h + de})

        # Cut text:
        text = text[loc_end + len(de):]

    # Return the accumulated result list:
    return res_lst

def stitch_pars(math_res_lst):
    """
    Stitch paragraphs, so that 
    """
    assert False

def mdown_math(context,text):
    assert False
