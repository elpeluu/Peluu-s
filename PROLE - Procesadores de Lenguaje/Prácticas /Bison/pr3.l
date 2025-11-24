%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

%%

[0-9]+                      { yylval.numero = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z_0-9]+      { yylval.id = strdup(yytext); return ID; }

"si"                        return SI;
"sino"                      return SINO;
"imprimir"                  return IMPRIMIR;
"mientras"                  return MIENTRAS;
"hacer"                     return HACER;

"+="                        return SUM_ASIGN;
"-="                        return SUB_ASIGN;
"*="                        return MUL_ASIGN;
"/="                        return DIV_ASIGN;
"="                         return ASIGN;

[ \t\n\r]+                  ; /* Ignorar espacios y saltos de linea */
"//".* ; /* Ignorar comentarios de linea */
"/*"([^*]|(\*+[^*/]))*\*+"*/" ; /* Ignorar comentarios multilinea (Regex corregida) */

.                           return yytext[0];

%%

int yywrap() {
    return 1;
}
