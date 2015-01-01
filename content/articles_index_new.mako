<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
<title>FreedomLayer | About</title>
</%block>

<%def name="article_entry(article_file)">
<%
    article_path = "articles/" + article_file
    post_meta = self.utils.inspect_temp(context,article_path,"post_metadata")
    
    return post_meta

%>
<a href="${self.utils.rel_file_link(article_path)}">${post_meta["name"]}</a>
</%def>

<%block name="web_page_body" filter="self.filters.mdown">

<h2>Articles</h2>
<a href="${self.utils.rel_file_link("articles_feed.rss")}">
<img src="${self.utils.rel_file_link("pics/feed_icon_small.png")}"/> Subscribe</a><br/><br/>

<h3>Roadmap</h3>

- ${article_entry("roadmap.mako")}
## - [Mesh Roadmap and Unsolved Questions](${self.utils.rel_file_link(})

<h3>Intro</h3>

- [Intro to the Internet and Current Issues]

- [The Mesh Question]


<h3>Distributed Hash Tables</h3>

- [Intro to Distributed Hash Tables]

- [Stabilizing Chord]

- [Basic DHT Security Concepts]


<h3>Mesh Routing</h3>

- [Sqrt(n) Mesh Routing]

- [Experimenting with Virtual DHT Routing]

- [The Distributed Post Office: Instant Hierarchy for Mesh Networks]

- [Landmarks Navigation by Random Walking]

- [The Unified Challenge-Response: Secure Time inside the Mesh]


</%block>
