<%inherit file="/blog_post.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "First post",\
    "date": "2014-11-09 21:20",\
    "author": "real",\
    "tags": []}
%>
</%def>

<%block name="blog_post_body" filter="self.filters.math_mdown">

Hi, welcome to the Freedom Layer project website. I also want to welcome you to
the quest for a **scalable, secure and distributed mesh network.**

If you have just arrived here, I'm sorry for all the mess. 
This website is not ready yet.

Right now I'm still working on adding basic level articles to the articles
section,so that I can move on later to the more advanced stuff.

Generally, I intend to put here stuff that I research on the subject of mesh
networks. Stay tuned.
</%block>
