#!/usr/bin/python

import threading
import time

exitFlag = 0
delay=1
# Define the main thread class
class myThread (threading.Thread):
    def __init__(self, threadID, name, delay):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.delay = delay
    def run(self):
        print "Starting " + self.name
        print_time(self.name, self.delay, 5)
        print "Exiting " + self.name

# Define the function that both threads execute concurrently
def print_time(threadName, delay, count):
    while count:
        if exitFlag:
            threadName.exit()
        time.sleep(delay)
        print "%s: %s" % (threadName, time.ctime(time.time()))
        count -= 1

# Create new threads
thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 1)

# Start new Threads
thread1.start()
thread2.start()

print "Exiting Main Thread"