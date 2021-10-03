%{
    #include <stdio.h>
    int yylex(void);
    void yyerror (char *);
%}

%union {
    int num;
    float float_;
    char char_;
    char* string;
}

%token <num> NUM
%token <float_> FLOAT
%token <char_> CHAR
%token <string> STRING

%start statements

%%

statements  : statement
            | statement statements
            ;

statement   : expression
            ;

expression  : NUM { printf("EXP\n"); }
            ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}