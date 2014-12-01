<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Sqrt(n) mesh navigation",\
    "date": "2014-11-27 10:03",\
    "author": "real",\
    "number":5,\
    "tags": [],\
    "draft":"True",\
    "description":""}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">
<!--
ceil and floor latex macros:
-->
\(
\newcommand{\ceil}[1]{\left\lceil{#1}\right\rceil}
\newcommand{\floor}[1]{\left\lfloor{#1}\right\rfloor}
  
\)

<h4>Abstract</h4>

(TODO: fill in)

Assume that we have a set of \(n\) nodes. Each node is directly connected to
some other nodes (About \(log(n)\) direct connections). For a node \(x\), we
call every other node \(y\) that is directly connected to \(x\) a **neighbour**.

Given two nodes \(a\) and \(b\) in the network, we want to be able to route a
message from \(a\) to \(b\). As \(a\) and \(b\) are possibly not neighbours, we
might need to transfer the message through some intermediate nodes until it
finally reaches its destination, \(b\).

In [The mesh question
article](${self.utils.rel_file_link("articles/mesh_question.html")}) we already
discussed the
[flooding](http://en.wikipedia.org/wiki/Flooding_%28computer_networking%29)
solution. We have seen that it works, but it is not very efficient.






</%block>
