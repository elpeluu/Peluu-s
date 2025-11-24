// Analizador sintáctico de la pr3 - VERSION CORRECTA SOBRE LA QUE TRABAJAR 
// Autor: Diego Garda Porto
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaramos yytext para leer el nombre de la variable directamente desde Flex
extern char *yytext;
int yylex();
void yyerror (char *s);

int nEtiqueta = 0;

int siguienteEtiqueta() {
    return nEtiqueta++;
}
%}

%union{
   int numero;
   char *id; 
   int eti; 
}

%token <numero>NUM <id>ID SI SINO IMPRIMIR MIENTRAS HACER SUM_ASIGN SUB_ASIGN MUL_ASIGN DIV_ASIGN ASIGN
%type <eti> if_inicial mien_inicial id_asig id_op

%left '+' '-' 
%left '*' '/'

%%

list_sntncs : sntnc ';'
            | sntnc ';' list_sntncs;

sntnc : sel_stmt
      | iter_stmt
      | assig_stmt
      | print_stmt;

print_stmt : IMPRIMIR '(' expr ')'  { printf("\tprint\n"); };

// Definicion del SI inicial dentro de un token 
if_inicial : SI '(' expr ')' {
    int eti = siguienteEtiqueta();
    printf("\tsifalsovea LBL%d\n", eti);
    
    // Guardamos el numero de la etiqueta para usarla  
    $$ = eti; 
};

sel_stmt : if_inicial '{' list_sntncs '}' {
		// Etiqueta siguiente a todo el SI
		printf("LBL%d\n", $1);
           }
         | if_inicial '{' list_sntncs '}' SINO {
             int eti_fin = siguienteEtiqueta();
             printf("\tvea LBL%d\n", eti_fin); 
             printf("LBL%d\n", $1);            
             $<eti>$ = eti_fin;                
           } 
           '{' list_sntncs '}' {
	     // Etiqueta siguiente a todo el SI-SINO
             printf("LBL%d\n", $<eti>6);       
           };

// Definición del mientras inicial con las acciones semanticas correspondientes
mien_inicial : MIENTRAS {
    int eti = siguienteEtiqueta();
    
    // Etiqueta inicial del bucle mientras  
    printf("LBL%d\n", eti);
    $$ = eti;
};

iter_stmt : mien_inicial '(' expr ')' {
              int eti_fin = siguienteEtiqueta();
              printf("\tsifalsovea LBL%d\n", eti_fin);
              $<eti>$ = eti_fin; 
            } 
            '{' list_sntncs '}' {
              printf("\tvea LBL%d\n", $1);      
              printf("LBL%d\n", $<eti>5);       
            }
	    
	    // Bucle HACER-MIENTRAS
          | HACER {
              int eti_ini = siguienteEtiqueta();
              printf("LBL%d\n", eti_ini);
              $<eti>$ = eti_ini;
            } 
            '{' list_sntncs '}' MIENTRAS '(' expr ')' {
              printf("\tsiciertovea LBL%d\n", $<eti>2); 
            };

// Id de una asignacion normel "="
id_asig : ID {
	printf("\tvalori %s\n", $1);
}

// Id de asignaciones con operaciones "+=", "-=", "*=", "/="
id_op : ID {
	printf("\tvalori %s\n\tvalord %s\n", $1, $1);
}

assig_stmt : id_asig ASIGN expr { printf("\tasigna\n"); }
           |  
	     id_op SUM_ASIGN expr {printf("\tsum\n\tasigna\n");}
 
           | id_op SUB_ASIGN expr {printf("\tsub\n\tasigna\n");}

           | id_op MUL_ASIGN expr {printf("\tmul\n\tasigna\n");} 

           | id_op DIV_ASIGN expr {printf("\tdiv\n\tasigna\n");}
           ;

expr : mult_expr
     | expr '+' mult_expr   {printf("\tsum\n");}       
     | expr '-' mult_expr   {printf("\tsub\n");}
     ;   

 

mult_expr : val 
     | mult_expr '*' val    {printf("\tmul\n");}        
     | mult_expr '/' val    {printf("\tdiv\n");}
     ;       

val : NUM       {printf("\tmete %d\n", $1);}        
    | ID        {printf("\tvalord %s\n", yytext);}       
    | '(' expr ')';

%%

void yyerror(char *s){
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}

int main(){
    yyparse();
    return 0;
}
