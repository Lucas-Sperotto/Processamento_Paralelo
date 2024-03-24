#include <stdlib.h>
#include <stdio.h>
#include "mpi.h"

	//*********************************************************************
	// InitTabuleiros: Inicializa dois tabuleiros localmente nos processadores
	//                 tabulIn com celulas mortas 
	//                 tabulOut com celulas mortas
	//*********************************************************************

	void InitTabuleiroLocal(int lin, int col, int **tabulIn, int **tabulOut){
		int i;
		int j;
		int rank;
		//Inicia Tabuleiro com Todas Mortas
		for (i = 0;i < (lin+2); i++){
			for (j = 0; j < (col+2); j++){
				tabulIn[i][j] = 0;
				tabulOut[i][j]= 0;
			}
		}
		MPI_Comm_rank(MPI_COMM_WORLD, &rank);
		if (rank == 0){
			tabulIn[1][2]= 1;
	   		tabulIn[2][3]= 1;
	   		tabulIn[3][1]= 1;
	    		tabulIn[3][2]= 1;
	   		tabulIn[3][3]= 1;
		}
	}
	
	//*********************************************************************
	// InitTabuleiros: Inicializa dois tabuleiros a nivel glogal (mestre)
	//                 tabulIn com um veleiro 
	//                 tabulOut com celulas mortas
	//*********************************************************************

	void InitTabuleiroGlobal(int tam, int **tabulIn, int **tabulOut){
		int i;
		int j;
		//Inicia Tabuleiro com Todas Mortas
		for (i = 0;i < (tam+2); i++){
			for (j = 0; j < (tam+2); j++){
				tabulIn[i][j] = 0;
				tabulOut[i][j]= 0;
			}
		}
	    	tabulIn[1][2]= 1;
	   	tabulIn[2][3]= 1;
	   	tabulIn[3][1]= 1;
	    	tabulIn[3][2]= 1;
	   	tabulIn[3][3]= 1;		
	}
	
	//**************************************************************
	// UmaVida: Executa uma iteracao do Jogo da Vida
	//          em tabuleiros de tamanho tam. Produz o tabuleiro
	//          de saida tabulOut a partir do tabuleiro de entrada
	//          tabulIn. Os tabuleiros tem tam-1 x tam-1 celulas
	//          internas vivas ou mortas. O tabuleiro eh orlado 
	//          por celulas eternamente mortas.
	//**************************************************************

	void UmaVida(int lin, int col, int **tabulIn, int **tabulOut){
  
		int i;
		int j;
		int vizviv=0;
		
		//int tamproc = 0 ;//tam dividido pelo numero de processadores
		//percorre o tabuleiro determinando o proximo estado de cada celula
 
		for (i = 1; i < lin+1; i++){
			for (j = 1 ;j < col+1; j++){
				vizviv = tabulIn[i-1][j-1] + tabulIn[i-1][j  ] + tabulIn[i-1][j+1] +
						 tabulIn[i  ][j-1] + tabulIn[i  ][j+1] + tabulIn[i+1][j-1] + 
						 tabulIn[i+1][j  ] + tabulIn[i+1][j+1];
				
				//Impoe regra do proximo estado
				
				if (tabulIn[i][j] == 1 && vizviv < 2)
					tabulOut[i][j] = 0;
                		else if (tabulIn[i][j] == 1 && vizviv > 3)
					tabulOut[i][j] = 0;
				else if (tabulIn[i][j] == 0 && vizviv == 3)
					tabulOut[i][j] = 1;
				else
					tabulOut[i][j] = tabulIn[i][j];
			}
		}
	}
	//*************************************************************
	// DumpTabuleiro: Imprime trecho do tabuleiro entre
	//                as posicoes (pri,pri) e (ult,ult)
	//                X representa celula viva
	//                . representa celula morta
	//*************************************************************

	void DumpTabuleiro1D(int Vet[], int col, int **tabul, int pri, int ult){
		int nProc, esteProc;
		char *linha;
			int i, j, p;
		int d,e;
		
		MPI_Status status;
		MPI_Comm_size(MPI_COMM_WORLD, &nProc);
		MPI_Comm_rank(MPI_COMM_WORLD, &esteProc);
				int vetAux[Vet[esteProc]+2][col+2];
				for (i = 0; i < (Vet[esteProc]+2); i++){
					for (j = 0; j < (col+2); j++){
						vetAux[i][j]=0;}}
				for (i = 1; i < (Vet[esteProc]+1); i++){
					for (j = 1; j < (col+1); j++){
					vetAux[i][j]=tabul[i][j];
		}}
		if (esteProc == 0){
			
			linha = (char*) malloc ((col+2) * sizeof(char));
			printf(" Dump das Posicoes %d : %d\n", pri, ult);
			printf("===========================\n");
			
			for( p = 0; p < nProc; p++){
				for (i = 1; i < (Vet[p]+1); i++){
					for (j = 1; j < (col+1); j++){
						if (vetAux[i][j] == 0)
							linha[j-1] = 'O';//-1 para apartir do elemento zero
						else
							linha[j-1] = 'x';
						
						printf("%c",linha[j-1]);
					}
					printf("\n");
				}/*((Vet[p+1]+2)*(col+2))*/
				if (p < nProc-1){
					for ( d=1;d<Vet[p+1]+1;d++){
						for ( e=1;e<col+1;e++){
						MPI_Recv(&vetAux[d][e], 1, MPI_INT, p+1, p+1, MPI_COMM_WORLD, &status);	
			}}}
			}
			printf("===========================\n");
			free(linha);
		}
		else{
			for ( d=1;d<(Vet[esteProc]+1);d++){
				for ( e=1;e<(col+1);e++){
			MPI_Send(&vetAux[d][e], 1 , MPI_INT, 0, esteProc, MPI_COMM_WORLD);
		}}}/*((Vet[esteProc]+2)*(col+2))*/			
		
	}
	
	//*************************************************************
	// DumpTabuleiro: Imprime trecho do tabuleiro entre
	//                as posicoes (pri,pri) e (ult,ult)
	//                X representa celula viva
	//                . representa celula morta
	//*************************************************************
	
	void DumpTabuleiro2D(int Vet[], int col, int iter, int **tabul, int pri, int ult){
		int nProc, esteProc;
		char *linha;
			int i, j, p;
		int d,e, size1, size2;
		int **TabulGlob;
		MPI_Status status;
		MPI_Comm_size(MPI_COMM_WORLD, &nProc);
		MPI_Comm_rank(MPI_COMM_WORLD, &esteProc);
				
		if (esteProc == 0){
			
			TabulGlob = (int**) malloc ((iter+2)*sizeof(int*));
			for( p = 0; p < iter+2; p++){
				TabulGlob[p] = (int*) malloc ((iter+2)*sizeof(int));
			}
			for (d=0;d<iter+2;d++){
				for (e=0;e<iter+2;e++){
					TabulGlob[d][e]=0;
				}	
			}
			linha = (char*) malloc ((iter+2) * sizeof(char));
			printf(" Dump das Posicoes %d : %d\n", pri, ult);
			printf("===========================\n");
			for (d=1;d<Vet[esteProc]+1;d++){
				for (e=1;e<col+1;e++){
					TabulGlob[d][e]=tabul[d][e];
				}
			}
			//for( p = 0; p < nProc; p++){
			//	printf("Vet[%d] = %d\n", p, Vet[p]);
			//}	
			size1 = Vet[0];
			size2 = 0;
			for(p = 1; p < nProc; p++){
				if (p%2==0){
				for (d = 1; d < Vet[p]+1; d++){
					MPI_Recv(&TabulGlob[size1+d][1], col, MPI_INT, p, p*1000+d, MPI_COMM_WORLD, &status);
					}
				size1 = size1+Vet[p];
				//printf("tampar %d\n",size1);
				}
				else{
				for (d = 1; d < Vet[p]+1; d++){
					MPI_Recv(&TabulGlob[size2+d][col+1], col, MPI_INT, p, p*1000+d, MPI_COMM_WORLD, &status);
					}
				size2 = size2+Vet[p];
				//printf("tamimpar %d\n",size2);
				}
				
				
			}
				for (i = 1; i < (iter+1); i++){
					for (j = 1; j < (iter+1); j++){
						if (TabulGlob[i][j] == 0)
							linha[j-1] = 'O';//-1 para apartir do elemento zero
						else
							linha[j-1] = 'x';
						
						printf("%c",linha[j-1]);
					}
					printf("\n");
				}
				
			printf("===========================\n");
			free(linha);
			for(p = 0; p < iter+2; p++){
				free(TabulGlob[p]);
			}
			free(TabulGlob);
		}
		else{
			
				if (esteProc%2==0){
				for (d = 1; d < Vet[esteProc]+1; d++){
					MPI_Send(&tabul[d][1], col, MPI_INT, 0, esteProc*1000+d, MPI_COMM_WORLD);
					}
				}
				if (esteProc%2==1){
				for (d = 1; d < Vet[esteProc]+1; d++){
					MPI_Send(&tabul[d][1], col, MPI_INT, 0, esteProc*1000+d, MPI_COMM_WORLD);
					}
				}		
		
		}
}
	
	//***********************************************************
	// Correto: verifica se o veleiro estah corretamente
	//          representado no canto inferior direito do
	//          tabuleiro, onde deve estar na ultima iteracao
	//***********************************************************
	
	int Correto (int lin, int col, int **tabulIn){
		int i, j;
		int rank, ult;
		int quantosVerdadeiros = 0;
		
		for (i = 1; i < (lin+1); i++){
			for (j = 1; j < (col+1); j++){
				quantosVerdadeiros += tabulIn[i][j];
			}
		}
		MPI_Comm_size(MPI_COMM_WORLD, &ult);
		MPI_Comm_rank(MPI_COMM_WORLD, &rank);
		if (rank != ult-1){
			if  (quantosVerdadeiros == 0)
				return 1;
			else 
				return 0;
		}
		if ((quantosVerdadeiros == 5) && (tabulIn[lin-2][col-1] == 1) && (tabulIn[lin-1][col] == 1) &&
			(tabulIn[lin][col-2] == 1) && (tabulIn[lin][col-1]) && (tabulIn[lin][col] == 1))
			return 1;
		else 
			return 0;
	}

	//***********************************************************
	// Divide:  Divide o tamanho do dominio para cada processo 
	//          e dilui o resto nos primeiros processos          
	//***********************************************************

	void Divide (int tam, int nProc, int Vet[]){
		int i;//variavel auxiliar
		//Distribui o tamanho para cada processo
		for (i = 0; i < nProc; i++){
			Vet[i] = tam/nProc;
		}
		//dilui o resto nos primeiros primeiros
		for (i = 0; i < (tam%nProc); i++){
			Vet[i] += 1;
		}
	}
