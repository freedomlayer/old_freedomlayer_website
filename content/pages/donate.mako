<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
<title>FreedomLayer | Donate</title>
</%block>

<%block name="web_page_body" filter="self.filters.mdown">
<h1>Donate</h1>

Hi there. This website is run by volunteers that care about the future of the
Internet.  Donations from people like you help us keep doing our job.

Money from donations will be used for:

- Covering servers and domains costs.

- Covering the time invested in research and articles.

<br/><br/>
Donations could be sent using paypal, by clicking on this button:
<%include file="/pages/paypal_button.makoa" />


</%block>
