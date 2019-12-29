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
type *crearTipo(){
	type *new = malloc(sizeof(type));
	new->id=0;
	new->nombre="";
	new->tipoBase=NULL;
	new->tamBytes=0;
	new->numElem=0;
	new->next=NULL;
	return new;
}

/*Borra type, libera la memoria*/
void borraType(type *t){
	free(t);
}

/*inserta al final de la lista en caso de insertar incrementa num
 *retorna la posicion donde inserto en caso contrario retorna -1*/
 int insertarTipo(typetab *tt, type *t){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(num==0){
			tt->root=t;
			num=num+1;
			return num;
		}
		if(t->id==iter->id){
			return -1;
		}
		if(iter->next==NULL){
			iter->next=t;
			num= num+1;
			return num;
		}
	}
}

 /*Retorna el tipo base de un tipo
  *En caso de no encontrarlo retorna NULL*/
 TipoBase getTipoBase(typetab *tt, int id){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(num==0){
			return -1;
		}
		if(id==iter->id){
			return iter->tipoBase;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}

 /*Retorna el numero de bytes de un tipo
  *En caso de no encontrarlo retorna -1*/
 int getTam(typetab *tt, int id){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(num==0){
			return -1;
		}
		if(id==iter->id){
			return iter->tamBytes;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
 }

 /*Retorna el numero de elementos de un tipo
  *En caso de no encontrarlo retorna -1*/
 int getNumElem(typetab *tt, int id){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(num==0){
			return -1;
		}
		if(id==iter->id){
			return iter->numElem;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}

 /*Retorna el nombre de un tipo 
  *En caso de no encontrarlo retorna NULL*/
 char* getNombre(typetab *tt, int id){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(num==0){
			return NULL;
		}
		if(id==iter->id){
			return iter->nombre;
		}
		if(iter->next==NULL){
			return NULL;
		}
	}
}
