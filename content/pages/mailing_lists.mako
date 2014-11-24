<%inherit file="/web_page.makoa"/>

<%block name="web_page_header">
<title>FreedomLayer | Mailing Lists</title>
</%block>

<%block name="web_page_body" filter="self.filters.mdown">
<h1>Mailing Lists</h1>

If you want to want to discuss or research topics of this project, you should
join the mailing lists. They are at
[lists.freedomlayer.org](http://lists.freedomlayer.org).

Currently there are two mailing lists:

- [Freedom Layer
  Research](http://lists.freedomlayer.org/listinfo/freedom-layer-research), for
  discussion of research ideas of mesh, networking and security related issues.
  It is also a good place to ask questions about the articles in this website.

- [Freedom Layer
  Meta](http://lists.freedomlayer.org/listinfo/freedom-layer-meta), for anything meta.


We are still experimenting with those mailing lists, as they are a bit new, so
stay tuned. 

For the interested, the lists are powered by
[Mailman](http://www.gnu.org/software/mailman/). You can find the repository
for making it work [here [github]](https://github.com/realcr/mailman_docker).

</%block>
