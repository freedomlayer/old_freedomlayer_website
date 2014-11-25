<%inherit file="/entries_page.makoa"/>

<%!
    entries_dir = "articles"
    sort_field = "number"
    reverse = False
%>

<%block name="entries_page_header">
<title>FreedomLayer | Articles</title>
</%block>


<%block name="entries_page_body_begin">
<h1>Articles</h1>
<a href="${self.utils.rel_file_link("articles_feed.rss")}">
<img src="${self.utils.rel_file_link("pics/feed_icon_small.png")}"/> Subscribe</a><br/><br/>
</%block>

<%block name="entries_page_body_end">
</%block>
