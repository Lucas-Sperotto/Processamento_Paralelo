COMP=-c

CC=cc
CCFLAGS=-mp 
CCLOAD= $(CCFLAGS)

EXEC=SparseMatrix

OBJ= 	wall_time.o\
	SparseMatrix.o

$(EXEC):	$(OBJ)
	$(CC) -o $(EXEC) $(CCLOAD) $(OBJ)

clean:
	rm -f *.o $(EXEC)


.SUFFIXES	:	.o .c

.c.o:
	$(CC) $(COMP) $(CCFLAGS) $*.c 



