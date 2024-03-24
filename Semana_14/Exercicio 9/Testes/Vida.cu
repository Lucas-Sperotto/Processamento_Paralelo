#include <stdio.h>
#include <stdlib.h>
#include <cutil_inline.h>

// prototipo de wall_time
double wall_time(void);


// UmaVida: Executa uma iteracao do Jogo da Vida
//          em tabuleiros de tamanho tam. Produz o tabuleiro
//          de saida tabulOut a partir do tabuleiro de entrada
//          tabulIn. Os tabuleiros tem tam x tam celulas
//          internas vivas ou mortas. O tabuleiro eh orlado 
//          por celulas eternamente mortas.
//          O tabuleiro eh dimensionado tam+2 x tam+2.

void UmaVida(int* tabulIn_h, int* tabulOut_h, int tam) {
  int i, j, jAnt, jCor, jPro;
  int vizviv;
  
  for (j=1; j<=tam; j++) {
    jAnt = (j-1)*(tam+2);  // inicio linha anterior
    jCor =  j   *(tam+2);  // inicio linha corrente
    jPro = (j+1)*(tam+2);  // inicio linha proxima
    for (i= 1; i<=tam; i++) {
      vizviv = 
	tabulIn_h[i-1 + jAnt] + 
	tabulIn_h[i   + jAnt] +
	tabulIn_h[i+1 + jAnt] + 
	tabulIn_h[i-1 + jCor] + 
	tabulIn_h[i+1 + jCor] + 
	tabulIn_h[i-1 + jPro] + 
	tabulIn_h[i   + jPro] + 
	tabulIn_h[i+1 + jPro];
      if (tabulIn_h[i + jCor] && vizviv < 2) 
	tabulOut_h[i + jCor] = 0;
      else if (tabulIn_h[i + jCor] && vizviv > 3) 
	tabulOut_h[i + jCor] = 0;
      else if (!tabulIn_h[i + jCor] && vizviv == 3) 
	tabulOut_h[i + jCor] = 1;
      else
	tabulOut_h[i + jCor] = tabulIn_h[i + jCor];
    }
  }
}


// Kernel

__global__ void UmaVidaGPU(int* tabulIn_d, int* tabulOut_d, int tam) {
  int i = blockIdx.x * blockDim.x + threadIdx.x + 1;
  int j = blockIdx.y * blockDim.y + threadIdx.y + 1; 
  int jAnt, jCor, jPro;
  int vizviv;
  
  //for (j=1; j<=tam; j++){ 
  if (j <= tam){
    jAnt = (j-1)*(tam+2);  // inicio linha anterior
    jCor =  j   *(tam+2);  // inicio linha corrente
    jPro = (j+1)*(tam+2);  // inicio linha proxima
    //for (i= 1; i<=tam; i++) {
	if (i <= tam){
      vizviv = 
	tabulIn_d[i-1 + jAnt] + 
	tabulIn_d[i   + jAnt] +
	tabulIn_d[i+1 + jAnt] + 
	tabulIn_d[i-1 + jCor] + 
	tabulIn_d[i+1 + jCor] + 
	tabulIn_d[i-1 + jPro] + 
	tabulIn_d[i   + jPro] + 
	tabulIn_d[i+1 + jPro];
      if (tabulIn_d[i + jCor] && vizviv < 2) 
	tabulOut_d[i + jCor] = 0;
      else if (tabulIn_d[i + jCor] && vizviv > 3) 
	tabulOut_d[i + jCor] = 0;
      else if (!tabulIn_d[i + jCor] && vizviv == 3) 
	tabulOut_d[i + jCor] = 1;
      else
	tabulOut_d[i + jCor] = tabulIn_d[i + jCor];
    }
  }
}


// InitTabuleiros: Inicializa dois tabuleiros:
//                tabulIn com um veleiro 
//                tabulOut com celulas mortas

void InitTabul(int* tabulIn, int* tabulOut, int tam){
  int ij;

  for (ij=0; ij<(tam+2)*(tam+2); ij++) {
    tabulIn[ij] = 0;
    tabulOut[ij] = 0;
  }

  tabulIn[1*(tam+2)+3] = 1; 
  tabulIn[2*(tam+2)+1] = 1; 
  tabulIn[2*(tam+2)+3] = 1; 
  tabulIn[3*(tam+2)+2] = 1; 
  tabulIn[3*(tam+2)+3] = 1; 
}


// DumpTabuleiro: Imprime trecho do tabuleiro entre
//                as posicoes (pri,pri) e (ult,ult)
//                X representa celula viva
//                . representa celula morta

void DumpTabul(int * tabul, int tam, int first, int last, char* msg){
  int i, ij;

  printf("%s; trecho [%d:%d, %d:%d] do tabuleiro\n", msg, first, last, first, last);
  for (i=first; i<=last; i++) printf("="); printf("=\n");

  for (i=first; i<=last; i++) {
    for (ij=first*(tam+2)+i; ij<=last*(tam+2)+i; ij+=(tam+2))
      printf("%c", tabul[ij]? 'X' : '.');
    printf("\n");
  }
  for (i=first; i<=last; i++) printf("="); printf("=\n");
}


// Correto: Verifica se a configuracao final do tabuleiro
//          estah correta ou nao (veleiro no canto inferior esquerdo)

int Correto(int* tabul, int tam){
  int ij, ini, cnt;

  cnt = 0;
  for (ij=0; ij<(tam+2)*(tam+2); ij++) {
    cnt = cnt + tabul[ij];
  }

  ini = (tam-3)*(tam+2) + (tam-3);
  if (cnt == 5 &&
      tabul[1*(tam+2)+3+ini] &&
      tabul[2*(tam+2)+1+ini] &&
      tabul[2*(tam+2)+3+ini] &&
      tabul[3*(tam+2)+2+ini] &&
      tabul[3*(tam+2)+3+ini] )
    return(1);
  else 
    return(0);
}


// Trafega um veleiro de tamanho tam ao longo do tabuleiro
// Tamanho tam eh argumento de execucao

int main(int argc, char *argv[]) {
  
  #define MinTam 4
  // Declaração de Variaveis na CPU (host)
  int i;
  int tam, tamBlk, nBlk;
  int* tabulIn_h;
  int* tabulOut_h;
  size_t size;
  double t00, t01, t02, t03;// Tempo na CPU
  double t10, t11, t12, t13;//Tempo na GPU
  
  //Declaração de Variaveis da GPU (device)
  int* tabulIn_d;
  int* tabulOut_d;
  
  // obtem tamanho do tabuleiro
  if (argc != 3) {
    printf(" uso: <exec> <celulas por bloco> <quantos blocos>\n");
    exit(-1);
  }
  tamBlk = atoi(argv[1]);
  nBlk = atoi(argv[2]);
  tam = nBlk*tamBlk;
  size = (tam+2)*(tam+2)*sizeof(int);
  
  // tamanho minimo
  if (tam < MinTam) {
    printf("**ERRO** tamanho %d menor que o minimo %d\n", tam, MinTam);
    exit(-1);
  }

//**************************************************************************
// CPU
//**************************************************************************

  // aloca e inicializa tabuleiros na CPU
  t00 = wall_time();
  tabulIn_h  = (int *) malloc (size);
  tabulOut_h = (int *) malloc (size);
  InitTabul(tabulIn_h, tabulOut_h, tam);
  
  // dump tabuleiro inicial na CPU
  DumpTabul(tabulIn_h, tam, 1, 4, "Inicial::CPU");
  
  // avanca geracoes na CPU
  t01 = wall_time();
  for (i=0; i<2*(tam-3); i++) {
    UmaVida (tabulIn_h, tabulOut_h, tam);
    UmaVida (tabulOut_h, tabulIn_h, tam);
  }
  t02 = wall_time();
  
  // dump tabuleiro final na CPU
  DumpTabul(tabulIn_h, tam, tam-3, tam, "Final::CPU");
  
  // Correcao na CPU
  if (Correto(tabulIn_h, tam)) 
    printf("**RESULTADO CORRETO NA CPU**\n");
  else
    printf("**RESULTADO ERRADO NA CPU**\n");

  t03 = wall_time();

  printf("CPU tam=%d; tempos: init=%f, comp=%f, fim=%f, tot=%f \n", 
	 tam, t01-t00, t02-t01, t03-t02, t03-t00);//Printa resultados CPU

//**************************************************************************
// GPU
//**************************************************************************
	 
	// aloca tabuleiros na GPU e envia tabuleiros inicializados
	t10 = wall_time();
	cudaMalloc((void**) &tabulIn_d, size);//Aloca na GPU
	cudaMalloc((void**) &tabulOut_d, size);//Aloca na GPU
	InitTabul(tabulIn_h, tabulOut_h, tam);//Inicializa novamente para enviar tabuleiro
	cudaMemcpy (tabulIn_d, tabulIn_h, size, cudaMemcpyHostToDevice);//Envia para GPU
	cudaMemcpy (tabulOut_d, tabulOut_h, size, cudaMemcpyHostToDevice);//Envia para GPU

	// avanca geracoes na GPU
	t11 = wall_time();
	dim3 dB (tamBlk, tamBlk);//dimensionamento
	dim3 dG (nBlk, nBlk);//dimensionamento
	for (i=0; i<2*(tam-3); i++) {
		UmaVidaGPU<<< dG, dB >>>(tabulIn_d, tabulOut_d, tam);//chamada do kernel
		cudaThreadSynchronize();//sincronização
		UmaVidaGPU<<< dG, dB >>>(tabulOut_d, tabulIn_d, tam);//chamada do kernel
		cudaThreadSynchronize();//outra sincronização
	}
	t12 = wall_time();
	 
	// Recebe tabuleiros e dump tabuleiro final da GPU
	cudaMemcpy (tabulIn_h, tabulIn_d, size, cudaMemcpyDeviceToHost);
	cudaMemcpy (tabulOut_h, tabulOut_d, size, cudaMemcpyDeviceToHost);
	DumpTabul(tabulIn_h, tam, tam-3, tam, "Final::GPU"); //dump do tabuleiro da CPU reescrito pelo resultado da GPU

	// Correcao na GPU
	if (Correto(tabulIn_h, tam)) //verifica na memoria da CPU
		printf("**RESULTADO CORRETO NA GPU**\n");
	else
		printf("**RESULTADO ERRADO NA GPU**\n");

	t13 = wall_time();
	 
  printf("GPU tam=%d; tempos: init=%f, comp=%f, fim=%f, tot=%f \n", 
	 tam, t11-t10, t12-t11, t13-t12, t13-t10);//Printa resultados GPU

  //Desaloca memória na CPU
  free(tabulIn_h);
  free(tabulOut_h);
  
  //Desaloca memória na GPU
  cudaFree(tabulIn_d);
  cudaFree(tabulOut_d);

  exit(0);    
}
