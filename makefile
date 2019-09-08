 g.DEFAULT_GOAL := all
MAKEFLAGS += --no-builtin-rules

ifeq ($(shell uname -s), Darwin)
    ASTYLE        := astyle
    BOOST         := /usr/local/include/boost
    CHECKTESTDATA := checktestdata
    CPPCHECK      := cppcheck
    CXX           := g++-9
    CXXFLAGS      := -fprofile-arcs -ftest-coverage -pedantic -std=c++17 -O3 -I/usr/local/include -Wall -Wextra
    LDFLAGS       := -lgtest -lgtest_main
    DOXYGEN       := doxygen
    GCOV          := gcov-9
    VALGRIND      := valgrind
else ifeq ($(shell uname -p), unknown)
    ASTYLE        := astyle
    BOOST         := /usr/include/boost
    CHECKTESTDATA := checktestdata
    CPPCHECK      := cppcheck
    CXX           := g++
    CXXFLAGS      := -fprofile-arcs -ftest-coverage -pedantic -std=c++17 -O3 -Wall -Wextra
    LDFLAGS       := -lgtest -lgtest_main -pthread
    DOXYGEN       := doxygen
    GCOV          := gcov
    VALGRIND      := valgrind
else
    ASTYLE        := astyle
    BOOST         := /usr/include/boost
    CHECKTESTDATA := checktestdata
    CPPCHECK      := cppcheck
    CXX           := g++-9
    CXXFLAGS      := -fprofile-arcs -ftest-coverage -pedantic -std=c++17 -O3 -Wall -Wextra
    LDFLAGS       := -lgtest -lgtest_main -pthread
    DOXYGEN       := doxygen
    GCOV          := gcov-9
    VALGRIND      := valgrind
endif

FILES :=                                  \
    .gitignore                            \
    collatz-tests                         \
    Collatz.c++                           \
    Collatz.h                             \
    makefile                              \
    RunCollatz.c++                        \
    RunCollatz.in                         \
    RunCollatz.out                        \
    TestCollatz.c++

# uncomment these four lines when you've created those files
# you must replace GitLabID with your GitLabID
#    collatz-tests/GitLabID-RunCollatz.in  \
#    collatz-tests/GitLabID-RunCollatz.out \
#    Collatz.log                           \
#    html                                  \

collatz-tests:
	git clone https://gitlab.com/gpdowning/cs371p-collatz-tests.git collatz-tests

html: Doxyfile Collatz.h
	$(DOXYGEN) Doxyfile

Collatz.log:
	git log > Collatz.log

# you must edit Doxyfile and
# set EXTRACT_ALL     to YES
# set EXTRACT_PRIVATE to YES
# set EXTRACT_STATEIC to YES
Doxyfile:
	$(DOXYGEN) -g

RunCollatz: Collatz.h Collatz.c++ RunCollatz.c++
	-$(CPPCHECK) Collatz.c++
	-$(CPPCHECK) RunCollatz.c++
	$(CXX) $(CXXFLAGS) Collatz.c++ RunCollatz.c++ -o RunCollatz

RunCollatz.c++x: RunCollatz
	./RunCollatz < RunCollatz.in > RunCollatz.tmp
	-diff RunCollatz.tmp RunCollatz.out

TestCollatz: Collatz.h Collatz.c++ TestCollatz.c++
	-$(CPPCHECK) Collatz.c++
	-$(CPPCHECK) TestCollatz.c++
	$(CXX) $(CXXFLAGS) Collatz.c++ TestCollatz.c++ -o TestCollatz $(LDFLAGS)

TestCollatz.c++x: TestCollatz
	$(VALGRIND) ./TestCollatz
	$(GCOV) -b Collatz.c++ | grep -A 5 "File '.*Collatz.c++'"

all: RunCollatz TestCollatz

check: $(FILES)

clean:
	rm -f *.gcda
	rm -f *.gcno
	rm -f *.gcov
	rm -f *.plist
	rm -f *.tmp
	rm -f RunCollatz
	rm -f TestCollatz

config:
	git config -l

ctd:
	$(CHECKTESTDATA) RunCollatz.ctd RunCollatz.in

docker:
	docker run -it -v $(PWD):/usr/gcc -w /usr/gcc gpdowning/gcc

format:
	$(ASTYLE) Collatz.c++
	$(ASTYLE) Collatz.h
	$(ASTYLE) RunCollatz.c++
	$(ASTYLE) TestCollatz.c++

init:
	touch README
	git init
	git remote add origin git@gitlab.com:gpdowning/cs371p-collatz.git
	git add README.md
	git commit -m 'first commit'
	git push -u origin master

pull:
	make clean
	@echo
	git pull
	git status

push:
	make clean
	@echo
	git add .gitignore
	git add .gitlab-ci.yml
	git add Collatz.c++
	git add Collatz.h
	-git add Collatz.log
	-git add html
	git add makefile
	git add README.md
	git add RunCollatz.c++
	git add RunCollatz.ctd
	git add RunCollatz.in
	git add RunCollatz.out
	git add TestCollatz.c++
	git commit -m "another commit"
	git push
	git status

run: RunCollatz.c++x TestCollatz.c++x

scrub:
	make clean
	rm -f  *.orig
	rm -f  Collatz.log
	rm -f  Doxyfile
	rm -rf collatz-tests
	rm -rf html
	rm -rf latex

status:
	make clean
	@echo
	git branch
	git remote -v
	git status

sync:
	make clean
	@pwd
	@rsync -r -t -u -v --delete            \
    --include "Collatz.c++"                \
    --include "Collatz.h"                  \
    --include "RunCollatz.c++"             \
    --include "RunCollatz.ctd"             \
    --include "RunCollatz.in"              \
    --include "RunCollatz.out"             \
    --include "TestCollatz.c++"            \
    --exclude "*"                          \
    ~/projects/c++/collatz/ .
	@rsync -r -t -u -v --delete            \
    --include "makefile"                   \
    --include "Collatz.c++"                \
    --include "Collatz.h"                  \
    --include "RunCollatz.c++"             \
    --include "RunCollatz.ctd"             \
    --include "RunCollatz.in"              \
    --include "RunCollatz.out"             \
    --include "TestCollatz.c++"            \
    --exclude "*"                          \
    . downing@$(CS):cs/git/cs371p-collatz/

versions:
	@echo "% shell uname -p"
	@echo  $(shell uname -p)
	@echo
	@echo "% shell uname -s"
	@echo  $(shell uname -s)
	@echo
	@echo "% which $(ASTYLE)"
	@which $(ASTYLE)
	@echo
	@echo "% $(ASTYLE) --version"
	@$(ASTYLE) --version
	@echo
	@echo "% grep \"#define BOOST_VERSION \" $(BOOST)/version.hpp"
	@grep "#define BOOST_VERSION " $(BOOST)/version.hpp
	@echo
	@echo "% which $(CHECKTESTDATA)"
	@which $(CHECKTESTDATA)
	@echo
	@echo "% $(CHECKTESTDATA) --version"
	@$(CHECKTESTDATA) --version
	@echo
	@echo "% which $(CXX)"
	@which $(CXX)
	@echo
	@echo "% $(CXX) --version"
	@$(CXX) --version
	@echo "% which $(CPPCHECK)"
	@which $(CPPCHECK)
	@echo
	@echo "% $(CPPCHECK) --version"
	@$(CPPCHECK) --version
	@echo
	@$(CXX) --version
	@echo "% which $(DOXYGEN)"
	@which $(DOXYGEN)
	@echo
	@echo "% $(DOXYGEN) --version"
	@$(DOXYGEN) --version
	@echo
	@echo "% which $(GCOV)"
	@which $(GCOV)
	@echo
	@echo "% $(GCOV) --version"
	@$(GCOV) --version
ifneq ($(shell uname -s), Darwin)
	@echo "% which $(VALGRIND)"
	@which $(VALGRIND)
	@echo
	@echo "% $(VALGRIND) --version"
	@$(VALGRIND) --version
endif
