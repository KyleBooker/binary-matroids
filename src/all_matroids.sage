"""
all_matroids.sage

Enumerates simple binary matroids (up to isomorphism) of bounded rank and size
that do not contain a given matroid as a minor. The default excluded minor is
M(K_5), the cycle matroid of the complete graph on 5 vertices.

Output is a dictionary D keyed by pairs (r, k) where r is the rank and
k = n - r (so n = r + k is the number of elements). D[(r, k)] is the list of
non-isomorphic matroids found at that rank and size. The dictionary is also
persisted to "Test.sobj" after each step so partial progress is recoverable.

Targets Sage with Python 2 syntax (the `print s` statements below). Tested
under Sage 8.x. To run on modern Sage (9.0+, Python 3), convert print
statements to function calls.
"""

from sage.matroids.advanced import *

# Excluded minor: the cycle matroid of K_5. Swap in any other matroid here
# (e.g. graphs.CompleteGraph(6), or a Matroid built from an explicit matrix)
# to enumerate matroids that exclude a different minor.
K5 = graphs.CompleteGraph(5)
K5 = Matroid(K5)


def all_matroids(field, maxsize, maxrank):
    """Return a dict of K5-minor-free matroids over `field`, indexed by (rank, size - rank).

    field    -- a Sage finite field, e.g. GF(2)
    maxsize  -- upper bound on the number of elements n
    maxrank  -- upper bound on the rank r

    The enumeration builds matroids inductively via single-element linear
    extensions and coextensions, discarding any candidate that is isomorphic
    to one already kept or that contains K5 as a minor.
    """
    count = 0
    D = {}
    D[(0,0)] = [Matroid(field=field, groundset=[], matrix=[[]])]
    for n in range(1, maxsize + 1):
        e = n
        D[(0,n)] = []
        for r in range(n):
            for M in D[(r, n - 1 - r)]:
                if M.rank() < maxrank + 1:
                    S = [N for N in M.linear_extensions(element=e, simple=True) if e in list(N._weak_partition())[-1]]
                    for N in S:
                        if count == 0 and not any(N.is_field_isomorphic(NN) for NN in D[(r, n - r)]) and not N.has_minor(K5):
                                D[(r, n - r)].append(N)
                                count += 1
            count = 0
            D[(r + 1, n - 1 - r)] = [M.linear_coextension(e, cochain={f:0 for f in M.groundset()}) for M in D[(r, n - 1 - r)] if M.rank() < maxrank]
            save(D, "Test.sobj")
    return D


# Example usage: enumerate K5-minor-free binary matroids up to size/rank 30
# and print a triangle of counts indexed by rank r down each column.
K5min = all_matroids(GF(2), 30, 30)

for n in range(30):
    s = ''
    for r in range(n+1):
        s = s + ' ' + str(len(K5min[(r,n-r)]))
    print s
