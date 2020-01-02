#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablaSym.h"


typedef struct _symstack symstack;

struct _symstack{
	symtab *root;
	int num;
};

symstack *crearSymStack();

void borrarSymStack(symstack *ss);

int insertarSymTab(symtab *st, symbol *sym);

symtab* getCima(symstack *ss);

symtab* sacarSymTab(symstack *ss);
