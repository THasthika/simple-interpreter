.PHONY: all

all: main

y.tab.h y.tab.c: lang.y hash_table.h linked_list.h
	yacc -d lang.y
lex.yy.c: lang.l y.tab.h
	lex lang.l
lex.yy.o: lex.yy.c
	gcc -std=c11 -c lex.yy.c -o lex.yy.o
y.tab.o: y.tab.c
	gcc -std=c11 -c y.tab.c -o y.tab.o
linked_list.o: linked_list.c linked_list.h
	gcc -std=c11 -c linked_list.c -o linked_list.o
hash_table.o: hash_table.c hash_table.h
	gcc -std=c11 -c hash_table.c -o hash_table.o
main: lex.yy.o y.tab.o hash_table.o linked_list.o
	gcc -o main linked_list.o hash_table.o lex.yy.o y.tab.o