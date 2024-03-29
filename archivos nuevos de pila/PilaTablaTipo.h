#ifndef PILATABLATIPO_H_INCLUDED
#include "tablaTipo.h"
typedef struct _typestack typestack;

struct _typestack
{
   typetab *root;
   int num;
};

typestack *newStackTT();
void borrarTypeStack(typestack *ptt);
void pushTT(typestack *ptt, typetab *type_tab);
typetab* getCimaType(typestack *ptt);
typetab* getFondoType(typestack *ptt);
typetab* popTT(typestack *ptt);
void printPilaType(typestack *ptt);
#define PILATABLATIPO_H_INCLUDED
#endif