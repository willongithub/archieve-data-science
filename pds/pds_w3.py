#!/usr/bin/env python3

# PDS Lab Week 3

"""
Programming for Data Science
Week 3 Tutorial
"""

# 1. Conditional Statements
# e1
x1 = 5
print(f'x1 = {x1}')

x2 = 2
print(f'x2 = {x2}')

if x1 == x2:
    print('x1 equals x2')
elif x1 < x2:
    print('x1 is less than x2')
else:
    print('x1 is greater than x2')

# e2
x = 5
while x <= 10:
    x += 1
else:
    print(f'x = {x}')

# e3
x = 0
while x <= 3:
    x += 2
    print(f'x = {x}')

# e4
assessments = ['tutorials', 'assignments', 'exams']
for ass in assessments:
    print(ass)

# e5
for c in 'data':
    print(c)

# e6
while True:
    x = int(input('Enter a number: '))
    if x == 0:
        break
    print('Your number is: ', x)
print('End')

# e7
while True:
    x = int(input('Enter a positive number: '))
    if x == 0:
        break
    elif x < 0:
        print('Must be positive!')
        continue
    print('Your number is: ', x)
print('End')

# q
while True:
    n = int(input('Enter a number: '))
    print(f'The square of {n} is {n*n}')
    a = input('Continue? (y/n) ')
    if a == 'y':
        continue
    else:
        break
print('Done')

# 2. Functions
# e8
def welcome():
    print('Welcome to functions!')

welcome()

# e9
def square(x):
    print('Square of' + str(x) + 'is' + str(x*x))

square(6)

# e10
def square(x):
    return x*x

n = square(6)
print('Square of 6 is' + str(n))

# e11
def distance(x1, x2, y1, y2):
    d = ((x2 - x1)**2 + (y2 - y1)**2)**0.5
    return d

x1, x2, y1, y2 = 3, 0, 0, 4
dist = distance(x1, x2, y1, y2)
print('Distance between (3, 0) and (0, 4) is ' + str(dist))

# e12
def distance(p1, p2):
    d = 0
    for i in range(len(p1)):
        d += (p2[i] - p1[i])**2
    d = d**0.5
    return d

p1, p2 = (3, 0), (0, 4)
dist = distance(p1, p2)
print('Distance between (3, 0) and (0, 4) is ' + str(dist))


p1 = (3, 0, 1, 1)
p2 = (0, 4, 1, 1)

# 3. DIY Questions
# q1
def get_grade(x):
    if x < 50:
        g = 'Fail'
    elif x < 65:
        g = 'P'
    elif x < 75:
        g = 'CR'
    elif x < 85:
        g = 'DI'
    else:
        g = 'HD'
    return g

# q2
def mark2grade():
    m = int(input("Enter you total mark: "))
    g = get_grade(m)
    print('Your grade is ' + g)

mark2grade()

# q3
def mark2grade():
    while True:
        m = int(input("Enter you total mark: "))
        if m < 0:
            break
        else:
            g = get_grade(m)
            print('Your grade is ' + g)
            continue
    return

mark2grade()

# q4
def find_max(*args):
    pop = args[0]
    for i in args:
        if i > pop:
            pop = i
    return pop

max = find_max(2, 4, 8, 3, 1, 33, 25, 65, 81)
print('Maximum value is ' + str(max))

max = find_max(2, 4, 8, 3, 1)
print('Maximum value is ' + str(max))

# 4. Drawings
from tkinter import *
top = Tk()

c = Canvas(top, bg="gray", height=600, width=800)

x1, y1, x2, y2 = 100, 100, 200, 300
c.create_line(x1, y1, x2, y2, fill="magenta")

c.pack()
top.mainloop()
