#!/bin/bash

function compile {
	echo "$1" | ./8cc > tmp.s
	if [ ! $? ]; then
		echo "Failed to compile $1"
		exit
	fi
	gcc -o tmp.out driver.c tmp.s || exit
	if [ $? -ne 0 ]; then
		echo "GCC failed"
		exit
	fi
}

function test {
	expected="$1"
	expr="$2"
	compile "$expr"
	result="`./tmp.out`"
	if [ "$result" != "$expected" ]; then
		echo "Test failed: $expeceted expected but got $result"
		exit
	fi
}

function testfail {
	expr="$1"
	echo "$expr" | ./8cc > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "Should fail to compile, but succeeded: $expr"
		exit
	fi
}

make -s 8cc

test 0 0
test abc '"abc"'

test 3 '1+2'
test 3 '1 + 2'
test 11 '2+2+3+4'
test 1 '3- 2'

testfail '"abc'
testfail '0abc'
testfail '1+'

echo "All tests passed"

