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
    #include "sintactico.tab.h"
    //#define YY_DECL extern "C" int yylex()

%}

%option yylineno
%option noyywrap

ent_1 [+-]?[0-9]+
real_2 [+-]?[0-9]*"."[0-9]+
dreal_3 [+-]?[0-9]*"."[0-9]+[Ff]

id [a-zA-Z_][a-zA-Z0-9_]{0,31}
cadena \"([^"]*)\"
caracter '[a-zA-Z]'

%%
{ent_1}    {
                yylval.num.tipo = 1;
                char *copy = malloc(sizeof(yytext));
                strcpy(copy, yytext);
                yylval.num.sval = copy;
                printf("<NUM>, ");
                return NUM;
            }

{real_2}    {
               
                yylval.num.tipo = 2;
                char *copy = malloc(sizeof(yytext));
                strcpy(copy, yytext);
                yylval.num.sval = copy;
                printf("<NUM>, ");
                return NUM;
            }

{dreal_3}   {
               
                yylval.num.tipo = 3;
                char *copy = malloc(sizeof(yytext));
                strcpy(copy, yytext);
                yylval.num.sval = copy;
                printf("<NUM>, ");
                return NUM;
            }

{caracter}  {        
                yylval.car.tipo = 4;
                       
                yylval.car.sval = yytext[1];
                printf("<CARACTER>, ");
                return CARACTER;
            }

{cadena}    {
                char *copy = malloc(sizeof(yytext));
                strcpy(copy, yytext);
                yylval.string.sval = copy;
                printf("<CADENA>, ");
                return CADENA;
            }

"ent"       { printf("<ENT>, "); return ENT;}

"dreal"     { printf("<DREAL>, "); return DREAL;}

"real"      { printf("<REAL>, "); return REAL;}

"car"       { printf("<CAR>, "); return CAR;}

"sin"       { printf("<SIN>, "); return SIN;}

"registro"  {printf("<REGISTRO>, "); return REGISTRO;}

"inicio"    {printf("<INICIO>, "); return INICIO;}

"func"      {printf("<FUNC>, "); return FUNC;}

"sino"      {printf("<SINO>, "); return SINO;}

"si"        {printf("<SI>, "); return SI;}

"devolver"  {printf("<DEVOLVER>, "); return DEVOLVER;}

"fin"       {printf("<FIN>, "); return FIN;}

"entonces"  {printf("<ENTONCES>, "); return ENTONCES;}

"verdadero" {printf("<VERDADERO>, "); return VERDADERO;}

"falso"     {printf("<FALSO>, "); return FALSO;}

"mientras"  {printf("<MIENTRAS>, "); return MIENTRAS;}

"hacer"     {printf("<HACER>, "); return HACER;}

"mientrasq" {printf("<MIENTRAS_QUE>, "); return MIENTRAS_QUE;}

"leer"      {printf("<LEER>, "); return LEER;}

"escribir"  {printf("<ESCRIBIR>, "); return ESCRIBIR;}

"terminar"  {printf("<TERMINAR>, "); return TERMINAR;}

[ \n\t\v]+ {}



","     {printf("<COMA>, "); return COMA;}
"."     {printf("<PUNTO>, "); return PUNTO;}
";"     {printf("<PC>, "); return PC;}

"+"     {printf("<MAS>, "); return MAS;}
"-"     {printf("<MENOR>, "); return MENOS;}
"*"     {printf("<MUL>, "); return MUL;}
"/"     {printf("<DIV>, "); return DIV;}
"%"     {printf("<MOD>, "); return MOD;}
"("     {printf("<PARI>, "); return PARI;}
")"     {printf("<PARD>, "); return PARD;}
"["     {printf("<CORI>, "); return CORI;}
"]"     {printf("<CORD>, "); return CORD;}
":="    {printf("<ASIG>, "); return ASIG;}
"<"     {printf("<MENOR>, "); return MENOR;}
">"     {printf("<MAYOR>, "); return MAYOR;}
"<="    {printf("<MENIGU>, "); return MENIGU;}
">="    {printf("<MAYIGU>, "); return MAYIGU;}
"<>"    {printf("<DIF>, "); return DIF;}
"=="    {printf("<IGUAL>, "); return IGUAL;}
"oo"    {printf("<DISY>, "); return DISY;}
"yy"    {printf("<CONJ>, "); return CONJ;}
"no"	{printf("<NOT>, "); return NOT;}

{id}        {          
                char *copy = malloc(sizeof(yytext));      
                strcpy(copy, yytext);
                yylval.id.sval = copy;
                printf("<ID>, ");
                return ID;
            }

. {printf("Error léxico: %s\n", yytext);
   exit(1);}

%%
