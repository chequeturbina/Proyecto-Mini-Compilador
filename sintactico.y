
// 1. programa -> declaraciones \n funciones
programa: declaraciones funciones
          ;

// 2. declaraciones -> tipo lista_var \n declaraciones
//                   | tipo_registro lista_var \n declaraciones
//                   | ε
delcaraciones: tipo lista_var declaraciones
               | tipo_registro lista_var declaraciones
               | {}
               ;

// 3. tipo_registro -> registro \n inicio declaraciones \n fin
tipo_registro: REGISTRO INICIO declaraciones FIN
               ;

// 4. tipo -> base tipo_arreglo
tipo: base tipo_arreglo
      ;

// 5. base -> ent | real | dreal | car | sin
base: ENT
      | REAL
      | DREAL
      | CAR
      | SIN
      ;

// 6. tipo_arregloi -> [num] tipo_arreglo | ε
tipo_arreglo: CORI NUM CORD tipo_arreglo
              | {}
              ;

// 7. lista_var -> lista_var , id | id
lista_var: lista_var , ID
           | ID
           ;

// 8. funciones -> func tipo id( argumentos ) inicio \n delcaraciones sentencias \n fin \n funciones | ε
funciones: FUNC tipo ID PARI argumentos PARD INICIO declaraciones sentencias FIN funciones
           | {}
           ;

// 9. argumentos -> lista_arg | sin
argumentos: lista_arg
            | SIN
            ;

// 10. lista_arg -> lista_arg arg | arg
lista_arg: lista_arg arg
           | arg
           ;

// 11. arg -> tipo_arg id
arg: tipo_arg ID
    ;

// 12. tipo_arg -> base param_arr
tipo_arg: base param_arr
        ;

// 13. param_arr -> [] param_arr | ε
param_arr: CORI param_arr CORD
           | {}
           ;

// 14. sentencias -> sentencias \n sentencia | sentencia
sentencias: sentencias sentencia
            | sentencia
            ;

// 15. sentencia -> si expresion_booleana entonces \n sentencias \n fin
//                | si expresion_booleana \n sentencias \n sino \n sentencias \n fin
//                | mientras \n expresion_booleana hacer \n sentencias \n fin
//                | hacer \n sentencia \n mientras que expresion_booleana
//                | id := expresion | escribir expresion | leer variable | devolver
//                | devolver expresion | terminar
sentencia: SI expresion_booleana ENTONCES sentencias FIN
           | SI expresion_booleana sentencias SINO sentencias FIN
           | MIENTRAS expresion_booleana HACER sentencias FIN
           | HACER sentencia MIENTRAS_QUE expresion_booleana
           | ID ASIG expresion
           | ESCRIBIR expresion
           | LEER variable
           | DEVOLVER
           | DEVOLVER expresion
           | TERMINAR
           ;

// 16. expresion_booleana -> expresion_booleana oo expresion_booleana
//                         | expresion_booleana yy expresion_booleana
//                         | no expresion_booleana
//                         | relacional | verdadero | falso
expresion_booleana: expresion_booleana DISY expresion_booleana
                    | expresion_booleana CONJ expresion_booleana
                    | NOT expresion_booleana
                    | relacional
                    | VERDADERO
                    | FALSO
                    ;

// 17. relacional -> relacional < relacional | relacional > relacional | relacional <= relacional
//                 | relacional >= relacional | relacional == relacional | relacional <> relacional | expresion
relacional: relacional MENOR relacional
            | relacional MAYOR relacional
            | relacional MENIGU relacional
            | relacional MAYIGU relacional
            | relacional IGUAL relacional
            | relacional DIF relacional
            | expresion
            ;

// 18. expresion -> expresion + expresion | expresion - expresion         FALTA CADENA
//                | expresion * expresion | expresion / expresion
//                | expresion % expresion | (expresion)
//                | variable | num | cadena | caracter | id( parametros )
expresion: expresion MAS expresion
           | expresion MENOS expresion
           | expresion MUL expresion
           | expresion DIV expresion
           | expresion MOD expresion
           | PARI expresion PARD
           | variable
           | CADENA
           | NUM
           | CARACTER
           | ID PARI parametros PARD
           ;

// 19. variable -> id arreglo | id.id
variable: ID arreglo
          | ID PUNTO ID
          ;

// 20. arreglo -> id [ expresion ] arreglo | ε
arreglo: ID CORI expresion CORD arreglo
         | {}
         ;

// 21. parametros -> lista_param | ε
parametros: lista_param
            | {}
            ;

// 22. lista_param -> lista_param , expresion | expresion
lista_param: lista_param COMA expresion
             | expresion
             ;