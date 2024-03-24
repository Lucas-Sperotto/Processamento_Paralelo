#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"

float wall_time(void);

long inCircle(long points, float xStart, float xRange) {
  long count;
  long inside;
  int randVal;
  float xRand;
  float yRand;

  #define yStart -1.0
  #define yRange 2.0

  inside=0;
  for (count=0; count<points; count++) {
    randVal=rand();
    xRand = xStart + xRange*(float)randVal/(float)RAND_MAX;//normaliza randomico de 0 a 1
    randVal=rand();
    yRand = yStart + yRange*(float)randVal/(float)RAND_MAX;
    if (xRand*xRand + yRand*yRand <= 1.0) inside++;
  }
  return(inside);
}


int main(int argc, char *argv[]) {
    int erro;
erro = MPI_Init(&argc, &argv);
	if (erro){
		printf("Erro Inicialização");
		exit(-1);
		}
//variaveis que só rerão utilizadas pelo mestre
  int procs=1;
  int pow;
  float tend, tstart;
  double computedPi, realPi, relError;

// variaveir que existem devido a paralelização
 // int erro;
  int nproc, theproc;
  float  xinicial, xrange;
  long nPoints2;
  int tag = 0;
  MPI_Status status;

// variaveir usadas pelo mestre e escravo
  long nPoints;
  int i = 0;
  long inside;
  long inside2;


//Inicia ambiente paralelo

//erro = MPI_Init(&argc, &argv);
	//if (erro){
	//	printf("Erro Inicialização");
	//	exit(-1);
	//	}
//
//Obtem numero de processos e identificação de processador

	erro = MPI_Comm_size(MPI_COMM_WORLD, &nproc); //numero de processos
	erro = MPI_Comm_rank(MPI_COMM_WORLD, &theproc); //numero do processador

printf("\nOBTEVE ID nproc %d  theproc %d  \n", theproc, nproc);

//verifica se é o mestre

if(theproc == 0){


  	/* le e critica argumentos */

	if (argc != 2) {
   		printf(" uso: <exec> <pontos (potencia de 2 entre 0 e 30)> \n");
    		exit(-1);
  	}
  	pow = atoi(argv[1]);
  	if (pow < 0 || pow > 30) {
    		printf(" potencia (%d) fora de [0:30] \n", pow);
   		exit(-1);
  	}
  	nPoints = 1L << pow;


  	/* mede tempo de calculo */

  	tstart = wall_time();


  	/* pontos no circulo unitario */


	//Calcula parcelar para cada um

		nPoints2 = nPoints/(long)nproc;
		xrange = 2.0 / (float)nproc;//calcula o range



  		for (i = 1; i < nproc; i++){//para cada processo......
		xinicial = -1.0 + (float)i * xrange;//calcula o inicio da coordenada x

		//envia mensagens para escravos
		MPI_Send(&nPoints2, 1, MPI_LONG, i, 10+i, MPI_COMM_WORLD);
		printf("MESTRE mandou MSG1 para %d \n", i);
		MPI_Send(&xinicial, 1, MPI_INT, i, 20+i, MPI_COMM_WORLD);
		printf("MESTRE mandou MSG2 para %d \n", i);
		MPI_Send(&xrange, 1, MPI_INT, i, 30+i, MPI_COMM_WORLD);
		printf("MESTRE mandou MSG3 para %d \n", i);

		}//fim do for

		//calcula pontos no circulo MESTRE
        xinicial = -1.0;//calcula o inicio da coordenada x
		inside = inCircle(nPoints2, xinicial, xrange);


		//Recebe mensagens dos escravos
		for (i = 1; i < nproc; i++){

		MPI_Recv(&inside2, 1, MPI_LONG, i, 40+i, MPI_COMM_WORLD, &status);
		printf("MESTRE recebeu MSG4 de %d \n", i);
			//soma numero de pontos INSIDE.....
		inside = inside + inside2;
		}//Fim for

  }//Fim do IF

else{//se for escravo


	//recebe mensagens do mestre

	MPI_Recv(&nPoints2, 1, MPI_LONG, 0, 10+theproc, MPI_COMM_WORLD, &status);
	printf("ESCRAVO %d recebeu MSG1 de 0 \n", theproc);
	MPI_Recv(&xinicial, 1, MPI_INT, 0, 20+theproc, MPI_COMM_WORLD, &status);
    printf("ESCRAVO %d recebeu MSG2 de 0 \n", theproc);
	MPI_Recv(&xrange, 1, MPI_INT, 0, 30+theproc, MPI_COMM_WORLD, &status);
	printf("ESCRAVO %d recebeu MSG3 de 0 \n", theproc);


	//Calcula pontos no circulo ESCRAVO

	inside2 = inCircle(nPoints2, xinicial, xrange );


	//Envia resultado para mestre

	MPI_Send(&inside2, 1, MPI_LONG, 0, 40+theproc, MPI_COMM_WORLD);
	printf("ESCRAVO %d mandou MSG4 para 0 \n", theproc);

	}


//se for o mestre.....
if (theproc == 0){

  /* calcula pi */

  computedPi = 4.0* ((double)inside/(double)nPoints);

  tend = wall_time();

  realPi = 2.0*asin(1.0);
  relError = 100.0*fabs(computedPi-realPi)/realPi;

  /* reporta resultados */

  printf("pi=%9.7f, rel error %8.4f%%, %d procs, 2^%d points, %f(s) exec time\n",
	 computedPi, relError, procs, pow, tend-tstart);

}//fim do IF


	//Finaliza Ambiente Paralelo

	erro = MPI_Finalize();

	//if (erro){
	//	printf("Erro Finalização");
	//	exit(-1);
	//}


  exit(0);//fim do programa
}

