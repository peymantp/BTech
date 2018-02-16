#!/usr/bin/python
from __future__ import print_function   # Need this for Python 2.x (print function)

def fib(n): # write Fibonacci series up to n
    """Print a Fibonacci series up to n."""
    a, b = 0, 1
    while a < n:
        print (a,end=' ')
        a, b = b, a+b
    print()

# Call the user-defined function with argument
num = input('Enter a number: ')
fib(num)