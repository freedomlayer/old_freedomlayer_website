<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
    <title>Index page</title>
    <script type="text/javascript"
        src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
    </script>
</%block>

<%block name="web_page_body">
	<h1>Index</h1>
	This is the index webpage.
	<br/>
	<img src="${self.utils.rel_file_link("pics/balls.png")}"/>
	<br/><br/>

<%block filter="self.filters.mdown_math">
This is a test for some text.
<h1>This is big text.</h1>

$$ A \subseteq B $$
usual line.
$$ x < y $$
$$ x <y $$

And this is inline: \(a \neq b\) as wanted.



Some more text.

</%block>
</%block>

