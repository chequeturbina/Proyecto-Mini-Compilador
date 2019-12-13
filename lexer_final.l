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
    //#include <sintactico.tab.h>

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

"ent"       { return ENT;}

"dreal"     { return DREAL;}

"real"      { return REAL;}

"car"       { return CAR;}

"sin"       { return SIN;}

"registro"  {return REGISTRO;}

"inicio"    { return INICIO;}

"func"      { return FUNC;}

"sino"      { return SINO;}

"si"        { return SI;}

"devolver"  { return DEVOLVER;}

"fin"       { return FIN;}

"entonces"  { return ENTONCES;}

"verdadero" { return VERDADERO;}

"falso"     { return FALSO;}

"mientras"  { return MIENTRAS;}

"hacer"     { return HACER;}

"mientrasq" { return MIENTRAS_QUE;}

"leer"      { return LEER;}

"escribir"  { return ESCRIBIR;}

"terminar"  { return TERMINAR;}

{id}        {
                yyval.line = yylineo;
                strcpy(yyval.sval, yytext);
                return ID;
            }

[ \t\v]+ {}
"\n"    { return SL;}
","     { return COMA;}
"."     { return PUNTO;}

"+"     { return MAS;}
"-"     { return MENOS;}
"*"     { return MUL;}
"/"     { return DIV;}
"%"     { return MOD;}
"("     { return PARI;}
")"     { return PARD;}
"["     { return CORI;}
"]"     { return CORD;}
":="    { return ASIG;}
"<"     { return MENOR;}
">"     { return MAYOR;}
"<="    { return MENIGU;}
">="    { return MAYIGU;}
"<>"    { return DIF;}
"=="    { return IGUAL;}
"oo"    { return DISY;}
"yy"    { return CONJ;}
"no"	{ return NOT;}

. {printf("No Reconocido");}

%%