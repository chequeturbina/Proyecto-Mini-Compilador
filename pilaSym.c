typedef struct _symtab symtab;

struct _symtab{
	symbol *root;
	int num;
	symtab *next;
};

typedef struct _symstack symstack;

struct _symstack{
	symtab *root;
	int num;
};

symstack *crearSymStack(){
	symstack *new = malloc(sizeof(symstack));
	new->root = NULL;
	new->num = 0;
	return new;
}

void borrarSymStack(symstack *ss){
	symtab *iter = ss->root;
	for (int i = 0; i < num; ++i)
	{
		symtab *ant= iter;
		iter = ant->next;
		free(ant);
	}
	free(ss);
}

void insertarSymTab(symtab *sym){
	symtab *iter = root;
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

symtab* getCima(symstack *ss){
	symtab *iter = ss->root;
	for(int i=0; i<ss->num; i++){	
		if(iter->next==NULL){
			return iter;
		}
		iter = iter->next;
	}
	return NULL;
}

symtab* sacarSymTab(symstack *ss){
	symtab *iter = ss->root;
	if(ss->num<=1){
		ss.borrar();
	}else{
		for(int i=0; i<ss->num-1; i++){	
			if(iter->next->next==NULL){
				symtab *aux= iter->next
				free(iter->next)
				return aux;
			}
			iter = iter->next;
		}
	}
	return NULL;	
}
