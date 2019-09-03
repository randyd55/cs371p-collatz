 g.DEFAULT_GOAL := all
MAKEFLAGS += --no-builtin-rules

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
	doxygen Doxyfile

Collatz.log:
	git log > Collatz.log

# you must edit Doxyfile and
# set EXTRACT_ALL     to YES
# set EXTRACT_PRIVATE to YES
# set EXTRACT_STATEIC to YES
Doxyfile:
	doxygen -g

RunCollatz: Collatz.h Collatz.c++ RunCollatz.c++
	-cppcheck Collatz.c++
	-cppcheck RunCollatz.c++
	g++ -pedantic -std=c++14 -Wall -Weffc++ -Wextra Collatz.c++ RunCollatz.c++ -o RunCollatz

RunCollatz.c++x: RunCollatz
	./RunCollatz < RunCollatz.in > RunCollatz.tmp
	-diff RunCollatz.tmp RunCollatz.out

TestCollatz: Collatz.h Collatz.c++ TestCollatz.c++
	-cppcheck Collatz.c++
	-cppcheck TestCollatz.c++
	g++ -fprofile-arcs -ftest-coverage -pedantic -std=c++14 -Wall -Weffc++ -Wextra  Collatz.c++ TestCollatz.c++ -o TestCollatz -lgtest -lgtest_main -pthread

TestCollatz.c++x: TestCollatz
	valgrind ./TestCollatz
	gcov -b Collatz.c++ | grep -A 5 "File '.*Collatz.c++'"

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
	checktestdata RunCollatz.ctd RunCollatz.in

docker:
	docker run -it -v $(PWD):/usr/gcc -w /usr/gcc gpdowning/gcc

format:
	astyle Collatz.c++
	astyle Collatz.h
	astyle RunCollatz.c++
	astyle TestCollatz.c++

init:
	touch README
	git init
	git remote add origin git@gitlab.com:gpdowning/cs371p-collatz.git
	git add README
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

versions:
	which         astyle
	astyle        --version
	@echo
	dpkg -s       libboost-dev | grep 'Version'
	@echo
	ls -al        /usr/lib/*.a
	@echo
	which         checktestdata
	checktestdata --version
	@echo
	which         cmake
	cmake         --version
	@echo
	which         cppcheck
	cppcheck      --version
	@echo
	which         doxygen
	doxygen       --version
	@echo
	which         g++
	g++           --version
	@echo
	which         gcov
	gcov          --version
	@echo
	which         git
	git           --version
	@echo
	which         make
	make          --version
	@echo
	which         valgrind
	valgrind      --version
	@echo
	which         vim
	vim           --version
