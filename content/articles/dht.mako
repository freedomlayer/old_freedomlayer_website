<%inherit file="/article.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Distributed Hash Tables (DHTs)",\
    "date": "2014-11-11 13:07",\
    "author": "real",\
    "number":3,\
    "tags": []}

%>
</%def>

<%block name="article_body" filter="self.filters.math_mdown">

<h3>Building a phone list</h3>
I want to begin with an example from life. You might want to read it even if you
have some general knowledge about DHTs, because it might give you some new
ideas about where DHTs come from.

On your cellphone, most likely you have a list of contacts. Could you maintain
contact with all your friends without having this list?
More specifically - What if every person in the world could remember only about
40 phone numbers. Given that structure, could we make sure that every person in
the world will be able to call any other person in the world?

<h4>First solution - Phone ring</h4>
<h5>General structure</h5>
A simple solution would be as follows: We sort the names of all the people in
the world into a very big list. (Assume that people have unique names, just for
this article :) ). Next, every person will have the responsibility of
remembering two phone numbers: The phone number of the next person on the list,
and the phone number of the previous person on the list.

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


Then Britney will keep the phone number of Benito and of Cassi. Cassi, in turn,
keeps the phone numbers of Britney and Cleotilde. Cleotilde keeps the phone
numbers of Cassi and Colene, and so on. 

The list is cyclic. You can think of it as a ring, more than as a list. The
last person on the list will remember the phone numbers of the previous person,
and the phone number of the first person on the list.  The first person on the
list will remember the phone number of the second person on the list, and the
phone number of the last person on the list. (In our list, it means that Benito
keeps the phone numbers Georgine and of Britney)

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht/linear_dht_circle.svg")}"/>
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
Assume that some person \(X\) wants to join the famous phone list. How can we
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
src="${self.utils.rel_file_link("articles/dht/join_linear_dht_circle.svg")}"/>
(The new state of the list, after Gary has joined.)<br/><br/>

<h5>Analysis</h5>
Whenever person \(A\) wants to find person \(B\) on the list, he will have to
traverse the list of people one by one until he finds \(B\). It could take a
very short time if \(A\) and \(B\) are close on this list, however it could
also take a very long time if \(A\) and \(B\) are very var (In the cyclic
sense. In the worst case, \(B\) is right before \(A\) on the list).

However we could find the average time it takes for \(A\) to contact \(B\). It
would be about \(\frac{n}{2}\), where \(n\) is the amount of people on the
list.

In addition, we can also measure the amount of memory used for each of the
people on the list. Every person is responsible for remembering exactly two
people's name and phone number. (The previous one and the next one). 

Whenever a person wants to call someone, he will have to remember another
additional phone number, which is the next person he is going to call. This is
not much to remember though.

In more mathematical terms, we say that a search (or a query) costs \(O(n)\)
operations, and every person on the list has to maintain memory of size
\(O(1)\).

Joining the network also costs \(O(n)\) operations. (That is because joining
the network requires a search).

<h4>Improving search speed</h4>
So far we managed to prove that we could live in a world without contact lists.
We just have to remember a few names and phone numbers (In the simple solution
above: only 2 names and phone numbers) to be able to call anyone eventually.
Though "eventually" is usually not enough. We don't want to call half of the
world to be able to contact one person. It is not practical.

Just imagine this: Every time that someone in the world wants to call someone
else, there is a probability of \(\frac{1}{2}\) that he will call you on the
way! Your phone will never stop ringing.

What if we could somehow arrange the phone list so that we will need to call
only a few people for every search? Maybe if we remember a bit more than 2
people's phone number, we could get a major improvement in search performance.

<h5>Adding more immediate links</h5>
A first idea for improving the phone list would be that each person will
remember more of his list neighbours phone numbers.
Instead of remembering just the previous and the next on the list, why not
remember the two previous and the two next people on the list?

In this structure, every person has to remember \(4\) names and phone numbers,
which is not so much more than the \(2\) that we previously had. However, the
improvment in the search operation is major: A search operation will now cost
an average of \(\frac{n}{4}\) operations, instead of \(\frac{n}{2}\) that we
had previously. (Implicitly, it also improves the cost of joining the network).

We can add more and more records to remember for each of the people on the
phone list, to get further improvment in the speed of one search operation.
If each person on the list remembers \(k\) neighbors forward
and backwards on the list, then the search opeartion will be \(k\) times
faster. As \(k\) can't be so big (Generally we will assume that people on the
list can not remember more than \(O(\log(n))\) stuff), we can only get so far
with this method.

Maybe if we choose to remember only specific people on the list in some special
way, we could get better results.

<img class="wimage"
src="${self.utils.rel_file_link("articles/dht/double_linear_dht_circle.svg")}"/>
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

Before dealing with solving this problem, I want to discuss the requirments.
Lets begin with the first requirement. What does it mean to be able to
"contact" other computers? Let me give you a simple use case. Lets assume that
every computer holds some chunk of information, some kind of a very big table.
Maybe this table is a distributed database. Maybe part of a file sharing
protocol. We want to make sure that every computer can reach any other
computer, to obtain data for example.

Regarding the second requirement - Every computer can remember only a few
addresses.  Why can't every computer keep the addresses of all the other
computers? Well, there are a few practical reasons for that. First - There
might be a lot of computers. \(n\) might be very large, and it might be heavy
for some computers to remember a list of \(n\) addresses. In fact, it might be
more than remembering \(n\) addresses. A [TCP
connection](http://en.wikipedia.org/wiki/Transmission_Control_Protocol) between
two computers, for example, has to be maintained somehow. It takes effort to
maintain it.

But there is another reason. Maybe a more major one. We want that this set of
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

Every node will be connected to the previous and next nodes on the ring.
Searching a node (By his unique name) will be done by iteratively asking the
next node for the name and address of the next next node, until the wanted node
is found.

Joining the network is as described in the phone list case. If a node \(X\)
wants to leave the network, he will inform his two neighbours \( R,Q \) on the
ring that he wants to leave, and ask them to connect to each other (He will
also tell \(R\) about \(Q\)'s address and vice versa).

<h4>Improving Search</h4>


</%block>
