/*
   S-> E \n S | E
   E -> E + E | E - E | E * E | E / E | (E) | num
*/

%{ 
#include <stdio.h>
void yyerror(char *s);
extern int yylex();
%}

%union{
    struct{
        int tipo;
        //char valor[100];
        union{
            int ival;
            float fval;
        }valor;
    }num;
}

%token<num> NUM
%token SL

%left MAS MENOS
%left MUL DIV
%nonassoc PARI PARD

%type<num> expresion

%start inicial

%%
inicial : inicial 
           SL expresion {if ($3.tipo == 0)
                        printf("El resultado es %d\n", $3.valor.ival);
                     else
                        printf("El resultado es %f\n", $3.valor.fval);
                    } 
        | expresion {if ($1.tipo == 0)
                        printf("El resultado es %d\n", $1.valor.ival);
                     else
                        printf("El resultado es %f\n", $1.valor.fval);
                    }
    ;

expresion : expresion MAS expresion{ if($1.tipo == $3.tipo){
                                        $$.tipo = $1.tipo;                            
                                        if($1.tipo = 0){                                            
                                            $$.valor.ival = $1.valor.ival + $3.valor.ival;
                                            printf("%d = %d + %d\n", $$.valor.ival, $1.valor.ival, $3.valor.ival);
                                        }else{
                                            $$.valor.fval = $1.valor.fval + $3.valor.fval;
                                        }                                        
                                     }
                                     //printf("E-> E+E\n");
                                    }
           | expresion MENOS expresion{ if($1.tipo == $3.tipo){
                                            $$.tipo = $1.tipo;                            
                                            if($1.tipo = 0){
                                                $$.valor.ival = $1.valor.ival - $3.valor.ival;
                                            }else{
                                                $$.valor.fval = $1.valor.fval - $3.valor.fval;
                                            }                                                                                    
                                        }
                                        //printf("E-> E-E\n");
                                    }
           | expresion MUL expresion{ if($1.tipo == $3.tipo){
                                        $$.tipo = $1.tipo;
                                        if($1.tipo = 0){
                                            $$.valor.ival = $1.valor.ival * $3.valor.ival;
                                        }else{
                                            $$.valor.fval = $1.valor.fval * $3.valor.fval;
                                        }                                        
                                     }
                                     //printf("E-> E*E\n");
                                    }
           | expresion DIV expresion{ if($1.tipo == $3.tipo){
                                        $$.tipo = $1.tipo;
                                        if($1.tipo = 0){                                            
                                            if($3.valor.ival != 0)
                                                $$.valor.ival = $1.valor.ival - $3.valor.ival;
                                            else
                                                yyerror("No se puede hacer la división entre cero");
                                        }else{                                                            
                                            if($3.valor.fval != 0)                                            
                                                $$.valor.fval = $1.valor.fval - $3.valor.fval;                                                                       
                                            else
                                                yyerror("No se puede hacer la división entre cero");

                                        }                                        
                                     }
                                     //printf("E-> E/E\n");
                                    }
        | PARI expresion PARD {
                                $$ = $2;
                                //printf("E-> (E)\n");
                            } 
        |NUM {                
                $$ = $1;
                //printf("E-> num\n");
             }
        ;

%%

void yyerror(char *s)
{
    printf("%s\n", s);
}