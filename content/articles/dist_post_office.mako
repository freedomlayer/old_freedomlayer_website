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

We can continue this argument until we get to \(x\). Then we conclude that
after \(k+1\) iterations, \(x\) will have \(t\) as the highest person in the
world, and \(x\) will also have a shortest path from \(x\) to \(t\).

Another way to think about it is that the amount of iterations needed until
every person finds the highest person in the world is not more than the
diameter of the neighbours graph.

<h5>Addressing and drift</h5>

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




</%block>
