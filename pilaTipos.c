typedef struct _typetab typetab;

struct _typetab{
	type *root;
	int num;
	type *next;
};

typedef struct _typestack typestack;

struct _typestack{
	typetab *root;
	int num;
};

typestack *crearTypeStack(){
	typestack *new = malloc(sizeof(symstack));
	new->root = NULL;
	new->num = 0;
	return new;
}

void borrarTypeStack(typestack *ts){
	typetab *iter = ts->root;
	for (int i = 0; i < ts->num; ++i)
	{
		typetab *ant= iter;
		iter = ant->next;
		free(ant);
	}
	free(ts);
}

void insertarTypeTab(typetab *sym){
	typetab *iter = root;
	if(num==0){
		root = sym;
		num=num+1;
	}else{
		for(int i=0; i<num; i++){	
			if(iter->next==NULL){
				iter->next=sym;
				num= num+1;
			}
			iter = iter->next;
		}
	}
}

typetab* getCimaType(typestack *ts){
	typetab *iter = ts->root;
	for(int i=0; i<ts->num; i++){	
		if(iter->next==NULL){
			return iter;
		}
		iter = iter->next;
	}
	return NULL;
}

typetab* sacarTypeTab(typestack *ts){
	typetab *iter = ts->root;
	if(ts->num<=1){
		ts.borrar();
	}else{
		for(int i=0; i<ts->num-1; i++){	
			if(iter->next->next==NULL){
				typetab *aux= iter->next
				free(iter->next)
				return aux;
			}
			iter = iter->next;
		}
	}
	return NULL;
}
