  GNU nano 7.2                                                                       pr3.y                                                                                 
// Analizador sintáctico de la pr3
// Autor: Diego Garda Porto
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int nEtiqueta =0;

void yyerror (const char *s);
extern int yylex();

%}

%union{
   int numero;
   char *id;
   int eti;
}

// Definicion de los tokens con los que se trabaja
%token <numero>NUM <id>ID SI SINO IMPRIMIR MIENTRAS HACER SUM_ASIGN SUB_ASIGN MUL_ASIGN DIV_ASIGN ASIGN
%left '+' '-'
%left '*' '/'   // Mayor precedencia sobre suma y resta
%%

list_sntncs : sntnc ';'
           | sntnc ';' list_sntncs;

sntnc : sel_stmt
      | iter_stmt
      | assig_stmt
      | print_stmt;

print_stmt : IMPRIMIR '(' expr ')'';'   {printf("\tprint\n");}

sel_stmt : SI '(' expr ')'      accionSi
         '{' list_sntncs '}'
         |
                                                      [ line   1/108 ( 0%), col 36/36 (100%), char   35/2407 ( 1%) ]
^G Help          ^O Write Out     ^W Where Is      ^K Cut           ^T Execute       ^C Location      M-U Undo         M-A Set Mark     M-] To Bracket   M-Q Previous
^X Exit          ^R Read File     ^\ Replace       ^U Paste         ^J Justify       ^/ Go To Line    M-E Redo         M-6 Copy         ^Q Where Was     M-W Next
