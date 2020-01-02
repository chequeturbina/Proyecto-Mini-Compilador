%{
#include<stdio.h>
#include<stdlib.h>
void yyerror(char *msg);
extern int yylex();
extern FILE *yyin;
extern int yylineno;
%}

%union{
    struct {
        char *sval;
        int tipo;
    } num;

    struct {
      char *sval;
    }  string;

    struct {
        char sval;
    } car;

    struct {
        char *sval;
    } id;
}

%token<num> NUM
%token<id> ID

%token ENT
%token REAL
%token DREAL
%token PC

%token CAR
%token SIN
%token REGISTRO
%token INICIO
%token FUNC
%token SI
%token DEVOLVER
%token FIN
%token ENTONCES
%token VERDADERO
%token HACER
%token TERMINAR
%token FALSO
%token MIENTRAS
%token MIENTRAS_QUE
%token LEER
%token ESCRIBIR
%token<string> CADENA
%token<car> CARACTER

%token COMA
%token PUNTO


%left ASIG
%left DISY
%left CONJ
%left<sval> IGUAL DIF
%left<sval> MAYOR MENOR MAYIGU MENIGU 
%left<sval> MAS MENOS
%left<sval> MUL DIV MOD
%left NOT
%nonassoc PARI PARD CORI CORD
%nonassoc SIX
%nonassoc SINO

%%

programa: declaraciones funciones { dir = 0
                                    StackTT = newStackTT();
                                    StackTS = newStackTS();
                                    ts = newSymTab();
                                    tt = newTypeTab();
                                    StackTT.push(tt);
                                    StackTS.push(ts);
                                    TablaDeCadenas = newTablaCadenas();
                                    }
          ;

declaraciones: tipo {type = $1.tipo} lista_var declaraciones
               | tipo_registro {type = $1.tipo} lista_var declaraciones
               | {}
               ;

tipo_registro: REGISTRO INICIO declaraciones FIN { ts = newSymTab();
                                                   tt = newTypeTab();
                                                   StackDir.push(dir);
                                                   dir = 0;
                                                   StackTT.push(tt);
                                                   StackTS.push(ts);
                                                   dir = StackDir.pop();
                                                   tt1 = StackTT.pop();
                                                   StackTS.getCima().setTT(tt1);
                                                   ts1 = StackTS.pop();
                                                   dir = StackDir.pop();
                                                   type = StackTT.getCima().addTipo("registro", 0, ts1);}
               ;

tipo: base {base = base.tipo;} tipo_arreglo {$$.tipo = $2.tipo;}
      ;

base: ENT {$$.tipo = 1;}
      | REAL {$$.tipo = 2}
      | DREAL {$$.tipo = 3;}
      | CAR {$$.tipo = 4;}
      | SIN {$$.tipo = 0;}
      ;

tipo_arreglo: CORI NUM CORD tipo_arreglo {if ($2.tipo == 1 && $2.sval) {
                                                $$.tipo = StackTT.getCima().addTipo("array", $2.sval, $4.tipo);
                                          } else {
                                            yyerror("EL indice tiene que ser entero y mayor que cero")
                                          }}
              | $$.tipo = base;
              ;

lista_var: lista_var COMA ID { if (StackTS.getCima().getId($3.sval) == -1) {
                                  StackTS.getCima().addSym($3.sval, dir, "var");
                                  dir = dir + StackTT.getCima().getTam(tipo);
                               } else {
                                 yyerror("El identificador ya fue declarado");
                               }}
           | ID { if (StackTS.getCima().getId($1.sval) == -1) {
                                  StackTS.getCima().addSym($1.sval, dir, "var");
                                  dir = dir + StackTT.getCima().getTam(tipo);
                               } else {
                                 yyerror("El identificador ya fue declarado");
                               }}
           ;

funciones: FUNC tipo ID PARI argumentos PARD INICIO declaraciones sentencias FIN funciones
           | /*empty*/
           ;

argumentos: lista_arg {$$.lista = $1.lista;}
            | SIN {$$.lista = NULL;}
            ;

lista_arg: lista_arg arg {$$.lista = $1.lista;
                          $$.lista.add($2.tipo);}
           | arg {$$.lista = newListaParam();
                  $$.lista.add($1.tipo);}
           ;

arg: tipo_arg ID
    ;

tipo_arg: base param_arr
        ;

param_arr: CORI CORD param_arr
           | /*empty*/
           ;

sentencias: sentencias sentencia
            | sentencia
            ;

sentencia: SI expresion_booleana ENTONCES sentencias FIN %prec SIX
           | SI expresion_booleana sentencias SINO sentencias FIN
           | MIENTRAS expresion_booleana HACER sentencias FIN
           | HACER sentencias MIENTRAS_QUE expresion_booleana
           | ID ASIG expresion
           | variable ASIG expresion
           | ESCRIBIR expresion
           | LEER variable
           | DEVOLVER PC
           | DEVOLVER expresion PC
           | TERMINAR
           ;

expresion_booleana: expresion_booleana DISY expresion_booleana
                    | expresion_booleana CONJ expresion_booleana
                    | NOT expresion_booleana
                    | relacional
                    | VERDADERO
                    | FALSO
                    ;

relacional: relacional MENOR relacional
            | relacional MAYOR relacional
            | relacional MENIGU relacional
            | relacional MAYIGU relacional
            | relacional IGUAL relacional
            | relacional DIF relacional
            | expresion
            ;

expresion: expresion MAS expresion
           | expresion MENOS expresion
           | expresion MUL expresion
           | expresion DIV expresion
           | expresion MOD expresion
           | PARI expresion PARD
           | variable
           | NUM 
           | CADENA
           | CARACTER
           | ID PARI parametros PARD
           ;

variable: ID
          | arreglo
          | ID PUNTO ID
          ;

arreglo: ID CORI expresion CORD 
         | arreglo CORI expresion CORD
         ;

parametros: lista_param
            | /*empty*/
            ;

lista_param: lista_param COMA expresion
             | expresion
             ;

%%

//extern int yylex();
//extern FILE *yyin;

void yyerror(char *msg){
    printf("%s: En la linea %i\n", msg, yylineno);
}

int main(int argc, char **argv){
    //printf("antes de la violación de seg");
    if(argc < 2) return -1;
    //printf("antes de la violación de seg");
    FILE *f = fopen(argv[1], "r");
    if(!f) return -1;
    yyin = f;
    //printf("antes de la violación de seg");
    int w = yyparse();
    //printf("despues de la violación de seg");
    if(!w){
      printf("LA CADENA ES LÉXICA Y SINTÁCTICAMENTE CORRECTA.");
    } else {
        printf("Error sintactico\n");
    }
    fclose(f);
    return 0;
}
