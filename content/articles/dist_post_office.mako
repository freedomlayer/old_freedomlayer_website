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
assume that every person \(X\) in the world meets a few people he trusts on a
regular basis. We also call those trusted regulars of \(X\) the **neighbours**
of \(X\). If \(Y\) is a neighbour of \(X\), we also say that \(X\) is a
neighbour of \(Y\). (These are just the rules of the game).

For the feasibility of things, let's also add in the assumption that
this system is connected. This means: We can get from any person to any other
person using a sequence of neighbours. Or, in other words: If we draw a graph
of all the people in the world (As nodes), and put edges between every person
and his neighbours, then we get a connected graph.

(TODO: Add a picture of a connected graph)

Would these assumptions be enough to let us send a message to anyone in the
world?

A few initial thoughts:

- Person \(A\) can send a package to person \(B\) only if there is a "path" of
  neighbours between \(A\) and \(B\). That means: \(A\) has some neighbour
  \(A_1\), and \(A_1\) has some neighbour \(A_2\) and so on, until finally some
  \(A_k\) has \(B\) as a neighbour.

- The lack of any centralized post office might create the urge to create one.
  This artificial post office might be some person that everyone knows.
  However, picking such a person that is agreed upon all the participants might
  be difficult task.

- What kind of addressing are we going to use for sending packages, if there is
  no central post office? (What are we going to write on the package on the TO
  field?) And what if the network layout changes? Will the address remain
  valid?

<h4></h4>





</%block>
