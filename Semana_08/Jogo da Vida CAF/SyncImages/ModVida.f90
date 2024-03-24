module JogoDaVida
  implicit none
contains


  ! UmaVida: Executa uma iteracao do Jogo da Vida
  !          em tabuleiros de tamanho tam. Produz o tabuleiro
  !          de saida tabulOut a partir do tabuleiro de entrada
  !          tabulIn. Os tabuleiros tem tam-1 x tam-1 celulas
  !          internas vivas ou mortas. O tabuleiro eh orlado 
  !          por celulas eternamente mortas.


  subroutine UmaVida (MaxImages, nImages, myId, tabulIn, tabulOut)
    integer, intent(in ) :: MaxImages
    integer, intent(in ) :: nImages
    integer, intent(in ) :: myId
    logical, intent(in ) :: tabulIn(0:MaxImages+1,0:2)[*]
    logical, intent(out) :: tabulOut(0:MaxImages+1,0:2)[*]
    !*** O RESTANTE DESTE PROCEDIMENTO JA FOI CONVERTIDO PARA CAF!!!!!!!!!!!!!!
    integer :: i
    integer :: j
    integer :: vizviv

    ! percorre o tabuleiro determinando o proximo
    ! estado de cada celula e grava no gost zone da 
	! proxima imagem

       j = 1 !verifica coluna do centro
	do i = 1, nImages !Tamanho adotado
          ! quantos vizinhos vivos localmente

          vizviv = count( (/&
               tabulIn(i-1,j-1), tabulIn(i-1,j), tabulIn(i-1,j+1), &
               tabulIn(i  ,j-1),                 tabulIn(i  ,j+1), &
               tabulIn(i+1,j-1), tabulIn(i+1,j), tabulIn(i+1,j+1) /) )

         ! impoe regra do proximo estado para as imagens menos a ultima
		if (myId < nImages) then
			if (tabulIn(i,j) .and. vizviv < 2) then
				tabulOut(i,j) = .false. !grava estado localmente
				tabulOut(i,j-1)[myId+1] = .false. !grava na gost zone correspondente
			else if (tabulIn(i,j) .and. vizviv > 3) then
				tabulOut(i,j) = .false. !grava estado localmente
				tabulOut(i,j-1)[myId+1] = .false. !grava na gost zone correspondente
			else if (.not. tabulIn(i,j) .and. vizviv == 3) then
				tabulOut(i,j) = .true. !grava estado localmente
				tabulOut(i,j-1)[myId+1] = .true. !grava na gost zone correspondente
			else
				tabulOut(i,j) = tabulIn(i,j) !grava estado localmente
				tabulOut(i,j-1)[myId+1] = tabulIn(i,j) !grava na gost zone correspondente

			end if
		sync images(myId+1) !Sincronização com seu proximo
		end if
	     ! impoe regra do proximo estado para imagens menos a primeira
		if (myId > 1) then
			if (tabulIn(i,j) .and. vizviv < 2) then
				tabulOut(i,j) = .false. !grava estado localmente
				tabulOut(i,j+1)[myId-1] = .false. !grava na gost zone correspondente
			else if (tabulIn(i,j) .and. vizviv > 3) then
				tabulOut(i,j) = .false. !grava estado localmente
				tabulOut(i,j+1)[myId-1] = .false. !grava na gost zone correspondente
			else if (.not. tabulIn(i,j) .and. vizviv == 3) then
				tabulOut(i,j) = .true. !grava estado localmente
				tabulOut(i,j+1)[myId-1] = .true. !grava na gost zone correspondente
			else
				tabulOut(i,j) = tabulIn(i,j) !grava estado localmente
				tabulOut(i,j+1)[myId-1] = tabulIn(i,j) !grava na gost zone correspondente
			end if
		sync images(myId-1) !Sincronização com seu anterior
		end if
    end do
	
  end subroutine UmaVida


  ! DumpTabuleiro: Imagem 1 imprime todo o tabuleiro
  !                X representa celula viva
  !                . representa celula morta


  subroutine DumpTabuleiro(MaxImages, nImages, &
       myId, firstGlobalCol, lastGlobalCol, &
       tabul, str)
    integer, intent(in) :: MaxImages
    integer, intent(in) :: nImages
    integer, intent(in) :: myId
    integer, intent(in) :: firstGlobalCol
    integer, intent(in) :: lastGlobalCol
    logical, intent(in) :: tabul(0:MaxImages+1,0:2)[*]
    character(len=*), optional, intent(in) :: str

    integer :: i
    integer :: j
    character :: linha(nImages)

    if (myId == 1) then
       write (*,"(a)", advance="no") "**(DumpTabuleiro)**"
       if (present(str)) then
          write(*, "(a)") trim(str)
       else
          write(*, "(a)") " "
       end if
       
       write(*,"('  ===========================')")

       do i = 1, nImages
          do j = 1, nImages
             if (tabul(i,1)[j]) then
                linha(j) = "X"
             else
                linha(j) = "."
             end if
          end do
          write(*,"(2x,100a1)") linha
       end do

       write(*,"('  ===========================')")

    end if
	
  end subroutine DumpTabuleiro



  ! InitTabuleiros: Inicializa dois tabuleiros:
  !                tabulIn com um veleiro 
  !                tabulOut com celulas mortas



  subroutine InitTabuleiros(MaxImages, nImages, &
       firstGlobalCol, lastGlobalCol, &
       tabulIn, tabulOut)
    integer, intent(in ) :: MaxImages
    integer, intent(in ) :: nImages
    integer, intent(in ) :: firstGlobalCol
    integer, intent(in ) :: lastGlobalCol
    logical, intent(out) :: tabulIn(0:MaxImages+1,0:2)[*]
    logical, intent(out) :: tabulOut(0:MaxImages+1,0:2)[*]
    integer :: globalCol      ! numero de coluna no conjunto das imagens
    integer :: localCol       ! numero de coluna nesta imagem

    ! inicializa os dois tabuleiros

    tabulIn = .false.
    tabulOut = .false.

    ! inicializa veleiro nas tres primeiras colunas globais

    do globalCol = 1, 3
       if (firstGlobalCol <= globalCol .and. lastGlobalCol >= globalCol) then
          localCol = globalCol - firstGlobalCol 
          select case (globalCol)
          case (1)
             tabulIn(3,localCol)=.true.
          case (2)
             tabulIn(1,localCol)=.true.
             tabulIn(3,localCol)=.true.
          case (3)
             tabulIn(2,localCol)=.true.
             tabulIn(3,localCol)=.true.
          end select
       end if
    end do

    ! sincroniza as imagens para garantir inicializacao

    sync all

  end subroutine InitTabuleiros


  ! Correto: verifica se o veleiro estah corretamente
  !          representado no canto inferior direito do
  !          tabuleiro, onde deve estar na ultima iteracao


  logical function Correto (MaxImages, nImages, &
       myId, firstGlobalCol, lastGlobalCol, &
       tabul)
    integer, intent(in ) :: MaxImages
    integer, intent(in ) :: nImages
    integer, intent(in ) :: myId
    integer, intent(in ) :: firstGlobalCol
    integer, intent(in ) :: lastGlobalCol
    logical, intent(in ) :: tabul(0:MaxImages+1,0:2)[*]

    integer :: globalCol, localCol   ! coluna global e local
    integer :: quantosVerdadeiros    ! em uma coluna
    integer :: image
    logical, save :: corretoLocal[*] ! correto em cada imagem

    do localCol = 0, 2

       globalCol = localCol + firstGlobalCol

       quantosVerdadeiros = count(tabul(:,localCol))

       if (globalCol == nImages - 2) then     
          ! verifica tabul(n,n-2)
          corretoLocal = &
               quantosVerdadeiros == 1   .and. &
               tabul(nImages,localCol)

       else if (globalCol == nImages - 1) then
          ! verifica tabul(n-2,n-1) e tabul(n,n-1)
          corretoLocal = &
               quantosVerdadeiros == 2   .and. &
               tabul(nImages-2,localCol) .and. &
               tabul(nImages,localCol)

       else if (globalCol == nImages) then
          ! verifica tabul(n-1,n) e tabul(n,n)
          corretoLocal = &
               quantosVerdadeiros == 2   .and. &
               tabul(nImages-1,localCol) .and. &
               tabul(nImages,localCol)

       else
          corretoLocal = &
               quantosVerdadeiros == 0
       end if

       ! desiste se alguma coluna incorreta

       if (.not. corretoLocal) exit
    end do

    ! espera outras imagens e atualiza memoria

    sync all

    ! reducao global

    Correto = .true.
    do image = 1, nImages
       Correto = Correto .and. corretoLocal[image]
    end do
  end function Correto
end module JogoDaVida
