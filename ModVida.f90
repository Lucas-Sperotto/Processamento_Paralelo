module JogoDaVida
  implicit none
contains


  ! UmaVida: Executa uma iteracao do Jogo da Vida
  !          em tabuleiros de tamanho tam. Produz o tabuleiro
  !          de saida tabulOut a partir do tabuleiro de entrada
  !          tabulIn. Os tabuleiros tem tam-1 x tam-1 celulas
  !          internas vivas ou mortas. O tabuleiro eh orlado 
  !          por celulas eternamente mortas.
  subroutine UmaVida (tam, tabulIn, tabulOut)
    integer, intent(in) :: tam
    logical, intent(in) :: tabulIn(0:tam + 1, 0:tam + 1)
    logical, intent(out) :: tabulOut(0:tam + 1, 0:tam + 1)

    integer :: i
    integer :: j
    integer :: vizviv

    ! percorre o tabuleiro determinando o proximo
    ! estado de cada celula
!$OMP PARALLEL DO FIRSTPRIVATE (i, j, vizviv)

    do j = 1, tam

       do i = 1, tam

          ! quantos vizinhos vivos

          vizviv = count( (/&
               tabulIn(i - 1, j - 1), tabulIn(i - 1, j), tabulIn(i - 1, j + 1), &
               tabulIn(i  , j - 1),                 tabulIn(i  ,j + 1), &
               tabulIn(i + 1, j - 1), tabulIn( i + 1, j), tabulIn( i + 1, j + 1) /) )

          ! impoe regra do proximo estado

          if (tabulIn(i, j) .and. vizviv < 2) then
             tabulOut(i, j) = .false.
          else if (tabulIn(i, j) .and. vizviv > 3) then
             tabulOut(i, j) = .false.
          else if (.not. tabulIn(i, j) .and. vizviv == 3) then
             tabulOut(i, j) = .true.
          else
             tabulOut(i, j) = tabulIn(i, j)
          end if
       end do

    end do
!$OMP END PARALLEL DO

  end subroutine UmaVida


  ! DumpTabuleiro: Imprime trecho do tabuleiro entre
  !                as posicoes (pri, pri) e (ult, ult)
  !                X representa celula viva
  !                . representa celula morta
  subroutine DumpTabuleiro(tam, tabul, pri, ult, str)
    integer, intent(in) :: pri, ult
    integer, intent(in) :: tam
    logical, intent(in) :: tabul(0:tam + 1, 0:tam + 1)
    character(len=*), optional, intent(in) :: str

    integer :: i
    integer :: j
    character :: linha(pri:ult)

    if (present(str)) then
       write(*, "(2x,a,i3,':',i3)") trim(str)//" dump das posicoes", pri, ult
    else
       write(*, "(2x,a,i3,':',i3)") " dump das posicoes", pri, ult
    end if

    write(*,"('  ===========================')")

    do i = pri, ult
       do j = pri, ult
          if (tabul(i, j)) then
             linha(j) = "X"
          else
             linha(j) = "."
          end if
       end do
       write(*,"(2x,100a1)") linha
    end do

    write(*,"('  ===========================')")

  end subroutine DumpTabuleiro


  ! InitTabuleiros: Inicializa dois tabuleiros:
  !                tabulIn com um veleiro 
  !                tabulOut com celulas mortas
  subroutine InitTabuleiros(tam, tabulIn, tabulOut)
    integer, intent(in) :: tam
    logical, intent(out) :: tabulIn(0:tam + 1, 0:tam + 1)
    logical, intent(out) :: tabulOut(0:tam + 1, 0:tam + 1)

    tabulIn = .false.
    tabulOut = .false.

    tabulIn(1, 2) = .true.
    tabulIn(2, 3) = .true.
    tabulIn(3, 1) = .true.
    tabulIn(3, 2) = .true.
    tabulIn(3, 3) = .true.
  end subroutine InitTabuleiros


  ! Correto: verifica se o veleiro estah corretamente
  !          representado no canto inferior direito do
  !          tabuleiro, onde deve estar na ultima iteracao
  logical function Correto (tam, tabulIn)
    integer, intent(in) :: tam
    logical, intent(in) :: tabulIn(0:tam + 1, 0:tam + 1)

    integer :: quantosVerdadeiros

    quantosVerdadeiros = count(TabulIn)

    Correto = (quantosVerdadeiros == 5) .and. &
         tabulIn(tam - 2, tam - 1) .and. &
         tabulIn(tam - 1, tam) .and. &
         tabulIn(tam, tam - 2) .and. &
         tabulIn(tam, tam - 1) .and. &
         tabulIn(tam, tam)
  end function Correto
end module JogoDaVida
