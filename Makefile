ASFLAGS= -f elf32 -g dwarf2


all:
	make clean
	make med

clean:
	rm -f *.o
	rm -f med 2


med:
	yasm $(ASFLAGS) -o med.o med.asm
	ld -o med med.o


