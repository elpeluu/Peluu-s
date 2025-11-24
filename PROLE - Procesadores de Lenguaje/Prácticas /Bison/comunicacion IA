// Analizador sintáctico de la pr3 
// Autor: Diego Garda Porto
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int nEtiqueta = 0;

int siguienteEtiqueta() {
    return nEtiqueta++;
}

void yyerror (const char *s);
extern int yylex();
extern char *yytext; // Necesario para acceder a yytext si se usa
%}

%union{
   int numero;
   char *id; 
   int eti; 
}

%token <numero>NUM <id>ID SI SINO IMPRIMIR MIENTRAS HACER SUM_ASIGN SUB_ASIGN MUL_ASIGN DIV_ASIGN ASIGN
%type <eti> sel_stmt iter_stmt

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

// --- ESTRUCTURAS DE CONTROL ---

sel_stmt : SI '(' expr ')'      { 
                                  int lbl = siguienteEtiqueta();
                                  printf("\tsifalsovea LBL%d\n", lbl);
                                  $<eti>$ = lbl; 
                                } 
           '{' list_sntncs '}'  {
                                  int lbl_fin = siguienteEtiqueta();
                                  printf("\tvea LBL%d\n", lbl_fin);
                                  printf("LBL%d\n", $<eti>5); 
                                  $<eti>$ = lbl_fin; 
                                }
           SINO 
           '{' list_sntncs '}'  {
                                  printf("LBL%d\n", $<eti>9);
                                };
                                // Nota: He simplificado para asumir siempre SINO para que compile sin conflictos
                                // Si necesitas IF simple, requeriría factorización.

iter_stmt : MIENTRAS            {
                                  int lbl_ini = siguienteEtiqueta();
                                  printf("LBL%d\n", lbl_ini);
                                  $<eti>$ = lbl_ini; 
                                }
            '(' expr ')'        {
                                  int lbl_fin = siguienteEtiqueta();
                                  printf("\tsifalsovea LBL%d\n", lbl_fin);
                                  $<eti>$ = lbl_fin; 
                                }
            '{' list_sntncs '}' {
                                  printf("\tvea LBL%d\n", $<eti>2);
                                  printf("LBL%d\n", $<eti>5);
                                }
          | HACER               {
                                  int lbl_ini = siguienteEtiqueta();
                                  printf("LBL%d\n", lbl_ini);
                                  $<eti>$ = lbl_ini;
                                }
            '{' list_sntncs '}' 
            MIENTRAS '(' expr ')' {
                                  printf("\tsiciertovea LBL%d\n", $<eti>2);
                                };

// --- ASIGNACIONES ---
// Aquí usamos $1. Para que esto funcione, pr3.l DEBE tener yylval.id = strdup(yytext)
// Si NO modificas pr3.l, $1 será NULL y fallará (Segmentation Fault).

assig_stmt : ID { printf("\tvalori %s\n", $1); } 
             ASIGN expr { printf("\tasigna\n"); free($1); }

           | ID { printf("\tvalori %s\n", $1); printf("\tvalord %s\n", $1); } 
             SUM_ASIGN expr { printf("\tsum\n"); printf("\tasigna\n"); free($1); }

           | ID { printf("\tvalori %s\n", $1); printf("\tvalord %s\n", $1); } 
             SUB_ASIGN expr { printf("\tsub\n"); printf("\tasigna\n"); free($1); }

           | ID { printf("\tvalori %s\n", $1); printf("\tvalord %s\n", $1); } 
             MUL_ASIGN expr { printf("\tmul\n"); printf("\tasigna\n"); free($1); }

           | ID { printf("\tvalori %s\n", $1); printf("\tvalord %s\n", $1); } 
             DIV_ASIGN expr { printf("\tdiv\n"); printf("\tasigna\n"); free($1); }
           ;

expr : mult_expr
     | mult_expr '+' expr   {printf("\tsum\n");}       
     | mult_expr '-' expr   {printf("\tsub\n");}
     ;   
 
mult_expr : val 
     | val '*' mult_expr    {printf("\tmul\n");}        
     | val '/' mult_expr    {printf("\tdiv\n");}
     ;       

val : NUM       {printf("\tmete %d\n", $1);}        
    | ID        {printf("\tvalord %s\n", $1); free($1);} // Liberamos aquí si viene de pr3.l copiado
    | '(' expr ')';

%%

void yyerror(const char *s){
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}

int main(){
    yyparse();
    return 0;
}
