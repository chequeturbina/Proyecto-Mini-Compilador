#include <stdio.h>
extern int yyparse();
extern FILE* yyin;

int main(int argc, char **argv)
{
    if(argc <2)
    {
        printf("Faltan argumentos\n");
        return -1;
    }
    FILE *f = fopen(argv[1], "r");
    if(!f){
        printf("El archivo %s no se puedo abrir\n", argv[1]);
        return -1;
    }
    yyin = f;
    yyparse();
    return 0;
}