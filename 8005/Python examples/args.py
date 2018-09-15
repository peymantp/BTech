#!/usr/bin/python

# User-defined function
def ArgsChange( FuncList ):
   "This changes a passed list into this function"
   FuncList = [1,2,3,4]; # This would assig new reference in mylist
   print "Values inside the function: ", FuncList
   return

# Now you can call function with an immutable argument
Origlist = [10,20,30];
ArgsChange( Origlist );
print "Values after the function call: ", Origlist