%{
    #include <stdlib.h>
    #include "y.tab.h"
    
    void yyerror(char *);
%}

%%

[0-9]+      {
                yylval.num = atoi(yytext);
                return NUM;
            }

%%

int yywrap(void) {
       return 1;
}