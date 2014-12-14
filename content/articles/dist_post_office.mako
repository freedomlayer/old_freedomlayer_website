<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "The Distributed Post Office",\
    "date": "2014-12-14 15:51",\
    "author": "real",\
    "number":8,\
    "tags": [],\
    "draft":"True",\
    "description":""}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">

<h4>Abstract</h4>

(TODO: Add abstract)

What if there there were no post offices in the world, and you wanted to send a
package to some far friend?

Assume that you meet some people you trust on a regular basis. More generally,
assume that every person in the world meets a few people he trusts on a regular
basis. For the feasibility of things, let's also add in the assumption that
this system is connected. This means: If we draw a graph of all the people in
the world (As nodes), and edges as people they trust and meet on a regular
basis, then we get a connected graph.

(TODO: Add a picture of a connected graph)

Would these assumptions be enough to let us send a message to anyone in the
world?


</%block>
