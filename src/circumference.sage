"""
circumference.sage

Computes the *minimum circumference* across all matroids of each rank/size
in the enumeration produced by all_matroids.sage. The circumference of a
matroid is the size of its largest circuit; here we take the minimum of that
quantity over the family at each (r, n-r).

Requires the dictionary `K5min` to be in scope -- produced by running
all_matroids.sage first (or by loading "Test.sobj").

Targets Sage with Python 2 syntax.
"""

from sage.matroids.advanced import *

K5 = graphs.CompleteGraph(5)
K5 = Matroid(K5)

# Minimum circumference per (r, n-r). Prints a triangular table to stdout.
for n in range(20):
    s = ''
    for r in range(n+1):
        min = r + 1
        if len(K5min[(r, n-r)]) == 0:
            s = s + ' 0'
        else:
            for matroid in K5min[(r, n-r)]:
                max = 0
                for circuit in matroid.circuits():
                    if max < len(circuit):
                        max = len(circuit)
                if max < min:
                    min = max
            s = s + ' ' + str(min)
    print s
