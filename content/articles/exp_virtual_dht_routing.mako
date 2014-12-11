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
decentralized mesh network: Using a "Virtual DHT". This idea is based on the
articles [Virtual Ring Routing: Network Routing Inspired by
DHTs](http://research.microsoft.com/pubs/75325/virtualring.pdf) and [Pushing
Chord into the Underlay: Scalable Routing for Hybrid
MANETs](http://os.ibds.kit.edu/downloads/publ_2006_fuhrmann-ua_pushing-chord.pdf).
This method is sometimes also called [Scalable Source
Routing](http://en.wikipedia.org/wiki/Scalable_Source_Routing).

A similar method apparently has a working implementation in the
[CJDNS](http://en.wikipedia.org/wiki/Cjdns) project. (Also see the
[whitepaper](https://github.com/cjdelisle/cjdns/blob/master/doc/Whitepaper.md))
I didn't manage to figure out from CJDNS whitepaper the specific details of the
implementation, though it seems like it uses the Kademlia DHT. We are going to
use Chord in this text.

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
specific node (or key) quickly (In about \(\log{n}\) iterations). If we
managed somehow to create a DHT between the nodes in the mesh network, we might
be able to find any wanted node quickly, and also pass messages quickly between
nodes.

<h4>Why can't we just use a regular DHT?</h4>

Why is this case different from our previous discussion about DHTs?  We already
know how DHTs work, why can't we just use a regular DHT to be able to navigate
messages in a network?

The answer is that creating a working DHT depends on our ability to send
messages "by address". In other words, to have a working DHT, we need to rely
on some structure like the internet. Thus trying to build something like the
internet using a DHT is kind of cyclic, when you think about it.

Let me explain it in detail. Let's recall how a DHT works. Whenever a node
\(x\) wants to join the DHT, \(x\) contacts some node \(y\) that is already
part of the DHT. \(y\) then finds the node closest to \(x\) (By DHT Identity
distance) inside the DHT. Let's call that node \(z\). \(y\) then sends to \(x\)
the address of \(z\). Finally, \(x\) can connect to \(z\) and join the DHT.

This would work if we have a structure like the internet to support the idea of
address. However, if we are working in a simple mesh, how could \(y\) connect
\(x\) to \(z\)? We don't yet have any notion of address, so it is a hard task
for \(y\) to introduce \(z\) to \(x\).

The act of "introducing nodes to other nodes" is something that happens a lot
in a DHT. In particular, it happens whenever a node wants to join the network,
and also every time that a node performs the stabilize operation. 

(TODO: Add a picture that describes the initial setup of a DHT)

One naive method to introduce nodes in a mesh is using paths. Assume that \(y\)
wants to introduce \(z\) to the node \(x\). \(y\) knows a path \(path(y,z)\)
from \(y\) to \(z\), and also a path \(path(y,x)\) from \(y\) to \(x\). \(y\)
can use those two paths to construct a path \(path(x,y) + path(y,z)\) from \(x\) to \(z\).

\(y\) can send \(path(x,y) + path(y,z)\) to \(x\). Then whenever \(x\) wants to send a
message to \(z\), \(x\) will use the path \(path(x,y) + path(y,z)\).

(TODO: Picture of the concatenated path)

This method sounds like a solution, but it has a major flaw: The path
\(path(x,y) + path(y,z)\) that we get from \(x\) to \(z\) is not optimal. It is
not the shortest path possible. What if \(x\) wants to introduce \(z\) to some
other node \(w\)? If we keep using the naive paths methods, \(w\) will end up
with a path \(path(w,x) + path(x,y) + path(y,z)\) from \(w\) to \(z\), which
could be pretty long.

After a while in the DHT, we might get to a situation where the paths become
too long to handle. In the next sections we will try to think of a solution.

<h4>Setup</h4>

To use a DHT we need DHT Identities for all the participants. For the rest of
this text we will use the Chord DHT, and we will choose a random Identities from
\(B_s = \{0,1,2,\dots,2^{s} - 1\}\), where \(s\) is large enough. (In practice
we could choose the Identities in [some other
way](${self.utils.rel_file_link("articles/dht_basic_security")}), but let's
assume for now they are just random)

Between every two nodes \(x,y\) (We use the notation \(x\) to denote both the
Identity value and the node itself) we will define two notions of distance
(Which are unrelated):

- The Network Distance: The length of the shortest path between the nodes
  \(x,y\) in the network.

- The Virtual Distance: The value \(d(x,y) = (y - x) % 2^{s}\). This is the
  distance we when we described the Chord DHT.

(TODO: Add pictures for the Network distance and Virtual Distance)
(Draw both a ring and the mesh graph on the same picture)

Note that two nodes could have very short Network Distance though very long
Virtual Distance, and vice versa. It is crucial to understand that the Network
Distance and the Virtual Distance are unrelated.

<h4>Converging the ring</h4>

To maintain a Chord DHT, every node should at least know about its successor
with respect to the DHT Identity. (This will form the basic Chord ring).
We will begin by finding out some way in which every node will find a mesh path
to his successor and predecessor with respect to the DHT Identity. (Somewhat
surprisingly, finding just the successor is harder than finding both the
successor and predecessor at the same time).

Finding the immediate successor and predecessor for every node \(z\) will allow
us to send a message (In a very inefficient way) between every two nodes
\(x\),\(y\). Assume that \(x\) wants to send a message to \(y\). \(x\) knows a
path to his DHT successor, \(x_1\). \(x\) will send the message to \(x_1\), and
ask \(x_1\) to pass the message to \(y\). \(x_1\), in turn, will send the
message through a known path to his successor on the ring, \(x_2\), and so on,
until the message will arrive at \(y\).

Why is this inefficient? First, only from the DHT (Virtual) perspective, the
message will go through about half the nodes in the DHT. Next, when looking at
the mesh, we find that passing the message from some node \(t\) to his
successor goes through even more nodes in the mesh. How many nodes? It depends
on our mesh. If it's a random graph, the distance between two random nodes
could be something like \(\log{n}\). If it's more like a grid (This might
happen if you deploy wifi antennas on some large surface), then the average
path might be longer.
It seems like our message will go through more than \(n\) nodes, which is too
much. Flooding could probably perform better.

But it is still a start. Maybe sending messages will be very inefficient, but
we still get a way to find a path from one node to another. As a conclusion,
our first task is finding the successor and predecessor (With respect to the
DHT) for every node \(x\) in the network.






</%block>
