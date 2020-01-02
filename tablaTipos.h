#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "pilaSym.h"


typedef union _tipo tipo;

union _tipo{
	int type; //Tipo simple
	symtab *estructura; //Tipo estructura
};

typedef struct _tipoBase tipoBase;

struct _tipoBase{
	bool est; //Si est es verdadero es estructura si no es tipo simple
	tipo t;
};

typedef struct _type type;

struct _type{
	int id;
	char nombre[10]; //se puede sustituir por un entero tambien
	tipoBase tb;
	int tamBytes;
	int numElem;
	type *next;
};


typedef struct _typetab typetab;

struct _typetab{
	type *root;
	int num;
	type *next;
};


type *crearTipo();

void borraType(type *t);

int insertarTipo(typetab *tt, type *t);

tipoBase getTipoBase(typetab *tt, int id);

int getTam(typetab *tt, int id);

int getNumElem(typetab *tt, int id);

char* getNombre(typetab *tt, int id);


