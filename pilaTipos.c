#include "pilaTipos.h"

typestack *crearTypeStack() {
	typestack *new = malloc(sizeof(symstack));
	new->root = NULL;
	new->num = 0;
	return new;
}

void borrarTypeStack(typestack *ts){
	typetab *iter = ts->root;
	for (int i = 0; i < ts->num; ++i) {
		typetab *ant= iter;
		iter = ant->next; // ant->next es de tipo type pero iter es de tipo typetab
		free(ant);
	}
	free(ts);
}

int insertarTypeTab(typetab *tt, type *t){
	type *iter = tt->root;
	for (int i = 0; i < tt->num; ++i) {	
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

typetab* getCimaType(typestack *ts){
	typetab *iter = ts->root;
	for(int i=0; i<ts->num; i++){	
		if(iter->next==NULL){
			return iter;
		}
		iter = iter->next; //iter->next es de tipo type pero iter es de tipo typetab
	}
	return NULL;
}

typetab* sacarTypeTab(typestack *ts){
	typetab *iter = ts->root;
	if(ts->num<=1){
		borrarTypeStack(ts);
	}else{
		for(int i=0; i<ts->num-1; i++){	
			if(iter->next->next==NULL){
				typetab *aux= iter->next; //iter->next es de tipo type pero aux es de tipo typetab
				free(iter->next);
				return aux;
			}
			iter = iter->next; //iter->next es de tipo type pero iter es de tipo typetab
		}
	}
	return NULL;
}
