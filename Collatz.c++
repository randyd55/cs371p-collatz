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

#include "Collatz.h"

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

// ------------
// collatz_eval
// ------------
int collatz_single(int i) {
    int count = 1;
    while(i > 1){
        if((i % 2) == 0){
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
    assert(j < 1000000);
    assert(i < j);
    int max_collatz = -1;
    int index;
    int lazy_cache[max(i, j)];
    for(index = 0; index < j; index++){
        lazy_cache[index] = -1;
    }
    lazy_cache[0] = 0;
    for(index = i; index < j; index++){
        int temp;
        if(lazy_cache[index] == -1){
            temp = collatz_single(index);
            lazy_cache[index] = temp;
        }
        else{
            temp = lazy_cache[index];
        }
        if(temp > max_collatz){
            max_collatz = temp;
        }
        int f;
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