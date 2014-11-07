<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
    <title>Index page</title>
    ## mathjax:
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

<%block filter="self.filters.math_mdown">
This is a test for some text.

Inline math example: \( \frac{n!}{k!(n-k)!} = \binom{n}{k} \).

Display math example: $$ \frac{n!}{k!(n-k)!} = \binom{n}{k} $$

Some more text.

</%block>
</%block>

