# !/usr/bin/env python3
# -*- coding: utf-8 -*-

# PDS Lab Week 2

"""
Programming for Data Science
Week 2 Tutorial
"""

# Example 1
print("Hello, World!")

x = input("Enter something: ")
print("You entered " + x)

# Example 2
a = 5
print(type(a))

# Example 3
b = 7.9
print(type(b))

c = 1 + 3j
print(type(c))

d = "data"
print(type(d))

e = 'data'
print(type(e))

f = True
print(type(f))

# Example 4
a, b = 'data', 'science'
print('a = ' + a)
print('b = ' + b)

c = d = 'data science'
print('c = ' + c + 'd = ' + d)

# Example 5
a = 5
print(a)

b = float(a)
print(b)

c = bool(b)
print(c)

d = str(c)
print(d)

e = complex(a)
print(e)

# Example 6
myId = 123456
print('My ID is ' + str(myId))
print(f'My ID is {myId}')

# Example 7
print('I love \nData Science')
print('''I love
Data Science''')

# Example 8

# Example 9

# Question
def doorman(base, price, count):
	return 4*base + 15*count + 0.02*price*count

doorman(1200, 150, 35)
