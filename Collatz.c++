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

int collatz_eval (int i, int j) {
    ASSERT(i > 0);
    ASSERT(j < 1000000);
    ASSERT(i < j);
    int max_collatz = -1
    for(int index = i; index <= j; index++){
        int temp = collatz_single(index);
        if(temp > max_collatz){
            max_collatz = temp;
        }
    }
    // <your code>
    return temp;
}

int collatz_single(int i) {
    int count = 0;
    while(i > 1){
        if((i % 2) == 0){
            i /= 2;
        }
        else{
            i = i * 3 + 1;
        }
        count++;
    }
    return count;
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
