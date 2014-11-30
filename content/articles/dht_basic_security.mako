<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Basic DHT security concepts",\
    "date": "2014-11-27 10:03",\
    "author": "real",\
    "number":5,\
    "tags": [],\
    "draft":"True"}

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

<h4>Abstract</h4>
We are going to talk about some very basic techniques of securing a DHT
(Distributed Hash Table). We begin by discussing the kind of Adversary are we
going to defend against. We then move on to some ideas regarding the choice of
Identities in a DHT. Finally we present a simple idea about bounding the amount
of adversarial nodes that manage to get into our network.

Most of the talk is going to be pretty informal, though it serves as a useful
down to earth introduction to the subject.

<h5>DHT Reminder</h5>
Before we move on to talk about security , We review again the basic functions
of our DHT. In the lower level of the DHT structure, it means the ability to
search for node \(\floor{v}\) given the value \(v\). In the higher level
(Thinking about a Distributed Hash table), it is the ability to store pairs of
(key,value), or retrieve a correct value given a key.

<h4>The Adversary</h4>

The first thing we want to do when talking about security is to define the
adversary. We will discuss it in a very informal manner, because this is just an
introduction to this subject. Our informal definitions here will be good enough
for this text.

Generally speaking, in our case the adversary is some entity that
wants to disrupt the DHT functions.  By entity we don't just mean one node, or
one computer, or even one person. The adversary could mean many things. More
than something realistic, it is an entity that helps us think about security.
It's like a game. We give the adversary certain powers, and see if our model can
deal with it. In some sense, our Adversariel model is really our understanding
of reality. If all of this sounds too abstract to you, don't worry, we are soon
going to see some examples.

Our general model of the adversary in the following text will be as follows.
The adversary manifests itself in the network in the form of "corrupt" nodes.
Those are nodes that are under the full control of the adversary. We then make
a distinction: For every node in the network, it is either a node controlled by
the adversary - A "corrupt node", or a "correct" node.  By "correct" we mean
honest, or "not corrupt". It's a node that follows the rules as we defined
them. (From now on we will not add the quotes when referring correct or corrupt
nodes).

Another important thing to note about the two types of nodes is that **it is not
possible to tell if a node is a correct node or a corrupt node.** Every node
knows if he himself is correct or corrupt, but he can never know for sure if
another node is correct or corrupt. You could try to ask a node if he is
correct, but then, if it's a corrupt node, he might lie. You could also try to
watch a node for a really long time, and then try to conclude that it is a
correct node. However that node might be just pretending, waiting for you to
look away.

Of those reasons, (And several others that will become clearer in the future),
we will never try to directly conclude if a node is correct or corrupt. We just
know that some nodes are corrupt and some are correct. This is the way of life.

One more thing to note is that for the sake of simplicity, we are going to
forget for a while the Churn and Reliability issues. We will not think about
nodes that fail in the article. We assume that all the correct nodes are
perfectly reliable, and our main problem to deal with is the Adversary.

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
into a network is also known as [Sybil Attack](http://en.wikipedia.org/wiki/Sybil_attack)
This kind of attack is not specific to DHTs. It is related to any distributed
network where all the nodes have symmetric roles. It is probably the first
attack to consider when you hear about a fully distributed technology.

The Sybil attack is one of the fundamental issues we have to deal with when
designing anything that is really distributed. We will not solve this at this
point, but we are going to talk about it more in the future.

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


<h4>Security of Identities' choice</h4>

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

Following the previous attempt, we want to make sure the Adversary could not
choose any arbitrary DHT Identity that he wants. We want to make it hard for the
adversary to choose arbitrary DHT identities. 

One possibility for Identity choice is Public keys, using any form of
[asymmetric
cryptography](http://en.wikipedia.org/wiki/Public-key_cryptography). (Also
known as Public key Cryptography).

In this method, every node that joins the network first generates a key pair of
public key and private key. Then the node uses his own public key as his DHT
Identity. Whenever a node \(y\) comes in contact with a node \(x\), \(y\) will
ask \(x\) to prove his claimed identity. \(x\) will then prove his identity
using the Public Key Cryptography system. This way the Adversary will have to
use a valid Identity for his corrupt nodes, if he wants to be able to
communicate with correct nodes.

We somehow hope that it is going to be hard for the Adversary to generate an
Identity that is both valid and close to a specified wanted number.

<h6>Some words about Public Key Cryptography</h6>

All those Cryptography stuff might sound very strange to you if you have never
heard about Public Key Cryptography before. I will try to explain shortly what
Public Key Cryptography feels like, however if you want to really understand
things, please take the time to read more about it from some more serious
sources. It will really make a difference in your understanding of things.

Public Key cryptography is a system with a few participants. Every participant
initially generates somehow two keys: A public key and a private key. Those keys
are usually generated randomly (By the participants), and they are related
somehow to each other. Then every participant shares his public key with the
rest of the participants, but keeps his private key a secret.

What could be done with those public and private keys? Using the public key one
can encrypt data. The corresponding private key could be used to decrypt that
data.

If for example Bob generates a key pair of Public key and private key, he will
share the public key with all the participants in the system. Then every
participant can encrypt messages with Bob's public key, but only Bob could
decrypt those messages with his secret private key.

Another feature that some Public Key cryptography systems has is the **ability to
sign**. Bob could sign some message, and then every participant could verify the
signature Bob's signature, and be sure that Bob wrote the message. It's pretty
much like signatures in the real world (Though a bit more secure :) )

In our case we are really interested in the signing ability that we get from
Public Key Cryptography. (Hint: We are going to use it later to prove that we own an
Identity in the DHT).

I don't want to get too abstract on you, so let me follow with a real example of
a Public Key Cryptography system. A famous example is
[RSA](http://en.wikipedia.org/wiki/RSA_%28cryptosystem%29). If Alice wants to
generate a key pair, she has to generate two big random prime numbers. Let's
call those \(p,q\). Then Alice multiplies them, to get the value \(N=pq\). \(N\)
is then called the public key, and \(p,q\) are the private keys. Alice can share
the public key (\(N\)) with anyone, however she will never tell \(p,q\). This is
the private (Or secret) key. Note that concluding the numbers \(p,q\) knowing
only \(N\) is considered to be a difficult computational problem. (See [Integer
Factorization](http://en.wikipedia.org/wiki/Integer_factorization))

In RSA the public key could be used to Encrypt messages, and the private key
could be used to decrypt messages. In a similar way, we could use the private
key to sign messages, and the public key to verify those messages. For the
interested, the operation of signing a message in RSA is the same as decrypting
a message using the private key. The operation of verifying an RSA signature is
the same as encrypting a message using the public key.

<h6>Using Public keys as Identities</h6>

As we mentioned in the beginning of this section, we planned that every node
\(x\) will generate a key pair, and use the Public key as a DHT Identity.
When a node \(x\) joins the network and presents his Public key (Which is his
claimed DHT Identity), we will send him to prove his identity.

How could we ask \(x\) to prove it his identity? A naive method would be to send
him some random value \(t\), and ask him ask him to sign it. If \(x\) manages to
create a valid signature over \(t\), we will conclude that his identity is
confirmed.

Again let's assume that the Adversary wants to block some key \(k\) in the DHT,
and see what happens in this case. The Adversary has to position some corrupt
node with an Identity very close to \(k\) (But not bigger than \(k\)) inside the
network. If we are dealing with RSA, then all the Adversary needs to do is find
some two prime number \(p,q\) such that \(pq\) is very close to \(k\). Then the
adversary will use \(N=pq\) as the corrupt node's Identity (Public Key), and
\(p,q\) as the private key. 

There are many prime numbers, so this should not really be a problem. It's a bit
harder than the previous case, where the Adversary could just pick and Identity
that he wants for his corrupt nodes, however it is not much harder.

(One could also say that it might be not needed to supply a value \(N\) that is
really made of a multiplication of two primes, but we don't need to get into
this. Even if we follow the rules and create \(N\) as a multiplication of two
primes, it seems to be pretty easy to get close as we want to \(k\)).

<h6>Using Hashed Public Keys as identities</h6>
We could make it a bit harder, though. For a node \(x\) with public key \(N\)
and private key \(p,q\), we could declare \(x\)'s identity to be \(f(N)\), where
\(f\) is some [cryptographic hash
function](http://en.wikipedia.org/wiki/Cryptographic_hash_function).

Let's again go over all the process of \(x\) joining the network to make sure
that this makes sense. \(x\) first generates a pair \(p,q\) of random big
primes, and then derives \(N=pq\) to be his public key. Next, \(x\) calculates
\(Id=f(N)\), and this is \(x\)'s DHT Identity.

When \(x\) joins the network, he has to confirm his identity. He will claim his
identity to be \(Id=F(N)\), and he will also supply the value \(N\). (The verifier
will check that \(Id=F(N)\)). Next, the verifier will send \(x\) some random
value \(t\), and ask \(x\) to sign it. \(x\) will create a signature over \(t\)
and send it back to the verifier. The verifier will then make sure that the
signature is correct. If it is, \(x\)'s identity is confirmed (With respect to
this verifier).

Now let's see what happens if the adversary wants to take control over a key
\(k\). The adversary has to create a corrupt node with Identity close to \(k\)
but no bigger than \(k\). Eventually, the Identity is \(f(N)\). \(N\) has to be
created in a specific way (Probably a multiplication of two primes), however we
could be generous and assume that the Adversary could get to any \(N\) that it
wants. All that is left is finding \(N\) such that \(f(N)\) is close to \(k\).
If the adversary could do that, he will be able to take control over the key
\(k\).

We assume that the adversary is computationally bounded. (He can only compute
things in polynomial time). So far we didn't discuss this property of our
adversary, however this might be a good place to add this assumption. Basically
it means that we assume that adversary doesn't have too much computation power.

Without thinking about any specific properties of the cryptographic hash
function \(f\), a good idea to find a correct \(N\) will to be generate random
numbers and check if \(d(f(a),k)\) is small enough. (Recall that \(d(a,b)\) is
the distance between two identity numbers on the ring). As we expect \(f\) to be
somewhat random, we expect that for some number \(a\), we will get that
\(d(f(a),k)\) is distributed uniformly on \([0,2^s)\). In simpler words, it
means that \(f(a)\) has the same likelihood of being anywhere on the ring.
By creating lots of numbers \(N=pq\) for many different primes \(p,q\), we can
generate many values \(f(N)\) that distribute uniformly on the ring.

We have some interval that we want to "land on", when getting a random value
\(f(a)\). This interval is exactly between \(\floor{k}\) and \(k\) - Right
between the node that is currently responsible over the key \(k\), and the key
\(k\) itself.

(TODO: Add a picture of the place we want to be in on the ring)

Now we want to know how many different values \(N=pq\) we have to generate
before we get that \(f(N)\) is inside the wanted interval on the ring.
A simple calculation shows that the expected number of tries is going to be The
size of the ring divided by the size of the interval. (Think if it makes sense
for an interval of size \(\frac{1}{4}\) of the ring, for example).

We still don't know the size of the interval, though. We want to evaluate
somehow the value \(d(\floor{k},k)\) for some key \(k\). We could get a rough
estimation of this value by thinking about the easy case, where all the nodes
are distributed evenly on the ring. In that case, if there are \(n\) nodes, we
expect that the distance between two consecutive nodes will be exactly \(\frac{2^s}{n}\).

Finally to get the amount of tries, we divide the size of the ring by the our
rough estimation of the size of the interval. We get
\(\frac{2^s}{\frac{2^s}{n}}=n\). Therefore we expect about \(n\) tries before we
get a number \(N\) such that \(d(f(N),k) < d(\floor{k},k)\). Recall that \(n\)
is the amount of nodes in the network. This number is probably not larget than
\(2^40\) in most cases.

As a short summary, the adversary could gain control over any specific key \(k\)
using this algorithm:

1. Generate two random primes \(p,q\). Calculate \(N=pq\).
2. Calculate \(f(N)\).
3. If \(d(f(N),k) < d(\floor{k},k)\) then return (p,q). Else go back to 1.

By our estimations we expect this algorithm to loop about \(n\) times, before a
suitable pair of \(p,q\) is found.

Also note that the Adversary doesn't have to use more than one corrupt node in
the network to gain control over the key \(k\). Most of the calculation is done
offline, ahead of time.

We can conclude that this method can not help us deal with this adversary, but
we did make some progress. Recall that in the previous sections the adversary
could gain control over some key \(k\) without much effort. Here the adversary
has to do some effort to take control over some key.

<h5>Hashing IPs</h5>

We have already considered the idea of hash functions to make it harder for the
adversary to control the Identity of corrupt nodes. Another idea would be to
use the hash of a the IP address of a node as its DHT Identity. This solution
relies on the hierarchical structure of the Internet and the fact that it is
hard to obtain many different IP addresses (At least for simple Adversaries).

Let's be more detailed. For a new node \(x\) with IP Address \(x_a\) that wants
to join the DHT, we define \(x\)'s Identity to be \(f(x_a)\), where \(f\) is a
known cryptographic hash function. Every other node \(y\) on the network that
contacts \(x\) knows \(x\)'s IP Address (Or else, how could \(y\) contact \(x\)
from the first place). Therefore \(y\) knows automatically the value \(f(x_a)\)
which is \(x\)'s DHT Identity.

This time, if an Adversary wants to take control over a key \(k\) in the DHT,
he will have to create a corrupt node with IP address \(a\) such that \(f(a)\)
is close to the value \(k\) (But not bigger than \(k\)).

In IPv4 There are no more than \(2^{32}\) possible addresses. By the calculations
we have seen in the idea of Public keys as Identities, we conclude that about
\(\frac{2^{32}}{n}\) Addresses will be suitable for the adversary if he wants
to take control over some specific key \(k\). 

Obtaining specific IPs could be pretty hard these days (Though not impossible).
Therefore this method does make it hard to take control over a specific key in
the DHT. Thinking about it, the change to IPv6 (Where there are \(2^{128}\)
possible addresses) might make this method less effective. 

Generally speaking, in a network where every node has the freedom to choose his
Address in some fast manner (And there are many possibilities for addresses),
this method might not work well. The Adversary could generate many Addresses
(We have seen that about \(n\) addresses should be enough), until one address
has a hash value in the correct range. Assuming that \(n\) is not too big, this
shouldn't be a hard calculation.

<h4>Bounding the Adversary</h4>

We talked earlier about our assumption of a Node Bounded Adversary - An
Adversary that can insert only so many corrupt nodes into the network. At this
point I want to show an example of achieving this property - Making sure that
the Adversary doesn't have too many corrupt nodes in the network.

Recall that the very naive solution we initially proposed for this was using
some kind of **external scarcity**, like real world ID cards. Every node that
wants to join the network should first be represented by a person in the real
world, handing over his (real world) ID card to some central authority.

There is probably something deeper about the scarcity idea. I say probably,
because we don't have any rigorous theory yet about it, but it seems like most
distributed systems today that are able to deal with Sybil attacks are based
on some kind of scarcity. That scarcity makes it hard for any participant to
insert many nodes into the network, as every node is linked to some amount of
that scarce resource.

In this example we are going to use Computing power as a scarce resource. This
kind of scarcity is widely used in
[Bitcoin](http://en.wikipedia.org/wiki/Bitcoin) based crypto currencies.

Recall that a DHT structure is based on links between nodes. Every node is
linked to a few other nodes, allowing strong network connectivity and fast
network traversal (Fast searching) at the same time. Also recall that to
maintain a link between two nodes, we proposed the idea of
[heartbeats](http://en.wikipedia.org/wiki/Heartbeat_%28computing%29). Messages
are sent in constant time interval between two nodes, to make sure that the
remote node is alive.

Every node in the network has to maintain a few links with other nodes.
Maintaining a link requires sending periodic heartbeat messages, which is not
very computationaly expensive. It would be interesting if we could make the task
of maintaining a link computationly expensive. In that case, the more nodes the
adversary inserts into the network, the more links he will have to maintain. A
computationally bounded Adversary will not be able to insert too many nodes, as
he won't be able to maintain all the links.

One way to make the task of maintaining links more difficult is using a [proof of
work](http://en.wikipedia.org/wiki/Proof-of-work_system) puzzle. We will extend
the idea of heartbeat, by adding a difficult riddle to the heartbeat. If \(x\)
and \(y\) are two linked nodes in the DHT, \(x\) will send a riddle to \(y\)
every 10 seconds, for example. \(x\) will then expect \(y\) to answer the riddle
in a short time. If \(y\) doesn't manage to solve the riddle, \(x\) will
disconnect the link to \(y\). The same happens the other way: \(y\) will send
\(x\) periodic riddles, and ask \(x\) to solve those riddles. If \(x\) doesn't
manage to solve the riddles in time, \(y\) will disconnect \(x\).

(TODO: Add a picture describing the idea of riddles in a full DHT picture)

This is somehow like the alarm clock applications that make you solve a hard
problem, to prove that you are awake and present. Here we use a riddle to make a
remote computer prove that he is present, and not scattered as many different
nodes in the network.

You might be wondering about the kind of "riddles" we are going to use. As we
are dealing with computers here, it must be a hard riddle. We could use
cryptographic hash functions to create some pretty hard riddles. Assuming that
we have a cryptographic hash function \(f\), A famous riddle is
to find a value \(a\) such that \(f(a|b)\) begins with \(k\) binary zeroes. (By
| we mean concatenation of strings). As \(f\) is some general cryptographic hash
function, we expect that the best strategy to solve this would be to randomize
many values \(a\) until we get that \(f(a|b)\) begins with \(k\) binary zeroes.
We should generate about \(2^k\) random values \(a\) until we get a good result
for \(f(a|b)\). For a large enough \(k\), this would be a hard question for a
computer.

Now let's go back to the Adversary point of view. We want to check if we managed
to bound the amount of corrupt nodes an adversary can insert into the network.
Assume that some adversary wants to insert many corrupt nodes into the network.
Each of those corrupt nodes has to maintain a few links, to be considered as
part of the network. If the adversary wants to insert \(m\) corrupt nodes, and
maintaining links of some node inside the network costs \(t\) basic calculation
units per second, then the adversary will need about \(mt\) basic calculation
units per second to maintain \(m\) corrupt nodes inside the network.

Assuming that the Adversary is capable of \(Q\) calculation units per second, we
get that the maximum amount of corrupt nodes that could stay inside the network
is about \(\frac{Q}{t}\). Note that if the cost of maintaining a node inside the
network, \(t\), is increased, the adversary can insert less corrupt nodes into
the network, however at the same time it becomes less comfortable for a correct
node to stay linked in the network. There is some tradeoff here.

One question that I leave you to think about - How could we avoid the following
situation: Assume that a corrupt node \(z\) is connected to two correct nodes
\(x\) and \(y\). \(x\) sends a riddle \(R\) to \(z\), but \(z\) (As a corrupt
node) doesn't want to invest the time in solving the riddle \(R\). Therefore
\(z\) forwards the riddle \(R\) to \(y\), asking him to solve that riddle. \(y\)
is an innocent correct node, and he solves the riddle \(R\), sending back the
solution \(S\) to \(z\). \(z\) then returns the solution \(S\) back to \(x\),
and \(x\) accepts the solution. This way \(z\) doesn't have to solve any riddles
that \(x\) sends.

As a final note about this example - We managed to find a way to bound the
amount of corrupt nodes in the network, assuming that our adversary is
computationally bounded. We used scarcity of computing power, and linked it to
maintanence of a node in the network.

<h4>Summary</h4>
We described shortly our network enemy - The Adversary, and talked about the
Sybil attack: An attack that happens when too many corrupt nodes are inside the
network. Next we discussed different methods of choosing the Identities for a
DHT from the security perspective. We found that using Hashed IP addresses could
be practical as a DHT Identity, but they rely on the structure of the Internet,
somehow. Finally we showed a simple method of bounding the amount of corrupt
nodes in our network, relying on the scarcity of computing power.

</%block>
