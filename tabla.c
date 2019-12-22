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

/*Retorna un apuntador a una variable Param*/
param *crearParam(int tipo){
	param *new = malloc(sizeof(param));
	new->tipo = tipo;
	new->next=NULL;
	return new;
}

/*Borra param, libera la memoria*/
void borraParam(param *p){
	remove(*p);
}

/*Retorna un apuntador a una variable listParam*/
listParam *crearLP(){
	listParam *new = malloc(sizeof(listParam));
	new->root = NULL;
	new->num = 0;
	return new;
}

/*Agrega al final de la lista el parametro e incrementa num*/
void add(listParam lp, int tipo){
	listParam *iter = lp->root;
	for (int i = 0; i < lp->num; ++i)
	{	
		if(num==0){
			lp->root->tipo=tipo;
			num=num+1;
		}
		if(iter->next==NULL){
			iter->next->tipo=tipo;
			num= num+1;
		}
	}

}

/*Borra toda la lista, libera la memoria*/
void borrarListParam(listParam* lp){
	listParam *iter = lp->root;
	for (int i = 0; i < lp->num; ++i)
	{
		listParam *ant= iter;
		iter = ant->next;
		free(ant);
	}

	free(lp);
}

/*Cuenta el numero de parametros en la lista*/
int getNumListParam(listaParam *lp){
	return lp->num;
}

typedef struct _symbol symbol;

struct _symbol{
	char id[32];
	int tipo;
	int dir;
	int tipoVar;
	listParam *params;
	symbol *next;
};

/*Retorna un apuntador a una variable symbol*/
symbol *crearSymbol(){
	symbol *new = malloc(sizeof(symbol));
	return new;
}

/*Borra symbol, libera la memoria*/
void borrarSymbol(symbol *s){
	free(s);
}

typedef struct _symtab symtab;

struct _symtab{
	symbol *root;
	int num;
	symtab *next;
};

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
		if(num==0){
			st->root=sym;
			num=num+1;
			return 0;
		}
		if(sym->id==iter->id){
			return -1;
		}
		if(iter->next==NULL){
			iter->next=sym;
				num= num+1;
				return num;
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
		if(num==0){
			return -1;
		}
		if(id==iter->id){
			return id;
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
