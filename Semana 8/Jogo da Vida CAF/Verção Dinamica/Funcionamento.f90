program funcionamento
  use JogoDaVida
  implicit none
  integer, parameter :: n=6
  integer :: i
  logical, allocatable :: tabulIn(:,:)
  logical, allocatable :: tabulOut(:,:)
  character(len=10) :: str="geracao XX"
!$ integer :: omp_get_max_threads

  ! aloca e inicializa dois tabuleiros
  ! tabuleiro tabulIn contem um veleiro

  allocate(tabulIn(0:n+1,0:n+1))
  allocate(tabulOut(0:n+1,0:n+1))
  call InitTabuleiros(n, tabulIn, tabulOut)

  ! dump estado inicial

!$  write(*,"(/,'***execucao com ',i1,' threads***',/)") omp_get_max_threads()
  call DumpTabuleiro(n, tabulIn, 1, n," estado inicial ")

  ! todas as geracoes para um veleiro

  do i = 1, 2*(n-3)

     ! geracao impar

     call UmaVida(n, tabulIn, tabulOut)

     ! dump geracao

     write(str(9:10), "(i2.2)") 2*i-1
     call DumpTabuleiro(n, tabulOut, 1, n, str)

     ! geracao par

     call UmaVida(n, tabulOut, tabulIn)

     ! dump geracao

     write(str(9:10), "(i2.2)") 2*i
     call DumpTabuleiro(n, tabulIn, 1, n, str)
  end do

  ! verifica correcao

  if (Correto(n, tabulIn)) then
     write(*,"(' Resultado correto ')")
  else
     write(*,"(' Resultado errado ')")
  end if

  ! destroi tabuleiros

  deallocate(tabulIn, tabulOut)
end program funcionamento
