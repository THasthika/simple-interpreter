%{
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    
    void yyerror(char *);

// \'[a-zA-Z0-9\!@#$%\^&\*\(\)_+-={}\[\]\|\\:;'"<,>.?/~`]\' {
//                     yylval.char_ = yytext[1];
//                     return CHAR;
//                 }
// \"[a-zA-Z0-9\!@#$%\^&\*\(\)_+-={}\[\]\|\\:;'"<,>.?/~`]*\" {
//                     int l = strlen(yytext);
//                     yytext[l-1] = '\0';
//                     yylval.str_ = strdup(&yytext[1]);
//                     return STRING;
//                 }

%}

%%

"print"         {
                    return PRINT;
                }
[0-9]+          {
                    yylval.number_ = 1.0 * atoi(yytext);
                    return NUMBER;
                }
[0-9]*\.[0-9]+  {
                    yylval.number_ = strtod(yytext, NULL);
                    return NUMBER;
                }
[a-zA-Z0-9][a-zA-Z0-9_]* {
                    yylval.identifier_ = strdup(yytext);
                    return IDENTIFIER;
                }
[+-=/\*\^%]      {
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