
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

// 13. param_arr -> [] param_arr | ε

// 14. sentencias -> sentencias \n sentencia | sentencia

// 15. sentencia -> si expresion_booleana entonces \n sentencias \n fin
//                | si expresion_booleana \n sentencias \n sino \n sentencias \n fin
//                | mientras \n expresion_booleana hacer \n sentencias \n fin
//                | hacer \n sentencia \n mientras que expresion_booleana
//                | id := expresion | escribir expresion | leer variable | devolver
//                | devolver expresion | terminar

// 16. expresion_booleana -> expresion_booleana oo expresion_booleana
//                         | expresion_booleana yy expresion_booleana
//                         | no expresion_booleana
//                         | relacional | verdadero | falso

// 17. relacional -> relacional < relacional | relacional > relacional | relacional <= relacional
//                 | relacional >= relacional | relacional == relacional | relacional <> relacional | expresion

// 18. expresion -> expresion + expresion | expresion - expresion
//                | expresion * expresion | expresion / expresion
//                | expresion % expresion | (expresion)
//                | variable | num | cadena | caracter | id( parametros )

// 19. variable -> id arreglo | id.id

// 20. arreglo -> id [ expresion ] arreglo | ε

// 21. parametros -> lista_param | ε

// 22. lista_paran -> lista_param , expresion | expresion