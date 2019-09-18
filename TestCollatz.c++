// ---------------
// TestCollatz.c++
// ---------------

// https://code.google.com/p/googletest/wiki/V1_7_Primer#Basic_Assertions

// --------
// includes
// --------

#include <iostream> // cout, endl
#include <sstream>  // istringtstream, ostringstream
#include <string>   // string
#include <utility>  // pair

#include "gtest/gtest.h"

#include "Collatz.h"

using namespace std;

// -----------
// TestCollatz
// -----------

// ----
// read
// ----

TEST(CollatzFixture, read) {
    string s("1 10\n");
    const pair<int, int> p = collatz_read(s);
    ASSERT_EQ(p.first,   1);
    ASSERT_EQ(p.second, 10);
}

// ----
// eval
// ----

TEST(CollatzFixture, eval_1) {
    const int v = collatz_eval(1, 10);
    ASSERT_EQ(v, 20);
}

TEST(CollatzFixture, eval_2) {
    const int v = collatz_eval(100, 200);
    ASSERT_EQ(v, 125);
}

TEST(CollatzFixture, eval_3) {
    const int v = collatz_eval(201, 210);
    ASSERT_EQ(v, 89);
}

TEST(CollatzFixture, eval_4) {
    const int v = collatz_eval(900, 1000);
    ASSERT_EQ(v, 174);
}

TEST(CollatzFixture, eval_6) {
    const int v = collatz_eval(385087,297240);
    ASSERT_EQ(v, 441);
}

TEST(CollatzFixture, eval_7) {
    const int v = collatz_eval(603, 75948);
    ASSERT_EQ(v, 340);
}

TEST(CollatzFixture, eval_8) {
    const int v = collatz_eval(243278, 922906);
    ASSERT_EQ(v, 525);
}

TEST(CollatzFixture, eval_9) {
    const int v = collatz_eval(5463, 5463);
    ASSERT_EQ(v, 117);
}

TEST(CollatzFixture, eval_10){
    const int v = collatz_eval(10000001, 10000002);
    ASSERT_EQ(v, 138);
}
// ----
// single
// ----

TEST(CollatzFixture, single_1) {
    const int v = collatz_single(5463);
    ASSERT_EQ(v, 117);
}

TEST(CollatzFixture, single_2) {
    const int v = collatz_single(1);
    ASSERT_EQ(v, 1);
}

TEST(CollatzFixture, single_3) {
    const int v = collatz_single(10000000);
    ASSERT_EQ(v, 146);
}

TEST(CollatzFixture, single_4) {
    const int v = collatz_single(50);
    ASSERT_EQ(v, 25);
}

TEST(CollatzFixture, single_5) {
    const int v = collatz_single(60000);
    ASSERT_EQ(v, 180);
}

TEST(CollatzFixture, single_6) {
    const int v = collatz_single(2);
    ASSERT_EQ(v, 2);
}

TEST(CollatzFixture, single_7) {
    const int v = collatz_single(432156);
    ASSERT_EQ(v, 144);
}

// -----
// print
// -----

TEST(CollatzFixture, print) {
    ostringstream w;
    collatz_print(w, 1, 10, 20);
    ASSERT_EQ(w.str(), "1 10 20\n");
}

// -----
// solve
// -----

TEST(CollatzFixture, solve) {
    istringstream r("1 10\n100 200\n201 210\n900 1000\n");
    ostringstream w;
    collatz_solve(r, w);
    ASSERT_EQ("1 10 20\n100 200 125\n201 210 89\n900 1000 174\n", w.str());
}
