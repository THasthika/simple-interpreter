%{
    #include <stdio.h>
    #include <assert.h>

    #include "linked_list.h"
    #include "hash_table.h"

    int yylex(void);
    void yyerror (char *);

    void assign_integer(char* identifier, int value);
    void assign_float(char* identifier, float value);
    void assign_ident(char* identifier, char* identifier1);
    float get_identifier(char* identifier);
    void print_variable(char* identifier);

    HashTable *table;
%}

%union {
    int int_;
    float float_;
    char char_;
    char* str_;
    char* identifier_;
}

%token <float_> NUMBER

%left '+' '-'
%left '*' '/'
%left '(' ')'

%token <char_> CHAR
%token <str_> STRING
%token <identifier_> IDENTIFIER

%token PRINT

%start statements

%type <float_> expression

// %type <void> statement

%%

statements  : statement ';'
            | statement ';' statements
            ;

statement   : assignment
            | print_fn
            ;

expression  : expression '+' expression { $$ = $1 + $3; }
            | expression '-' expression { $$ = $1 - $3; }
            | expression '*' expression { $$ = $1 * $3; }
            | expression '/' expression { $$ = $1 / $3; }
            | '(' expression ')' { $$ = $2; }
            | NUMBER { $$ = $1; }
            | IDENTIFIER { $$ = get_identifier($1); }
            ;

assignment  : IDENTIFIER '=' expression { assign_float($1, $3); }
            ;

print_fn    : PRINT IDENTIFIER { print_variable($2); }
            

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

void assign_integer(char* identifier, int value) {
    if (hash_table_add(table, identifier, &value, TYPE_INTEGER)) {
        return;
    }
    if (hash_table_replace(table, identifier, &value, TYPE_INTEGER)) {
        return;
    }
    printf("error assigning integer!\n");
}

void assign_float(char* identifier, float value) {
    if (hash_table_add(table, identifier, &value, TYPE_FLOAT)) {
        return;
    }
    if (hash_table_replace(table, identifier, &value, TYPE_FLOAT)) {
        return;
    }
    printf("error assigning integer!\n");
}


void assign_ident(char* identifier, char* identifier1) {
    HashTableItem *item;
    if (hash_table_lookup_item(table, identifier1, &item) == 0) {
        return;
    }
    if (item->type == TYPE_INTEGER) {
        assign_integer(identifier, *(int*)item->data);
    } else if (item->type == TYPE_FLOAT) {
        assign_float(identifier, *(float*)item->data);
    }
}

void print_variable(char* identifier) {
    
    HashTableItem *item;
    if (hash_table_lookup_item(table, identifier, &item) == 0) {
        return;
    }

    if (item->type == TYPE_INTEGER) {
        printf("%d\n", *(int*)item->data);
    } else if (item->type == TYPE_FLOAT) {
        printf("%.3f\n", *(float*)item->data);
    }
}

float get_identifier(char* identifier) {
    float x;
    hash_table_lookup(table, identifier, &x, NULL);
    return x;
}

int main(void) {

    hash_table_create(&table, 13);

    yyparse();

    int a = 1;

    // hash_table_add(table, "AA", &a, TYPE_INTEGER);
    // hash_table_add(table, "ZZ", &a, TYPE_INTEGER);

    hash_table_destroy(table);

    return 0;
}

/*

non terminals -> INTEGER, FLOAT, CHAR, STRING

```
S -> statements

statements ->   statement
                | statements

statement ->    assignment
                | function_call
                | function_definition

*/