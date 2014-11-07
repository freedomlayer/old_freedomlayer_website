<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
	<title>Index page</title>
</%block>

<%block name="web_page_body">
	<h1>Index</h1>
	This is the index webpage.
	<br/>
	<img src="${self.utils.rel_file_link("pics/balls.png")}"/>
	<br/><br/>
</%block>

