<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Intro to Distributed Hash Tables (DHTs)",\
    "date": "2014-11-11 13:07",\
    "author": "real",\
    "number":3,\
    "tags": []}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">
<h3>Abstract</h3>
We introduce the idea of the Chord DHT from scratch, giving some intuition for
the decisions made in the design of Chord.

<h3>Building a phone list</h3>
I want to begin with an example from life. You might want to read it even if you
have some general knowledge about DHTs, because it might give you some new
ideas about where DHTs come from.

On your cellphone, most likely you have a list of contacts. Could you maintain
contact with all your friends without having this list?
More specifically - What if every person in the world could remember only about
40 phone numbers. Given that structure, could we make sure that every person in
the world will be able to call any other person in the world?

In the spirit of no hierarchical related solutions, we will also want to have a
solution where all the participants have more or less symmetric roles.

<h4>First solution - Phone ring</h4>
<h5>General structure</h5>
A simple solution would be as follows: We sort the names of all the people in
the world into a very big list. (Assume that people have unique names, just for
this article :) ). Next, every person will have the responsibility of
remembering one phone number: The phone number of the next person on the list.

As an example, if the list is as follows:

    Benito Kellner  
    Britney Antonio  
    Cassi Dewolfe  
    Cleotilde Vandyne  
    Colene Kaufmann  
    Cordell Varley  
    Denae Fernandez  
    Donnette Thornberry  
    Edwin Peters  
    Georgine Reneau  


Then Britney will keep the phone number of Cassi. Cassi, in turn,
keeps the phone number of Cleotilde. Cleotilde keeps the phone
number of Colene, and so on. 

The list is cyclic. You can think of it as a ring, more than as a list. The
last person on the list will remember the phone number of the first person on
the list.
(In our list, it means that Georgine keeps the phone number of Benito).

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht_intro/linear_dht_circle.svg")}"/>
(The phone list drawn as a ring, with lines representing the connection between
people on the list.)<br/><br/>

Now assume that Benito wants to call Edwin. How can he do that? He will first
call Britney, because he knows her phone number. He will ask Britney for the
name and phone number of the next person on the list. That would be Cassi.

Next Benito will call Cassi, and ask her for the name and phone number of the
next person on the list. That would be Cleotilde. At this point Benito can
forget the name and phone number of Cassi, and move on to calling Cleotilde.
Benito will keep advancing in the list until he finally finds Edwin.

We call this operation of finding someone on the list a query, or a search.

<h5>Joining the ring</h5>
Assume that some person \(X\) wants to join the phone list. How can we
add \(X\) so that the structure is preserved?

\(X\) will first contact some person \(Y\) that is already on the list. Let us
assume that \(X\) contacts Denae for example. Denae will then search for a
suitable place for \(X\) on the cyclic list, so that the list will stay sorted.
If in our example \(X\) is Gary Jablonski, Then Denae search will yield that
Gary should be put between Edwin and Georgine.

After \(Y\) Finds a place for \(X\) on the list, \(Y\) will tell \(X\) about
his designated location in the list. Then \(X\) will join the list at this
place. (We assume that \(X\) is a good person, and he will just go to his
designated place without giving us any trouble.)

Following our example of Gary Jablonski joining the list, the new list will
look somehow like this:

    Benito Kellner  
    Britney Antonio  
    Cassi Dewolfe  
    Cleotilde Vandyne  
    Colene Kaufmann  
    Cordell Varley  
    Denae Fernandez  
    Donnette Thornberry  
    Edwin Peters  
    Gary Jablonski  
    Georgine Reneau  

Of course that in the new setting, Edwin for example now has to remember only
Gary's phone. He shouldn't keep remembering Georgine's phone number, because
it is not needed anymore.

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht_intro/join_linear_dht_circle.svg")}"/>
(The new state of the list, after Gary has joined.)<br/><br/>

<h5>Analysis</h5>
Whenever person \(A\) wants to find person \(B\) on the list, he will have to
traverse the list of people one by one until he finds \(B\). It could take a
very short time if \(A\) and \(B\) are close on this list, however it could
also take a very long time if \(A\) and \(B\) are very far (In the cyclic
sense. In the worst case, \(B\) is right before \(A\) on the list).

However we could find the average time it takes for \(A\) to contact \(B\). It
would be about \(\frac{n}{2}\), where \(n\) is the amount of people on the
list.

In addition, we can also measure the amount of memory used for each of the
people on the list. Every person is responsible for remembering exactly one
people's name and phone number. (The next one on the list). 

Whenever a person wants to call someone, he will have to remember an additional
phone number, which is the next person he is going to call. This is not much to
remember though.

In more mathematical terms, we say that a search (or a query) costs \(O(n)\)
operations, and every person on the list has to maintain memory of size
\(O(1)\).

Joining the network also costs \(O(n)\) operations. (That is because joining
the network requires a search).

<h4>Improving search speed</h4> So far we managed to prove that we could live
in a world without contact lists.  We just have to remember a few names and
phone numbers (In the simple solution above: only one name and one phone
number) to be able to call anyone eventually.  Though "eventually" is usually
not enough. We don't want to call half of the world to be able to contact one
person. It is not practical.

Just imagine this: Every time that someone in the world wants to call someone
else, there is a probability of \(\frac{1}{2}\) that he will call you on the
way! Your phone will never stop ringing.

What if we could somehow arrange the phone list so that we will need to call
only a few people for every search? Maybe if we remember a bit more than one
people's phone number, we could get a major improvement in search performance.

<h5>Adding more immediate links</h5>
A first idea for improving the phone list would be that each person will
remember more of his list neighbours phone numbers.
Instead of remembering just the next on the list, why not remember the two next
people on the list?

In this structure, every person has to remember \(2\) names and phone numbers,
which is not so much more than the \(1\) that we previously had. However, the
improvement in the search operation is major: A search operation will now cost
an average of \(\frac{n}{4}\) operations, instead of \(\frac{n}{2}\) that we
had previously. (Implicitly, it also improves the cost of joining the network).

We can add more and more records to remember for each of the people on the
phone list, to get further improvement in the speed of one search operation.
If each person on the list remembers \(k\) neighbors forward
on the list, then the search operation will be \(k\) times
faster. As \(k\) can't be so big (Generally we will assume that people on the
list can not remember more than \(O(\log(n))\) stuff), we can only get so far
with this method.

Maybe if we choose to remember only specific people on the list in some special
way, we could get better results.

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht_intro/double_linear_dht_circle.svg")}"/>
(The list with \(k=2\). Search operation is twice as fast.)<br/><br/>

<h3>Chord</h3>
So far we have discussed a very nice phone list game, and you might not
understand why care about it at all.
Let me formulate the question differently. Assume that we have a set of
\(n\) computers, or nodes, connected to the Internet (The good old internet that
you know and use). Each computer has some kind of unique name. (The unique name
is not his Internet Address.) 

We want to create a communication structure (Or an overlay network) that
satisfies the following requirements: 

1.  Each computer will able to "contact" each of the other computers.
2.  Every computer can remember the addresses of only about \(O(\log(n))\)
    other computers' addresses.
3.  Computers might join or leave the network from time to time. We would like
    to be able to allow that while preserving the general structure of the
    network.

Before dealing with solving this problem, I want to discuss some of the
requirements.  Lets begin with the first requirement. What does it mean to be
able to "contact" other computers? Let me give you a simple use case. Lets
assume that every computer holds some chunk of information, some kind of a very
big table.  Maybe this table is a distributed database. Maybe part of a file
sharing protocol. Maybe something else. We want to make sure that every
computer can reach any other computer, to obtain data for example.

Regarding the second requirement - Every computer can remember only a few
addresses. Why can't every computer keep the addresses of all the other
computers? Well, there are a few practical reasons for that. First - There
might be a lot of computers. \(n\) might be very large, and it might be heavy
for some computers to remember a list of \(n\) addresses. In fact, it might be
more than remembering \(n\) addresses. A [TCP
connection](http://en.wikipedia.org/wiki/Transmission_Control_Protocol) between
two computers, for example, has to be maintained somehow. It takes effort to
maintain it.

But there is another reason. Probably a more major one. We want that this set of
computers will be able to change with time. Some computers might join, and
others might leave from time to time. If every computer is to remember all the
addresses of all the other computers, then every time a computer joins this
set, \(n\) computers will have to be informed about it. That means joining the
network costs at least \(O(n)\), which is unacceptable.

If we want computers in this set to be able to bear the churn of computers
joining and leaving, we will have to build a structure where every computer
maintains links with only a small number of other computers.

<h4>Adapting the phone ring solution</h4>
As you have probably noticed, this problem is not very different from the phone
list problem. Just replace Computers with People, Computers' unique identities
with the people's unique names, and Computer's Internet Addresses (IPs) with
People's phone numbers. (Go ahead and do it, I'm waiting :) )

So the solution for the Computer's case is as follows:
First we sort the node's names somehow. (If the nodes' unique names are numbers, we
just use the order of the natural numbers). Then we build a ring that contains
all the nodes, ordered by their name. (We just think about it as ring, we don't
really order the nodes physically in a ring, just like we didn't order the
people in a circle when we dealt with the phone list problem)

Every node will be linked to the next node on the ring.
Searching a node (By his unique name) will be done by iteratively asking the
next node for the name and address of the next next node, until the wanted node
is found.

Joining the network is as described in the phone list case. (Leaving the
network is a subject we will discuss in a later time.)

Here, just like in our description of the previous problem (The phone list), we
could also improve the speed of search if every node will keep more links to
direct neighbours. However, as we have seen before, we can only get so much
improvement in this method, and we would like to find a better idea for link
structures between the nodes.

<h4>Improving the Search</h4>
The following leap of thought could be achieved in more than one way. One way
to begin with it to think ituitively about how we manage to find things in the
real world.

<h5>Intuition from real world searching</h5>
Lets assume that you want to get to some place, and you are not sure where it
is. A good idea would be to ask someone how to get there. If you are very far
from your destination, most likely the person you asked will give you a very
vague description of how to get there. But it will get you starting in the
correct direction.

After you advance a while, you can ask somebody else. You will get another
description, this time more a detailed one. You will then follow this
description, until you get closer.

Finally when you are really close, you will find someone that knows exactly
where is that place you are looking for. Then your search will end.

This might lead us to think that maybe the network of links between nodes
should be arranged as follows:

-   Every node \(X\) is "linked" to nodes with names closest to his name. (His two
    immediate neighbors on the ring, for example).

-   Every node \(X\) is connected to other nodes from the ring: As the distance
    \(X\) becomes greater, \(X\) is connected to less and less nodes.

Generally: \(X\) knows a lot about his close neighbourhood, however he knows
little about the parts of the rings that are far.

<h5>Binary Search</h5>
A different way to look at the search problem is from the angle of a more
common method: [Binary
search](http://en.wikipedia.org/wiki/Binary_search_algorithm). Given a sorted
array, we could find an element inside the array in \(O(log(n))\) operations,
instead of the naive \(O(n)\).

How could we apply Binary Search to our case? In the binary search algorithm in
every iteration we cut the array to two halves, and then continue searching in
the relevant half. We can do that because we have [random
access](http://en.wikipedia.org/wiki/Random_access) to the elements of the
array. That means - We could access any element that we want immediately. We
could access the middle element immediately.

In the simple ring setting (Every node is connected to the next and previous
nodes) we don't have random access. However we could obtain something similar
to random access if we added the right links from every node. Take some time to
think about it. How would you wire the nodes to obtain the "random access
ability"?

<h5>Binary search Wiring</h5>

To explain the next structure of links I want to discuss some notation stuff
first. We assume that the names of all the nodes are numbers that could be
represented using \(s\) bits. In other words, the names of nodes are from the
set: \(B_s := \{0,1,2,\dots,2^{s}-1 \}\). The details here don't really matter.
All that matters is that \(2^{s} \geq n\), so that there are enough possible
unique names for all the nodes in the network.

We also want to treat the set \(B_s\) as cyclic
[modulo](http://en.wikipedia.org/wiki/Modulo_operation) \(2^{s}\).

Let \(x\) be some node on the ring. (\(x\) is the name of this node. \(x \in
B_s\)). We will connect \(x\) to the following nodes on the ring:

- \(\left\lceil{x + 1}\right\rceil\)
- \(\left\lceil{x + 2}\right\rceil\)
- \(\left\lceil{x + 4}\right\rceil\)

\(\cdots\)

- \(\left\lceil{x + 2^{s-1}}\right\rceil\)

The notation \(\left\lceil{y}\right\rceil\) means the first node
that his name is bigger than \(y\).

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht_intro/log_wiring.svg")}"/>
In the picture: The ring represents the set \(B_s\) of possible names for
nodes. (With \(s = 6\)). Blue points are existing nodes. Their location on the ring represents
their name. Cuts on the ring represent the exact locations of \(x+1,
x+2,\dots,x+2^{s-1}\). The nodes of the form \(\left\lceil{x +
2^{q}}\right\rceil\) are marked on the ring.
The green lines represents links from the node \(x\) to other
nodes.<br/><br/>

Follow the picture and make sure you understand what \(\left\lceil{x +
2^{q}}\right\rceil\) means - It is the "first" (clockwise) node with a name
bigger than the number \(x + 2^{q}\) on the ring.

This idea of wiring is also known as a [Skip
list](http://en.wikipedia.org/wiki/Skip_list).

<h5>New Search Algorithm</h5>
Let's describe the searching process with the new links structure.
Assume that node \(x\) (\(x \in B_s\) is the name of the node) wants to reach
node \(y\). Node \(x\) will first check his own list of links, and see if he is
already connected directly to \(y\). If this is the case, \(x\) can reach
\(y\).

But \(x\) will not be that lucky every time. if \(y\) is not in \(x\)'s links
list, then \(x\) will choose the "closest" option - a node \(x_1\) that is the
closest \(x\) knows to \(y\). By "closest" we mean the closest when walking
clockwise. (As an example, the node just before \(x\) on the ring is the farest
node from \(x\)).

\(x\) will ask \(x_1\) if he knows \(y\), and if he doesn't, \(x\) will ask
\(x_1\) what is the closest node to \(y\) known to \(x_1\)? Let that node be
\(x_2\).

\(x\) will keep going, until he eventually finds \(y\). We should analyze this
algorithm to make sure that indeed \(x\) eventually finds \(y\), and also how
many iterations it takes to find \(y\).

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht_intro/x_search_y.svg")}"/>
(Illustrated search process)<br/><br/>

<h5>Analysis</h5>
Let us start with the simple things. How many links every node has to maintain?
By the definitions of links earlier, we know that not more than \(s\) links. We
said that the size of the set \(B_s\) must be more than \(n\), therefore
\(2^{s} \geq n\), which means \(s \geq \log(n)\). Therefore every node
maintains about \(\log(n)\) links. This is generally a reasonable number, even
for very large \(n\)-s.

Next, we want to know how long does it take for a node \(x\) to find some
random node \(y\). In fact, we want to be sure that \(x\) always manages to
find \(y\) eventually.

If you are not in a mood for some math symbols, I give here a short description
of what is going to happen. We are soon going to find out that in every
stage of the search algorithm we get twice as close to \(y\). As the size of
the set \(B_s\) is \(2^{s}\), we are going to have no more than \(s\) stages
before we find \(y\). This also proves that we always manage to find \(y\).

Now let's do some math.
We define the distance (going clockwise) between two nodes \(a\) and \(b\) to
be \(d(a,b)\). If \(b > a\) then \(d(a,b) = b-a\). Otherwise \(d(a,b) = 2^{s} +
b - a\). (Think why).

Back to the searching algorithm, we can note that at every stage we are at
point \(x_t\) on the ring, and we want to reach \(y\). We will pay attention to
the amount \(d(x_t,y)\) at any stage of the algorithm.

We begin from \(x\). If \(x\) is not directly connected to \(y\), then \(x\)
finds the closest direct link he has to \(y\). Let that node be \(x_1\). As
\(x\) is linked to \(\left\lceil{x + 1}\right\rceil, \left\lceil{x +
2}\right\rceil, \left\lceil{x + 4}\right\rceil \dots ,\left\lceil{x +
2^{s-1}}\right\rceil \), we conclude that
\(d(x_1,y) < \frac{1}{2}\cdot d(x,y)\). 

Let me explain it in a more detailed fashion:
Assume that \(y = x +q\) for some \(q\) (The addition of \(x + q\) might be
modulo the set \(B_s\)). There is some integer number \(r\) such that \(2^{r}
\leq q < 2^{r+1}\). (You could understand it by counting the amount of bits in the
[binary representation](http://en.wikipedia.org/wiki/Binary_number) of \(q\)
for example). Therefore the closest link from \(x\) to \(y\) would be
\(\left\lceil{x + 2^{r}}\right\rceil = x_1\). 
And indeed, we get that \(d(x_1,y) = d(x_1,x+q) \leq d(x+2^r,x+q) \leq q - 2^r
 < \frac{q}{2} = \frac{d(x,y)}{2}\). So we get that \(d(x_1,y) < \frac{d(x,y)}{2}\).

The same is true at the next stages of the algorithm (When finding
\(x_2,x_3,\dots\), therefore we conclude that on every stage we get
twice closer to \(y\), compared to the previous stage. Finally we get that
\(d(x_q,y) < \frac{1}{2}\cdot d(x_{q-1},y) < \frac{1}{4}\cdot d(x_{q-2},y) <
\dots < \frac{1}{2^{q}}\cdot d(x,y)\)

We know that the initial distance \(d(x,y)\) is no more than \(2^{s}\),
therefore in at most \(s\) stages we will reach distance \(0\), which means we
have found \(y\).

If you are a careful reader, you might be worried at this point that \(s\)
might be much more than \(\log(n)\). This is in fact true. It is also true that
in some worst case scenarios the amount of stages for the search algorithm will
actually be \(s\), even if \(log(n)\) is much smaller.

However if the names of the nodes are chosen somehow uniformly from the set
\(B_s\), we should expect better results which are much closer to \(log(n)\).

<h4>Some words about Chord</h4>
Congratulations, you now know how to wire a collection of \(n\) nodes so that
they can contact each other quickly, and at the same time each node doesn't have to
remember too many addresses of other nodes.

The construct we have described is related to an idea called [The Chord
DHT](http://en.wikipedia.org/wiki/Chord_(peer-to-peer)). You can find the
original article
[here](http://pdos.csail.mit.edu/papers/chord:sigcomm01/chord_sigcomm.pdf)


<h3>Distributed Hash Tables (DHTs)</h3>

Lets discuss an important use case for the structure we have found so far.
We want to be able to store a large table of keys and values over a large set
of computers. This is usually called a [Distributed Hash Table
(DHT)](http://en.wikipedia.org/wiki/Distributed_hash_table).

The main operations that we want to be able to perform are as
follows:

- set_value(key,value) - Sets the value of "key" in the table to be "value".

- get_value(key) - Reads the value of "key" from the table.

The cool part is that we can invoke those operations from any of the computers,
as all the computers have a symmetric role in the network. Instead of letting
just one computer deal with requests from client, theoretically we could use
all the computers on the network. (Though we might have to deal with some
synchronization stuff, which are outside the scope of this document).

There are still some questions to be asked here. What kind of values can the
keys be? Must they be numbers, or could they be something else? Maybe
strings?

Lets begin with the case in which keys are also from the set \(B_s\). This is
not always very realistic, but it would be easier to solve at this point. In that
case, the keys are in the same "space" as the names of nodes.

We could let node \(\left\lfloor{k}\right\rfloor\) keep the value of key \(k\),
where \(\left\lfloor{k}\right\rfloor\) is the "last" node (clockwise) that has
a name not bigger than the number \(k\).

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht_intro/responsible_keys.svg")}"/>
In the picture: The node \(z\) (A blue dot), and some keys that \(z\) is
responsible to keep (Small orange dots). The keys and node names are of the
same kind (Both are from \(B_s\), so we can also draw them on the ring
according to their value. The next node (clockwise) after \(z\) marks the end
of the domain \(z\) has responsibility over.<br/><br/>

To invoke set_value(key=k,value=v), we first search (Using our search
algorithm) for the node that is responsible for keeping the key \(k\). This is
done by searching for the value \(k\). We are going to find the node \(z =
\left\lfloor{k}\right\rfloor\), which is exactly the node that has the
responsibility to keep the key \(k\). Then we just ask the node \(z\) to update
\(k\) to have the value \(v\).

To invoke get_value(key=k), again we search for \(k\), and find the node \(z =
\left\lfloor{k}\right\rfloor\). We then ask \(z\) what is the value that
corresponds to the key \(k\). \(z\) will then tell us the value \(v\).

<h4>Dealing with complex keys</h4>

But what if our keys are not from the set \(B_s\)? Maybe the keys are strings?
Maybe they are names of files, or people? In that case all we need is some
function \(f: K\rightarrow B_s\), where \(K\) is the world of keys. Hopefully
the function \(f\) will also be some kind of a random function, which means
a few things:

- It is very unlikely for two keys \(k_1,k_2\) to satisfy \(f(k_1) = f(k_2)\).
  (A property also known as [Collision Resistance](http://en.wikipedia.org/wiki/Collision_resistance)).

- The keys will map evenly as possible between all the elements inside the set
  \(B_s\). We don't want to have too much load of a few of the computers.

If you were wondering where you can get such a function, don't worry. We have a
few of those functions. They are called [Cryptographic Hash
Functions](http://en.wikipedia.org/wiki/Cryptographic_hash_function).

Now that we have the function \(f\), we will define two operations:

- 	set_key_generic(key=k,value=v) will invoke
  	set_key(key=\(f(k)\),value=v).

- 	get_key_generic(key=k) will invoke get_key(key=\(f(k)\))

And we get a DHT for a generic key space.

<h3>Final Notes</h3>
We have introduced a special way to wire a set of computers, so that we don't
use too many wires, and at the same time it is easy to find any computer
quickly. A major use case of this construct is the idea of DHT.

Our main construction follows the idea of the [The Chord
DHT](http://en.wikipedia.org/wiki/Chord_(peer-to-peer)), however there are
other possible designs for DHT which we haven't talked about. Our space of
names was a ring, with a distance function of walking clockwise. There are
other spaces with different distance functions that give nice results. One
notable example is the [Kademlia DHT](http://en.wikipedia.org/wiki/Kademlia),
which uses XOR as a metric.

We discussed the problem generally, but we didn't address a few important
issues. We didn't address stability issues (What happens if some node on the
way goes offline just when we want to search for some key?) and security
issues. (What happens if a node gives us a wrong value for the key? Could an
adversary block users from getting the value of a specific key in the DHT?)

We will think about those topics and how to deal with some of them in the next
articles.
</%block>
