#include "pilaSym.h"


symstack *crearSymStack(){
	symstack *new = malloc(sizeof(symstack));
	new->root = NULL;
	new->num = 0;
	return new;
}

void borrarSymStack(symstack *ss){
	symtab *iter = ss->root;
	for (int i = 0; i < ss->num; ++i)
	{
		symtab *ant= iter;
		iter = ant->next;
		free(ant);
	}
	free(ss);
}

int insertarSymTab(symtab *st, symbol *sym){
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
		borrarSymStack(ss);
	}else{
		for(int i=0; i<ss->num-1; i++){	
			if(iter->next->next==NULL){
				symtab *aux= iter->next;
				free(iter->next);
				return aux;
			}
			iter = iter->next;
		}
	}
	return NULL;

int main(int argc, char const *argv[]) {
		/* code */
		return 0;
	}	
}