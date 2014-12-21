<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "Landmarks Navigation by random walking",\
    "date": "2014-12-18 15:51",\
    "author": "real",\
    "number":9,\
    "tags": [],\
    "draft":"True",\
    "description":""}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">

<h4>Abstract</h4>

TODO: Add abstract

<h4>Motivation</h4>

(TODO: Fix links here:)

Given a mesh network, we want to be able to send a message between two
arbitrary nodes. We have already presented several possible solutions:
[flooding](http://en.wikipedia.org/wiki/Flooding_%28computer_networking%29),
\(\sqrt{n} mesh routing\), Virtual DHT routing and the Distributed Post office.

We can look at this question from another perspective: How can
a message inside the network navigate itself to a given destination?

<h5>The Global Positioning System</h5>
As human beings, the modern way of navigating oneself around the surface of the
planet is using the [Global Positioning
System](http://en.wikipedia.org/wiki/Global_Positioning_System), also known as
GPS. It works pretty well, and one might wonder why not apply it to messages
that travel inside mesh networks.

Some objections to use GPS to route messages in a mesh network might be as
follows:

- Having a GPS receiver on a node might require extra hardware setup and cost.

- Being dependent on GPS coordinates for message routing means being dependent
  on a system of satellites on the sky. (If someone can take those satellites
  down, he can take down our mesh network).

- GPS coordinates might not be so accurate, so we might have to complement the
  GPS navigation with some other routing algorithm whenever the message gets
  close enough to the destination.

- The loss of Anonymity: If a node's address is his GPS coordinates, it is easy
  to find his location geographically. (There might be a way around this
though).

But even ignoring all the objections mentioned above, there is still one more
thing to consider. Navigating using GPS coordinates inside a mesh network has
an inherent theoretical flaw.

While the GPS system encapsulates a "good understanding" of physical location on
the Earth surface, generally it will not have a "good understanding" of the
mesh network layout. Put in other words: **Two network nodes that are connected
by a direct network link might be very distant geographically**, and thus have
very different GPS coordinates.

Work done by Jon Kleinberg, ["The Small-World Phenomenon: An
Algorithmic Perspective"](http://www.cs.cornell.edu/home/kleinber/swn.pdf),
puts this idea into a more formal argument. Kleinberg's work hints that
navigation in a mesh using GPS coordinates can work efficiently only when the
network links are configured in a specific way. (If a link between every
two nodes \(x,y\) exists with probability proportional to the inverse square
geographical distance between \(x\) and \(y\)).

In simpler words, routing algorithms that rely on GPS coordinates will not make
good use of long links between distant nodes, unless those links show up in some
specific probability. (Don't let this make you skip the Small-World paper though :) )

We don't know if this specific configuration happens in real mesh networks, but
it seems to be very specific, so we will assume that generally it doesn't
happen for the rest of this text.

(TODO: Add a picture example for failure of the greedy algorithm to find the shortest
path (Draw a map). Explain relation to Kleinberg small world model).

Despite the flaws in GPS based routing, there is still something very
attractive about it. Routing a message in a mesh network is hard because every
node has only local knowledge of the network, which doesn't give much
information about the network's structure as a whole. 
GPS gives us some approximation (although very incomplete) about
where we are in the network: It gives us some kind of "global information",
something that could not be trivially achieved in a distributed mesh network.

We might be able to reproduce the effect we get from GPS using some other
means. We begin by understanding how GPS works. 

<h5>How Positioning Systems work?</h5>

Described very roughly, the GPS system is based on a set of human made statellites
around earth. The satellites where positioned in a way that makes sure in every
time and place on earth, one can receive signal from a few of them. In order to
find out where you are on earth, you should receive signal from a few
satellites and find out how far you are from those satellites. Using the
obtained set of distances (And some information about current time and course
of those satellites), you can calculate where you are.

(TODO: Add a picture of the satellites system?)

The navigators of old used [Celestial
Navigation](http://en.wikipedia.org/wiki/Celestial_navigation) to find their
way using the stars. They looked at the stars and concluded information about
their location or direction. (Instead of measuring distance and time, they used
angular measurements).

We might be able to make our own system of "satellites" or "stars" inside our
network, to allow messages find their way in the network.

<h4>The Network Coordinates</h4>

<h5>The Landmarks</h5>

(TODO: Fix link here:)

In the end of [The Distributed Post Office] article we mentioned the idea of
Landmarks. Given a network of \(n\) nodes, we choose a set of \(k\) nodes to be
landmarks: \(\{l_1,l_2,\dots,l_k\}\). (Those are just regular nodes that were
given the "Landmark" title.) Every node \(x\) in the network remembers
a shortest path to each of the landmarks.

Let's assume that every node in the network has generated a keypair of [public
key and private key](http://en.wikipedia.org/wiki/Public-key_cryptography). We
also assume that every node in the network knows a list of all the landmarks'
public keys. Every node that is a landmark would be able to prove it, by proving
that he owns his public key.

We currently do not discuss the method used to choose the set of landmarks.
Instead we will assume that it was chosen randomly somehow ahead of time. This
will be discussed in the future. (We showed one method to do this in "The
Distributed Post Office": Choosing the nodes that maximize the value of some
cryptographic hash functions)

We also do not discuss the value we pick for \(k\). Currently you may assume
that we pick \(k\) to be of some
[polylogarithmic](http://en.wikipedia.org/wiki/Polylogarithmic_function) size
with respect to \(n\).

<h5>Maintaining contact with the Landmarks</h5>

We begin by describing how each node \(x\) in the network obtains a shortest
path to each of the landmarks: This is done by a few iterations where every
node in the network exchanges information with his immediate neighbours.

Find Shortest Paths (for node \(x\)):

- Every few seconds:
    - Send to all immediate neighbours the shortest path known to landmark
      \(l_j) for each \(1 \leq j \leq k\).

- On receival of a set of paths:
    - Update shortest paths to \(l_j\) for each \(1 \leq j \leq k\) accordingly.


As shown in [The Distributed Post Office], this algorithm will calculate
shortest paths from every node \(x\) to all the landmarks in at most \(d\)
iterations, where \(d\) is the
[diameter](http://en.wikipedia.org/wiki/Distance_%28graph_theory%29) of the
network. Note that we don't need to know the exact value of \(d\), because the
"Find Shortest Paths" algorithm keeps running as long as a node is in the
network.

Next, Every node \(x\) should verify periodically that his paths to the
landmarks are alive. Here is one way to do it: \(x\) will periodically send a
message to each of the landmarks that asks them to prove their identity (The
message will be sent along the shortest path known to \(x\)). In return, the
landmarks will respond with a proof that they are alive.

(TODO: Add a picture for periodic verification for the landmarks. In the picture
\(x\) should have paths to each of the landmarks. The picture will \(x\) sending
a message to one of the landmarks, asking him to prove his identity).

This method works, but it puts a lot of load on the landmarks. From the point of
view of one landmark \(l_j\), \(l_j\) has to send proofs to all the nodes in the
network every period of time. Forget about this problem for a while. We will show how
to resolve it in the future.

(TODO: Add a picture of \(l_j\) having to send proofs to all the node in the
network).


We get that at all times, every node \(x\) has a verified shortest path to each
of the landmarks in the network. \(x\) can calculate his network distance from
each of the landmarks (It's the length of the shortest path to those landmarks).
We denote the list of distances of \(x\) from each of the landmarks by

\[(c_x^1,\dots,c_x^k) := (dist(x,l_1),\dots,dist(x,l_k))\] 

and we call it **\(x\)'s network coordinate**.

(TODO: Add a picture that explains network coordinate).

<h5>Properties of the Network Coordinates</h5>

By our construction we get a network coordinate for every node in the network.
We note here a few properties of the network coordinates.

<h6>Coordinates of landmarks</h6>

The landmark \(l_j\) will have a coordinate of the form:

\[(dist(l_j,l_1),\dots,dist(l_{j-1},l_j),0,dist(l_{j+1},l_j),\dots,dist(l_j,l_k)\]

That is because \(dist(l_j,l_j) = 0\) (The network distance of \(l_j\) from himself is
0\). 

In addition, note that if a node \(x\) has some \(0\) coordinate, than \(x\) must be a
landmark. (If the \(i\)'s coordinate is \(0\), then this is the \(i\)'s
landmark.)

<h6>Continuity</h6>

For every two immediate neighbours \(x\) and \(y\) in the network, we get that
\(\left|c_x^j - c_y^j\right| \leq 1\) for every \(1 \leq j \leq k\). (Whenever
we move to an adjacent node in the network, we change every entry in the network
coordinate by at most 1)

We can prove this [by
contradiction](http://en.wikipedia.org/wiki/Proof_by_contradiction). Assume
(Without loss of generality) that for some \(j\) we get that \(c_x^j - c_y^j
\geq 2\). This means that \(dist(x,l_j) \geq 2 + dist(y,l_j)\): The shortest
path between \(x\) and \(l_j\) is two hops longer than the shortest path between
\(y\) and \(l_j\). But \(x\) and \(y\) are neighbours, so \(x\) could instead
use the following path to \(l_j\): First move to \(y\), and then continue using
the shortest path from \(y\) to \(l_j\), which is of length \(dist(y,l_j)\). As
a result we get a path from \(x\) to \(l_j\) which is of total length
\(dist(y,l_j) + 1\), \(1\) hop shorter than the path we assumed is the shortest
from \(x\) to \(l_j\). This is a contradiction.

(TODO: Add a picture of \(x,y\) and the shortest paths to \(l_j\). Try to show
the contradiction in the picture).

Therefore we conclude that for every two immediate neighbours \(x,y\) in the
network, \(\left|c_x^j - c_y^j\right| \leq 1\). We call this property **the
continuity of network coordinates.**

<h6>The triangle inequalities</h6>

The function \(dist(x,y)\) calculates the length of a shortest path between two
nodes \(x,y\) in the network. It satisfies a few properties for every \(x,y,z\)
nodes in the network:

- \(dist(x,y) \geq 0\) (Non negativity)
- \(dist(x,y) = 0\) if and only if \(x=y\).
- \(dist(x,y) = dist(y,x)\). (Symmetry)
- \(dist(x,z) \leq dist(x,y) + dist(y,z)\) (The Triangle inequality).

Make sure that you understand why the first three are correct.

We now show why the fourth one: The Triangle inequality, is correct.
The length of the shortest path between \(x\) and \(y\) is \(d(x,y)\). The
length of the shortest path between \(y\) and \(z\) is \(d(y,z)\). We can always
concatenate those two paths to obtain a path between \(x\) and \(z\) that is of
length \(d(x,y) + d(y,z)\). Therefore the shortest path between \(x\) and \(z\)
is at most of length \(d(x,y) + d(y,z)\).

The four properties of \(dist\) mentioned above could be summarized by saying
that \(dist\) is a
[metric](http://en.wikipedia.org/wiki/Metric_%28mathematics%29).


We use \(dist\)'s properties to conclude some inequalities about the network
coordinates.



TODO: Continue writing here:




\[\left|c_x^i - c_x^j\right| \leq dist(l_i,l_j) \leq c_x^i + c_x^j\]




<h6>The Uniqueness question</h6>









</%block>
