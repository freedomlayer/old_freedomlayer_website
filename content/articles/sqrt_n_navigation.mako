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

Assume that we have a set of \(n\) correct nodes (No adversary). Each
node is directly connected to some other nodes (About \(log(n)\) direct
connections). For a node \(x\), we call every other node \(y\) that is directly
connected to \(x\) an immediate **neighbour** (We will sometimes write only
"neighbour").

Given two arbitrary nodes \(a\) and \(b\) in the network, we want to be able to
route a message from \(a\) to \(b\). As \(a\) and \(b\) are possibly not
neighbours, we might need to transfer the message through some intermediate
nodes until it finally reaches its destination, \(b\).

In [The mesh question
article](${self.utils.rel_file_link("articles/mesh_question.html")}) we already
discussed the
[flooding](http://en.wikipedia.org/wiki/Flooding_%28computer_networking%29)
solution. We have seen that it works, but it is not very efficient: Every
message sent in the network has to pass through all the nodes in the network.


<h4>Virtual Neighbours</h4>

We noted above that in our network, every node \(x\) has a small set of
immediate neighbours. We can extend this idea of neighbours by keeping contact
with farer nodes that are not necessarily immediate neighbours.

We say that a **path** is a consecutive set of connected nodes.
If a node \(x\) knows a path to some other node \(y\), \(x\) could send
messages to \(y\) through that path, assuming that all the nodes on that path
cooperate.

(TODO: Add a picture of a path between \(x\) and \(y\)).

It might be very likely that \(y\) will want to send a message back to \(x\).
(After all, they are having a conversation). In that case, \(y\) will need to
know some path to send the message back to \(x\). It could be exactly the same
path from \(x\) to \(y\) (But reversed), or some other path.

\(x\) and \(y\) will maintain contact by sending periodic
[heartbeats](http://en.wikipedia.org/wiki/Heartbeat_%28computing%29) to each
other, making sure that the remote side is alive. In that case we will say that
\(x\) and \(y\) are **virtual neighbours**. (\(x\) is a virtual neighbour of
\(y\), and vice versa).

The longer the path between \(x\) and \(y\), the harder it becomes for them to
stay in contact. That is because the link between \(x\) and \(y\) relies on all
the nodes on the path used between \(x\) and \(y\).

<h4>A Common Virtual Neighbour</h4>

Let's assume that every node in the network has some virtual neighbours.

In addition, let's imagine that somehow, every two nodes \(a\) and \(b\) in the
network have a virtual neighbour \(z\) in common. In that case we can route
messages between any two nodes \(a\) and \(b\) in that network:

Assume that we are at node \(a\), and we want to send a message to node \(b\).
We first send a message to each of \(a\)'s virtual neighbours, asking them if
they know \(b\) (As their virtual neighbour). One of \(a\)'s virtual
neighbours, \(z\), should have \(b\) as a virtual neighbour. Then we could send
a message to \(z\), and \(z\) will forward that message to \(b\).

(TODO: Show a picture of \(z\) being a virtual neighbour both of \(a\) and
\(b\))

To make this solution valid, we have to make sure somehow that every two nodes
in the network have a virtual neighbour in common.

<h4>Using Random Virtual Neighbours</h4>

One simple approach would be to try randomize a set of virtual neighbours for
every node on the network, and hope for the best. We should still decide how
many virtual nodes every node is going to have, and how to randomize them.

Assume for a while that we do have a method of choosing a random virtual
neighbour. Given that ability, all that is left is to choose how many random
virtual neighbours every node will have. Knowing about the [birthday paradox](
http://en.wikipedia.org/wiki/Birthday_problem), we can assume that we are going
to need at least \(\sqrt{n}\) virtual neighbours per node.

Assume that every node has a set of \(r\) virtual neighbours. Let \(a\) be some
node in the network, and we want to send a message from \(a\) to \(b\). What
are the odds of finding a path to \(b\) using the random virtual
neighbours?

\(a\) will ask each of his virtual neighbours if they know \(b\). \(a\) has
\(r\) virtual neighbours, and each of those neighbours knows about \(r\)
virtual neighbours. The probability that some specific virtual neighbour of
\(a\) doesn't know about \(b\) is:

\[1 - \frac{r}{n}\]

Thus the probability that all of \(a\)'s virtual neighbours don't know \(b\)
is: 

\[p = (1 - \frac{r}{n})^r \leq e^{\frac{-r^2}{n}}\]

We want to get a value for \(p\) that is very close to \(0\), and becomes
smaller as \(n\) increases.
Choosing \(r=\sqrt{n}\) will give us a constant bound over \(p\), which is not
what we want. We should increase \(r\) a bit. We could pick \(r=\sqrt{n
\log{n}}\). In that case we get that \(p \leq e^{\frac{-r^2}{n}} = e^{-\log{n}}
= \frac{1}{n}\), which is what we wanted.

We conclude that to be able to send a message from any node to any other node
in the network, it is enough to make sure that every node in the network
maintains \(r = \sqrt{n \log{n}}\) randomly chosen virtual neighbours.

<h4>Randomizing Virtual Neighbours</h4>











</%block>
