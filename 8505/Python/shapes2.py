#!/usr/bin/python

# Geometry of shapes class
class Shape:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def area(self):
        return self.x * self.y
    def perimeter(self):
        return 2 * self.x + 2 * self.y
    def scaleSize(self,scale):
        self.x = self.x * scale
        self.y = self.y * scale
    
rectangle = Shape(100,50)

#instantiate a new class from the parent "Shape" class
class Square(Shape):
    def __init__(self, x):
        self.x = x
        self.y = x

square = Square(100)

# Find the area of the square 
print "Square Area: ", square.area()

# Find the perimeter of the square
print "Square Perimeter: ", square.perimeter()

# Find the area of the rectangle
print "Rectangle Area: ", rectangle.area()

# Find the perimeter of the rectangle
print "Rectangle Perimeter: ", rectangle.perimeter()

# Scale the rectangle
rectangle.scaleSize(0.5)

# Find the area of the scaled rectangle
print "Scaled Rectangle Area: ", rectangle.area()

