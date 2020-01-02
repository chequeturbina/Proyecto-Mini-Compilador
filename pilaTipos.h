#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablaTipos.h"

typedef struct _typestack typestack;

struct _typestack{
	typetab *root;
	int num;
};


typestack *crearTypeStack();

void borrarTypeStack(typestack *ts);

int insertarTypeTab(typetab *tt, type *t);

typetab* getCimaType(typestack *ts);

typetab* sacarTypeTab(typestack *ts);