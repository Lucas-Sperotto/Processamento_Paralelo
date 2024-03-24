COMP=-c

F90=ftn
F90FLAGS=-h caf
F90LOAD= $(F90FLAGS)

EXEC=Vida.exe

OBJ=    Funcionamento.o \
	ModVida.o 


$(EXEC):	$(OBJ)
	$(F90) -o $(EXEC) $(F90LOAD) $(OBJ)

ModVida.o:	ModVida.f90
Funcionamento.o:	Funcionamento.f90 ModVida.o


clean:
	rm -f *.o *.mod $(EXEC) 


.SUFFIXES	:	.o .f90

.f90.o:
	$(F90) $(COMP) $(F90FLAGS) $*.f90



