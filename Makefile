.PHONY: all

all: main

y.tab.h y.tab.c: lang.y
	yacc -d lang.y
lex.yy.c: lang.l y.tab.h
	lex lang.l
lex.yy.o: lex.yy.c
	gcc -std=c11 -c lex.yy.c -o lex.yy.o
y.tab.o: y.tab.c
	gcc -std=c11 -c y.tab.c -o y.tab.o
main: lex.yy.o y.tab.o
	gcc -o main lex.yy.o y.tab.o