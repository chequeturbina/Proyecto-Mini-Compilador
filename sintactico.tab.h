
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUM = 258,
     ID = 259,
     ENT = 260,
     REAL = 261,
     DREAL = 262,
     CAR = 263,
     SIN = 264,
     REGISTRO = 265,
     INICIO = 266,
     FUNC = 267,
     SINO = 268,
     SI = 269,
     DEVOLVER = 270,
     FIN = 271,
     ENTONCES = 272,
     VERDADERO = 273,
     HACER = 274,
     TERMINAR = 275,
     FALSO = 276,
     MIENTRAS = 277,
     MIENTRAS_QUE = 278,
     LEER = 279,
     ESCRIBIR = 280,
     CADENA = 281,
     CARACTER = 282,
     COMA = 283,
     PUNTO = 284,
     SL = 285,
     ASIG = 286,
     DISY = 287,
     CONJ = 288,
     DIF = 289,
     IGUAL = 290,
     MENIGU = 291,
     MAYIGU = 292,
     MENOR = 293,
     MAYOR = 294,
     MENOS = 295,
     MAS = 296,
     MOD = 297,
     DIV = 298,
     MUL = 299,
     NOT = 300,
     CORD = 301,
     CORI = 302,
     PARD = 303,
     PARI = 304
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 8 "sintactico.y"

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



/* Line 1676 of yacc.c  */
#line 122 "sintactico.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


