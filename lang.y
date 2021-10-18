%{
    #include <stdio.h>
    #include <assert.h>
    #include <math.h>

    #include "linked_list.h"
    #include "hash_table.h"

    int yylex(void);
    void yyerror (char *);

    void assign_double(char* identifier, double value);
    void assign_ident(char* identifier, char* identifier1);
    double get_identifier(char* identifier);
    void print_variable(char* identifier);

    HashTable *table;
%}

%union {
    double number_;
    char* identifier_;
}

%token <number_> NUMBER

%left '+' '-'
%left '*' '/'
%left '^'
%left '(' ')'

%token <identifier_> IDENTIFIER

%token PRINT

%start statements

%type <number_> expression

// %type <void> statement

%%

statements  : statement ';'
            | statement ';' statements
            ;

statement   : expression
            | assignment
            | print_fn
            ;

expression  : expression '+' expression { $$ = $1 + $3; }
            | expression '-' expression { $$ = $1 - $3; }
            | expression '*' expression { $$ = $1 * $3; }
            | expression '/' expression { $$ = $1 / $3; }
            | expression '^' expression { $$ = pow($1, $3); }
            | expression '%' expression { $$ = (int)$1 % (int)$3; }
            | '(' expression ')' { $$ = $2; }
            | NUMBER { $$ = $1; }
            | IDENTIFIER { $$ = get_identifier($1); }
            ;

assignment  : IDENTIFIER '=' expression { assign_double($1, $3); }
            ;

print_fn    : PRINT expression { printf("%.3f\n", $2); }
            ;
            

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

void assign_double(char* identifier, double value) {
    if (hash_table_add(table, identifier, value)) {
        return;
    }
    if (hash_table_replace(table, identifier, value)) {
        return;
    }
    printf("error assigning integer!\n");
}


void assign_ident(char* identifier, char* identifier1) {
    HashTableItem *item;
    if (hash_table_lookup_item(table, identifier1, &item) == 0) {
        return;
    }
    assign_double(identifier, item->data);
}

void print_variable(char* identifier) {
    
    HashTableItem *item;
    if (hash_table_lookup_item(table, identifier, &item) == 0) {
        return;
    }

    printf("%.3f\n", item->data);
}

double get_identifier(char* identifier) {
    double x;
    hash_table_lookup(table, identifier, &x);
    return x;
}

int main(void) {
    hash_table_create(&table, 13);
    yyparse();
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