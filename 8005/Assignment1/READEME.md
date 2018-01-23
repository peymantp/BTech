# Comp 8005   Computer Systems Technology   January 2018

Network and Security Applications Development

Assignment #1

Due: January 22, 1200 hrs.

Objective:   Use multiple processes  and threads  on either the Windows or Linux operating systems and measure the performance and efficiency of each mechanism.


Your Mission:

Design and implement two separate programs, one will use multiple processes and the other will use multiple threads. The objective here is to obtain a measure of efficiency and performance of each implementation as they perform a set of specified tasks. The easiest task to implement for each program is a set of intensive mathematical computations together with I/O activity.

You may select any mathematical task you wish. For the I/O I suggest file I/O for one or more process/threads. A suggestion would be to write the results of the computations and the timing data into an external file. The gettimeofday() (Linux) function may be useful to your travails.

Be as creative as you want and keep in mind that the experiment you design must be the same for both the process and thread implementation. Design the experiment so that each process/thread (workers) is assigned a sub-task  and obtain information on how long it took each worker to complete the task. Then combine all the results together to obtain a measure of overall performance.


Constraints:

     Each  implementation  must  have  the  same  number  of  “workers”,  a  minimum  of  five
processes or threads.

     You may use any other IPC constructs that you deem necessary.

     Clearly  outline the combination of mathematical and I/O tasks you have selected and outline the reasons for your selection.

     Provide a brief report of your findings and present all your results in graphical and/or tabular form.

To Be Submitted:

     Hand in complete and well-documented design work,  listings and an executable..
     Ensure that you clearly explain the testing procedures for your programs and provide test
data as necessary.
     Submit a  zip file containing all the code and documents as described below in the sharein
folder for this course under “Assignment #1”.
     Your report must follow the standard technical format.


Assignment #1 Evaluation


(1). Design Work:                                                     / 10 (3). Experiment Design & Functionality:                   / 20 (4). Testing & Report:                                               / 20

Total:                                                                      / 50
