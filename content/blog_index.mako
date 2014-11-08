<%inherit file="/web_page.makoa"/>
<%namespace name="bindex" module="content.bindex"/>

<%block name="web_page_header">
<title>FreedomLayer | Blog</title>
</%block>

<%block name="web_page_body">
<h1>Blog</h1>
    <%
        b_entries = bindex.get_blog_entries()
    %>

    <ul>
    % for b_entry in b_entries:
	<li>
        <a href="${b_entry["link_addr"]}">
        ${b_entry["props"]["post_metadata"]["title"]}</a>
	</li>
        
    % endfor
    </ul>
</%block>

