<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "The Unified Challenge-Response: Inventing time inside the mesh",\
    "date": "2014-12-26 19:19",\
    "author": "real",\
    "number":10,\
    "tags": [],\
    "draft":"True",\
    "description": "")}
%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">
<!--
abs function.
-->
\(
\newcommand{\abs}[1]{\left|{#1}\right|}
\newcommand{\paren}[1]{\left({#1}\right)}
\)

<h4>Abstract</h4>

TODO: Add abstract


<h4>Motivation</h4>

<h5>The Challenge-Response</h5>

Let \(x,y\) be two nodes in distributed mesh network. Assume that there is a
path of nodes between \(x\) and \(y\), known to \(x\) and \(y\).  By a path we
mean that \(x\) is an immediate neighbour of some other node \(x_1\), which in
turn an immediate neighbour of some other node \(x_2\) and so on, until we get
to some \(x_k\), which is an immediate neighbour of \(y\).

\(x\) and \(y\) are not immediate neighbours, however using the path between
them they can communicate.

As the network changes, the path between \(x\) and \(y\) might not last
forever. (One of the nodes one the path might fail). Moreover, one of the nodes
\(x\) or \(y\) might fail at some point. In a case of failure, the nodes \(x\)
and \(y\) will want to be informed, to find an alternative path. (Or even just
give up on the connection, in case one of them has failed).

(TODO: A picture of the path between \(x\) and \(y\))

One idea would be that \(x\) and \(y\) will send periodic messages to
each other along the known path. Then if for example \(x\) has not received a
message from \(y\) for a long period of time, \(x\) will assume that some node
along the path has failed, or \(y\) itself has failed.

To make things a bit more secure we could use [public key
cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography), with an
idea we call "challenge-response". \(x\) will send a periodic message to \(y\)
(Along the path) which is a challenge to prove his identity. \(y\) will respond
with a proof about his identity, sent along the path all the way to \(x\).
Using public key cryptography we hope that \(y\)'s response could not be faked.

Note that the challenge sent by \(x\) along the path to \(y\) has to be a
different challenge every time. \(x\) can not use the same challenge twice. The
next example explains why.

<h5>The Replay Attack</h5>

Consider the following case: \(x\) and \(y\) are connected by some path, and
\(e\) is a node on the path between \(x\) and \(y\). Assume that \(x\) sends a
challenge message \(cm\) along the path to \(y\). \(e\) sees the messages
\(cm\) and passes it to the next node on the path, until the message \(cm\)
arrives at \(y\).

\(y\) creates a proof to his identity the related to the sent challenge. We
call this proof \(pr\). \(y\) then sends \(pr\) along the path from \(y\) to
\(x\). \(e\) will see \(pr\), and pass it along to the next node on the path to
\(x\).

Assume that \(x\) now sends the same challenge \(cm\) along the path to \(y\).
Whenever the challenge \(cm\) arrives at \(e\), \(e\) will not pass it to the
next node on the path to \(y\). Instead, it will send back to \(x\) the proof
message \(pr\) that \(y\) has generated in response to \(cm\) the last time it
was sent.

\(x\) will receive the message \(pr\) which is a valid proof, and so \(x\) will
wrongly assume that \(y\) has sent it. At this point \(y\) might be already
dead, but \(e\) could keep sending convincing messages to \(x\) about \(y\)'s
existence.

(TODO: Show the path between \(x\) and \(y\), and two stages of the replay
attack. First \(e\) just listens to the messages, and then \(e\) cuts the next
message and sends \(x\) back the response).

This kind of attack, performed by \(e\), is also known as [Replay
attack](http://en.wikipedia.org/wiki/Replay_attack). One way to avoid it is to
make sure that \(x\) sends to \(y\) a different challenge every time.

<h5>One to Many challenge-response</h5>

Assume that some node \(t\) is a pretty important node in the network. It's so
important that every node \(x\) in the network keeps a path to \(t\). (An
example to this case could be found in [Landmarks Navigation by Random
Walking](${self.utils.rel_file_link("articles/landmarks_navigation_rw.html")}),
where \(t\) might be one of the landmarks).

Note that this case is a bit different from the one described above. It
assymetric. Every node remembers a path to \(t\), but \(t\) doesn't remember a
path to each node in the network. \(t\) doesn't have the ability to do that, as
there are too many nodes in the network. Therefore we assume that every node
\(x\) remembers a path to \(t\), however \(t\) doesn't know that path.

Every node \(x\) that keeps a path to \(t\) will want to know that \(t\) is
still alive, and that his path to \(t\) is still alive. 

<h6>Using simple challenge response</h6>

One idea to do that would be to use the challenge-response method that was
introduced earlier. \(x\) will periodically send a unique message with a
**unique** challenge along the path to \(t\), then \(t\) will produce a proof
and send a response message containing that proof somehow back to \(x\).

The main issue with this idea is that \(t\) will have to generate proofs for
challenges sent from every node in the network. As noted above, \(t\) does not
have the ability to do that, because there are too many nodes in the network.

<h6>Flooding a signed message</h6>

Maybe instead of using the challenge response mechanism, \(t\) could just flood
the network with a message signed by \(t\)'s key that says \(t\) is alive?

This method is vulnerable to the Replay Attack: A node \(e\) could wait until
\(t\) sends such a message, and then send this message again at a later time,
convincing all the nodes in the network the \(t\) is alive.

<h6>Flooding a signed message with a counter</h6>

To avoid the attack described above, \(t\) could send a unique signed message
every time. \(t\) can include some kind of counter inside his messages, and
increase that counter by \(1\) for every message sent. Then the message sent by
\(t\) will look something like: ("I am alive, counter = 345",Signature), where
the counter is increased for every message.

This time \(e\) will not be able to immediately replay \(t\)'s messages. That
is because the messages have a counter, and every node in the network remembers the
last counter value sent by \(t\).




TODO: Continue explaining failure of this method:




However, \(e\) could wait for a while, until \(t\) disconnects from the
network, and all the nodes in the network forget about \(t\)'s old messages and
counter numbers. This must happen at some point, because the network 






</%block>
