from math import atan2

from fxpmath import Fxp
import numpy as np
import math


N = 16
FRAC = N - 3
K = 8
DATA = Fxp(val=None, signed=True, n_word=N, n_frac=FRAC)


e = Fxp(1).like(DATA)
print(e.hex())

ITERATIONS = 12

LUT = Fxp(np.array([
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
    math.atan(2.0 ** -11)
])).like(DATA)

print(LUT.bin(frac_dot=True))

for i in range(ITERATIONS):
    e.equal(math.cos(LUT[i]) * e)

print('e', e)
print('e', e.hex())
print('e', e.bin(frac_dot=True))

PIDIV2 = Fxp(math.pi).like(DATA)
print('pi ', PIDIV2.hex())


goal = Fxp(0).like(DATA)


result = Fxp(0).like(DATA)

x = Fxp(1).like(DATA)
y = Fxp(0).like(DATA)

x1 = Fxp(1).like(DATA)
y1 = Fxp(0).like(DATA)
x1.config.shifting = 'trunc'
y1.rounding = 'trunc'
x.config.shifting = 'trunc'
y.rounding = 'trunc'

print("goal", goal.bin(frac_dot=True))
print("goal", goal.hex())

print("x", x.bin(frac_dot=True))
print("y", y.bin(frac_dot=True))

for i in range(ITERATIONS):
    if result < goal:
        # против часовой
        result.equal(result + LUT[i])
        x1.equal(x - (y >> i))
        y1.equal(y + (x >> i))
    else:
        # по часовой
        result.equal(result - LUT[i])
        x1.equal(x + (y >> i))
        y1.equal(y - (x >> i))
    x.equal(x1)
    y.equal(y1)
    print("x", x.hex())
    print("y", y.hex())
    print("result", result.hex())

print()
print('expected')
print(math.sin(goal))
print(math.cos(goal))
print(goal)
print('actual')

e_str = str(e.bin()[0][0][0][0][0][0][0][0][0][0][0][0])
e_str = e_str.replace('\'','')
result_x = Fxp(0).like(DATA)
result_y = Fxp(0).like(DATA)

result_y.config.shifting = 'trunc'
result_y.rounding = 'trunc'
result_x.config.shifting = 'trunc'
result_x.rounding = 'trunc'

print('x', (x).hex())
print('y', (y).hex())
for i in range(0, ITERATIONS - 2):
    if e_str[i + 2] == '1':
        result_x.equal(result_x + (x >> (i)))
        result_y.equal(result_y + (y >> (i)))

    print('shift x', (x >> (i)).hex())
    print('shift y', (y >> (i)).hex())
    print('x shifted', result_x.hex())
    print('y shifted', result_y.hex())


print('x approximate', result_x)
print('y approximate', result_y)

print('x approximate', result_x.hex())
print('y approximate', result_y.hex())
print("x", x * e)
print("y", y * e)
print(result)

print('actual bin x')
print((x * e).bin(frac_dot=True))

print('actual bin y')
print((y * e).bin(frac_dot=True))

print('actual hex x wn')
print((x).hex())

print('actual hex y wn')
print((y).hex())

print('actual hex x')
print((x * e).hex())

print('actual hex y')
print((y * e).hex())
