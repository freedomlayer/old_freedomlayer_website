import markdown
from mako import filters

class ExceptFilters(Exception):
    pass

class ExceptNoClosingDelimiter(ExceptFilters):
    pass


def _mdown(text):
    """
    Convert mdown text to html.
    This is a filter.
    """
    return markdown.markdown(text,\
        extensions=['markdown.extensions.codehilite(linenums=True)'])

def mdown(context,text):
    """
    Exported version of mdown.
    """
    return _mdown(text)


# All math delimiters:
MATH_DELIMS = {r'$$':r'$$',\
               r'\[':r'\]',\
               r'\(':r'\)'}

def get_first_delim(text,delims):
    """
    We want to find the first delimiter inside the current text.
    It could be one of a few delimiters (that are in the delims list), so
    we search for all of the beginning delimiters, and pick the first one
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

def math_raw_lst(text,delims=MATH_DELIMS):
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
    chunks = []
    # Remove whitespaces from beginning and ending:
    text = text.strip()

    while len(text) > 0:
        res = get_first_delim(text,delims)
        if res is None:
            # Append all the left text:
            chunks.append({'type':'text',\
                           'content':text})
            # Empty text:
            text = ""
            continue

        # Get the first delimiter and its location:
        loc_start,ds = res

        # Add the text until loc_start to the res_lst:
        # Note that if there is not such text, we add an empty chunk.
        # This is intentional.
        chunks.append({'type':'text',\
                       'content':text[:loc_start]})

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
        chunks.append({'type':'math',\
                       'delim':ds,\
                       'content':ds + math_chunk_h + de})

        # Cut text:
        text = text[loc_end + len(de):]

    # Return the accumulated result list:
    return chunks

def combine_math_mdown(chunks):
    """
    combine the math and markdown together.
    """
    # We use a very unlikely string to mark the position
    # of math chunks:
    UNLIKELY_STR = "21db701d30f81f68ef55208b47c183ac"
    # It's a very serious hack, however at the same time combining all those
    # stuff together is probably something that was not meant to be.
    # Sorry about that.

    res_chunks = []
    math_chunks = []
    for i,c in enumerate(chunks):
        if c['type'] == 'text':
            res_chunks.append(c['content'])
        else:
            res_chunks.append(UNLIKELY_STR)
            math_chunks.append(c['content'])

    mdown_res = _mdown("".join(res_chunks))
    for mc in math_chunks:
        # Replace one occurence of the unlikely string with the content
        # of the current math chunk:
        mdown_res = mdown_res.replace(UNLIKELY_STR,mc,1)
        
    return mdown_res

def math_mdown(context,text):
    """
    Filter markdown and math together, and render them into HTML.

    Separates the math parts from the markdown parts. Then the markdown
    renderer is only applied to the markdown parts, and the math renderer is
    applied to the math parts.

    Finally everything is stitched together nicely.
    """
    chunks = math_raw_lst(text)
    return combine_math_mdown(chunks)

def math_html(context,text):
    """
    Filter html that contains math into HTML.

    Separates the math parts from the HTML parts. Renders the math parts, and
    then combines everything.
    """
    res_lst = []
    chunks = math_raw_lst(text)

    # Combine the contents of all chunks together:
    for c in chunks:
        res_lst.append(c['content'])
    return "".join(res_lst)
