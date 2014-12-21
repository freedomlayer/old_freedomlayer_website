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

<h4></h4>


</%block>
