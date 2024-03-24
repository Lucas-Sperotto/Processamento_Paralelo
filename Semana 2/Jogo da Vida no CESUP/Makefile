COMP=-c

F90=ifort
F90FLAGS=-openmp -openmp-report2 
F90LOAD= $(F90FLAGS)

EXEC1=Tempo
EXEC2=Funciona

OBJ=\
	ModVida.o 

OBJ1 = TempoExec.o
OBJ2 = Funcionamento.o

all:	$(EXEC1) $(EXEC2)


$(EXEC1):	$(OBJ) $(OBJ1)
	$(F90) -o $(EXEC1) $(F90LOAD) $(OBJ) $(OBJ1)


$(EXEC2):	$(OBJ) $(OBJ2)
	$(F90) -o $(EXEC2) $(F90LOAD) $(OBJ) $(OBJ2)

ModVida.o:	ModVida.f90
TempoExec.o:	TempoExec.f90 ModVida.o
Funcionamento.o:	Funcionamento.f90 ModVida.o


clean:
	rm -f *.o *.mod $(EXEC1) $(EXEC2)


.SUFFIXES	:	.o .f90 .c

.f90.o:
	$(F90) $(COMP) $(F90FLAGS) $*.f90

.c.o:
	$(CC) $(COMP) $(CCFLAGS) $*.c 



