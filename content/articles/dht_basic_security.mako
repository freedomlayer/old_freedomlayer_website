<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Basic DHT security concepts",\
    "date": "2014-11-27 10:03",\
    "author": "real",\
    "number":5,\
    "tags": [],\
    "draft":"True",\
    

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

In (TODO: previous article) we talked about the Chord ring structure and about
how to "stabilize" it. By stabilizing we referred to the task of maintaining the
structure, despite the rapid changes the happen in the network. (Nodes joining,
leaving and failing).

We haven't addressed some issues yet though. To some of them we are going to
come back in future articles. This time I want to talk about general ideas of
securing Chord, or even more generally, **securing a DHT**.

<h4>The Adversary</h4>

The first thing we want to do when talking about security is to define the
adversary. Generally speaking, in our case the adversary is some entity that
wants to disrupt the DHT functions. 

By entity we don't just mean one node, or one computer, or even one person. The
Adversary could mean many things. More than something realistic, it is an entity
that helps us think about security. It's like a game. We give the Adversary
certain powers, and see if our model can deal with it. If all of this sounds too
abstract to you, don't worry, we are soon going to see some examples.

Before we move on to checking out some adversaries, We review again the basic
functions of our DHT.  In the lower level of the DHT structure, it means the
ability to search for node \(\floor{v}\) given the value \(v\). In the higher
level (Thinking about a Distributed Hash table), it is the ability to store
pairs of (key,value), or retrieve a correct value given a key.

Our general model of the adversary in the following text will be as follows.
The Adversary manifests itself in the network in the form of "corrupt" nodes.
Those are nodes that are under the full control of the Adversary. We then make
a distinction: For every node in the network, it is either a node controlled by
the Adversary - A "corrupt node", or a "correct" node.  By "correct" we mean
honest, or "not corrupt". It's a node that follows the rules as we defined
them. (From now on we will not add the quotes when referring correct or corrupt
nodes).

Another important thing to note about the two types of nodes is that it is not
possible to tell if a node is a correct node or a corrupt node. Every node
knows if he himself is correct or corrupt, but he can never know for sure if
another node is correct or corrupt.

You could try to ask a node if he is correct, but then, if it's a corrupt node,
he might lie. You could also try to watch a node for a really long time, and
then try to conclude that it is a correct node. However that node might be just
pretending, waiting for you to look away.

Of those reasons, (And several others that will become clearer in the future),
we will never try to directly conclude if a node is correct or corrupt. We just
know that some nodes are corrupt and some are correct. This is the way of life.

Let's talk about what the adversary can do, or at least what we "allow" him to
do in this model. 

<h5>The Sybil Attack</h5>

We begin with an Adversary that can get into the network as many corrupt
nodes as he likes. To make things easy to think about, forget about reliability
issues (Nodes that fail). We will assume that the correct nodes never fail.

Try to think for a moment what could be done with this ability of inserting as
many corrupt nodes as you want into the DHT.

One very philosophical way of thinking about this situation is as follows: Does
the network really belong to us if there are more corrupt nodes than correct
nodes? Could we really enforce our structure on the network if the nodes we
control are in a minority? And if we could, why couldn't the Adversary do
exactly the same? Thinking about it, what makes us and the Adversary so
different?

Going back to our physical world, let's try to see some concrete examples of
things the Adversary can do:

- Disconnecting the DHT: The Adversary could insert many nodes into the network,
  and let them run by the DHT rules. Correct nodes will not be able to
  distinguish between the corrupt nodes and the correct nodes, and they will
  form connection to the corrupt nodes. Then in one sudden moment, the
  Adversary will make all the corrupt nodes halt. That means: All the corrupt
  nodes will stop responding. As the Adversary has many nodes (Much more than
  corrupt nodes), With a pretty high probability, the DHT will become
  disconnected. 

- Blocking or Changing specific keys: Assume that the Adversary doesn't want
  some key to be accessible (It will not be possible to get the value \(v\) for
  a key \(k\)).  To do this, The adversary could insert many nodes into the
  network with random IDs (Remember that every node has some ID). If the
  Adversary has a very big amount of nodes, with some high probability the key
  \(k\) will be under the responsibility of a corrupt node. Then whever that
  key is asked for, the Adversary could return some other value \(v'\) instead
  of \(v\), or just not return anything.

As we mentioned above though (In the philosophical paragraph), if the Adversary
wanted he could make anything out of this network, because really, he owns this
network. He was a majority of "corrupt" nodes.

This kind of attack where an Adversary inserts a large amount of "corrupt" nodes
into a network is also known as Sybil Attack. (TODO: Add link here)
This kind of attack is not specific to DHTs. It is related to any distributed
network where all the nodes have symmetric roles. It is probably the first
attack to consider when you hear about a fully distributed technology.

You might be wondering what could be done about the Sybil Attack. We won't solve
it now, sorry. We need something extra to solve it. I just wanted you to know
about it. At this point we will try to come up with a weaker Adversary.

<h5>Node bounded Adversary</h5>

We have seen that we can't defend outselves at this point from an Adversary that
inserts unlimited amount of nodes into the network. So let's put a limit to the
amount of nodes the Adversary can insert.

Assuming that there are \(n\) nodes in the network, a reasonable bound might be
\(\alpha \cdot n\), where \(0 < \alpha < 0.5\). In other words, the maximal amount
of corrupt nodes is a constant fraction of the total size of the network. Why do
we pick \(\alpha\) smaller than half? That is because (As we noted above) if the
Adversary has more than half the nodes im the network, he pretty much owns the
network.


</%block>
