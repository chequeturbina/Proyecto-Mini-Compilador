%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tabla.c"
#include "pilaSym.c"
#include "pilaTipos.c"
#include "tablaTipo.c"

void yyerror(char *msg);
extern int yylex();
extern FILE *yyin;

  // Variable que llevara el manejo de direcciones.
  int dir;
  int FuncType;
  int temp;
  bool FuncReturn;
  stack_dir stackDir;
  int tipo_g; 
  symstack *StackTS;
  stack_cad *StackCad;
  typestack *StackTT;
  ttype base;
  typetab *tt_global;
  symtab *ts_global;
  code CODE;
  int indice;
  int label_c;

  int id_tipo;

  // Variable que guardara la direccion cuando se haga un cambio de alcance.
  int dir_aux;
  // Variable que llevara la cuenta de variables temporales.
  int temporales;
  // Variable que indica la siguiente instruccion.
  int siginst;
  // Variable que guarda el tipo heredado.
  int global_tipo;
  // Variable que guardara la dimension heredada.
  int global_dim;
  // Variable que llevara el numero de parametros que tiene una funcion.
  int num_args;
  // Lista que guarda los tipos de los parametros.
  int* list_args;
  // Variable que nos ayuda a saber en que alcance estamos.
  int scope;
  // Variable que dice si hay un registro en camino
  int has_reg;

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


%%

// 1. programa -> declaraciones \n funciones
programa:
  {
    label_c = 0;
    indice = 0;
    temp = 0;
    stackDir = crearStackDir();
    dir = 0;
    id_tipo = 5;
    StackTT = crearTypeStack();
    StackTS = crearSymStack();
    tt_global = crearTypeTab();
    ts_global = crearSymTab();
    insertarTypeTab(StackTT,tt_global);
    insertarSymTab(StackTS,ts_global);
    StackCad = crearStackCad();

  } declaraciones funciones;

// 2. declaraciones -> tipo lista_var \n declaraciones
//                   | tipo_registro lista_var \n declaraciones
//                   | ε
declaraciones: tipo {tipo_g = $1.tipo;} lista_var declaraciones
               | tipo_registro {tipo_g = $1.tipo;} lista_var declaraciones
               | {}
               ;

// 3. tipo_registro -> registro \n inicio declaraciones \n fin
tipo_registro: REGISTRO INICIO declaraciones FIN {

  typetab *tt = crearTypeTab();
  symtab *ts = crearSymTab();
  addStackDir(&stackDir,dir);
  dir = 0;
  insertarTypeTab(StackTT,tt);
  insertarSymTab(StackTS,ts);
  dir = popStackDir(&stackDir);
  typetab *tt1 = sacarTypeTab(StackTT);
  //setTT(getCimaSym(StackTS),tt1);
  symtab *ts1 = sacarSymTab(StackTS);
  dir = popStackDir(&stackDir);
  $$.tipo = insertarTipo(getCimaType(StackTT),crearTipoNativo(id_tipo,"registro",crearArqueTipo(true,crearTipoStruct(ts1)),-1));
  id_tipo++;
  
  }
               ;

// 4. tipo -> base tipo_arreglo
tipo: base {base = $1;} tipo_arreglo {$$ = $3;}
      ;

// 5. base -> ent | real | dreal | car | sin
base: ENT {$$.tipo = 1; $$.dim = 4;}
      | REAL {$$.tipo = 2; $$.dim = 8;}
      | DREAL {$$.tipo = 3; $$.dim = 16;}
      | CAR {$$.tipo = 4; $$.dim = 2;}
      | SIN {$$.tipo = 0; $$.dim = 0;}
      ;

// 6. tipo_arregloi -> [num] tipo_arreglo | ε
tipo_arreglo: CORI NUM CORD tipo_arreglo {

  if($2.tipo == 1 && $2.ival > 0){
    $$.tipo =  insertarTipo(getCimaType(StackTT),crearTipoArray(id_tipo,"array",getTipoBase(getCimaType(StackTT),tipo_g),base.dim,$2.ival));
    id_tipo ++;
  }
  yyerror("Error. Indice tiene que ser entero y mayor a cero\n");
  }

  | {
      $$ = base;
  }

  ;

// 7. lista_var -> lista_var , id | id
lista_var: lista_var COMA ID {

  if(buscar(getCimaSym(StackTS),$3) == -1){
    symbol *sym = crearSymbol($3, tipo_g, dir, "var");
    insertar(getCimaSym(StackTS),sym);
    dir = dir + getTam(getCimaType(StackTT),tipo_g);
  }else{
    yyerror("Error. Identificador ya existe");
  }
}

  | ID {

    if(buscar(getCimaSym(StackTS),$1) == -1){
      symbol *sym = crearSymbol($1, tipo_g, dir, "var");
      insertar(getCimaSym(StackTS),sym);
      dir = dir + getTam(getCimaType(StackTT),tipo_g);
    }else{
      yyerror("Error. Identificador ya existe");
    }

  }
  ;

// 8. funciones -> func tipo id( argumentos ) inicio \n delcaraciones sentencias \n fin \n funciones | ε
funciones: FUNC tipo ID PARI argumentos PARD INICIO declaraciones {FuncReturn = false;} sentencias FIN funciones {

      insertarSymTab(StackTS,ts_global);
      insertarTypeTab(StackTT,tt_global);
      dir = popStackDir(&stackDir);
      agregar_cuadrupla(&CODE,"label","","",$3);
      label *L = newLabel();      
      backpatch(*L,$12.lnext->i);
      agregar_cuadrupla(&CODE,"label","","",label_to_char(*L));
      sacarSymTab(StackTS);
      sacarTypeTab(StackTT);
      dir = popStackDir(&stackDir);
      addListParam(getCimaSym(StackTS),$6.lista,$3);
      if($2.tipo != 0 && FuncReturn == false){
        yyerror("Error. La funcion debe regresar un valor.");
      }
  }
           | {}
           ;

// 9. argumentos -> lista_arg | sin
argumentos: lista_arg { $$.lista = $1.lista; }
            | SIN { $$.lista = NULL; }
            ;

// 10. lista_arg -> lista_arg arg | arg
lista_arg: lista_arg arg {

    $$.lista = $1.lista;
    add_tipo($$.lista,$2.tipo);
  }

  | arg {

    $$.lista = crearLP();
    add_tipo($$.lista,$1.tipo);
  }
  ;

// 11. arg -> tipo_arg id
arg: tipo_arg ID {

    if(buscar(getCimaSym(StackTS),$2) == -1){
      symbol *sym = crearSymbol($2, tipo_g, dir, "var");
      insertar(getCimaSym(StackTS),sym);
      dir = dir + getTam(getCimaType(StackTT),tipo_g);
    }else{
      yyerror("el identificador ya fue declarado");
    }
  }
    ;

// 12. tipo_arg -> base param_arr
tipo_arg: base param_arr {

  base.tipo = $1.tipo;
  $$.tipo = $2.tipo;
}
        ;

// 13. param_arr -> [] param_arr | ε
param_arr: CORI CORD param_arr {

    $$.tipo = insertarTipo(getCimaType(StackTT),crearTipoArray(6,"array",getTipoBase(getCimaType(StackTT),$3.tipo),$3.dim,-1));
  }

  | {

    $$.tipo = base.tipo;
    $$.dim = base.dim;
  }
  ;

// 14. sentencias -> sentencias \n sentencia | sentencia
sentencias: sentencias sentencia {

  label *L = newLabel();
  backpatch(*L, $1.lnext->i);
  $$.lnext = $3.lnext;
  }

  | sentencia {

    $$.lnext = $1.lnext;
  }
  ;

// 15. sentencia -> si expresion_booleana entonces \n sentencias \n fin
//                | si expresion_booleana \n sentencias \n sino \n sentencias \n fin
//                | mientras \n expresion_booleana hacer \n sentencias \n fin
//                | hacer \n sentencia \n mientras que expresion_booleana
//                | id := expresion | escribir expresion | leer variable | devolver
//                | devolver expresion | terminar
sentencia: SI expresion_booleana ENTONCES sentencias FIN {

    label *L = newLabel();

    backpatch(*L, $2.ltrue->i);
    $$.lnext = merge($2.lfalse,$3.lnext);
  } %prec SIX

  | SI expresion_booleana sentencias SINO sentencias FIN {

    label *L = newLabel();
    label *L1 = newLabel();
    backpatch(*L, $2.ltrue->i);
    backpatch(*L1, $2.lfalse->i);
    $$.lnext = merge($3.lnext,$6.lnext);
  }

  | MIENTRAS expresion_booleana HACER sentencias FIN {

    label *L = newLabel();
    label *L1 = newLabel();
    backpatch(*L, $6.lnext->i);
    backpatch(*L1, $3.ltrue->i);
    $$.lnext = $3.lfalse;
    agregar_cuadrupla(&CODE,"goto","","",label_to_char(*L));
  }

  | HACER sentencia MIENTRAS_QUE expresion_booleana {

    label *L = newLabel();
    label *L1 = newLabel();
    backpatch(*L, $6.ltrue->i);
    backpatch(*L1, $3.lnext->i);
    $$.lnext = $6.lfalse;
    agregar_cuadrupla(&CODE,"goto","","",label_to_char(*L));
  }

  | ID ASIG expresion {

    if(buscar(getCimaSym(StackTS),$1)!=-1){
      int t = getTipo(getCimaSym(StackTS),$1);
      int d = getDir(getCimaSym(StackTS),$1);
      char *di;
      sprintf(di,"%d",$3.dir);
      char *alfa = reducir(di,$3.tipo,t);
      char* res;
      sprintf(res,"%s%d","id",d);
      agregar_cuadrupla(&CODE,"=",alfa,"",res); 
    }
  }

  | ESCRIBIR expresion {

    char *d;
    sprintf(d,"%d",$2.dir);
    agregar_cuadrupla(&CODE,"print",d,"","");
    $$.lnext = NULL;
  }

  | LEER variable {

    char *d;
    sprintf(d,"%d",$2.dir);
    agregar_cuadrupla(&CODE,"scan",d,"",d);
    $$.lnext = NULL;
  }

  | DEVOLVER {

    if ( FuncType == 0 ){
      agregar_cuadrupla(&CODE,"return","","","");
    }else{
      yyerror("Error. La funcion no devuelve ningun valor.");
    }
  }

  | DEVOLVER expresion {

    if ( FuncType == 0 ){
      char *d;
      sprintf(d,"%d",$2.dir);
      char *alfa = reducir(d,$2.tipo,FuncType);
      sprintf(d,"%d",$2.dir);
      agregar_cuadrupla(&CODE,"return",d,"","");
      FuncReturn = true;
    }else{
      yyerror("La funcion debe retonar valor no sin");
    }
    $$.lnext = NULL;
  }

  | TERMINAR {

    char *I = newIndex();
    agregar_cuadrupla(&CODE,"goto","","",I);
    $$.lnext = newLabel();
  }
  ;

// 16. expresion_booleana -> expresion_booleana oo expresion_booleana
//                         | expresion_booleana yy expresion_booleana
//                         | no expresion_booleana
//                         | relacional | verdadero | falso
expresion_booleana: expresion_booleana DISY expresion_booleana {

  label *L = newLabel();
  backpatch(*L, $1.lfalse->i);
  $$.ltrue = merge($1.ltrue,$3.ltrue);
  $$.lfalse = $3.lfalse;
  agregar_cuadrupla(&CODE,"label","","",label_to_char(*L));
  }

  | expresion_booleana CONJ expresion_booleana {

    label *L = newLabel();
    backpatch(*L, $1.ltrue->i);
    $$.ltrue = merge($1.lfalse,$3.lfalse);
    $$.ltrue = $3.ltrue;
    agregar_cuadrupla(&CODE,"label","","",label_to_char(*L));
  }

  | NOT expresion_booleana {

    $$.ltrue = $2.lfalse;
    $$.lfalse = $2.ltrue;
  }

  | relacional {

    $$.ltrue = $1.ltrue;
    $$.lfalse = $1.lfalse;
  }

  | VERDADERO {

    char* I = newIndex();
    $$.ltrue = NULL;
    $$.ltrue = create_list(atoi(I));
    agregar_cuadrupla(&CODE,"goto","","",I);
    $$.lfalse = NULL;
  }

  | FALSO {
    char* I = newIndex();
    $$.ltrue = NULL;
    $$.lfalse = create_list(atoi(I));
    agregar_cuadrupla(&CODE,"goto","","",I);
  }
  ;

// 17. relacional -> relacional < relacional | relacional > relacional | relacional <= relacional
//                 | relacional >= relacional | relacional == relacional | relacional <> relacional | expresion
relacional: relacional MENOR relacional { $$ = relacional($1,$3,$2); }

            | relacional MAYOR relacional { $$ = relacional($1,$3,$2); }

            | relacional MENIGU relacional { $$ = relacional($1,$3,$2); }

            | relacional MAYIGU relacional { $$ = relacional($1,$3,$2); }

            | relacional IGUAL relacional { $$ = relacional($1,$3,$2); }

            | relacional DIF relacional { $$ = relacional($1,$3,$2); }

            | expresion {

              $$.tipo = $1.tipo;
              $$.dir = $1.dir;
            }
            ;

// 18. expresion -> expresion + expresion | expresion - expresion         FALTA CADENA
//                | expresion * expresion | expresion / expresion
//                | expresion % expresion | (expresion)
//                | variable | num | cadena | caracter | id( parametros )
expresion: expresion MAS expresion {$$ = operacion($1,$3,$2);}

           | expresion MENOS expresion {$$ = operacion($1,$3,$2);}

           | expresion MUL expresion {$$ = operacion($1,$3,$2);}

           | expresion DIV expresion {$$ = operacion($1,$3,$2);}

           | expresion MOD expresion {$$ = operacion($1,$3,$2);}

           | PARI expresion PARD {$$.dir = $2.dir;$$.tipo=$2.tipo;}

           | variable {

              $$.dir = atoi(newTemp());
              $$.tipo = $1.tipo;
              char* d;
              sprintf(d,"%d",$$.dir);
              char* b;
              sprintf(b,"%c",$1.base[$1.dir]);
              agregar_cuadrupla(&CODE, "*",b,"",d);
            }

           | CADENA {
              $$.tipo = 7;
    
            }

           | NUM {
              $$.tipo = $1.tipo;
              $$.dir = $1.ival;
            }

           | CARACTER {
              $$.tipo = 4;
    
            }

           | ID PARI parametros PARD {
              if(buscar(getFondoSym(StackTS),$1) != -1){
                if(strcmp(getTipoVar(getFondoSym(StackTS),$1), "func")==0){
                  listParam *lista = getListParam(getFondoSym(StackTS),$1);
                  if(getNumListParam(lista) != getNumListParam($3.lista)){
                    yyerror("El numero de argumentos no coincide");
                  }
                  param *p,*pl;
                  p = $3.lista->root;
                  pl = lista->root;
                  for(int i=0; i<getNumListParam($3.lista);i++){
                    if(p->tipo != pl->tipo){
                      yyerror("El tipo de los parametros no coincide");
                    }p = p->next;
                    pl = pl->next;
                  }
                  $$.dir = atoi(newTemp());
                  $$.tipo = getTipo(getFondoSym(StackTS),$1);
                  char *d;
                  sprintf(d,"%d",$$.dir);
                  agregar_cuadrupla(&CODE,"=","call",$1,d);
                }
              }
            }
           ;

// 19. variable -> id arreglo | id.id
variable: ID arreglo {

  $$.dir = $1.dir;
  $$.base[0] = $1.base[0];
  $$.tipo = $1.tipo;
}

| ID PUNTO ID {
    if(buscar(getFondoSym(StackTS),$1)!=-1){
      int t = getTipo(getFondoSym(StackTS),$1);
      char *t1 = getNombre(getFondoType(StackTT),t);
      if (strcmp(t1,"registro") == 0 ){
        tipoBase *tb = getTipoBase(getFondoType(StackTT),t);
      }
    }
  }
  ;

// 20. arreglo -> id [ expresion ] arreglo | ε
arreglo: ID CORI expresion CORD arreglo {

  if(buscar(getCimaSym(StackTS),$1) != -1){
    int t = getTipo(getCimaSym(StackTS),$1); 
    if (strcmp(getNombre(getCimaType(StackTT),t),"array") == 0){
      if ($3.tipo == 1){
        strcpy($$.base,$1);
        $$.tipo = getTipoBase(getCimaType(StackTT),t)->t.type;
        $$.tam = getTam(getCimaType(StackTT),$$.tipo);
        $$.dir = atoi(newTemp());
        char tm[10];
        intToChar(tm,$$.tam);
        char dr[10];
        intToChar(dr,$$.dir);
        char dre[10];
        intToChar(dre,$3.dir);
        agregar_cuadrupla(&CODE,"*",dre,tm,dr);

        } else{
          yyerror("Error. El indice debe ser entero.");
        }
        }else{
        yyerror("Error. El identificador debe ser un arreglo");
      }
  
    }else{
      yyerror("Error. Identificador no existe");
    }
  } 
         | {}
         ;

// 21. parametros -> lista_param | ε
parametros: lista_param {

    $$.lista = $1.lista;
  }

  | {
      $$.lista = NULL;
  }
  ;

// 22. lista_param -> lista_param , expresion | expresion
lista_param: lista_param COMA expresion {

    $$.lista = $1.lista;
    add_tipo($$.lista,$3.tipo);
    char *d;
    sprintf(d,"%d",$3.dir);
    agregar_cuadrupla(&CODE,"param",d,"","");
  }

  | expresion {
  
    $$.lista = crearLP();
    add_tipo($$.lista,$1.tipo);
    char *d;
    sprintf(d,"%d",$1.dir);
    agregar_cuadrupla(&CODE,"param",d,"","");
  }
  ;

%%

//extern int yylex();
//extern FILE *yyin;

void yyerror(char *msg){
    printf("%s\n", msg);
}

int main(int argc, char **argv){
    if(argc < 2) return -1;
    FILE *f = fopen(argv[1], "r");
    if(!f) return -1;
    yyin = f;
    int w = yyparse();
    if(!w){
      printf("LA CADENA ES LÉXICA Y SINTÁCTICAMENTE CORRECTA.");
    }
    fclose(f);
    return 0;
}
