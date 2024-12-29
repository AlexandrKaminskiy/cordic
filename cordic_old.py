from math import atan2

from fxpmath import Fxp
import numpy as np
import math


e = 0.6072529350089735

ITERATIONS = 10

LUT = np.array([
    math.atan(2.0 ** 0),
    math.atan(2.0 ** -1),
    math.atan(2.0 ** -2),
    math.atan(2.0 ** -3),
    math.atan(2.0 ** -4),
    math.atan(2.0 ** -5),
    math.atan(2.0 ** -6),
    math.atan(2.0 ** -7),
    math.atan(2.0 ** -8),
    math.atan(2.0 ** -9),
    math.atan(2.0 ** -10),
    math.atan(2.0 ** -11),
    math.atan(2.0 ** -12),
    math.atan(2.0 ** -13),
    math.atan(2.0 ** -14),
    math.atan(2.0 ** -15),
    math.atan(2.0 ** -16),
    math.atan(2.0 ** -17),
    math.atan(2.0 ** -18),
    math.atan(2.0 ** -19),
    math.atan(2.0 ** -20),
])
#
# for i in range(ITERATIONS):
#     e *= math.cos(LUT[i])

print(e)
goal = math.pi / 3

result = 0

x = 1
y = 0


for i in range(ITERATIONS):
    if result < goal:
        # против часовой
        result += LUT[i]
        x1 = x - y * (2.0 ** (-i))
        y1 = y + x * (2.0 ** (-i))
    else:
        # по часовой
        result -= LUT[i]
        x1 = x + y * (2.0 ** (-i))
        y1 = y - x * (2.0 ** (-i))
    x = x1
    y = y1
    # print("deg", math.degrees(result))
    print("x", x)
    print("y", y)

print()
print('expected')
print(math.sin(goal))
print(math.cos(goal))
print('actual')
print("x", x * e)
print("y", y * e)
print(result)
# x 1.0
# y 1.0
# x 0.5
# y 1.5
# x 0.875
# y 1.375
# x 0.703125
# y 1.484375
# x 0.7958984375
# y 1.4404296875
# x 0.840911865234375
# y 1.415557861328125
# x 0.818793773651123
# y 1.428697109222412
# x 0.8299554698169231
# y 1.4223002828657627
# x 0.8243996093369788
# y 1.425542296419735
# x 0.821615347039284
# y 1.4271524519067214