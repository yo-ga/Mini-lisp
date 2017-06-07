#!/bin/sh
bison -d $1.y
flex $1.l
g++ -c $1.tab.c
g++ -c lex.yy.c
g++ lex.yy.o $1.tab.o -o $1.exe -lfl
rm lex.yy.*
rm $1.tab.*
