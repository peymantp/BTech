#include <time.h>
#include <string>
#include <iostream>
#include <pthread.h>
using namespace std;

//------------ Mutex Variables ---------------------
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

// Function Prototypes
void* outputMsg (void*);

int main (int argc, char **argv) 
{
  pthread_t thread1, thread2;
  string n1("Hello"), n2("World");

  // Create and run the threads.
  pthread_create (&thread1, NULL, outputMsg, static_cast<void*>(&n1));
  pthread_create (&thread2, NULL, outputMsg, static_cast<void*>(&n2));

  // And wait until they are both done
  pthread_join (thread1, NULL);
  pthread_join (thread2, NULL);  
  
  return 0;
}


void* outputMsg (void *arg) 
{
  const string name = *static_cast<string*>(arg);
  struct timespec sleep;
  sleep.tv_nsec = 0;
  
  for (int i = 0; i < 100; i++) 
  {
    pthread_mutex_lock (&lock);
    cout << name << ": " << i << endl;
    pthread_mutex_unlock (&lock);    
    
    sleep.tv_sec = 1;
    nanosleep (&sleep, NULL);
  }
  return NULL;
}

