#!/usr/bin/python

import threading
import time

# Define the main thread class
class myThread (threading.Thread):
    def __init__(self, threadID, name, delay):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.delay = delay
    def run(self):
        print "Starting " + self.name
        # Acquire the lock to synchronize threads
        threadLock.acquire()
        print_time(self.name, self.delay, 3)
        # Release the lock to allow the next thread to print time
        threadLock.release()

# Define the function that both threads execute concurrently
def print_time(threadName, delay, count):
    while count:
        time.sleep(delay)
        print "%s: %s" % (threadName, time.ctime(time.time()))
        count -= 1

# Create the new lock
threadLock = threading.Lock()
threads = []    # array for the list of threads

# Create new threads
thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 1)

# Start new Threads
thread1.start()
thread2.start()

# Add threads to thread list
threads.append(thread1)
threads.append(thread2)

# Wait for all threads to complete
for t in threads:
    t.join()
print "Exiting Main Thread"