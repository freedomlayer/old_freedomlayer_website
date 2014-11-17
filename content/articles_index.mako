<%inherit file="/web_page.makoa"/>
<%namespace name="ar_index" module="content.ar_index"/>

<%block name="web_page_header">
<title>FreedomLayer | Articles</title>
</%block>

<%block name="web_page_body">
<h1>Articles</h1>
    <%
        a_entries = ar_index.get_articles()
    %>

    <ul>
    % for a_entry in a_entries:
    <%
        pmeta = a_entry["props"]["post_metadata"]
    %>
	
	
	<li>
        <a href="${a_entry["link_addr"]}">
        ${pmeta["title"]}</a>
	</li>
        
    % endfor
    </ul>
</%block>

