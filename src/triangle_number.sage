"""
triangle_number.sage

Computes the maximum *triangle number* (count of 3-element circuits) per
(rank, size - rank) bucket in the K5-minor-free enumeration. Triangles are
the smallest nontrivial circuits in a simple matroid; their count is a
useful structural statistic when bounding matroid size by rank.

Requires the dictionary `K5min` to be in scope -- produced by running
all_matroids.sage first (or by loading "Test.sobj").

Targets Sage with Python 2 syntax.
"""

from sage.matroids.advanced import *

Test = Matroid(field=GF(2), groundset=[], matrix=[[]])


for n in range(20):
    s = ''
    for r in range(n+1):
        if len(K5min[(r, n-r)]) == 0:
            s = s + ' 0'
        else:
            min_matroid = 0
            TEST = 0
            for matroid in K5min[(r, n-r)]:
                    count = 0
                    for circuit in matroid.circuits():
                        if len(circuit) == 3:
                            count += 1
                    if count > TEST:
                        TEST = count
            if TEST > min_matroid:
                min_matroid = TEST
            if min_matroid == 100:
                s = s + ' 0'
            else:
                s = s + ' ' + str(min_matroid)
    print s
