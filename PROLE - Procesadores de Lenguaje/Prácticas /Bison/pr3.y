// Analizador sintáctico de la pr3 
// Autor: Diego Garda Porto
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaramos yytext para leer el nombre de la variable directamente desde Flex
extern char *yytext;
extern int yylex();
void yyerror (const char *s);

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
%type <eti> if_cabecera iter_cabecera

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

// --- ESTRUCTURAS DE CONTROL (FACTORIZADAS) ---

if_cabecera : SI '(' expr ')' {
    int lbl = siguienteEtiqueta();
    printf("\tsifalsovea LBL%d\n", lbl);
    $$ = lbl; 
};

sel_stmt : if_cabecera '{' list_sntncs '}' {
             printf("LBL%d\n", $1);
           }
         | if_cabecera '{' list_sntncs '}' SINO {
             int lbl_fin = siguienteEtiqueta();
             printf("\tvea LBL%d\n", lbl_fin); 
             printf("LBL%d\n", $1);            
             $<eti>$ = lbl_fin;                
           } 
           '{' list_sntncs '}' {
             printf("LBL%d\n", $<eti>6);       
           };

iter_cabecera : MIENTRAS {
    int lbl = siguienteEtiqueta();
    printf("LBL%d\n", lbl);
    $$ = lbl;
};

iter_stmt : iter_cabecera '(' expr ')' {
              int lbl_fin = siguienteEtiqueta();
              printf("\tsifalsovea LBL%d\n", lbl_fin);
              $<eti>$ = lbl_fin; 
            } 
            '{' list_sntncs '}' {
              printf("\tvea LBL%d\n", $1);      
              printf("LBL%d\n", $<eti>5);       
            }
          | HACER {
              int lbl_ini = siguienteEtiqueta();
              printf("LBL%d\n", lbl_ini);
              $<eti>$ = lbl_ini;
            } 
            '{' list_sntncs '}' MIENTRAS '(' expr ')' {
              printf("\tsiciertovea LBL%d\n", $<eti>2); 
            };


// --- ASIGNACIONES (USANDO yytext) ---
// IMPORTANTE: Usamos yytext en lugar de $1 porque $1 es nulo si no usas strdup en el .l

assig_stmt : ID { printf("\tvalori %s\n", yytext); } 
             ASIGN expr { printf("\tasigna\n"); }

           | ID { 
               printf("\tvalori %s\n", yytext); 
               printf("\tvalord %s\n", yytext); 
             } 
             SUM_ASIGN expr { printf("\tsum\n"); printf("\tasigna\n"); }

           | ID { 
               printf("\tvalori %s\n", yytext); 
               printf("\tvalord %s\n", yytext); 
             } 
             SUB_ASIGN expr { printf("\tsub\n"); printf("\tasigna\n"); }

           | ID { 
               printf("\tvalori %s\n", yytext); 
               printf("\tvalord %s\n", yytext); 
             } 
             MUL_ASIGN expr { printf("\tmul\n"); printf("\tasigna\n"); }

           | ID { 
               printf("\tvalori %s\n", yytext); 
               printf("\tvalord %s\n", yytext); 
             } 
             DIV_ASIGN expr { printf("\tdiv\n"); printf("\tasigna\n"); }
           ;

// --- EXPRESIONES ---

expr : mult_expr
     | mult_expr '+' expr   {printf("\tsum\n");}       
     | mult_expr '-' expr   {printf("\tsub\n");}
     ;   
 
mult_expr : val 
     | val '*' mult_expr    {printf("\tmul\n");}        
     | val '/' mult_expr    {printf("\tdiv\n");}
     ;       

val : NUM       {printf("\tmete %d\n", $1);}        
    | ID        {printf("\tvalord %s\n", yytext);}  // Usamos yytext aquí también      
    | '(' expr ')';

%%

void yyerror(const char *s){
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}

int main(){
    yyparse();
    return 0;
}
