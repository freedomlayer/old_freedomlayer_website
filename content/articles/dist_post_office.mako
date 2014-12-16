<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "The Distributed Post Office",\
    "date": "2014-12-14 15:51",\
    "author": "real",\
    "number":8,\
    "tags": [],\
    "draft":"True",\
    "description":""}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">

<h4>Abstract</h4>

(TODO: Add abstract)

<h4>The distributed post office question</h4>

What if there there were no post offices in the world, and you wanted to send a
package to some far friend?

Assume that you meet some people you trust on a regular basis. More generally,
assume that every person \(x\) in the world meets a few people he trusts on a
regular basis. We also call those trusted regulars of \(x\) the **neighbours**
of \(x\). If \(y\) is a neighbour of \(x\), we also say that \(x\) is a
neighbour of \(y\). The neighbours relationships could be used to transfer
packages. 

For the feasibility of things, let's also add in the assumption that
this system is connected. This means: We can get from any person to any other
person using a sequence of neighbours. Or, in other words: If we draw a graph
of all the people in the world (As nodes), and put edges between every person
and his neighbours, then we get a connected graph.

(TODO: Add a picture of a connected graph)

Would these assumptions be enough to let us send a message to anyone in the
world?

A few initial thoughts:

- Person \(a\) can send a package to person \(B\) only if there is a "path" of
  neighbours between \(a\) and \(b\). That means: \(a\) has some neighbour
  \(a_1\), and \(a_1\) has some neighbour \(a_2\) and so on, until finally some
  \(a_k\) has \(b\) as a neighbour.

- The lack of any centralized post office might create the urge to create one.
  This artificial post office might be some person that everyone knows.
  However, picking such a person that is agreed upon all the participants might
  be difficult task.

- What kind of addressing are we going to use for sending packages, if there is
  no central post office? (What are we going to write on the package on the
  "TO" field?) And what if the network layout changes? Will the address remain
  valid?

<h4>Basic Distributed Post office</h4>

<h5>Finding the highest person</h5>

One way to solve this is finding some special person. This person will be used
as a reference point for sending messages. All our messages will pass through
this person. This centralized point of view is a bit different from our usual
decentralized point of view, but it will present some idea that we
might later be able to utilize in a decentralized way, so bear with me here.

Finding a special person could be acheived as follows: Every person \(x\) will
maintain a link (Maybe through a few neighbours) to the highest person he knows
of (We assume that there are no two people of the exact same height). By
maintaining a link we mean that \(x\) will remember some person \(y\), his
height and a path from \(x\) to \(y\) that goes through neighbours.

Initially, every person \(x\) will look at his neighbours (And himself), and
find the highest person among them. Then \(x\) will inform all his neighbours
of the highest person he knows (He will also send his path to that person).
Next, \(x\) will look at all the highest known people he received from his
neighbours. He will update his highest known person accordingly.

The algorithm could be described simply as follows: In every iteration,
every person \(x\) sends to all his neighbours the highest person \(y\) that he
knows, and also the shortest path he knows from \(x\) to \(y\). (Iteration
could happen every few seconds, for example).

After enough iterations, we expect that every person \(x\) will find the
highest person in the world \(t\). In addition, \(x\) will know a shortest path
possible from \(x\) to \(t\).


Let's explain this result: Why do we expect that the highest person \(t\) will
always be found by all people, and also that a shortest path will be found?

Assume that \(x\) is some person, and \(t\) is the highest person in the world.
There is some shortest path of neighbours between \(x\) and \(t\) (However
\(x\) doesn't know that path yet). Let's assume that this path of neighbours
have the people: \((x,x_1,x_2,\dots,x_{k-1},x_k,t)\) in this order. 

(TODO: Add a picture of the shortest path between \(x\) and \(t\))

After the first iteration, \(x_k\) will have \(t\) as the highest person in the
world. \(x_k\) will also have a shortest path to \(t\). In the next iteration,
\(x_{k-1}\) will know \(t\) as the highest person in the world (Because \(x_k\)
has told him about it). \(x_{k-1}\) will also know a shortest path to \(t\):
The path: \((x_{k-1},x_{k},t)\). What if this is not the shortest path? Then
there must be some path of length two, as follows: \(x_{k-1},t\). In that case,
there is also a shorter path between \(x\) and \(t\):
\((x,x_1,x_2,\dots,x_{k-1},t)\). But this will contradict our assumption that
\(x,x_1,x_2,\dots,x_{k-1},x_k\) is a shortest path between \(x\) and \(t\).

We can continue this argument until we get to \(x\). (The formal way to do it
is using mathematical induction). Then we conclude that after \(k+1\)
iterations, \(x\) will have \(t\) as the highest person in the world, and \(x\)
will also have a shortest path from \(x\) to \(t\).

Another way to think about it is that the amount of iterations needed until
every person finds the highest person in the world is not more than the
[diameter](http://en.wikipedia.org/wiki/Distance_%28graph_theory%29) of the
neighbours graph.

We don't really deal with security here, but I want to mention this question:
Whenever a person sends to all his neighbours the highest person he knows, how
can we know he doesn't lie? We will deal with this later.

<h5>Addressing and Drift</h5>

So far we got some special person \(t\) that every person can reach: Every
person \(x\) knows a path to \(t\), and thus \(x\) can send a package to \(t\).

How could \(x\) send a message to some arbitrary person \(y\)? \(x\) already
knows the path from \(x\) to \(t\). If \(x\) knew a path from \(t\) to \(y\),
he could first deliver his package to \(t\), and then ask \(t\) to send his
package to \(y\).


This idea leads us to choose the address of an arbitrary node \(y\) as a
shortest path between \(t\) and \(y\). (This is the reversed path between \(y\)
and \(t\)). We will mark this as the address of \(y\), or **\(A(y)\)**. 

Given \(A(y)\), \(x\) can send a package to \(y\) by sending the package first
to \(t\), with the address \(A(y)\) written on the package. \(t\) will then use
the path \(A(y)\) to deliver the message all the way to \(y\).

We ignore the centrality issues of this idea for a moment (\(y\) has to deal
with all the packages sent in the world!!!), and try to think about the
addressing idea.

\(y\)'s address is induced from the structure of the network of neighbours.
Certain changes could invalidate \(y\)'s address. In other words: There is a
drift in the addresses, as the network of neighbours changes.

One way to deal with this issue is to **refresh** the addresses from time to
time: If \(x\) is in contact with \(y\), then \(y\) will send his current
address to \(x\) every few seconds. \(x\) will also send his current address to
\(y\) every few seconds. This might not be very reliable, but it's an idea.


<h4>Changing people into nodes</h4>

Formally we solved the problem of delivering packages, however the solution is
not very satisfying. All the packages has to go through some special person.
This is not good for us because of security reasons (Could we trust the special
person), and also because of load balancing issues (Just because he is the
tallest person in the world, he has to deal with all the packages?)

Before we start proposing more ideas, it is probably a good time to change our
terminology to networks and nodes. We get the following question: Assume that
we are given a mesh network, where every node has a few neighbours. How can we
deliver messages between every two arbitrary nodes?

Instead of checking the height of people, we can use some other properties of
nodes. We will use some [public key
cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography). 
Every node \(y\) will create a key pair \(prv_x,pub_x\) (Private and Public).
We assume that every node \(x\) knows the public keys of all his neighbours.

Next, we choose some [cryptographic hash
function](http://en.wikipedia.org/wiki/Cryptographic_hash_function) \(h\).
Instead of person \(x\)'s height, we will take a look at \(h(pub_x)\). We will
call this value \(x\)'s height.  The highest person in the world will turn into
the node \(t\) that maximizes the value \(h(pub_t)\). In that case we will also
say that \(t\) is the "highest" node in the network with respect to the
cryptographic hash function \(h\).

While it was difficult to verify the height of a person from a
distance, we could verify the public key of a node from a distance.
If node \(x\) is informed by node \(y\) about some remote node \(t\) that has a
certain \(h(pub_t)\) value, \(x\) can verify it himself. \(x\) can send some
challenge all the way to \(t\), and \(t\) will send back a response that proves
he owns the public key \(pub_t\). 

(TODO: Add a picture about remote verification).

Note however that this challenge response idea is not a magic cure to all the
security problems in this model. It just helps a bit.


<h4>Adding hierarchy</h4>

<h5>Highest node in some radius</h5>
One approach to make things better is to create some kind of hierarchy. Earlier,
every node \(x\) maintained contact to the "highest" node in the network (with
respect to some cryptographic hash function \(h\)) through some path of nodes. 

This time, instead of remembering just the "highest" node in the network, every
node \(x\) will remember a few special nodes. Every node will be the "highest"
in some certain area around \(x\):

- \(t_x^1\): The "highest" node of maximum distance \(1\).
- \(t_x^2\): The "highest" node of maximum distance \(2\).
- \(t_x^3\): The "highest" node of maximum distance \(3\).

...

- \(t_x^d\) The "highest" node in the network.

(TODO: Add a picture of the circles around \(x\) and highest nodes in those
circles).

Side question: How can we know \(d\)? One suggestion is to keep increasing the
distance until we stop getting new highest nodes. Another suggestion would be
to just assume that the graph diameter won't be more than some constant number.


First let's assume that somehow we managed to have the above information for
every node in the network, and see what we can do with it. (Note that we didn't
yet describe how to get this information. It will be described soon later). 

We define \(x\)'s address to be \(A(x) = (p_x^1,p_x^2,\dots,p_x^d)\), where
\(p_x^j\) is the path from \(t_x^j\) to \(x\). This definition of \(A(x)\) is
an extension of our previous definition of \(A(x)\), where we only had the
\(t_x^d = t\). Also note that looking at some \(p_x^j\), one can conclude
\(t_x^j\) (It is just the first node on the path).

Looking at two different nodes: \(x,y\), the first thing to note is that
\(t_x^d\) and \(t_y^d\) are the same, assuming that \(d\) is large enough. Why?
Because \(t_x^d = t_y^d = t\), the highest node in the network. For other
distances, the nodes \(x\) and \(y\) have chosen might differ. For example,
\(t_x^1\) and \(t_y^1\) are likely to be different.

How to deliver messages using the address information? Assume that \(x\) has
the address of \(y\): \(A(y)\), as described above. \(x\) will compare his own
address: \(A(x)\) with \(A(y)\). \(x\) will try to find the smallest \(j\) such
that \(t_x^j = t_y^j\). \(x\) knows a shortest path from \(x\) to \(t_x^j\).
\(x\) also knows \(A(y)\), So \(x\) knows \(p_y^j\), which is a shortest
path from \(t_y^j = t_x^j\) to \(y\). Finally, \(x\) can create a full path
from \(x\) to \(y\) that goes through \(t_y^j = t_x^j\). This path could be
used to send messages.

(TODO: Add picture of sending a message from \(x\) to \(y\) using the
intermediate \(t_y^j = t_x^j\)).

Addresses should not be too large if we want them to be practical to use. Let's
estimate the size of a typical address, as defined above. For some node \(x\),
\(x\)'s address is \((p_x^1,p_x^2,\dots,p_x^d)\). Every such \(p_x^j\) is a
path. Assuming that the diameter of the network graph is \(d\), we get that
each path is of length no more than \(d\). Therefore we get at most \(d^{2}
q\), where \(q\) is the size of a typical public key. This could become more
than a few kilobytes if the public key size and the network diameter are big.
(Much more than an IP address, unfortunately).


<h5>Obtaining "highest" nodes</h5>

We now explain how a node \(x\) can obtain contact to the nodes
\(t_x^1,\dots,t_x^d\). (And also a shortest path to each of those nodes).

In every iteration, the node \(x\) will ask every neighbour \(y\) for the value
\(t_y^j\) for every \(1 \leq j \leq d\). Then \(x\) will update his values of
\(t_x^j\) accordingly: 
The value \(t_y^j\) from \(y\) is a candidate for \(t_x^{j+1}\). If \(t_y^j\)
is "higher" than \(t_x^{j+1}\), then \(x\) will replace it with \(t_y^j\).

Simply speaking: In iteration number \(k\), a node \(x\) is aware of all the
"highest" nodes in the network until distance \(k\).

Formally, Using mathematical induction (Over the amount of iterations) it can
be shown that after \(k\) network iterations, Every node \(x\) knows the
correct value for \(t_x^j\) for every \(1 \leq j \leq k\), and also a shortest
path to \(t_x^j\).

<h5>Hierarchy benefits?</h5>

Why would we want to have hierarchy from the first place? Earlier we complained
that all the messages will go through one special node \(t\), and \(t\) won't
be able to deal with the load. Maybe the hierarchy we have added can help a
bit.

How often will a message go through the "highest" node \(t\)? 

Assume that \(x\) wants to send a message to some node \(y\). \(x\) checks
\(y\)'s address, and tries to find the first \(j\) such that \(t_x^j =
t_y^j\). (As described above). If any small enough such \(j\) is found, the
message will be routed through \(t_x^j = t_y^j\), and not through the "highest"
node \(t\). We can think of \(t\), the "highest" node, as some kind of backup.
If nothing better was found, we can always route through \(t\).

But how do we know if \(x\) will route his message to \(y\) through \(t\), or
through some lower level node \(t_x^j = t_y^j\)? Generally speaking, we expect
that the more \(x\) and \(y\) are close, the more their addresses \(A(x),A(y)\)
are similar, and the more likely it is to route the message using a "high" node
that is not the "highest" node in the network.

(TODO: Explain more about failure here:)

We expect that messages between close nodes are routed using a local "high"
node, while messages between very far nodes are routed using a globally "high"
node. Therefore **idealy** we expect that the "highest" node in the network
will not be so loaded, because the lower level "high" nodes will take part of
the load.
This somehow resembles the way physical post offices work. You have
the global post office which handles messages between countries, and smaller
post offices that handle messages between cities, and so on.

However, this is just the ideal. It is true that the local "high" nodes in the
network take part of the load from the "highest" node in the network, but
usually they only take a small part of it. Intuitively, this happens for a few
reasons:

- In physical mail system people tend to send packages and letters to people
  close to them geographically, so the structure of global post offices and local
  post offices makes sense. However, this is not the case with mesh networks: In
  a mesh network, any two arbirary nodes \(x\) and \(y\) might want to
  communicate. With high probability \(x\) and \(y\) are far away from each
  other (With respect to the network graph), and so their messages will be routed
  through the "highest" node in the network.

- In a grid style graph (Or any [planar
  graphs](http://en.wikipedia.org/wiki/Planar_graph)), close nodes are expected
  to have many "high" nodes in common. However, for other types of graphs, close
  nodes might only have the "highest" node in common.


I want to discuss the second reason with a bit more detail. For some node \(x\)
in the network, we denote by \(R_j(x)\) the set of nodes of distance no more
than \(j\) from \(x\). You can think about it as a ball around \(x\) of radius
\(j\).

(TODO: Add a picture of \(R_j(x)\).

Consider two nodes \(x\) and \(y\) in the network. We observe the sets \(R_i(x)
\cap R_j(y)\) and \(R_i(x) \cup R_j(y)\).

(TODO: Add a picture of the two sets\)

Let \(w\) be the "highest node in \(R_i(x) \cup R_j(y)\). If \(w\) is inside
\(R_i(x) \cap R_j(y)\) then \(t_x^i = w = t_y^j\). (In other words: \(w\) is
the "highest" node in distance \(i\) from \(x\), and the "highest" node in
distance \(j\) from \(y\)). In that case, \(x\) and \(y\) could route messages
through \(w\).

What are the odds for that event to happen? As the "highest" node in \(R_i(x)
\cup R_j(y)\) could be any node in that set, the odds are: 
\[\frac{\left|R_i(x) \cap R_j(y)\right|}{\left|R_i(x) \cup R_j(y)\right|}\]


For some graphs, like a grid for example, this probability is not so small. \(|R_i(x)|\)








(TODO: Add a piece of code that proves the failure).






</%block>
