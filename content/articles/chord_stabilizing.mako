<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Ideas about Practical DHT Stabilizing",\
    "date": "2014-11-13 19:41",\
    "author": "real",\
    "number":4,\
    "tags": []}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">
In the [Intro to
DHTs](${self.utils.rel_file_link("articles/dht_intro/responsible_keys.svg")})
article we presented a very basic idea of the chord DHT, and generally how to
search it.

We treated it pretty much as a static network of computers. We did not invest
much time on thinking about what happens when nodes join or leave the network
(Or what happens when nodes fail).

In this article we are going to discuss (Very briefly) some ideas regarding
stabilization of the Chord DHT. In other words: How to make sure our DHT
survives, despite all the frequent changes that happen to the DHT structure -
Of nodes joining and leaving the network, or just failing from time to time.


<h3>The origin of Churn</h3>
Before we get into the details, I want us to have some general picture of what
we are going to deal with, when I'm saying "Stabilize". At this point we are
not going to deal with some malicious powerful adversary that tries to destroy
our DHT (We will meet this adversary later at some point, but not today). You
may assume that all the nodes are inside some laboratory, and we own all of
them.

There are some events that could happen. First of all, there are the usual DHT
events of nodes joining and leaving. How should we handle those joins and
leaves, so that the network keeps its "original structure"? So that it stays
searchable, and even more than that: Stays connected?

Besides joins and leaves, we should also deal with nodes that fail. Why would a
node fail? There could be a few reasons. Maybe the computer broke, or someone
tripped over the LAN cable connecting the node to the rest of the computers. It
might be that power went offline, or someone pushed the restart button. We
don't really know. We just know that the failure was immediate, and the node
had no chance at all to report its failure to the network.

We are going to find at some point that this failed node is dead, but not
immediately. One inherent characteristic of the Internet, and maybe networks
generally, is that **you can not know immediately that a remote node died**.
You will find out about it after some time, eventually.

<h4>Heartbeats</h4>
How would you check if someone is dead on the real world? A good idea might be
to check if he can talk. If someone is talking, he must be alive.

A similar solution can be used over the Internet. To make sure that a remote
node is alive, you just check if he recently sent a message.
Going further with this idea, we can have the following arrangement in our
network: If \(x\) is a node that is linked to \(y\), \(x\) is expecting to get
a message from \(y\) at least as frequent as every 10 seconds. If it doesn't
happen, \(x\) will assume that \(y\) is dead. \(y\) expects the same from
\(x\).

But what if \(y\) doesn't have anything important to say to \(x\), and 10
seconds are soon going to pass? In that case, \(y\) will send some kind of a
dummy message to \(x\). A dummy message that is used to prove that \(y\) is
alive.

This technique is sometimes referred to as *Heartbeat* messages.

Two notes here:

-   For the Transport Protocols savvy people: Some claim that a TCP connection
    would be enough to hold a link. It might be true in some cases, though some
    NATs will be happy to close your TCP connection if some time passes and no
    communication occurs, so sending Heartbeats is generally a good practice
    (At least in my opinion).

-   To see the theoretical incompleteness of this method of understand the
    state of a remote node, I recommend you to read about the [Two Generals'
    Problem](http://en.wikipedia.org/wiki/Two_Generals%27_Problem). (You could also
    just look at the arbitrary "10 seconds" constant, and realize that there is
    nothing very deep here).

<h4>Nodes that leave don't care</h4>
(TODO)



<h3>Stabilizing the ring</h3>
I remind you that the chord network is just a ring of nodes (Each node
connected to the next one), with some extra links. Those extra links make
searches much faster, though they are not really needed for the search
operation to function. So lets forget about them for a moment, and go back to
the basic ring idea.

Now we are left with a very simple ring of nodes, where every node is connected
to the next node.



</%block>
