<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "Inventing Time inside the Mesh Network",\
    "date": "2014-12-23 19:19",\
    "author": "real",\
    "number":10,\
    "tags": [],\
    "draft":"True",\
    "description": "")}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">
<!--
abs function.
-->
\(
\newcommand{\abs}[1]{\left|{#1}\right|}
\newcommand{\paren}[1]{\left({#1}\right)}
\)

<h4>Abstract</h4>

TODO: Add abstract


<h4>Motivation</h4>

In [Landmarks Navigation by Random
Walking](${self.utils.rel_file_link("articles/landmarks_navigation_rw.html")})
we introduced a method for assigning Networ Coordinates to every node in a mesh
network. The coordinates are calculated as distances to a known set of nodes,
called **landmarks**. We believe that the knowledge of Network Coordinates
might allow efficient routing of messages in the network.

We want to be calculate 



To make sure that a path from a node \(x\) to a landmark
\(l_j\) is not faked or blocked by an adversary, the node \(x\) periodically
sends a challenge to \(l_j\) along a shortest path to \(l_j\). \(l_j\) then
replies with a proof of identity


</%block>
