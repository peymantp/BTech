#!/usr/bin/python

# Pass by reference mutable example
def ChangeList(TheList):
    print 'Received', TheList
    TheList.append('Python')
    print 'Changed to', TheList

OrigList = ['C', 'C++', 'Ruby']

print 'Before function call: OrigList =', OrigList
ChangeList(OrigList)
print 'After function call, OrigList =', OrigList