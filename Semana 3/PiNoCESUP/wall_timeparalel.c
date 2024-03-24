#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"

float wall_time(void);

long inCircle(long points, int xStart, int xRange) {
  long count;
  long inside;
  int randVal;
  float xRand;
  float yRand;
//#define xStart -1.0
//#define xRange 2.0
#define yStart -1.0
#define yRange 2.0

  inside=0;
  for (count=0; count<points; count++) {
    randVal=rand();
    xRand = (float)xStart + (float)xRange*(float)randVal/(float)RAND_MAX;//normaliza randomico de 0 a 1
    randVal=rand();
    yRand = yStart + yRange*(float)randVal/(float)RAND_MAX;
    if (xRand*xRand + yRand*yRand <= 1.0) inside++;
  }
  return(inside);
}

int main(int argc, char *argv[]) {
  int procs=1;
  int pow;
  int nproc, theproc;
  int nPoints2, xinicial, xrange;
  long nPoints;
  long inside;
  float tend, tstart;
  double computedPi, realPi, relError;

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
  
	MPI_Init(int *argc, char ***argv);
		if (num){
			cout<<"Erro Inicialização";
			exit(-1);
		}	

		MPI_Comm_size(MPI_COMM_WORLD, &nproc);
		MPI_Comm_size(MPI_COMM_WORLD, &theproc);

		nPoints2 = nPoints/nproc;
		xrange = 2.0 / nproc;
		xinicial = -1.0 + theproc * xrange;
 
		inside = inCircle(nPoints2, xinicial, xrange );
  
	MPI_Finalize(void);
	
	if (num){
		cout<<"Erro Finalização";
		exit(-1);
	}
	
  /* calcula pi */

  computedPi = 4.0* ((double)inside/(double)nPoints);

  tend = wall_time();

  realPi = 2.0*asin(1.0);
  relError = 100.0*fabs(computedPi-realPi)/realPi;

  /* reporta resultados */

  printf("pi=%9.7f, rel error %8.4f%%, %d procs, 2^%d points, %f(s) exec time\n",
	 computedPi, relError, procs, pow, tend-tstart);

  exit(0);
}