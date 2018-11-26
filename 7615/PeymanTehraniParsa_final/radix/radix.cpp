// C++ implementation of Radix Sort
#include <iostream>
#include <vector>
#include <algorithm>        // Required
#include <iterator>            // Required
#include <queue>            // Require
using namespace std;

const int SIZE = 1000000;

// Radix Sort using base-10 radix
template <typename InputIterator, typename OutputIterator> void radixSort(InputIterator start, InputIterator end, OutputIterator output){
    const int BASE = 10;    // Base
    std::queue<  typename std::iterator_traits<OutputIterator>::value_type > bucket[BASE];    // An array of buckets based on the base
    
    unsigned size = end - start;
    // Get the maximum number
    typename std::iterator_traits<InputIterator>::value_type max = *std::max_element(start, end);    // O(n)
    
    // Copy from input to output
    std::copy(start, end, output);    // O(n)
    
    // Iterative Radix Sort - if k is log BASE (max), then the complexity is O( k * n)
    for (unsigned power = 1; max != 0; max /= BASE, power*=BASE){ // If BASE was 2, can use shift. Although compiler should be smart enough to optimise this.
        
        // Assign to buckets
        for (OutputIterator it = output; it != output+size; it++){
            unsigned bucketNumber =  (unsigned) ( (*it/power)  % BASE );
            bucket[bucketNumber].push(*it);        // O(1)
        }
        
        // Re-assemble
        OutputIterator it = output;
        for (int i = 0; i < BASE; i++){
            int bucketSize = bucket[i].size();
            for (int j = 0; j < bucketSize; j++){
                *it = bucket[i].front();
                bucket[i].pop();
                it++;
            }
        }
    }
}


// Driver program to test above functions
int main()
{
    vector<unsigned> input(SIZE);
    for (int x = 0; x < SIZE; ++x)
    {
        input[x] = rand() + 1;
    }
    vector<unsigned> output(input.size());
    radixSort(input.begin(), input.end(), output.begin());
    
    //for (unsigned it : output){
    //    cout << it << endl;
    //}

    return 0;
}
