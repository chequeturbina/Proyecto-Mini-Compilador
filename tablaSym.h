#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _param param;

struct _param{
	int tipo;
	param *next;
};

typedef struct _listParam listParam;

struct _listParam{
	param *root;
	int num;
};

typedef struct _symbol symbol;

struct _symbol{
	char id[32];
	int tipo;
	int dir;
	int tipoVar;
	listParam *params;
	symbol *next;
};

typedef struct _symtab symtab;

struct _symtab{
	symbol *root;
	int num;
	symtab *next;
};



param *crearParam(int tipo);

void borraParam(param *p);

listParam *crearLP();

void add(listParam lp, int tipo);

void borrarListParam(listParam* lp);

int getNumListParam(listParam *lp);

symbol *crearSymbol();

void borrarSymbol(symbol *s);

symtab *crearSymTab();

void borrarSymTab(symtab *st);

int insertar(symtab *st, symbol *sym);

int buscar(symtab *st, char *id);

int getTipo(symtab *st,char *id);

int getTipoVar(symtab *st, char *id);

int getDir(symtab *st, char *id);

listParam *getListParam(symtab *st, char *id);

int getNumParam(symtab *st, char *id);