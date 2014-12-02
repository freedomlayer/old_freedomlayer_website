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
decentralized mesh network: Using a "Virtual DHT".

A similar method apparently has a working implementation in the
[CJDNS](http://en.wikipedia.org/wiki/Cjdns) project. (Also see the
[whitepaper](https://github.com/cjdelisle/cjdns/blob/master/doc/Whitepaper.md))


<h4>The message routing problem</h4>

Assume that we have \(n\) correct (honest) nodes (We will not consider any
Adversary at the moment), connected somehow in a mesh. Every node is linked to
a few other nodes. We call these nodes his immediate neighbours.  
Nodes in the mesh have only local knowledge. They only know about their
immediate neighbours. They don't know about the general structure of the mesh
network.

For any two nodes \(a,b\) in the network, we want to be able to send a message
from \(a\) to \(b\). We care that this message will arrive with high
probability, quickly enough, and also that it won't disturb too many nodes in
the network.

<h4>Motivation for using a DHT</h4>

Recall that a [DHT](${self.utils.rel_file_link("articles/dht_intro.html")}) is
a special structure of links between nodes. This structure allows to find a
specific node (or key) quickly (In about \(\log{n}\) iterations).  If we
managed somehow to create a DHT between the nodes in the mesh network, we might
be able to find any wanted node quickly, and also pass messages quickly between
nodes.

<h4>Setup</h4>


</%block>
