COMP=-c

CC=mpicc
CCFLAGS=
CCLOAD= $(CCFLAGS)

EXEC=Pi

OBJ= 	wall_time.o\
	SeqPi.o

$(EXEC):	$(OBJ)
	$(CC) -o $(EXEC) $(CCLOAD) $(OBJ)

clean:
	rm -f *.o $(EXEC)


.SUFFIXES	:	.o .c

.c.o:
	$(CC) $(COMP) $(CCFLAGS) $*.c 



