program funcionamento
  use JogoDaVida
  implicit none
  integer :: i
  integer, parameter :: MaxImages=16
  logical :: tabulIn (0:MaxImages+1,0:2)[*]
  logical :: tabulOut(0:MaxImages+1,0:2)[*]
  character(len=10) :: str="geracao XX"
  integer :: nImages
  integer :: myId
  integer :: firstGlobalCol
  integer :: lastGlobalCol

  ! quantas imagens e quem eu sou

  nImages = num_images()
  myId = this_image()

  ! numero minimo de imagens para um veleiro

  if (nImages < 3) then
     if (myId == 1) then
        write(*,"(a)") "**(ERRO)** numero minimo de imagens eh 3"
     end if
     stop
  else if (nImages > MaxImages) then
     if (myId == 1) then
        write(*,"(a,i2)") "**(ERRO)** numero maximo de imagens eh ",MaxImages
     end if
     stop
  end if

  ! uma coluna por imagem; inclui ghost zone

  firstGlobalCol = myId-1
  lastGlobalCol = myId+1

  ! inicializa dois tabuleiros
  ! tabuleiro tabulIn contem um veleiro

  call InitTabuleiros(MaxImages, nImages, &
       firstGlobalCol, lastGlobalCol, &
       tabulIn, tabulOut)

  ! dump estado inicial

 call DumpTabuleiro(MaxImages, nImages, &
      myId, firstGlobalCol, lastGlobalCol, &
      tabulIn, " estado inicial ")


  ! todas as geracoes para um veleiro

  do i = 1, 2*(nImages-3)

     ! geracao impar

     call UmaVida(MaxImages, nImages, myId, tabulIn, tabulOut)

     ! dump geracao

    !!$ write(str(9:10), "(i2.2)") 2*i-1
    !!$ call DumpTabuleiro(MaxImages, nImages, &
    !!$      myId, firstGlobalCol, lastGlobalCol, &
    !!$      tabulOut, str)

     ! geracao par

     call UmaVida(MaxImages, nImages, myId, tabulOut, tabulIn)

     ! dump geracao

    !!$write(str(9:10), "(i2.2)") 2*i
	!!$ call DumpTabuleiro(MaxImages, nImages, &
    !!$     myId, firstGlobalCol, lastGlobalCol, &
    !!$     tabulIn, str)
 
  end do

  ! dump estado final

  call DumpTabuleiro(MaxImages, nImages, &
       myId, firstGlobalCol, lastGlobalCol, &
       tabulIn, " estado final ")

  ! verifica correcao

  if (Correto (MaxImages, nImages, &
       myId, firstGlobalCol, lastGlobalCol, &
       tabulIn)) then
     if (myId == 1) then
        write(*,"(' Resultado correto com ',i2,' imagens')") nImages
     end if
  else if (myId == 1) then
     write(*,"(' Resultado errado com ',i2,' imagens ')") nImages
  end if

end program funcionamento
