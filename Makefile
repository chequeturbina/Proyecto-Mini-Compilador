flex lexer_final.l
bison -d sintactico.y
gcc -g lex.yy.c sintactico.tab.c -o ejecutable
