<%inherit file="/entries_page.makoa"/>

<%!
    entries_dir = "blog"
    sort_field = "date"
    reverse = True
%>

<%block name="entries_page_header">
<title>FreedomLayer | Blog</title>
</%block>


<%block name="entries_page_body_begin">
<h1>Blog</h1>
<a href="${self.utils.rel_file_link("blog_feed.rss")}">
<img src="${self.utils.rel_file_link("pics/feed_icon_small.png")}"/> Subscribe</a><br/><br/>
</%block>

<%block name="entries_page_body_end">
</%block>
