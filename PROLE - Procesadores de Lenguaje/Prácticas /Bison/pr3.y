// Analizador sintáctico de la pr3 
// Autor: Diego Garda Porto
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int nEtiqueta =0;

int yyerror (char*);
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

// El símbolo ID en la primera acción es $1, y el ID en la segunda acción es $1.
// No usamos $$ = $1 porque no es necesario para el flujo de pila.

assig_stmt : ID	            {
                            // ACCIÓN 1: Preparación de la Asignación
                            // Se imprime VALORI, que es la dirección donde guardaremos el resultado.
                            printf("\tvalori %s\n", $1);
                        }
		ASIGN expr	{
                            // ACCIÓN 2: Finalización de la Asignación
                            // El código de 'expr' se imprime justo aquí.
                            printf("\tasigna\n");
                            // Si se requiriera liberar la memoria del ID: free($1);
                        }
	   ;

// --------------------------------------------------------------------------

| ID SUM_ASIGN	        {
                            // ACCIÓN 1: Preparación Compuesta
                            // 1. VALORI (Dirección para guardar)
                            printf("\tvalori %s\n", $1);
                            // 2. VALORD (Valor actual como operando 1)
                            printf("\tvalord %s\n", $1);
                        }
		expr		{
                            // ACCIÓN 2: Finalización Compuesta
                            // El código de 'expr' se imprime implícitamente aquí (operando 2).
                            printf("\tsum\n");
                            printf("\tasigna\n");
                        }

// --------------------------------------------------------------------------

| ID SUB_ASIGN	        {
                            // ACCIÓN 1: Preparación Compuesta
                            printf("\tvalori %s\n", $1);
                            printf("\tvalord %s\n", $1);
                        }
		expr		{
                            // ACCIÓN 2: Finalización Compuesta
                            printf("\tsub\n");
                            printf("\tasigna\n");
                        }

// --------------------------------------------------------------------------

| ID MUL_ASIGN	        {
                            // ACCIÓN 1: Preparación Compuesta
                            printf("\tvalori %s\n", $1);
                            printf("\tvalord %s\n", $1);
                        }
		expr		{
                            // ACCIÓN 2: Finalización Compuesta
                            printf("\tmul\n");
                            printf("\tasigna\n");
                        }

// --------------------------------------------------------------------------

| ID DIV_ASIGN	        {
                            // ACCIÓN 1: Preparación Compuesta
                            printf("\tvalori %s\n", $1);
                            printf("\tvalord %s\n", $1);
                        }
		expr		{
                            // ACCIÓN 2: Finalización Compuesta
                            printf("\tdiv\n");
                            printf("\tasigna\n");
                        }
	;		

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

int yyerror(char *s){
	fprintf(stderr, "%s\n", s);
	exit(-1);
}

int main(){
	yyparse();
	return 0;
}

