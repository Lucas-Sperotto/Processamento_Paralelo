#include<stdlib.h>
#include<stdio.h>
#include<math.h>

// fun��o para calcular o tempo
float wall_time(void);


// Fun��o para o c�lculo da norma de um vetor
// Retorna a norma em float.
float norma2(float X[], int size){
    int i=0;// variavel auxiliar
    float norm = 0.000000000000000;// variavel da norma
	float aux = 0.000000000000000;// auxiliar no calculo recebe o quadrado do elemento
	// la�o calcula a soma do quadrado dos elementos do vetor
    for (i=0; i < size; i++){
		aux = X[i]*X[i];// eleva o elemento ao quadrado
        norm += aux;// soma o quadrado dos elementos
    }
    return sqrt(norm);// retorna a raiz quadrada da soma dos quadrados
}
//fun��o para multiplica��o de Martis CRS por vetor denso
void multMatrix(float A[], float X[], float Y[], int Vcol[], int Vlin[], int lin){
    int i1, j1, k1;// Variaveis Auxiliares
    //float Y[lin];// vetor para resultado da multiplica��o
	// Calculo Principal
	#pragma omp for schedule(static) private (i1, j1)
    for(i1=0; i1 < lin; i1++){
        Y[i1]=0.000000000000000;
		for(j1=Vlin[i1]; j1 < Vlin[i1+1]; j1++){
			Y[i1] += A[j1]*X[Vcol[j1]];
		}
    }
	// La�o para transferir vetor Y para X
    #pragma omp for schedule(static)
    for(j1=0; j1< lin; j1++){
         X[j1]=Y[j1];
        }

}
// Converter vetor lin formato CRS
void ConvCRS(int Vlin[], int Vlinaux[], int nonZero, int lin2){
	int i=0, j=0, aux=1, vari=0;// variaveis auxiliares nos la�os e indices
	Vlin[0] = 0;// primeiro elemento sempre remota ou primeiro indice do vetor val
	for (i=1; i < nonZero; i++){// la�o passa por todol os elementos indices do vetor lin e val
        vari = Vlinaux[i]-Vlinaux[i-1];// guarda a varia��o do indice da linha
		if (vari==1){//para varia��o unitaria
			Vlin[aux] = i;// recebe i indice do proximo elemento de val
			aux++;
		}
		if (vari > 1){//para varia��o maior que um linha nula
			for(j=0; j < vari; j++){
				Vlin[aux] = i;// recebe varia��o vezes o indice do elemento n�o nulo
				aux++;
			}
		}// caso a vari��o for zero - mesma linha - o vetor n recebe nada
    }
    for(j=aux; j < lin2; j++){// ultimos elemento recebe o ultimo indice do vetor val
		Vlin[j] = nonZero;
		aux++;
	}
}

int main(int argc, char* argv[]){

    int lin=0;// Variavel para guardar numero de linhas
    int col=0;// Variavel para guardar numero de colunas
    int nonZero=0;// Variavel para guardar numero de elementos n�o nulos

    FILE *pt;// cria ponteiro para leitura de arquivo

	//pt = fopen("Esparsa_3.txt","r");
    pt = fopen(argv[2],"r");// abre arquivo do argumento
	//printf("%s\n", argv[1]);

    fscanf(pt,"%d", &lin);// le numero de linhas
    fscanf(pt,"%d", &col);// le numero de colunas
    fscanf(pt,"%d", &nonZero);// le numero de elementos n�o nulos

	/*
	printf("%d\n", lin);
    printf("%d\n", col);
    printf("%d\n", nonZero);*/

    int Jit=0;// cria e inicializa variavel para o numero de itera��es
	//printf("%d\n", atoi(argv[2]));
	Jit = atoi(argv[3]);// le numero de itera��es do argumento
    int i=0;// variavel auxiliar nos la�os
    int j=0;// variavel auxiliar nos la�os
	float tstart, tend;//Variaveis para contagem do Tempo
    float norma;//Variavel para receber a norma do vetor
    float A[nonZero];// Vetor para receber valores dos elementos n�o nulos
    int Vcol[nonZero];// Vetor para receber indices das colunas do arquivo
    int Vlinaux[nonZero];//Vetor para receber os indices linhas do arquivo
    int lin2 = lin+1;//para criar vLin com um elemento a mais que o numero de linhas
	int Vlin[lin2];//Vetor indices do primeiro elemento da linha
    float X[lin];// Vetor denso para a multiplica��o
    float Y[lin];
	//La�o para Receber informa��es do arquivo
    for (i=0; i < nonZero; i++){
        fscanf(pt,"%d", &Vlinaux[i]);// recebe indice linha
        fscanf(pt,"%d", &Vcol[i]);// recebe indice coluna
        fscanf(pt,"%f", &A[i]);// recebe valor do n�o nulo

        //adecua indices das linhas e colunas para a linguagem C
        Vlinaux[i]=Vlinaux[i]-1;
        Vcol[i]=Vcol[i]-1;
    }

    fclose(pt);// Fechamento do Arquivo

	// convers�o dos valores dos indices das linhas para
	// formato de armazenagem CRS
	ConvCRS(Vlin, Vlinaux, nonZero, lin2);

	/*
    for (i=0; i < nonZero; i++){
        printf("%d ", Vlinaux[i]);
        printf("%d ", Vcol[i]);
        printf("%f\n", A[i]);
    }*/

	/*
	for (i=0; i < lin2; i++){
		printf("Vlin[%d]= %d\n",i, Vlin[i]);
    }*/

    //Inicializar Vetor X1 com 1
    for (i=0; i < lin; i++){
        X[i]=1.000000000000000;
    }

	/*
    for (i=0; i < lin; i++){
        printf("%f\n",X[i]);
	}*/



	tstart = wall_time();// Inicia Contagem do Tempo

	//La�o iterativo para o calculo.......J itera��es......
	#pragma omp parallel private(i)
	{//inicia regi�o paralela
    		for (i=0; i < Jit; i++){

				multMatrix(A, X, Y, Vcol, Vlin, lin);// chama fun��o para multiplica��o da matriz pelo vetor denso
				/*
				for (j=0; j < lin; j++){
					printf("%f\n",X[j]);
				}*/
				//printf("%d \n", i);
    		}
	}//termina regi�o paralela

	tend = wall_time();// Finaliza Contagem do Tempo

    //Agora calcular a norma2 do vetor final
    norma = norma2(X, lin);
	//Imprimir em arquivo dados selecionados e pronto
	printf("%s_%s Threads\n", argv[2], argv[1]);
    printf("Norma2 = %f, Tempo = %f (s)\n", norma, tend-tstart);
	//printf("Norma2 = %f", norma);
    return 0;
}
