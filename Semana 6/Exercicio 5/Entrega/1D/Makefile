COMP=-c

CC=cc
CCFLAGS= -lm
CCLOAD= $(CCFLAGS)

EXEC1=	Tempo
EXEC2=	Funciona

OBJ=\
	ModVida.o

OBJ1= 	wall_time.o\
	TempoExec.o

OBJ2=	Funcionamento.o

all:	$(EXEC1) $(EXEC2)
	
$(EXEC1):	$(OBJ) $(OBJ1)
	$(CC) -o $(EXEC1) $(CCLOAD) $(OBJ) $(OBJ1)

$(EXEC2):	$(OBJ) $(OBJ2)
	$(CC) -o $(EXEC2) $(CCLOAD) $(OBJ) $(OBJ2)
clean:
	rm -f *.o *.mod $(EXEC1) $(EXEC2)

.SUFFIXES	:	.o .c

.c.o:
	$(CC) $(COMP) $(CCFLAGS) $*.c 



