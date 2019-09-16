// -----------
// Collatz.c++
// -----------

// --------
// includes
// --------

#include <cassert>  // assert
#include <iostream> // endl, istream, ostream
#include <sstream>  // istringstream
#include <string>   // getline, string
#include <utility>  // make_pair, pair

//#include "Collatz.h"

using namespace std;

// ------------
// collatz_read
// ------------

pair<int, int> collatz_read (const string& s) {
    istringstream sin(s);
    int i;
    int j;
    sin >> i >> j;
    return make_pair(i, j);
}

int cache[100000000];
// ------------
// collatz_eval
// ------------
int collatz_single(long long i) {
    int count = 1;
    //int store = i;
    while(i > 1){
        if(i < 100000000 && cache[i] > 0)
            return cache[i] + count - 1;
        else if((i % 2) == 0){
            i /= 2;
        }
        else{
            i = i + i/2 + 1;
            count++;
        }
        count++;
    }
    return count;
}

int collatz_eval (int i, int j) {
    assert(i > 0);
    assert(j < 100000000);
    int max_collatz = collatz_single(i);
    int index;
    cache[0] = 0;
    cache[1] = 1;
    int start = min(i, j);
    int end = max(i , j);
    for(index = start; index <= end; index++){
        int temp;
        if(cache[index] == 0){
            temp = collatz_single(index);
            cache[index] = temp;
        }
        else{
            temp = cache[index];
        }
        if(temp > max_collatz){
            max_collatz = temp;
        }
    }
    return max_collatz;
}

// -------------
// collatz_print
// -------------

void collatz_print (ostream& w, int i, int j, int v) {
    w << i << " " << j << " " << v << endl;
}

// -------------
// collatz_solve
// -------------

void collatz_solve (istream& r, ostream& w) {
    string s;
    while (getline(r, s)) {
        const pair<int, int> p = collatz_read(s);
        const int            i = p.first;
        const int            j = p.second;
        const int            v = collatz_eval(i, j);
        collatz_print(w, i, j, v);
    }
}