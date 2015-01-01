<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "Mesh Roadmap and unsolved Questions",\
    "date": "2015-1-1 14:12",\
    "author": "real",\
    "number":11,\
    "tags": [],\
    "draft":"False",\
    "description": "Current roadmap for the creation of a secure distributed mesh network"}
%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">
<!--
abs function.
-->
\(
\newcommand{\paren}[1]{\left({#1}\right)}
\)


<h4>Unsolved Questions</h4>

<h5>The Routing Question</h5>

To have a working mesh network, we have to be able to route messages. Even if
we consider only friendly environments (There are no adversaries and all nodes
are correct), **At this point we don't know of any routing algorithm that
scales well**. We have some ideas, but we don't know to prove that they scale.

The two most promising ideas I currently know of to route messages in a large
decentralized networks are:

-   [Virtual DHT
    Routing](${self.utils.rel_file_link("articles/virtual_dht_routing.html")})

-   [Landmarks Navigation](${self.utils.rel_file_link("articles/landmarks_navigation_rw.html")

For Landmarks Navigation we only showed a very naive routing method (Random
walking), and currently we don't know of a better algorithm to use the Network
Coordinates information for navigation. I think there should be a better way to
route messages using Network Coordinates. It requires some more thinking.

The Virtual DHT Routing idea seems to have nice results, be we never checked it
for networks of size larger than \(2^{15}\). Lacking any rigorous ideas of how
it works, we don't know for sure what is going to happen for large networks.

Checking the results, I found that the paths we get from nodes to their best
finger candidates are not always the shortest. It might be possible to change
the algorithm so that those paths are always as short as possible. I have some
ideas about how to do it, but I still have to check them.

<h5>Incentives and Security</h5>

A working routing mechanism is very nice to have, but it is not enough. In
practice, the network nodes will not cooperate if they don't have the right
incentives to do so. In addition, Adversaries will want to DoS the network or
subvert it somehow.

We put into some more detail a list of our main requirements:


- Nodes in the mesh will have incentives to pass messages to their destination.

- Sybil attack resilience: A computationally / networkly bounded adversary will
  not be able to insert too many corrupt nodes into the network.

- DoS will be expensive to perform.

- Leaf nodes (Nodes that are in the "edge" of the network. For example: Nodes
  that are connected to only one other node) will be able to participate, and
  their messages will be passed.


<h4>Current Plan</h4>

I list here some of our current efforts. If you have an idea or a suggestion,
please share it at the mailing list, or send me a message directly.


<h5>Ideas regarding Routing</h5>

We already know of a simple Virtual DHT Routing algorithm. I want to
improve/change it, to get the following properties:

- The path between a node \(x\) and his best candidates for fingers are the
  shortest paths possible. This is an important property if we plan to use this
  routing algorithm for very large networks.

- The Network will always stay connected after every iteration of updating the
  finger candidates. Note that the current simple solution doesn't promise that
  property.

<h5>Ideas regarding Incentives and Security</h5>

I discuss here Incentives and Security ideas for the Virtual DHT Routing
method.

Here are the security issues we need to deal with:

- Sybil attack. What happens if some Adversary inserts lots of corrupt nodes
  into the network? How can we make sure it doesn't happen?

- Eclipse attack. An adversary could cause much damage even using only one
  corrupt node. A corrupt node could claim to have many DHT identities, and
  then block a whole region of the DHT namespace. The corrupt node will turn into
  a "messages magnet", taking a large portion of the network messages.

Some issues regarding incentives:

- A message from \(x\) to \(y\) in the network passes through other nodes. Why
  would those nodes want to pass the message? They need to be compensated
  somehow, in terms of some currency or reputation.

- In a mesh network, the value that a node contributes is mostly his ability to
  bridge and forward messages. However, what about a node that is in the "edge"
  of the network? It is not much a bridge. It can't contribute much in terms of
  bandwidth or communication. If we just rely on communication as network
  contribution, these kind of nodes will never be able to participate in the
  network. One way to solve it might be to introduce other types of possibilities
  to contribute.


</%block>
