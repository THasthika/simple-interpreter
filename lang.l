%{
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    
    void yyerror(char *);
%}

%%

"print"         {
                    return PRINT;
                }
[0-9]+          {
                    yylval.float_ = 1.0f * atoi(yytext);
                    return NUMBER;
                }
[0-9]*\.[0-9]+  {
                    yylval.float_ = atof(yytext);
                    return NUMBER;
                }
\'[a-zA-Z0-9\!@#$%\^&\*\(\)_+-={}\[\]\|\\:;'"<,>.?/~`]\' {
                    yylval.char_ = yytext[1];
                    return CHAR;
                }
\"[a-zA-Z0-9\!@#$%\^&\*\(\)_+-={}\[\]\|\\:;'"<,>.?/~`]*\" {
                    int l = strlen(yytext);
                    yytext[l-1] = '\0';
                    yylval.str_ = strdup(&yytext[1]);
                    return STRING;
                }
[a-zA-Z0-9][a-zA-Z0-9]* {
                    yylval.identifier_ = strdup(yytext);
                    return IDENTIFIER;
                }
[+-=/\*]        {
                    return *yytext;
                }
[ \t\n]         {;}
.               {
                    yyerror("Unknown Token");
                    return -1;
                }

%%

int yywrap(void) {
       return 1;
}