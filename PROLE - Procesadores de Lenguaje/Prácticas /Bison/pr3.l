%{
#include "y.tab.h"
%}

%%
[0-9]+			return NUM;
[a-zA-Z_][a-zA-Z_0-9]+	return ID; 
"si"			return SI;
"sino"			return SINO;
"imprimir"		return IMPRIMIR;
"mientras"		return MIENTRAS;
"hacer"			return HACER;
"+="			return SUM_ASIGN;
"-="			return SUB_ASIGN;
"*="			return MUL_ASIGN;
"/="			return DIV_ASIGN;
"="			return ASIGN;

[ \t\n\r]+              ;
"//".*			;
"/."[.\n]*"*/"		;

.			return yytext[0];
%%
