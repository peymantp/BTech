#include <iostream>

using namespace std;

int main()
{
    unsigned long long int n = 94,
                           t1 = 0,
                           t2 = 1,
                           nextTerm = 0;

    for (int j = 0; j < 10; j++)
    {
        t1 = 0, t2 = 1,nextTerm = 0;
        for (int i = 1; i <= n; ++i)
        {
            // Prints the first two terms.
            if (i == 1)
            {
                //cout << " " << t1;
                continue;
            }
            if (i == 2)
            {
                //cout << t2 << " ";
                continue;
            }
            nextTerm = t1 + t2;
            t1 = t2;
            t2 = nextTerm;
            //cout << nextTerm << "\n";
        }
    }
    return 0;
}