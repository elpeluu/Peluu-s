// Analizador sintáctico de la pr3 
// Autor: Diego Garda Porto
%{
   int nEtiqueta =0;

   int siguienteEtiqueta(nEtiqueta)
   {
	 
   }

%}

%union{
   int numero;
   char	*id; 
   int eti; 
}

// Definicion de los tokens con los que se trabaja
%token <numero>NUM <id>ID SI SINO IMPRIMIR MIENTRAS HACER
%left '+' '-' 
%left '*' '/'	// Mayor precedencia sobre suma y resta
%%
list_sntncs : sntnc ';'
	   | sntnc ';' list_sntncs;

sntnc : sel_stmt
      |	iter_stmt
      | assig_stmt
      | print_stmt;

print_stmt : IMPRIMIR '(' expr ')';	{printf("\tprint\n");}

sel_stmt : SI '(' expr ')'	{printf("\tsifalsovea LBL%d\n", ...);}
	 '{' list_sntncs '}'
	 | 
	 SI '(' expr ')'      	  {printf("\tsifalsovea LBL%d\n", ...);} 
	 '{' list_sntncs '}' 
	 SINO			                {printf("\tvea LBL%d\n", ...);
				                     printf("LBL%d\n", ...);} 
	 '{' list_sntncs '}';	    {printf("LBL%d\n", ...);}

iter_stmt : MIENTRAS		    {printf("LBL%d\n", ...);} 

	'(' expr ')'		          {printf("\tsifalsovea LBL%d\n", ...);} 
	'{' list_sntncs '}'	      {printf("\tvea LBL%d\n", ...);}
	|
	HACER			                {printf("LBL%d\n", ...);} 
	'{' list_sntncs '}' 
	MIENTRAS '(' expr ')';	  {printf("\tsiciertovea LBL%d\n");}

assig_stmt : ID			        {printf("\tvalori %s\n", $1);}
		'='expr		              {printf("\tasigna\n");}

	   | ID	'+='		          {printf("\tvalori %s\n", $1);
				                     printf("\tvalord %s\n", $1);}
		expr		                {printf("\tsum\n");
				                     printf("\tasigna\n");}

	   | ID	'-='		          {printf("\tvalori %s\n", $1);
				                     printf("\tvalord %s\n",$1);} 
		expr		                {printf("\tsub\n");
				                     printf("\tasigna\n");}

	   | ID	'*='		          {printf("\tvalori %s\n", $1);
				                     printf("\tvalord %s\n", $1);} 
		expr		                {printf("\tmul\n");
				                     printf("\tasigna\n");}

	   | ID	'/='		          {printf("\tvalori %s\n", $1);
				                     printf("\tvalord %s\n", $1);} 
		expr		                {printf("\tdiv\n");
				                     printf("\tasigna\n");}
			

expr : mult_expr
     | mult_expr '+' expr	  {printf("\tsum\n");}		
     | mult_expr '-' expr;	{printf("\tsub\n");}		
 
mult_expr : val 
	  | val '*' mult_expr    	{printf("\tmul\n");}		
	  | val '/' mult_expr;	  {printf("\tdiv\n");}		

val : NUM		                {printf("\tmete %d\n", $1);}		
    | ID		                {printf("\tvalord %s\n", $1);}		
    | '(' expr ')';

%%

int main(){
	yyparse();
	return 0;
}
