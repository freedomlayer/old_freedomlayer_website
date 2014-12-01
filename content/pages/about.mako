<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
<title>FreedomLayer | About</title>
</%block>

<%block name="web_page_body" filter="self.filters.mdown">
<h1>About</h1>

Hi. Welcome to the **Freedom Layer** project website.  We work here on designing a
scalable, secure and distributed mesh network, together. We put strong
emphasis on the theoretic side of things, researching algorithms for secure
routing in a flat network. At the same time we strive to implement a practical
real world solution.

These days we are mostly busy with documenting our current knowledge. Some
parts of it are common knowledge, while others are the result of recent
research. We also try to educate newcomers on the core concepts of distributed
mesh networks.

<h2>Current Stage</h2>

We are still in research stages. These days we mostly try to understand how to
route a message securly through a mesh network. We have some good ideas, but we
still have to refine them before we have something that can really work.

We don't have any working code that you can play with at this point. Sorry
:)

<h2>Participate</h2>
There are a few ways in which you can help:

<h3>Think</h3>
If you want to know more about decentralized mesh
networks, begin by educating yourself at the
[articles](${self.utils.rel_file_link("articles_index.html")}) section.

If you have new ideas, or maybe you want to report some flaw you have found,
join in to the discussion at the  [Mailing Lists](${self.utils.rel_file_link("pages/mailing_lists.html")})

<h3>Donate</h3>
The Freedom Layer project is run by volunteers. Donations help us keep the
project running. You can [donate here](${self.utils.rel_file_link("pages/donate.html")}).

<h2>About the Website</h2>
The website's source could be [obtained on
github](https://github.com/realcr/freedomlayer_website). The articles are
written with markdown (With some mathjax latex on top). If you have any
corrections or ideas, don't hesitate to send a pull request. If you are not
sure, you could ask us at the [Mailing
Lists](${self.utils.rel_file_link("pages/mailing_lists.html")}) first.

<h2>Contact</h2>
You can contact us at real(&)freedomlayer.org, or through the [Mailing
Lists](${self.utils.rel_file_link("pages/mailing_lists.html")}).


</%block>
