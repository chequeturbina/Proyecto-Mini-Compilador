%{ 
#include <stdio.h>
#include <string.h>
#include "symbols.h"
#include "types.h"

int contadorEtiquetas= 0;
extern int yylineno;
char *newLabel();
code *codeGBL;

void yyerror(char *s);
extern int yylex();
int tipoGbl;
int dirGBL = 0;
int tamGBL;

typedef struct sym{
    char id[32];
    int tipo;    
    int dir;
} symbol;

typedef struct symtab{
    symbol syms[32];
    int num;
} SymTab;

SymTab tabla;

int insertar(char *id, int dir, int tipo);
void imprimirTabla();
void initTabla();
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
    struct{
        listIndices listaVerdadera;
        listIndices listaFalse;
    } exp_bool;
    struct {
        listIndices listaSiguientes;
    } sigs;
    char id[32];
    int tipoAtrib;
}

/*Tokens de la gramatica*/

%token<num> NUM
%token<id> ID

%token INT ENT
%token INT REAL
%token INT DREAL

%token CAR
%token SIN
%token REGISTRO
%token INICIO
%token FUNC
%token SINO
%token SI
%token DEVOLVER
%token FIN
%token ENTONCES
%token VERDADERO
%token FALSO
%token MIENTRAS
token MIENTRAS_QUE
%token LEER
%token ESCRIBIR
%token<sval> CADENA
%token<car> CARACTER

%token COMA
%token SL

%left ASIG
%left DISY
%left CONJ
%left<sval> IGUAL DIF
%left<sval> MAYOR MENOR MAYIGU MENIGU 
%left<sval> MAS MENOS
%left<sval> MUL DIV MOD
%left NOT

%nonassoc PARI PARD CORI CORD

/*Tipos de la gramatica*/

%type<tval> base tipo tipo_arreglo  tipo_registro declaraciones arg tipo_arg param_arr
%type<args_list> argumentos lista_arg lista_param parametros
%type<eval> expresion arreglo variable
%type<cond> expresion_booleana relacional
%type<sent> sentencias sentencia

%start program

%%
program: {initTabla();} declaracion {imprimirTabla();}sentencia;

declaracion: declaracion tipo {tipoGbl = $2;} lista SL {printf("D->D T L ;\n");}
            | tipo {tipoGbl = $1;} lista SL {printf("D-> T L ;\n");};

tipo: INT {$$ = 0; tamGBL = 4; printf("T->int\n");}  
    | FLOAT{$$= 1; tamGBL = 4;printf("T->float\n");};

lista: lista COMA ID {
    insertar($3,dirGBL, tipoGbl);
    dirGBL += tamGBL;
    printf("L->L, id\n");
} | ID{
    insertar($1,dirGBL, tipoGbl);
    dirGBL += tamGBL;
    printf("L-> id\n");
};

sentencia : sentencia
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

           /* | IF PARI expresion_booleana PARD sentencias %prec THEN
            | IF PARI expresion_booleana PARD sentencias ELSE sentencias */
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

int insertar(char *id, int dir, int tipo)
{    
    strcpy(tabla.syms[tabla.num].id , id);
    printf("%s\n", tabla.syms[tabla.num].id);
    tabla.syms[tabla.num].dir = dirGBL;
    tabla.syms[tabla.num].tipo = tipoGbl;
    tabla.num++;
}

void initTabla(){
    tabla.num = 0;
}

void imprimirTabla(){
    int i;
    printf("ID\tDIR\tTIPO\n");
    for(i= 0; i < tabla.num; i++){
        printf("%s\t%d\t%d\n", tabla.syms[tabla.num].id, tabla.syms[tabla.num].dir, tabla.syms[tabla.num].tipo);
    }
    printf("Dirección %d\n", dirGBL);
}

char res[45];

char *newLabel(){
    char etiqueta[45];    
    contadorEtiquetas++;    
    sprintf(etiqueta, "L%d", contadorEtiquetas);
    return etiqueta;
}