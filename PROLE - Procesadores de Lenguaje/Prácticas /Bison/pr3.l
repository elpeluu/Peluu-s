%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

%%

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

[0-9]+                      { yylval.numero = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z_0-9]* { return ID; }

[ \t\n\r]+                  ; /* Ignorar espacios */
"//".* ; /* Comentarios linea */
"/*"([^*]|(\*+[^*/]))*\*+"*/" ; /* Comentarios bloque */

.                           return yytext[0];

%%

int yywrap() {
    return 1;
}
