%{
/**
 * Archivo del analizador lexico de nuestro compilador.
 * Autores: Jesus Fernando Moreno Ruiz
 * Juan Adolfo Alfaro Jimenez
 * Emmanuel Meza Martinez
 * kevin Cervantes GOnzalez
 * Fecha: 12/12/19			
**/
	#include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
%}

%option yylineno
%option noyywrap

ent_1 [+-]?[0-9]+
real_2 [+-]?[0-9]*"."[0-9]+
dreal_3 [+-]?[0-9]*"."[0-9]+

id [a-zA-Z_][a-zA-Z0-9_]{0,31}
cadena [.^\t ]+
caracter [a-zA-Z]

%%
{ent_1}    {
                yyval.num.tipo = 1;
                strcpy(yyval.num.sval, yytext);
                return NUM;
            }

{real_2}    {
               
                yyval.num.tipo = 2;
                strcpy(yyval.num.sval, yytext);
                return NUM;
            }

{dreal_3}   {
               
                yyval.num.tipo = 3;
                strcpy(yyval.num.sval, yytext);
                return NUM;
            }

{caracter}  {
                yyval.car = yytext;
                return CARACTER;
            }

{cadena}    {

                Strcpy(yyval.sval, yytext);
                return CADENA;
            }

"ent"       {yyval.line = yylineo; return ENT;}

"dreal"     {yyval.line = yylineo; return DREAL;}

"real"      {yyval.line = yylineo; return REAL;}

"car"       {yyval.line = yylineo; return CAR;}

"sin"       {yyval.line = yylineo; return SIN;}

"registro"  {yyval.line = yylineno; return REGISTRO;}

"inicio"    {yyval.line = yylineo; return INICIO;}

"func"      {yyval.line = yylineo; return FUNC;}

"sino"      {yyval.line = yylineo; return SINO;}

"si"        {yyval.line = yylineo; return SI;}

"devolver"  {yyval.line = yylineo; return DEVOLVER;}

"fin"       {yyval.line = yylineo; return FIN;}

"entonces"  {yyval.line = yylineo; return ENTONCES;}

"verdadero" {yyval.line = yylineo; return VERDADERO;}

"falso"     {yyval.line = yylineo; return FALSO;}

"mientras"  {yyval.line = yylineo; return MIENTRAS;}

"hacer"     {yyval.line = yylineo; return HACER;}

"mientrasq" {yyval.line = yylineo; return MIENTRAS_QUE;}

"leer"      {yyval.line = yylineo; return LEER;}

"escribir"  {yyval.line = yylineo; return ESCRIBIR;}

"terminar"  {yyval.line = yylineo; return TERMINAR;}

{id}        {
                yyval.line = yylineo;
                strcpy(yyval.sval, yytext);
                return ID;
            }

[ \t\v]+ {}
"\n"    {yyval.line = yylineo; return SL;}
","     {yyval.line = yylineo; return COMA;}
"."     {yyval.line = yylineo; return PUNTO;}

"+"     {yyval.line = yylineo; return MAS;}
"-"     {yyval.line = yylineo; return MENOS;}
"*"     {yyval.line = yylineo; return MUL;}
"/"     {yyval.line = yylineo; return DIV;}
"%"     {yyval.line = yylineo; return MOD;}
"("     {yyval.line = yylineo; return PARI;}
")"     {yyval.line = yylineo; return PARD;}
"["     {yyval.line = yylineo; return CORI;}
"]"     {yyval.line = yylineo; return CORD;}
":="    {yyval.line = yylineo; return ASIG;}
"<"     {yyval.line = yylineo; return MENOR;}
">"     {yyval.line = yylineo; return MAYOR;}
"<="    {yyval.line = yylineo; return MENIGU;}
">="    {yyval.line = yylineo; return MAYIGU;}
"<>"    {yyval.line = yylineo; return DIF;}
"=="    {yyval.line = yylineo; return IGUAL;}
"oo"    {yyval.line = yylineo; return DISY;}
"yy"    {yyval.line = yylineo; return CONJ;}
"no"	{yyval.line = yylineo; return NOT;}

. {printf("No Reconocido");}

%%
