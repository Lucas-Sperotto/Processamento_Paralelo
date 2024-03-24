program TempoExec
  use JogoDaVida
  implicit none
  integer :: n
  integer :: nPot
  integer, parameter :: nPotMin=5
  integer, parameter :: nPotMax=10
  integer :: i
  logical, allocatable :: tabulIn(:,:)
  logical, allocatable :: tabulOut(:,:)
  integer :: count_ini, count_end, count_rate, count_max
  real :: t0, t1
  character(len=10) :: str="geracao XX"
  real :: tempo, operacoes
!$ integer :: omp_get_max_threads

!$  write(*,"(/,'***execucao com ',i1,' threads***',/)") omp_get_max_threads()

  write(*,"('   tamanho       tempo')")

  ! faz para diversos tamanhos

  do nPot = nPotMin, nPotMax
     n = 2**nPot


     ! aloca e inicializa dois tabuleiros
     ! tabuleiro tabulIn contem um veleiro

     allocate(tabulIn(0:n+1,0:n+1))
     allocate(tabulOut(0:n+1,0:n+1))
     call InitTabuleiros(n, tabulIn, tabulOut)

     ! mede tempo
     
     call system_clock(count_ini, count_rate, count_max)
     
     ! todas as geracoes para um veleiro
     
     do i = 1, 2*(n-3)

        ! geracao impar
        
        call UmaVida(n, tabulIn, tabulOut)
        
        ! geracao par

        call UmaVida(n, tabulOut, tabulIn)

     end do

     ! mede tempo
     
     call system_clock(count_end)
     tempo = real(count_end-count_ini)/real(count_rate)

     ! imprime tempo sse resultado correto

     if (Correto(n, tabulIn)) then
        write(*,"(i10,2x,f10.5)") n, tempo
     else
        write(*,"(' Resultado errado ')")
        exit
     end if

     ! destroi tabuleiros

     deallocate(tabulIn, tabulOut)
  end do
end program TempoExec
