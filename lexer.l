%{
	#include <stdio.h>
%}

salto [\n]
reg 'registro'
ini 'inicio'
fin 'fin'
base ('ent'|'real'|'dreal'|'car'|'sin')
si 'si'
entonces 'entonces'
sino 'sino'
mientras 'mientras'
hacer 'hacer'
que 'que'
operador ':='
escribir 'escribir'
leer 'leer'
devolver 'devolver'
or 'oo'
and 'yy'
not 'no'
verd 'verdadero'
fals 'falso'
relacional (\<|\>|\<\=|\>\=|\=\=|\<\>)
expresion (\+|\-|\*|\/|\%)
coma \,
var \.
func 'func'
abrep \(
cierrap \)
abrel \[
cierral \]

num [0-9]+
id [a-zA-Z_][a-zA-Z0-9_]{0,31}
cadena [.^\t ]+
caracter [a-zA-Z]+

%x comentario
%x multilinea

%%

{abrep} {printf("<token,%s>\n",yytext),return 10;}
{cierrap} {printf("<token,%s>\n",yytext),return 11;}
{abrel} {printf("<token,%s>\n",yytext),return 12;}
{cierral} {printf("<token,%s>\n",yytext),return 13;}

{num} {printf("<num,%s>\n",yytext),return 1;}

{salto} {printf("<token,%s>\n",yytext),return 5;}
{reg} {printf("<token,%s>\n",yytext),return 6;}
{ini} {printf("<token,%s>\n",yytext),return 7;}
{fin} {printf("<token,%s>\n",yytext),return 8;}
{base} {printf("<token,%s>\n",yytext),return 9;}
{si} {printf("<token,%s>\n",yytext),return 14;}
{entonces} {printf("<token,%s>\n",yytext),return 15;}
{sino} {printf("<token,%s>\n",yytext),return 16;}
{mientras} {printf("<token,%s>\n",yytext),return 17;}
{hacer} {printf("<token,%s>\n",yytext),return 18;}
{que} {printf("<token,%s>\n",yytext),return 19;}
{operador} {printf("<token,%s>\n",yytext),return 20;}
{escribir} {printf("<token,%s>\n",yytext),return 21;}
{leer} {printf("<token,%s>\n",yytext),return 22;}
{devolver} {printf("<token,%s>\n",yytext),return 23;}
{or} {printf("<token,%s>\n",yytext),return 24;}
{and} {printf("<token,%s>\n",yytext),return 25;}
{not} {printf("<token,%s>\n",yytext),return 26;}
{verd} {printf("<token,%s>\n",yytext),return 27;}
{fals} {printf("<token,%s>\n",yytext),return 28;}
{relacional} {printf("<token,%s>\n",yytext),return 29;}
{expresion} {printf("<token,%s>\n",yytext),return 30;}	
{coma} {printf("<token,%s>\n",yytext),return 31;}
{var} {printf("<token,%s>\n",yytext),return 32;}
{func} {printf("<token,%s>\n",yytext),return 33;}

{caracter} {printf("<caracter,%s>\n",yytext),return 4;}
{cadena} {printf("<cadena,%s>\n",yytext),return 3;}
{id} {printf("<identificador,%s>\n",yytext),return 2;}


"--" BEGIN(comentario);
<comentario>[^\n]* {printf("<Comentario 1 linea,--%s>\n",yytext),return 34;}
<comentario>\n {BEGIN(INITIAL);}

"<*" BEGIN(multilinea);
<multilinea>[^"*>"]* {printf("Comentario multilinea,<*%s*>>\n",yytext),return 35;}
<multilinea>"*"+">" {BEGIN(INITIAL);}

. {printf("No Reconocido");}

%%
	
int main(){
	yylex();
}
