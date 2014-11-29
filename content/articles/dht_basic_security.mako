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
adversary could mean many things. More than something realistic, it is an
entity that helps us think about security. It's like a game. We give the
adversary certain powers, and see if our model can deal with it. In some sense,
our Adversariel model is really our understanding of reality. If all of this
sounds too abstract to you, don't worry, we are soon going to see some
examples.

Before we move on to checking out some adversaries, We review again the basic
functions of our DHT.  In the lower level of the DHT structure, it means the
ability to search for node \(\floor{v}\) given the value \(v\). In the higher
level (Thinking about a Distributed Hash table), it is the ability to store
pairs of (key,value), or retrieve a correct value given a key.

Our general model of the adversary in the following text will be as follows.
The adversary manifests itself in the network in the form of "corrupt" nodes.
Those are nodes that are under the full control of the adversary. We then make
a distinction: For every node in the network, it is either a node controlled by
the adversary - A "corrupt node", or a "correct" node.  By "correct" we mean
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

We begin with an adversary that can get into the network as many corrupt
nodes as he likes. To make things easy to think about, forget about reliability
issues (Nodes that fail). We will assume that the correct nodes never fail.

Try to think for a moment what could be done with this ability of inserting as
many corrupt nodes as you want into the DHT.

One very philosophical way of thinking about this situation is as follows: Does
the network really belong to us if there are more corrupt nodes than correct
nodes? Could we really enforce our structure on the network if the nodes we
control are in a minority? And if we could, why couldn't the adversary do
exactly the same? Thinking about it, what makes us and the adversary so
different?

Going back to our physical world, let's try to see some concrete examples of
things the adversary can do:

- Disconnecting the DHT: The adversary could insert many nodes into the network,
  and let them run by the DHT rules. Correct nodes will not be able to
  distinguish between the corrupt nodes and the correct nodes, and they will
  form connection to the corrupt nodes. Then in one sudden moment, the
  adversary will make all the corrupt nodes halt. That means: All the corrupt
  nodes will stop responding. As the adversary has many nodes (Much more than
  corrupt nodes), With a pretty high probability, the DHT will become
  disconnected. 

- Blocking or Changing specific keys: Assume that the adversary doesn't want
  some key to be accessible (It will not be possible to get the value \(v\) for
  a key \(k\)).  To do this, The adversary could insert many nodes into the
  network with random IDs (Remember that every node has some ID). If the
  adversary has a very big amount of nodes, with some high probability the key
  \(k\) will be under the responsibility of a corrupt node. Then whever that
  key is asked for, the adversary could return some other value \(v'\) instead
  of \(v\), or just not return anything.

As we mentioned above though (In the philosophical paragraph), if the adversary
wanted he could make anything out of this network, because really, he owns this
network. He was a majority of "corrupt" nodes.

This kind of attack where an adversary inserts a large amount of "corrupt" nodes
into a network is also known as Sybil Attack. (TODO: Add link here)
This kind of attack is not specific to DHTs. It is related to any distributed
network where all the nodes have symmetric roles. It is probably the first
attack to consider when you hear about a fully distributed technology.

You might be wondering what could be done about the Sybil Attack. We won't solve
it now, sorry. We need something extra to solve it. I just wanted you to know
about it. At this point we will try to come up with a weaker adversary.

<h5>Node bounded Adversary</h5>

We have seen that we can't defend outselves at this point from an adversary that
inserts unlimited amount of nodes into the network. So let's put a limit to the
amount of nodes the adversary can insert.

Assuming that there are \(n\) nodes in the network, a reasonable bound might be
\(\alpha \cdot n\), where \(0 < \alpha < 0.5\). In other words, the maximal amount
of corrupt nodes is a constant fraction of the total size of the network. Why do
we pick \(\alpha\) smaller than half? That is because (As we noted above) if the
adversary has more than half the nodes im the network, he pretty much owns the
network. Just as a sanity check, note that the amount of correct nodes in the
network is \((1 - \alpha)n\).

The adversary has a collection of \(\alpha n\) corrupt nodes. He can insert
each of those nodes into the DHT, and also remove each of them from the DHT.
The adversary has much freedom to move the corrupt nodes around, however he
owns only \(\alpha n\) nodes.

You might be thinking how come we get to choose the abilities of our adversary.
For example - How can we allow ourselves to bound the amount of corrupt nodes?
After all, the adversary doesn't work by our rules. There are two answers. The
first is that we can't, but it helps us to think. The second answer is that we
might actually create some mechanism where the adversary will not be able to
issue too many corrupt nodes. In that case, it could be easier to first think
about the DHT construct, and only later about the other mechanism to bound the
amount of corrupt nodes.

Just to make sure I don't leave you with abstract promises, let's consider a
very naive mechanism to bound the amount of possible corrupt nodes. For every
node who wants to join the network, we will ask the computer owner to show up
in person and hand over his id card. (In the real world). We will let one node
in for every unique id card that we get. In this example, hopefully the
adversary will not be able to get too many id cards, and therefore he will not
be able to have too many nodes inside the network.

We are not going to use this mechanism (It is not very distributed or
efficient), but it serves as a good example of how to bound the amount of
corrupt nodes in a network. Another formulation of that example would be: 
We used the scarcity of id cards in the real world to make Sybil attacks hard
to perform.

<h5>The Node Bounded Slow Changing Adversary</h5>

By now you are probably convinced that dealing with a tough adversary might be
more difficult than dealing with random churn in the network (Node failures,
for example). However, we still have to consider the random churn and
reliablity issues.

Our model will become pretty complicated if we have to deal both with an
adversary and with reliability problems. An interesting idea would be to add
the properties of the network churn into the set of the adversary's abilities.
Then we only have to think about dealing with the adversary.

In the Node bounded Adversary model we assume that some nodes are corrupt (They
might behave in arbitrary ways), and the other nodes are correct. We also
assumed that the correct nodes never fail.

This is not true in "real life". We know that even correct nodes could fail.
Maybe there was a power shutdown, or somebody stepped on the network cable. How
could we design an Adversarial model that includes arbitrary failure of correct
nodes? Take a few moments to think about it.

Let's consider the following model of an adversary - The Node Bounded Slow
Changing Adversary:

- Node bounded: The adversary controls no more than \(\alpha n\) corrupt nodes,
  where \(\alpha < 0.5\)

- **Slow changing**: Every big enough time interval \(T_c\) (You can think
  about this interval as 10 seconds for example), The adversary has the ability
  to perform the **random change step**: The set of corrupt nodes changes to
  some random subset of the network nodes. The Adversary doesn't have control
  over which subset will be chosen. It happens randomly.

In this model, as usual, the corrupt nodes are fully controlled by the
adversary, and can do pretty much anything. The correct nodes work by the rules
of the network (In our case, the DHT), and never fail.

In addition, to complement the time constant \(T_c\), we also assume that
sending messages between two connected nodes in the network takes no more than
\(T_s\) time. (You can think about this time interval as 1 second for example). 
Note that if we don't consider this quantity \(T_s\), defining \(T_c\) is
pretty much meaningless. The absolute speed of changing of the Adversary
doesn't say much by itself. We care about it with respect to the speed of
message delivery in the network.

(TODO: Add a picture of the slow changing property)

We begin by understanding the properties of the Bounded Slow Changing
Adversary. The first property is being Node Bounded. This just means that the
adversary can't have too many corrupt nodes. 

The next property is "slow changing". Basically "slow changing" means that the
adversary could change (slowly and randomly) the set of nodes under his
control. This step just randomly changes all the corrupt nodes to a new set of
corrupt nodes. 

One thing to note about this property is that it is not a limitation. We know
this because the adversary has a choice: Every time interval \(T_c\) the
adversary could perform some step, however he doesn't have to do that. Therefore
we are sure that the second property makes this adversary "stronger" than the
earlier model of Node Bounded Adversary. That it because it has more options.

<h6>Observations about the Slow Changing Adversary</h6>

First, we note that The Node Bounded Slow Changing Adversary takes into account
"network churn". In our previous model, the Node Bounded Adversary, If some
node was a correct node, it could never fail. In this model, however, correct
nodes might turn into corrupt nodes, and then they might "fail".

Let's observe some node \(x\) in the network. If \(x\) is a corrupt node, he is
under the adversary's control, and therefore he could fail (If the adversary
decides so). If \(x\) is a correct node, then it does not fail as long as it is
correct. However, after enough time intervals \(T_c\) the adversary might gain
control over \(x\), and then \(x\) might fail.

Therefore in the Node Bounded Slow Changing Adversary model, every node might
fail after long enough time. This is a nice "model" of what could happen in
reality.

In some sense, the adversary encapsulates inside him both our wicked enemy that
tries to destroy our network, and at the same time the "bad luck" of having nodes
failing randomly from time to time.

The next observation is that the "Slow" requirement is important. Assume that
the time interval \(T_c\) was a very small number, or even zero. In that case at
any given moment the adversary could gain control over any specific node \(x\).
This could be done by running the random change step many times, until \(x\) is 
part of the new randomly chosen corrupt nodes set.

Having \(T_c\) close to zero is somehow equivalent to letting the adversary
have control over all the nodes in the network. (Just like [being very fast in
the real world](https://www.youtube.com/watch?v=qckKMEySSYg) could be
equivalent to being everywhere at the same time]). Having a large enough time
interval \(T_c\) avoids this issue.

Finally I want to shortly note that the definition we have seen for the Slow
Changing "model" is not very formal. We might discuss this model in a formal
manner in the future though. For the interested,
try to think about the following issue: How can one [measure
time](http://en.wikipedia.org/wiki/Theory_of_relativity) in a decentralized
network of computers?

But please don't worry about it now. This informal model should be enough to
understand the following ideas.

<h4>Securing a DHT</h4>

(TODO: continue here)


In the following sections we will try to deal with various security issues that
might arise in a DHT. We have met the Chord DHT (TODO: Add link to article),
but this might apply to a wider range of DHT structures.

Regarding the Adversarial model: We are going to assume a Node Bounded Slow
Changing Adversary. To avoid writing those 5 words every time I want to refer
the Adversary, we will call it just Adversary on the rest of this text.

Most of our security considerations presented here will relate to the way we
choose the Identities of nodes in the network. I remind you that in Chord, every
node has an Identity number which is from a set \(B_s := \{0,1,2,\dots,2^{s}-1
\}\) (A number of size \(s\) bits). Identities in a DHT are very important, as
they determine the range of keys a node has responsibility over.

Given that we know the set of possible identities, we are left with the task of
choosing the Identity for new nodes who join the network. We will observe a few
methods here.

<h5>Random Identities</h5>

A simple solution for the Identity choice would be to let every new node in the
network pick a random Identity number. If we are talkin about Chord, that random
Identity number will be a random bit string of size \(s\) bits. If all the nodes
are correct and \(s\) is [large
enough](http://en.wikipedia.org/wiki/Birthday_problem), we can be pretty sure
that no two nodes are going to have the exact same Identity number.

However, if we take into consideration an Adversary as discussed above, we are
expected to have problems. One thing the adversary can do, for example, is to
block or modify the value for any wanted key. Assume that the Adversary wants
to block the value of key \(k\). It is enough that the Adversary will insert
just one corrupt node \(z\) into the network, choosing for him the Identity
\(k\).

Then for sure the node \(z\) will have the responsibility of keeping the key
\(k\) and its corresponding value. Whenever some other node \(x\) will search
for the key \(k\) and ask for its value, the node \(z\) could not respond (Thus
blocking access to the key \(k\)), or give a different value \(v'\).

The idea of Random Identities gets us started, but obviously it can not deal
with our Adversary.

<h5>Public keys as Identities</h5>

Another possibility for Identity choice is Public keys, using any form of
[asymmetric
cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography). (Also
known as Public Cryptography).

In this method, every node that joins the network first generates a key pair of
public key and private key. Then the node uses his own public key as his DHT
Identity.

If you don't have any experience with public key cryptography, let me try to
make it more concrete for you in a few sentences, introducing you to the
[RSA](http://en.wikipedia.org/wiki/RSA_%28cryptosystem%29) method. A new node
\(x\) that wants to join the network first generates two large and random prime
numbers \(p,q\). Then he multiplies those two prime numbers, getting as a
result a large number \(pq = N\). This number \(N\) is going to be \(x\) Identity
inside the DHT. The numbers \(p,q\) are considered to be the \(x\)'s private
key, and he will keep them secret. This was just an example of one Public key
cryptosystem. Almost any such cryptosystem will be enough for our purposes
here, however I choose to stick with the RSA system notation for clarity.

Generating a public key and using it as a DHT Identity is still not enough, as
any corrupt node could still claim any DHT Identity \(N\), just like in the
previous proposal. Therefore we have to add some kind of verification -
Whenever a node joins the network and claims an Identity, he will have to prove
somehow that he owns the private key for this public key. (In the RSA case, He
will have to prove that he knows some two prime numbers \(p,q\) such that
\(pq=N\)). 

TODO: CONTINUE HERE.

Proving that you know the private key for a given identity \(N\) is in this
case equivalent to proving that you "own" the identity \(N\). One can prove
that he knows the private key using a [digital
signature](http://en.wikipedia.org/wiki/Digital_signature).



</%block>
