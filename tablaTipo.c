#include <stdbool.h>
typedef struct _type type;
typedef struct _tipoBase tipoBase;
typedef struct _tipo tipo;

union _tipo{
	int type; //Tipo simple
	symtab *estructura; //Tipo estructura
};

struct _tipoBase{
	bool est; //Si est es verdadero es estructura si no es tipo simple
	tipo t;
};

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
};

/*Retorna un apuntador a una variable type*/
type *crearTipo();

/*Borra type, libera la memoria*/
void borraType(type *t);

/*inserta al final de la lista en caso de insertar incrementa num
 *retorna la posicion donde inserto en caso contrario retorna -1*/
 int insertarTipo(typetab *tt, type *t);

 /*Retorna el tipo base de un tipo
  *En caso de no encontrarlo retorna NULL*/
 TipoBase getTipoBase(typetab *tt, int id);

 /*Retorna el numero de bytes de un tipo
  *En caso de no encontrarlo retorna -1*/
 int getTam(typetab *tt, int id);

 /*Retorna el numero de elementos de un tipo
  *En caso de no encontrarlo retorna -1*/
 int getNumElem(typetab *tt, int id);

 /*Retorna el nombre de un tipo 
  *En caso de no encontrarlo retorna NULL*/
 char* getNombre(typetab *tt, int id);
