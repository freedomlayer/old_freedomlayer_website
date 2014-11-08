<%inherit file="/blog_post.makoa"/>

<%def name="post_metadata()">
<%
    return {\
    "title": "Blog post test.",\
    "date": "2014-11-05 11:20",\
    "author": "real",\
    "tags": []}
%>
</%def>

<%block name="blog_post_body" filter="self.filters.math_mdown">

Example blog post.
Some math: \( A \subseteq B \)
Some displayed math: $$ A \subseteq B$$

Some code:

	:::python
        def a_star(self,src,dst,w=1):
            """
            A_star algorithm from src to dst, assuming that h is good (monotonic)
            See:
            http://en.wikipedia.org/wiki/A*_search_algorithm
            For more information.

            w is the weight
            """
            def h(x):
                """
                (Admissible h function)
                Lower bound of the distance between
                x and the destination vertex dst.
                """
                return w*self.obs_max_dist(x,dst)
                

            # We count the amount of expanded nodes.
            num_expanded = 1

            # Initialize g and f lists:
            g_score = {}
            f_score = {}
            came_from = {}
            closedset = set()
            openset = set([src])
            dst_coord = self.get_coord(dst)

            g_score[src] = 0
            f_score[src] = g_score[src] + h(src)

            while len(openset) > 0:
                num_expanded += 1
                # We tie break by adding x in the tuple.
                current = min(openset,key=lambda x:(f_score[x],x))
                # if self.get_coord(current) == dst_coord:
                #    assert current == dst
                if current == dst:
                    path = reconstruct_path(came_from,dst)
                    return True,len(path),len(closedset)

                openset.remove(current)
                closedset.add(current)

                for nei in self.graph.neighbors_iter(current):
                    if nei in closedset:
                        continue
                    # The distance between neighbors is always 1 in our network.
                    # Maybe later we could change it to something else?
                    tent_g_score = g_score[current] + 1

                    should_update = False
                    if nei in openset:
                        if tent_g_score < g_score[nei]:
                            should_update = True
                    else:
                        should_update = True

                    if should_update:
                        h_nei = h(nei)
                        came_from[nei] = current
                        g_score[nei] = tent_g_score
                        f_score[nei] = g_score[nei] + h_nei
                        if nei not in openset:
                            # print(h(nei),current_upperbound)
                            openset.add(nei)

            # We get here if destination was not found:
            return False,0,len(closedset)


Some more text.

</%block>
