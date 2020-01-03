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
          {if (StackTS.getFondo().get($3.sval) != -1) {
                StackTS.getFondo().addSym($3.sval, $2,-,-,"func");
                StackDir.push(dir);
                FuncType = $2.tipo;
                FuncReturn == false;
                dir = 0;
                StackTT.push(tt);
                StackTS.push(ts);
                dir = StackDir.pop();
                add_quad(code, "label",-,-,$3.sval);
                L = newLabel();
                backpatch(code, $9.next, L);
                add_quad(code, "label", -, -, L);
                StackTT.pop();
                StackTS.pop();
                dir = StackDir.pop();
                StackTS.getCima().addArgs($3.sval, $5.lista);
                if ($2.tipo != sin && FuncReturn == false) {
                  yyerror("La funcion no tiene valor de retorno");
                }
            } else {
              yyerror("El identific ador ya fue declarado");
            }}
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

arg: tipo_arg ID {
        if(StackTS.getCima().getId($2.sval) == -1){
            StackTS.getCima().addSym($2.sval,tipo,dir,"var");
            dir = dir + StackTT.getCima().getTam(tipo);
        }else{
            yyerror("El identificador ya fue declarado"):
        }
        arg.tipo = tipo_arg.tipo;
            };

tipo_arg: base param_arr{
        base = base.tipo;
        tipo_arg.tipo = param_arr.tipo;
            };

param_arr: CORI CORD param_arr1{
        $$.tipo = StackTT.getCima().addTipo("array", -, $3.tipo);
        }
           | /*empty*/ {
               $$.tipo = base;
           }
           ;

sentencias: sentencias sentencia{
            L = newLabel();
            backpatch(code, sentencias.listnext,L);
            $1.listnext = $2.listnext;
            }
            | sentencia{
                $$.listnext = $1.listnext;
            };

sentencia: SI expresion_booleana ENTONCES sentencias FIN %prec SIX{
            L = newLabel();
            backpatch(code,expresion_booleana.listtrue,L);
            $$.listnext = combinar($2.listfalse, $4.listnext);
            }
           | SI expresion_booleana sentencias SINO sentencias FIN{
               L = newLabel();
               L1 = newLabel();
               backpatch(code, $2.listtrue,L);
               backpatch(code, $2.listfalse,L1);
               $$.listnext = combinar($3.listnext,$5.listnext);
           }
           | MIENTRAS expresion_booleana HACER sentencias FIN{
               L = newLabel();
               L1 = newLabel();
               backpatch(code,$4.listnext,L);
               backpatch(code,$2.listtrue,L1);
               $$.listnext = $2.listfalse;
               add_quad(code,"goto",-,-,L);
           }
           | HACER sentencia MIENTRAS_QUE expresion_booleana{
               L = newLabel();
               backpatch(code,$4.listtrue,L);
               backpatch(code,$2.listnext,L1);
               $$.listnext = $4.listfalse;
               add_quad(code,"label",-,-,L);
           }
           | ID ASIG expresion{
               if(StackTS.getCima().getId($1.sval) != -1){
                   t = StackTS.getCima().getTipo($1.sval);
                   d = StackTS.getCima().getDir($1.sval);
                   alfa = reducir($3.dir,$3.tipo,t);
                   add_quad(code,"=",alfa,-,"Id"+d);
               }else{
                   yyerror("El identificador no ha sido declarado");
               }
               $$.listnext = NULL;
           }
           | variable ASIG expresion{
               alfa = reducir($3.dir,$3.tipo,$1.tipo);
               add_quad(code,"=",alfa,-,$1.base[$1.dir]);
               $$.listnext = NULL;
           }
           | ESCRIBIR expresion{
               add_quad(code,"print",$2.dir,-,-);
               $$.listnext = NULL;
           }
           | LEER variable{
               add_quad(code,"scan",-,-,$2.dir);
               $$.listnext = NULL;
           }
           | DEVOLVER PC{
               if(FuncType = sin){
                   add_quad(code,"return",-,-,-);
               }else{
                   yyerror("La funcion debe retornar algun valor de tipo" + FuncType);
               }
               $$.listnext = null;
           }
           | DEVOLVER expresion PC{
               if(FuncType != sin){
                   alfa = reducir($2.dir, $2.tipo, FuncType);
                   add_quad(code,"return",$2.dir,-,-);
                   FuncReturn = true;
               }else{
                   yyerror("La funcion no puede retornar algun valor de tipo");
               }
               $$.listnext = null;
           }
           | TERMINAR{
               I = newIndex();
               add_quad(code,"goto",-,-,I);
               $$.listnext = newList();
               $$.listnext.add(I);
           };

expresion_booleana: expresion_booleana DISY expresion_booleana{
                        L = newLabel();
                        backpatch(code, $1.listfalse,L);
                        $$.listtrue = combinar($1.listtrue,$3.listtrue);
                        $$.listfalse = $3.listfalse;
                        add_quad(code,"label",-,-,L);
                    }
                    | expresion_booleana CONJ expresion_booleana{
                      L = newLabel();
                      backpatch(code,$1.listtrue,L);
                      $$.listtrue = $3.listtrue;
                      $$.listfalse = combinar($1.listfalse,$3.listfalse);
                      add_quad(code,"label",-,-,L);
                    }
                    | NOT expresion_booleana{
                      $$.listtrue = $2.listfalse;
                      $$.listfalse = $2.listtrue;
                    }
                    | relacional{
                      $$.listtrue = $1.listtrue;
                      $$.listfalse = $1.listfalse;
                    }
                    | VERDADERO{
                      I = newIndex();
                      $$.listtrue = newList();
                      $$.listtrue.add(I);
                      add_quad(code,"goto",-,-,I);
                      $$.listfalse = NULL;
                    }
                    | FALSO{
                      I = newIndex();
                      $$.listtrue = NULL;
                      $$.listfalse = newList();
                      $$.listtrue.add(I);
                      add_quad(code,"goto",-,-,I);
                    }
                    ;

relacional: relacional MENOR relacional{
                $$.listtrue = newList();
                $$.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                $$.listtrue.add(I);
                $$.listfalse.add(I1);
                $$.tipo = max($1.tipo, $3.tipo);
                alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
                alfa2 = ampliar($3.dir, $3.tipo, $$.tipo);
                add_quad(code,"<",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
             }
            | relacional MAYOR relacional{
                $$.listtrue = newList();
                $$.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                $$.listtrue.add(I);
                $$.listfalse.add(I1);
                $$.tipo = max($1.tipo, $3.tipo);
                alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
                alfa2 = ampliar($3.dir, $3.tipo, $$.tipo);
                add_quad(code,">",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional MENIGU relacional{
                $$.listtrue = newList();
                $$.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                $$.listtrue.add(I);
                $$.listfalse.add(I1);
                $$.tipo = max($1.tipo, $3.tipo);
                alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
                alfa2 = ampliar($3.dir, $3.tipo, $$.tipo);
                add_quad(code,"<=",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional MAYIGU relacional{
                $$.listtrue = newList();
                $$.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                $$.listtrue.add(I);
                $$.listfalse.add(I1);
                $$.tipo = max($1.tipo, $3.tipo);
                alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
                alfa2 = ampliar($3.dir, $3.tipo, $$.tipo);
                add_quad(code,">=",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional IGUAL relacional{
                $$.listtrue = newList();
                $$.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                $$.listtrue.add(I);
                $$.listfalse.add(I1);
                $$.tipo = max($1.tipo, $3.tipo);
                alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
                alfa2 = ampliar($3.dir, $3.tipo, $$.tipo);
                add_quad(code,"==",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional DIF relacional{
                $$.listtrue = newList();
                $$.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                $$.listtrue.add(I);
                $$.listfalse.add(I1);
                $$.tipo = max($1.tipo, $3.tipo);
                alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
                alfa2 = ampliar($3.dir, $3.tipo, $$.tipo);
                add_quad(code,"<>",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | expresion{
              $$.tipo = $1.tipo;
              $$.dir = $1.dir;
            }
            ;

expresion: expresion MAS expresion{
              $$.tipo = max($1.tipo,$3.tipo);
              $$.dir = newTemp();
              alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
              alfa2 = ampliar($3.dir,$3.tipo,$$.tipo);
              add_quad(code,"+",alfa1,alfa2,$$.dir);
            }
           | expresion MENOS expresion{
              $$.tipo = max($1.tipo,$3.tipo);
              $$.dir = newTemp();
              alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
              alfa2 = ampliar($3.dir,$3.tipo,$$.tipo);
              add_quad(code,"-",alfa1,alfa2,$$.dir);
           }
           | expresion MUL expresion{
              $$.tipo = max($1.tipo,exp$3resion2.tipo);
              $$.dir = newTemp();
              alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
              alfa2 = ampliar($3.dir,$3.tipo,$$.tipo);
              add_quad(code,"*",alfa1,alfa2,$$.dir);
           }
           | expresion DIV expresion{
              $$.tipo = max($1.tipo,$3.tipo);
              $$.dir = newTemp();
              alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
              alfa2 = ampliar($3.dir,$3.tipo,$$.tipo);
              add_quad(code,"/",alfa1,alfa2,$$.dir);
           }
           | expresion MOD expresion{
              $$.tipo = max($1.tipo,$3.tipo);
              $$.dir = newTemp();
              alfa1 = ampliar($1.dir, $1.tipo, $$.tipo);
              alfa2 = ampliar($3.dir,$3.tipo,$$.tipo);
              add_quad(code,"%",alfa1,alfa2,$$.dir);
           }
           | PARI expresion PARD{
             $$.dir = $1.dir;
             $$.tipo = $1.tipo;
           }
           | variable{
             $$.dir = newTemp();
             $$.tipo = $1.tipo;
             add_quad(code,"*",$1.base[$1.dir],-,$$.dir);
           }
           | NUM{
             $$.tipo = $1.tipo;
             $$.dir = $1.sval;
           } 
           | CADENA{
             $$.tipo = cadena;
             $$.dir = TablaDeCadenas.add(cadena);
           }
           | CARACTER{
             $$.tipo = caracter;
             $$.dir = TablaDeCadenas.add(caracter);
           }
           | ID PARI parametros PARD{
             if(StackTS.getFondo().getId($1.sval) != -1){
               if(StackTS.getFondo().getVar($1.sval) == "func"){
                 lista = StackTS.getFondo().getArgs($1.sval);
                 if(lista.getTam() != $3.getTam()){
                   yyerror("El numero de argumentos no coincide");
                 }
                 for(i=0,i<$3.lista.getTam(),1){
                   if($3[i] != lista[i]){
                     yyerror("El tipo de parametros no coincide");
                   }
                 }
                 $$.dir = newTemp();
                 $$.tipo = StackTS.getFondo().getTipo($1.sval);
                 add_quad(code,"=","call",$1.sval,$$.dir);
               }
             }else{
               yyerror("El identificador no ha sido declarado");
             }
           }
           ;

variable: ID{
            if(buscar(getCima(StackTS),$1)!=-1){
              $$.dir = getDir(getCima(StackTS),$1);
              $$.tipo = getTipo(getCima(StackTS),$1);
              strcpy($$.base,"");
              }else{
                yyerror("variable ya definida");
                }
          }
          | arreglo{
            $$.dir = $1.dir;
            $$.base = $1.base;
            $$.tipo = $1.tipo;
          }
          | ID PUNTO ID{
            if(StackTS.getFondo().getId($1.sval) != -1){
              t = StackTS.getFondo().getTipo($1.sval);
              t1 = StackTT.getFondo().getTipo(t);
              if(t1 == "registro"){
                tipoBase = StackTT.getFondo().getTipoBase(t);
                if(tipoBase.getId($3) != -1){
                  $$.tipo = tipoBase.getType($3);
                  $$.dir = $3;
                  $$.base = $1;
                }else{
                  yyerror("El id no existe en la estructura");
                }
              }else{
                yyerror("el id noes una estructura");
              }
            }else{
              yyerror("El identificador no ha sido declarado");
            }
          }
          ;

arreglo: ID CORI expresion CORD{
            if(StackTS.getCima().getId($1.sval) != -1){
              t = StackTS.getCima().getTipo($1.sval);
              if(StackTT.getCima().getTipo(t) == "array"){
                if($3.tipo == ent){
                  $$.base = $1.sval;
                  $$.tipo = StackTT.getCima().getTipoBase(t);
                  $$.tam = StackTT.getCima().getTipo($$.tipo);
                  $$.dir = newTemp();
                  add_quad(code,"*",$3.dir,$$.tam,$$.dir);
                }
              }else{
                yyerror("La expresion para un indice debe ser de tipo entero");
              }
            }else{
              yyerror("El identificador no ha sido declarado");
            }
          }
         | arreglo CORI expresion CORD{
           if(StackTT.getCima().getTipoBase($1.tipo) == "array"){
             if($3.tipo == ent){
               $$.base = $1.base;
               $$.tipo = StackTT.getCima().getTipoBase($1.tipo);
               $$.tam = StackTT.getCima().getTipo($$.tipo);
               temp = newTemp();
               $$.dir = newTemp();
               add_quad(code,"*",$3.dir,$$.tam,temp);
               add_quad(code,"+",$1.dir,temp,$$.dir);
             }else{
               yyerror("La expresion par aun indice debe ser de tipo entero");
             }
           }else{
             yyerror("El arreglo no tiene tantas dimensiones");
           }
         }
         ;

parametros: lista_param{
              $$.lista = $1.lista;
             }
            | /*empty*/{
              $$.lista = null;
            }
            ;

lista_param: lista_param1 COMA expresion{
                $$.lista = $1.lista;
                $$.lista.add($3.tipo);
                add_quad(code,"param",$3.dir,-,-);
              }
             | expresion{
               $$.lista = newListaParam();
               $$.lista.add($3.tipo);
               add_quad(code,"param",$3.dir,-,-);
             }
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