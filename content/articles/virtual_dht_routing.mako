<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Virtual DHT Routing",\
    "date": "2014-12-02 17:45",\
    "author": "real",\
    "number":7,\
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

TODO: Abstract


We have seen so far a few ways of routing messages in a mesh network: Flooding
(See [The mesh
question](${self.utils.rel_file_link("articles/mesh_question.html")})) and
[sqrt(n) routing](${self.utils.rel_file_link("articles/sqrt_n_routing.html")}).

Flooding was pretty inefficient (However pretty robust and secure). The idea of
\(\sqrt{n}\)-routing was a bit more efficient, though it required that every
node will maintain contact with \(\sqrt{n\log{n}}\) virtual neighbours.

We will consider here a different approach for routing messages in a
decentralized mesh network: Using a DHT.

A similar method apparently has a working implementation in the
[CJDNS](http://en.wikipedia.org/wiki/Cjdns) project. (Also see the
[whitepaper](https://github.com/cjdelisle/cjdns/blob/master/doc/Whitepaper.md))



</%block>
