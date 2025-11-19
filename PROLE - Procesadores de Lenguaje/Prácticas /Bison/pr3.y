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
   char	*id; 
   int eti; 
}

// Definicion de los tokens con los que se trabaja
%token <numero>NUM <id>ID SI SINO IMPRIMIR MIENTRAS HACER SUM_ASIGN SUB_ASIGN MUL_ASIGN DIV_ASIGN ASIGN
%left '+' '-' 
%left '*' '/'	// Mayor precedencia sobre suma y resta
%%

list_sntncs : sntnc ';'
	   | sntnc ';' list_sntncs;

sntnc : sel_stmt
      |	iter_stmt
      | assig_stmt
      | print_stmt;

print_stmt : IMPRIMIR '(' expr ')'	{printf("\tprint\n");}

sel_stmt : SI '(' expr ')'	accionSi
	 '{' list_sntncs '}'
	 | 
	 SI '(' expr ')'	accionSi 
	 '{' list_sntncs '}' 
	 SINO			{printf("\tvea LBL\n");
				 printf("LBL\n");} 
	 '{' list_sntncs '}'	{printf("LBL\n");}
	;

// Para solucionar el problema de bison REDUCE/REDUCE al aplicar acciones semánticas dentro del si-sino
accionSi: {printf("\tsifalsovea LBL\n");}

iter_stmt : MIENTRAS		{printf("LBL\n");} 

	'(' expr ')'		{printf("\tsifalsovea LBL\n");} 
	'{' list_sntncs '}'	{printf("\tvea LBL\n");}
	|
	HACER			{printf("LBL\n");} 
	'{' list_sntncs '}' 
	MIENTRAS '(' expr ')'	{printf("\tsiciertovea LBL\n");}
	;

assig_stmt : ID			{printf("\tvalori %s\n", $1);}
		ASIGN expr	{printf("\tasigna\n");
				 free($1);}

	   | ID	SUM_ASIGN	{printf("\tvalori %s\n", $1);
				 printf("\tvalord %s\n", $1);}
		expr		{printf("\tsum\n");
				 printf("\tasigna\n");
				 free($1);}

	   | ID	SUB_ASIGN	{printf("\tvalori %s\n", $1);
				 printf("\tvalord %s\n",$1);} 
		expr		{printf("\tsub\n");
				 printf("\tasigna\n");
				 free($1);}

	   | ID	MUL_ASIGN	{printf("\tvalori %s\n", $1);
				 printf("\tvalord %s\n", $1);} 
		expr		{printf("\tmul\n");
				 printf("\tasigna\n");
				 free($1);}

	   | ID	DIV_ASIGN	{printf("\tvalori %s\n", $1);
				 printf("\tvalord %s\n", $1);} 
		expr		{printf("\tdiv\n");
				 printf("\tasigna\n");
				 free($1);}
			

expr : mult_expr
	| mult_expr '+' expr	{printf("\tsum\n");}		
	| mult_expr '-' expr	{printf("\tsub\n");}
	;	
 
mult_expr : val 
	| val '*' mult_expr	{printf("\tmul\n");}		
	| val '/' mult_expr	{printf("\tdiv\n");}
	;		

val : NUM		{printf("\tmete %d\n", $1);}		
    | ID		{printf("\tvalord %s\n", $1);}		
    | '(' expr ')';

%%

void yyerror(const char *s){
	fprintf(stderr, "Error de sintaxis %s\n", s);
}

int main(){
	yyparse();
	return 0;
}
