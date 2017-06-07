#!/bin/sh
bison -d $1.y
flex $1.l
gcc -c $1.tab.c
gcc -c lex.yy.c
gcc lex.yy.o $1.tab.o -o $1.exe -lfl
rm lex.yy.*
rm $1.tab.*
