<%inherit file="/article.makoa"/>
<%def name="post_metadata()">
<%
    return {\
    "title": "The Unified Challenge-Response: Secure time inside the mesh",\
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


<h4>Introduction</h4>

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
incorrectly assume that \(y\) has sent it. At this point \(y\) might be already
dead, but \(e\) could keep sending convincing messages to \(x\) about \(y\)'s
existence.

(TODO: Show the path between \(x\) and \(y\), and two stages of the replay
attack. First \(e\) just listens to the messages, and then \(e\) cuts the next
message and sends \(x\) back the response).

This kind of attack, performed by \(e\), is also known as [Replay
attack](http://en.wikipedia.org/wiki/Replay_attack). One way to avoid it is to
make sure that \(x\) sends to \(y\) a different challenge every time.

<h5>One to Many Challenge-Sesponse</h5>

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

<h5>Using simple challenge response</h5>

One idea to do that would be to use the challenge-response method that was
introduced earlier. Every node \(x\) will periodically send a unique message
with a **unique** challenge along the path to \(t\), then \(t\) will produce a
proof and send a response message containing that proof somehow back to \(x\).

The main issue with this idea is that \(t\) will have to generate proofs for
challenges sent from every node in the network. As noted above, \(t\) does not
have the ability to do that, because there are too many nodes in the network.

<h5>Flooding a signed message</h5>

Instead of using the challenge response mechanism, \(t\) could just flood the
network with a message signed by \(t\)'s key that says \(t\) is alive.
The message will be something of the form: ("\(t\) is alive",Signature by \(t\)).
(Note that the signature signs the content "\(t\) is alive").

Recall what flooding means: Every node \(x\) that recieves such a message and
thinks it is valid will pass the message to all of its immediate neigbhours.

This method is vulnerable to the Replay Attack: Let \(e\) be some node in the
network. \(e\) receives all the messages flooded from \(t\). Therefore \(e\)
will obtain the message ("\(t\) is alive", Signature) pretty soon.

Assume that after a while \(t\) went offline. \(e\) could then send the message
("\(t\) is alive", Signature) again. This could trick all the nodes in the
network to believe that \(t\) is still alive, although it is not online.

<h5>Flooding a signed message with a counter</h5>

To avoid the Replay attack introduced in the case of flooding signed message,
we could add something to \(t\)'s message which will make it a bit different
every time.

\(t\) can include some kind of counter inside his messages, and
increase that counter by \(1\) for every message sent. Then the message sent by
\(t\) will look something like: ("\(t\) is alive", counter = 345, Signature by
\(t\)), where the counter is increased for every message. (Note that the
signature signs the content and the counter together).

This time it is a bit harder for \(e\) to replay \(t\)'s messages.
That is because the messages have a counter, and every node in the network
remembers the last counter value sent by \(t\). If \(e\) tries to replay some
message that was sent earlier by \(t\), the nodes in the network will recognize
that the message is not recent, and they will not accept it.

Explained in some more detail: Assume that \(t\) sends a periodic signed
message with a counter, stating that he is alive. An example for a sequence of
messages sent from \(t\) would be: 

("\(t\) is alive", counter = 103, Signature)

("\(t\) is alive", counter = 104, Signature)

("\(t\) is alive", counter = 105, Signature)

...

("\(t\) am alive", counter = 171, Signature)

Recall that those messages have the purpose of proving to all the nodes in the
network that \(t\) is still alive. 

After the last message sent by \(t\), all the nodes in the network remember the
counter value \(171\) for \(t\)'s sequence.

Let \(e\) be some node in the network that receives those messages from \(t\).
\(e\) can try to send again one of \(t\)'s old messages. For example, the
message ("\(t\) is alive",counter = 104,Signature). However, the nodes in the
network will not accept this message, because they know the current value of
the counter: 171. They know that the message with counter = 104 sent by \(e\)
is not new.


However, if \(e\) is really determined to replay \(t\)'s messages, he can
wait longer. \(e\) can wait until \(t\) is offline, and then wait even more:
until all the nodes in the network have forgotten about \(t\)'s existence.

Why do we think that \(t\) will eventually be forgotten? For every node \(x\)
in the network we assume that \(x\) will forget \(t\) at some point. That is
because it is not practical for \(x\) to remember all the \(t\)-s of the past
together with their counter number forever. \(x\) will have to delete some old
information, to make space for new information.

At the point where the information about \(t\) was long forgotten, \(e\) will
be able to replay all of \(t\)'s messages. \(e\) could send all the messages
from the list above, one after the other, living the history of \(t\) again.

<h5>Using the Time</h5>

We saw that adding a counter to the signed "alive" messages helps to deal with
replay attacks of the present, but it fails protecting against replay attacks
that take place in the far future.

To prove that a signed "alive" message was signed recently, we could add the
current time into the message, and sign it. A typical message would be:
("\(t\) is alive", time="Sat Dec 27 09:38:58 UTC 2014",Signature), where the
signature is over the message's content and the time. This method to overcome
replay attacks is sometimes called a
[Timestamp](http://en.wikipedia.org/wiki/Timestamp).

Whenever a node \(x\) receives an "alive" message, he will verify the signature
and check the time stated inside the message. If the time stated is very long
ago (Maybe a few minutes ago), \(x\) will discard the message. Otherwise, if
the time is recent and the signature is valid, \(x\) will know that \(t\) is
alive.

In this case a node \(e\) will not be able to replay an old "alive" message
sent by \(t\). If \(e\) wants to generate a valid "alive" message, he needs to
have a recent time stamp inside the message, together with a signature of \(t\)
over this message. Without cooperation from \(t\), this would be computationaly
infeasible for \(e\).


There are some possible issues with this method, though.
First, we might not fully trust \(t\). Maybe it is important for us that \(t\)
generates "alive" messages in real time, and doesn't make many of those
messages ahead of time for later use.

With the Timestamping mechanism introduced above, \(t\) could generate many
messages for the future ahead of time, signing over future timestamps. \(t\)
could then hand those future "alive" messages for someone else to deliver, in
the future.

The next issue is about time itself. **How can we get a definition of time
inside a distributed mesh network?** It seems to be a nontrivial question, both
because of relativistic time effects in distributed networks, and also because
we assume existence of some adversary players inside our network.

There are some solutions for this problem for the case of no adversaries or
weak adversaries. One thing you should probably check out is [Lamport
Timestamps](http://en.wikipedia.org/wiki/Lamport_timestamps).

I include here some naive approaches to get a mesh network definition of time,
and a short explanation of why they won't fit for our case:

- We can set a special trusted node \(TS\) (Time Server) that is responsible
  for advertising time. \(TS\) will flood the network with a message about his
  current time every 1 second. \(TS\)

  The message sent by \(TS\) will be of the form (current_time, Signature by
  \(TS\)).

  Then whenever \(t\) wants to send an "alive" message, it will take the last
  message sent by \(TS\), concat to that message the string "\(t\) is alive"
  and add a signature over everything. The end result will be:
  ("\(t\) is alive",(current_time,Signature by \(TS\)),Signature by \(t\)).
  (Note that using this method \(t\) can not make "alive" messages ahead of
  time).

  To make this work we need some trusted node with some globally trusted key.
  This node has to live forever, or else the time in the network will "stop
  moving. This is probably unacceptable for most distributed network settings.

- Every node will have its own clock, and nodes will fix drift by asking each
  other about the time. The time it takes a message to arrive can also be taken
  into account.

  This could probably work in a setting where we trust all the nodes to tell
  the truth about time. However, in the case of adversarial nodes inside the
  network, this will probably not work correctly.


<h5>The Unified-Challenge response</h5>

Short recap of our ideas so far: Let \(t\) be a specific node inside a mesh
network. We are looking for a way to let \(t\) broadcast a signed message to all
the nodes in the network, so that every node will know that the message sent was
signed recently, and thus \(t\) was recently alive. 

We mentioned two main ideas:

- Challenge-Response: Every node \(x\) sends a unique challenge to \(t\), and
  \(t\) responds with a proof. This proves to \(x\) that \(t\) is alive. We
  couldn't use this method because we can't afford letting \(t\) generate
  proofs for challenges from all the nodes in the network.

- Signing over some recent data: \(t\) will sign some recent data, like the 
  current time, and broadcast it to all the nodes in the network. We couldn't
  use this method because we don't have a reliable and secure way to generate
  "recent data", like time.

The approach presented in this text is to somehow combine those two ideas
together. We will create something that we call the "Unified Challenge": A
challenge that will be created together by all the nodes in the network, in a
distributed and efficient fashion. 

This challenge will have somewhat similar role as the "current time" had in our
previous ideas. \(t\) will sign the Unified challenge. Whenever a node
\(x\) sees that unified challenge, he will be able to identify his own part
inside this challenge, thus \(x\) will know that the message from \(t\) is
recent, and hence \(t\) was recently alive.




</%block>
