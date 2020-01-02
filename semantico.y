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

arg: tipo_arg ID {
        if(StackTS.getCima().getId(id.lexval) == -1){
            StackTS.getCima().addSym(id.lexval,tipo,dir,"var");
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
            sentencias.listnext = sentencia.listnext;
            }
            | sentencia{
                sentencias.listnext = sentencia.listnext;
            };

sentencia: SI expresion_booleana ENTONCES sentencias FIN %prec SIX{
            L = newLabel();
            backpatch(code,expresion_booleana.listtrue,L);
            sentencia.listnext = combinar(expresion_booleana.listfalse, sentencias.listnext);
            }
           | SI expresion_booleana sentencias1 SINO sentencias2 FIN{
               L = newLabel();
               L1 = newLabel();
               backpatch(code, expresion_booleana.listtrue,L);
               backpatch(code, expresion_booleana.listfalse,L1);
               sentencia.listnext = combinar(sentencias1.listnext,sentencias2.listnext);
           }
           | MIENTRAS expresion_booleana HACER sentencias FIN{
               L = newLabel();
               L1 = newLabel();
               backpatch(code,sentencias.listnext,L);
               backpatch(code,expresion_booleana.listtrue,L1);
               sentencia.listnext = expresion_booleana.listfalse;
               add_quad(code,"goto",-,-,L);
           }
           | HACER sentencia MIENTRAS_QUE expresion_booleana{
               L = newLabel();
               backpatch(code,expresion_booleana.listtrue,L);
               backpatch(code,sentencias.listnext,L1);
               sentencia.listnext = expresion_booleana.listfalse;
               add_quad(code,"label",-,-,L);
           }
           | ID ASIG expresion{
               if(StackTS.getCima().getId(id.lexval) != -1){
                   t = StackTS.getCima().getTipo(id.lexval);
                   d = StackTS.getCima().getDir(id.lexval);
                   alfa = reducir(expresion.dir,expresion.tipo,t);
                   add_quad(code,"=",alfa,-,"Id"+d);
               }else{
                   yyerror("El identificador no ha sido declarado");
               }
               sentencia.listnext = null;
           }
           | variable ASIG expresion{
               alfa = reducir(expresion.dir,expresion.tipo,variable.tipo);
               add_quad(code,"=",alfa,-,variable.base[variable.dir]);
               sentencia.listnext = null;
           }
           | ESCRIBIR expresion{
               add_quad(code,"print",expresion.dir,-,-);
               sentencia.listnext = null;
           }
           | LEER variable{
               add_quad(code,"scan",-,-,variable.dir);
               sentencia.listnext = null;
           }
           | DEVOLVER PC{
               if(FuncType = sin){
                   add_quad(code,"return",-,-,-);
               }else{
                   yyerror("La funcion debe retornar algun valor de tipo" + FuncType);
               }
               sentencia.listnext = null;
           }
           | DEVOLVER expresion PC{
               if(FuncType != sin){
                   alfa = reducir(expresion.dir, expresion.tipo, FuncType);
                   add_quad(code,"return",expresion.dir,-,-);
                   FuncReturn = true;
               }else{
                   yyerror("La funcion no puede retornar algun valor de tipo");
               }
               sentencia.listnext = null;
           }
           | TERMINAR{
               I = newIndex();
               add_quad(code,"goto",-,-,I);
               sentencia.listnext = newList();
               sentencia.listnext.add(I);
           };

expresion_booleana: expresion_booleana1 DISY expresion_booleana2{
                        L = newLabel();
                        backpatch(code, expresion_booleana1.listfalse,L);
                        expresion_booleana.listtrue = combinar(expresion_booleana1.listtrue,expresion_booleana2.listtrue);
                        expresion_booleana.listfalse = expresion_booleana2.listfalse;
                        add_quad(code,"label",-,-,L);
                    }
                    | expresion_booleana CONJ expresion_booleana{
                      L = newLabel();
                      backpatch(code,expresion_booleana1.listtrue,L);
                      expresion_booleana.listtrue = expresion_booleana2.listtrue;
                      expresion_booleana.listfalse = combinar(expresion_booleana1.listfalse,expresion_booleana2.listfalse);
                      add_quad(code,"label",-,-,L);
                    }
                    | NOT expresion_booleana1{
                      expresion_booleana.listtrue = expresion_booleana1.listfalse;
                      expresion_booleana.listfalse = expresion_booleana1.listtrue;
                    }
                    | relacional{
                      expresion_booleana.listtrue = relacional.listtrue;
                      expresion_booleana.listfalse = relacional.listfalse;
                    }
                    | VERDADERO{
                      I = newIndex();
                      expresion_booleana.listtrue = newList();
                      expresion_booleana.listtrue.add(I);
                      add_quad(code,"goto",-,-,I);
                      expresion_booleana.listfalse = null;
                    }
                    | FALSO{
                      I = newIndex();
                      expresion_booleana.listtrue = null;
                      expresion_booleana.listfalse = newList();
                      expresion_booleana.listtrue.add(I);
                      add_quad(code,"goto",-,-,I);
                    }
                    ;

relacional: relacional1 MENOR relacional2{
                relacional.listtrue = newList();
                relacional.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                relacional.listtrue.add(I);
                relacional.listfalse.add(I1);
                relacional.tipo = max(relacional1.tipo, relacional2.tipo);
                alfa1 = ampliar(relacional1.dir, relacional1.tipo, relacional.tipo);
                alfa2 = ampliar(relacional2.dir, relacional2.tipo, relacional.tipo);
                add_quad(code,"<",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
             }
            | relacional1 MAYOR relacional2{
                relacional.listtrue = newList();
                relacional.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                relacional.listtrue.add(I);
                relacional.listfalse.add(I1);
                relacional.tipo = max(relacional1.tipo, relacional2.tipo);
                alfa1 = ampliar(relacional1.dir, relacional1.tipo, relacional.tipo);
                alfa2 = ampliar(relacional2.dir, relacional2.tipo, relacional.tipo);
                add_quad(code,">",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional1 MENIGU relacional2{
                relacional.listtrue = newList();
                relacional.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                relacional.listtrue.add(I);
                relacional.listfalse.add(I1);
                relacional.tipo = max(relacional1.tipo, relacional2.tipo);
                alfa1 = ampliar(relacional1.dir, relacional1.tipo, relacional.tipo);
                alfa2 = ampliar(relacional2.dir, relacional2.tipo, relacional.tipo);
                add_quad(code,"<=",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional MAYIGU relacional{
                relacional.listtrue = newList();
                relacional.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                relacional.listtrue.add(I);
                relacional.listfalse.add(I1);
                relacional.tipo = max(relacional1.tipo, relacional2.tipo);
                alfa1 = ampliar(relacional1.dir, relacional1.tipo, relacional.tipo);
                alfa2 = ampliar(relacional2.dir, relacional2.tipo, relacional.tipo);
                add_quad(code,">=",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional IGUAL relacional{
                relacional.listtrue = newList();
                relacional.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                relacional.listtrue.add(I);
                relacional.listfalse.add(I1);
                relacional.tipo = max(relacional1.tipo, relacional2.tipo);
                alfa1 = ampliar(relacional1.dir, relacional1.tipo, relacional.tipo);
                alfa2 = ampliar(relacional2.dir, relacional2.tipo, relacional.tipo);
                add_quad(code,"==",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | relacional DIF relacional{
                relacional.listtrue = newList();
                relacional.listfalse = newList();
                I = newIndex();
                I1 = newIndex();
                relacional.listtrue.add(I);
                relacional.listfalse.add(I1);
                relacional.tipo = max(relacional1.tipo, relacional2.tipo);
                alfa1 = ampliar(relacional1.dir, relacional1.tipo, relacional.tipo);
                alfa2 = ampliar(relacional2.dir, relacional2.tipo, relacional.tipo);
                add_quad(code,"<>",alfa1,alfa2,I);
                add_quad(code,"goto",-,-,I1);
            }
            | expresion{
              relacional.tipo = expresion.tipo;
              relacional.dir = expresion.dir;
            }
            ;

expresion: expresion1 MAS expresion2{
              expresion.tipo = max(expresion1.tipo,expresion2.tipo);
              expresion.dir = newTemp();
              alfa1 = ampliar(expresion1.dir, expresion1.tipo, expresion.tipo);
              alfa2 = ampliar(expresion2.dir,expresion2.tipo,expresion.tipo);
              add_quad(code,"+",alfa1,alfa2,expresion.dir);
            }
           | expresion MENOS expresion{
              expresion.tipo = max(expresion1.tipo,expresion2.tipo);
              expresion.dir = newTemp();
              alfa1 = ampliar(expresion1.dir, expresion1.tipo, expresion.tipo);
              alfa2 = ampliar(expresion2.dir,expresion2.tipo,expresion.tipo);
              add_quad(code,"-",alfa1,alfa2,expresion.dir);
           }
           | expresion MUL expresion{
              expresion.tipo = max(expresion1.tipo,expresion2.tipo);
              expresion.dir = newTemp();
              alfa1 = ampliar(expresion1.dir, expresion1.tipo, expresion.tipo);
              alfa2 = ampliar(expresion2.dir,expresion2.tipo,expresion.tipo);
              add_quad(code,"*",alfa1,alfa2,expresion.dir);
           }
           | expresion DIV expresion{
              expresion.tipo = max(expresion1.tipo,expresion2.tipo);
              expresion.dir = newTemp();
              alfa1 = ampliar(expresion1.dir, expresion1.tipo, expresion.tipo);
              alfa2 = ampliar(expresion2.dir,expresion2.tipo,expresion.tipo);
              add_quad(code,"/",alfa1,alfa2,expresion.dir);
           }
           | expresion MOD expresion{
              expresion.tipo = max(expresion1.tipo,expresion2.tipo);
              expresion.dir = newTemp();
              alfa1 = ampliar(expresion1.dir, expresion1.tipo, expresion.tipo);
              alfa2 = ampliar(expresion2.dir,expresion2.tipo,expresion.tipo);
              add_quad(code,"%",alfa1,alfa2,expresion.dir);
           }
           | PARI expresion1 PARD{
             expresion.dir = expresion1.dir;
             expresion.tipo = expresion1.tipo;
           }
           | variable{
             expresion.dir = newTemp();
             expresion.tipo = variable.tipo;
             add_quad(code,"*",variable.base[variable.dir],-,expresion.dir);
           }
           | NUM{
             expresion.tipo = num.tipo;
             expresion.dir = num.val;
           } 
           | CADENA{
             expresion.tipo = cadena;
             expresion.dir = TablaDeCadenas.add(cadena);
           }
           | CARACTER{
             expresion.tipo = caracter;
             expresion.dir = TablaDeCadenas.add(caracter);
           }
           | ID PARI parametros PARD{
             if(StackTS.getFondo().getId(id.lexval) != -1){
               if(StackTS.getFondo().getVar(id.lexval) == "func"){
                 lista = StackTS.getFondo().getArgs(id.lexval);
                 if(lista.getTam() != parametros.getTam()){
                   yyerror("El numero de argumentos no coincide");
                 }
                 for(i=0,i<parametros.lista.getTam(),1){
                   if(parametros[i] != lista[i]){
                     yyerror("El tipo de parametros no coincide");
                   }
                 }
                 expresion.dir = newTemp();
                 expresion.tipo = StackTS.getFondo().getTipo(id.lexval);
                 add_quad(code,"=","call",id.lexval,expresion.dir);
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
            variable.dir = arreglo.dir;
            variable.base = arreglo.base;
            variable.tipo = arreglo.tipo;
          }
          | ID PUNTO ID{
            if(StackTS.getFondo().getId(id.lexval) != -1){
              t = StackTS.getFondo().getTipo(id.lexval);
              t1 = StackTT.getFondo().getTipo(t);
              if(t1 == "registro"){
                tipoBase = StackTT.getFondo().getTipoBase(t);
                if(tipoBase.getId(id2) != -1){
                  variable.tipo = tipoBase.getType(id2);
                  variable.dir = id2;
                  variable.base = id1;
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
            if(StackTS.getCima().getId(id.lexval) != -1){
              t = StackTS.getCima().getTipo(id.lexval);
              if(StackTT.getCima().getTipo(t) == "array"){
                if(expresion.tipo == ent){
                  arreglo.base = id.lexval;
                  arreglo.tipo = StackTT.getCima().getTipoBase(t);
                  arreglo.tam = StackTT.getCima().getTipo(arreglo.tipo);
                  arreglo.dir = newTemp();
                  add_quad(code,"*",expresion.dir,arreglo.tam,arreglo.dir);
                }
              }else{
                yyerror("La expresion para un indice debe ser de tipo entero");
              }
            }else{
              yyerror("El identificador no ha sido declarado");
            }
          }
         | arreglo1 CORI expresion CORD{
           if(StackTT.getCima().getTipoBase(arreglo1.tipo) == "array"){
             if(expresion.tipo == ent){
               arreglo.base = arreglo1.base;
               arreglo.tipo = StackTT.getCima().getTipoBase(arreglo1.tipo);
               arreglo.tam = StackTT.getCima().getTipo(arreglo.tipo);
               temp = newTemp();
               arreglo.dir = newTemp();
               add_quad(code,"*",expresion.dir,arreglo.tam,temp);
               add_quad(code,"+",arreglo1.dir,temp,arreglo.dir);
             }else{
               yyerror("La expresion par aun indice debe ser de tipo entero");
             }
           }else{
             yyerror("El arreglo no tiene tantas dimensiones");
           }
         }
         ;

parametros: lista_param{
              parametros.lista = lista_param.lista;
             }
            | /*empty*/{
              parametros.lista = null;
            }
            ;

lista_param: lista_param1 COMA expresion{
                lista_param.lista = lista_param1.lista;
                lista_param.lista.add(param.tipo);
                add_quad(code,"param",expresion.dir,-,-);
              }
             | expresion{
               lista_param.lista = newListaParam();
               lista_param.lista.add(expresion.tipo);
               add_quad(code,"param",expresion.dir,-,-);
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
