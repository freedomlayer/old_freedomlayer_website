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

Given a mesh network, we want to be able to send a message between two
arbitrary nodes. We can look at this question from another perspective: How can
a message inside the network navigate itself to a given destination?

<h5>The Global Positioning System</h5>
As human beings, the modern way of navigating oneself around the surface of the
planet is using the [Global Positioning
System](http://en.wikipedia.org/wiki/Global_Positioning_System), also known as
GPS. It works pretty well, and one might wonder why not apply it to messages
that travel inside mesh networks.

Given that every node in the network knows it's own GPS coordinates, routing a
message to a destination GPS coordinate is still not a trivial question. A
[greedy algorithm](http://en.wikipedia.org/wiki/Greedy_algorithm) 
(Always transfer the message to node with closest GPS coordinates) will not
always work correctly. This algorithm might get stuck on some node \(y'\) that
is closer than all his neighbours to the destination GPS coordinates, but still
\(y'\) will not be the destination node. This is a case of a greedy algorithm
getting stuck on a local maximum, instead of finding the global maximum.

(TODO: Add a picture of the failure of the greedy algorithm. Local maximum
which is not the global maximum).

Even if we do manage to find a navigation algorithm that works well with the
GPS coordinates, we still have some weak points to overcome:

- Having a GPS receiver on a node might require extra hardware setup and cost.

- Being dependent on GPS coordinates for message routing means being dependent
  on a system of satellites on the sky. (If someone can take those satellites
  down, he can take down our mesh network).

- GPS coordinates might not be so accurate, so we might have to complement the
  GPS navigation with some other routing algorithm whenever the message gets
  close enough to the destination.

- The loss of Anonymity: If a node's address is his GPS coordinates, it is easy to find his
  location geographically. (There might be a way around this though).

There is one more weak point which is more about the routing
itself: The GPS system encapsulates a good understanding of physical
location on the Earth surface, but generally it will not have a "good
understanding" of the mesh network layout. In other words: Two network nodes
that are connected by a direct link might be very distant geographically.
This will be less of a problem in mesh networks where every node is connected to
geographically close nodes, however such mesh networks will have very high
latency. 


Finally, Work done by Jon Kleinberg, ["The Small-World Phenomenon: An
Algorithmic Perspective"](http://www.cs.cornell.edu/home/kleinber/swn.pdf),
hints that the GPS method will work efficiently only when the network links are
configured in a specific way.


(TODO: Add an example for failure of the greedy algorithm to find the shortest
path (Draw a map). Explain relation to Kleinberg small world model).





</%block>
