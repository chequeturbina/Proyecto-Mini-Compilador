#include "tablaTipos.h"


/*Retorna un apuntador a una variable type*/
type *crearTipo(){
	type *new = malloc(sizeof(type));
	new->id=0;
	new->nombre[0]=' ';
	new->tb=NULL; //ERROR
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
		if(tt->num==0){
			tt->root=t;
			tt->num=tt->num+1;
			return tt->num;
		}
		if(t->id==iter->id){
			return -1;
		}
		if(iter->next==NULL){
			iter->next=t;
			tt->num= tt->num+1;
			return tt->num;
		}
	}
}

 /*Retorna el tipo base de un tipo
  *En caso de no encontrarlo retorna NULL*/
 tipoBase getTipoBase(typetab *tt, int id){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(tt->num==0){
			return NULL; //ERROR
		}
		if(id==iter->id){
			return iter->tb;
		}
		if(iter->next==NULL){
			return NULL;//ERROR
		}
	}
}

 /*Retorna el numero de bytes de un tipo
  *En caso de no encontrarlo retorna -1*/
 int getTam(typetab *tt, int id){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i)
	{	
		if(tt->num==0){
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
		if(tt->num==0){
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
		if(tt->num==0){
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
