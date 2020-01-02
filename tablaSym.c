#include "tablaSym.h"

/*Retorna un apuntador a una variable Param*/
param *crearParam(int tipo){
	param *new = malloc(sizeof(param));
	new->tipo = tipo;
	new->next=NULL;
	return new;
}


/*Retorna un apuntador a una variable listParam*/
listParam *crearLP(){
	listParam *new = malloc(sizeof(listParam));
	new->root = NULL;
	new->num = 0;
	return new;
}

/*Agrega al final de la lista el parametro e incrementa num*/
void addListParam(listParam lp, int tipo){
	param *iter = lp.root;
	for (int i = 0; i < lp.num; ++i)
	{	
		if(lp.num==0){
			lp.root->tipo=tipo;
			lp.num=lp.num+1;
		}
		if(iter->next==NULL){
			iter->next->tipo=tipo;
			lp.num= lp.num+1;
		}
	}

}

/*Borra toda la lista, libera la memoria*/
void borrarListParam(listParam* lp){
	param *iter = lp->root;
	for (int i = 0; i < lp->num; ++i)
	{
		listParam *ant= iter; //iter es de tipo param pero ant es de tipo listParam
		iter = ant->num; //iter es de tipo param pero ant->num es int
		free(ant);
	}

	free(lp);
}

/*Cuenta el numero de parametros en la lista*/
int getNumListParam(listParam *lp){
	return lp->num;
}



/*Retorna un apuntador a una variable symbol*/
symbol *crearSymbol(){
	symbol *new = malloc(sizeof(symbol));
	return new;
}

/*Borra symbol, libera la memoria*/
void borrarSymbol(symbol *s){
	free(s);
}



/*Retorna un apuntador a una variable symtab, inicia contador en 0*/
symtab *crearSymTab(){
	symtab *new = malloc(sizeof(symtab));
	new->num = 0;
	new->next = NULL;
	new->root = NULL;
	return new;
}

/*Borra toda la lista, libera la memoria*/
void borrarSymTab(symtab *st){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{
		symbol *ant= iter;
		iter = ant->next;
		free(ant);
	}

	free(st);
}

/*Inserta al final de la lista en caso de insertar incrementa num
 *retorna la posicion donde inserto en caso contrario retorna -1
 */
int insertar(symtab *st, symbol *sym){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(st->num==0){
			st->root=sym;
			st->num=st->num+1;
			return 0;
		}
		if(sym->id==iter->id){
			return -1;
		}
		if(iter->next==NULL){
			iter->next=sym;
				st->num= st->num+1;
				return st->num;
		}
	}

}

/*Busca en la tabla de simbolos mediante el id
 *En caso de encontrar el id retorna la posicion
 *En caso contrario retorna -1
 */
int buscar(symtab *st, char *id){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(st->num==0){
			return -1;
		}
		if(id==iter->id){
			return id; //id es char, no int
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}

/*Retorna el tipo de dato de un id
 *En caso de no encontrarlo retorna -1*/
int getTipo(symtab *st,char *id){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(id==iter->id){
			return iter->tipo;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}

/*Retorna el tipo de Variable de un id
 *En caso de no encontrarlo retorna -1*/
 int getTipoVar(symtab *st, char *id){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(id==iter->id){
			return iter->tipoVar;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}

 /*Retorna la direccion de un id
  *En caso de no encontrarlo retorna -1*/
 int getDir(symtab *st, char *id){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(id==iter->id){
			return iter->dir;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}

 /*Retorna la lista de parametros de un id
  *En caso de no encontrarlo retorna NULL*/
 listParam *getListParam(symtab *st, char *id){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(id==iter->id){
			return iter->params;
		}
		if(iter->next==NULL){
			return NULL;
		}
	}
}

 /*Retorna el numero de parametros de un id
  *En caso de no encontrarlo retorna -1*/
 int getNumParam(symtab *st, char *id){
	symbol *iter = st->root;
	for (int i = 0; i < st->num; ++i)
	{	
		if(id==iter->id){
			return iter->params->num;
		}
		if(iter->next==NULL){
			return -1;
		}
	}
}
