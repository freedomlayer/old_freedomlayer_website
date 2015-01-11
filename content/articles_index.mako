<%inherit file="/web_page.makoa"/>
<%!
    import os
%>


<%block name="web_page_header">
<title>FreedomLayer | Articles</title>
</%block>

<%def name="article_entry(article_file)">
<%
    link_path = "articles/" + article_file + ".html"
    mako_path = os.path.join(context['my_content_dir'],"articles",article_file) + ".mako"
    post = self.utils.inspect_temp(mako_path,["post_metadata"])
%>
<a href="${self.utils.rel_file_link(link_path)}">${post["post_metadata"]["title"]}</a>
</%def>

<%block name="web_page_body">

<h2>Articles</h2>
<a href="${self.utils.rel_file_link("articles_feed.rss")}">
<img src="${self.utils.rel_file_link("pics/feed_icon_small.png")}"/> Subscribe</a><br/><br/>

<h3>Roadmap</h3>

<lu>
## [Mesh Roadmap and Unsolved Questions](${self.utils.rel_file_link(})
<li>${article_entry("roadmap")}</li>
</lu>

<h3>Intro</h3>

<lu>
## [Intro to the Internet and Current Issues]
<li>${article_entry("intro_internet")}</li>


## [The Mesh Question]
<li>${article_entry("mesh_question")}</li>
</lu>


<h3>Distributed Hash Tables</h3>

<lu>

## [Intro to Distributed Hash Tables]
<li>${article_entry("dht_intro")}</li>

## [Stabilizing Chord]
<li>${article_entry("chord_stabilize")}</li>


## [Basic DHT Security Concepts]
<li>${article_entry("dht_basic_security")}</li>
</lu>


<h3>Mesh Routing</h3>

<lu>
## [Sqrt(n) Mesh Routing]
<li>${article_entry("sqrt_n_routing")}</li>

## [Experimenting with Virtual DHT Routing]
<li>${article_entry("exp_virtual_dht_routing")}</li>

## [The Distributed Post Office: Instant Hierarchy for Mesh Networks]
<li>${article_entry("dist_post_office")}</li>

## [Landmarks Navigation by Random Walking]
<li>${article_entry("landmarks_navigation_rw")}</li>

## [The Unified Challenge-Response: Secure Time inside the Mesh]
<li>${article_entry("unified_challenge_response")}</li>

</lu>


</%block>
