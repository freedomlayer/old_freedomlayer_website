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

Let's talk about what the adversary can do, or at least what we "allow" him to
do in this model. 

<h5>The Sybil Attack</h5>

We begin with an Adversary that can get into the network as many nodes as he
likes. We then make a distinction: For every node in the DHT, it is either a
node controlled by the Adversary - A "corrupt node", or a "correct" node. 
By "correct" we mean honest, or "not corrupt". It's a node that follows the
rules as we defined them.

In this model, the "correct" nodes run our DHT code. The "corrupt" nodes are
fully controlled by the adversary, and he tells them what to do. They don't have
to comply to the DHT rules. The Adversary can use corrupt nodes (The nodes under
his control) to send data to any other nodes in the system. One important thing
to remember here is that the corrupt nodes work together (Under the leadership
of the Adversary).

TODO: CONTINUE HERE.

It's a really simplistic model. We don't think about different parties colluding
together

Try to think for a moment what could be done with this ability of inserting as
many nodes as you want into the DHT.

One way to look at the effects



</%block>
