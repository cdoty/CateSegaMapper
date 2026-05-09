# Set the name of the output ROM.
name		= Test

# Set the output file extension. Some emulators look for specific extension.
extension	= sms

# Set the console type, based on the directories in tms9918lib.
console		= SMS

# Set the output rom size
romSize		= 131072

# Set the ROM and RAM start addresses
bank0seg	= 7FF0-7FFF,0000-7FEF
cseg		= 8000-BFFF
dseg	 	= C000-DFFF

# Set comment settings
mameSystem	= sms
cpuTag		= :maincpu

# Set the tools path.
TOOLS_PATH	= ../Tools

# Set the CATE compiler path. Bin and lib are expected to exist inside the directory.
CATE_PATH	= $(TOOLS_PATH)/Cate
BIN_PATH	= $(CATE_PATH)/bin
LIB_PATH	= $(CATE_PATH)/lib

# CATE/ASM8/Lib compile ID. (ie CATEXX.exe)
compileType	= 80

# Customize the processor type.
SystemC_S	= SystemLib/$(console)/crt0/C/Header.s
SystemC_S	+= SystemLib/$(console)/crt0/C/Cart.s
SystemC_S	+= $(wildcard System/C/*.s)

SharedC_S	= SystemLib/Z80/Decompression/C/aplib-z80.s
SharedC_S	+= $(wildcard SystemLib/$(console)/C/*.s)
SharedC_S	+= $(wildcard SystemLib/$(console)/Bank/C/*.s)
SharedC_S	+= $(wildcard SystemLib/$(console)/Graphics/C/*.s)
SharedC_S	+= $(wildcard SystemLib/$(console)/Sound/SN76489/C/*.s)
SharedC_S	+= $(wildcard SystemLib/$(console)/Sprites/C/*.s)
SharedC_S	+= $(wildcard SystemLib/Z80/Shared/C/*.s)

SystemZ_S	= SystemLib/$(console)/crt0/Z/Header.s
SystemZ_S	+= SystemLib/$(console)/crt0/Z/Cart.s
SystemZ_S	+= $(wildcard System/Z/*.s)

SharedZ_S	= SystemLib/Z80/Decompression/Z/aplib-z80.s
SharedZ_S	+= $(wildcard SystemLib/$(console)/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/$(console)/Bank/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/$(console)/Graphics/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/$(console)/Sound/SN76489/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/$(console)/Sprites/Z/*.s)
SharedZ_S	+= $(wildcard SystemLib/Z80/Shared/Z/*.s)

Bank1_C		= $(wildcard Bank1/*.c)
Bank1_ASM	= Bank1/BankTable.asm

Bank2_C		= $(wildcard Bank2/*.c)
Bank2_ASM	= Bank2/BankTable.asm

Bank3_C		= $(wildcard Bank3/*.c)
Bank3_ASM	= Bank3/BankTable.asm

Bank0_Obj 	= $(SystemC_S:.s=.obj)
Bank0_Obj 	+= $(SharedC_S:.s=.obj)

Bank1_Obj 	= $(SystemZ_S:.s=.obj)
Bank1_Obj 	+= $(SharedZ_S:.s=.obj)
Bank1_Obj	+= $(Bank1_ASM:.asm=.obj)
Bank1_Obj	+= $(Bank1_C:.c=.obj)

Bank2_Obj 	= $(SystemZ_S:.s=.obj)
Bank2_Obj 	+= $(SharedZ_S:.s=.obj)
Bank2_Obj	+= $(Bank2_ASM:.asm=.obj)
Bank2_Obj	+= $(Bank2_C:.c=.obj)

Bank3_Obj 	= $(SystemZ_S:.s=.obj)
Bank3_Obj 	+= $(SharedZ_S:.s=.obj)
Bank3_Obj	+= $(Bank3_ASM:.asm=.obj)
Bank3_Obj	+= $(Bank3_C:.c=.obj)

bankObjects	= $(Bank0_Obj)
bankObjects	+= $(Bank1_Obj)
bankObjects	+= $(Bank2_Obj)
bankObjects	+= $(Bank3_Obj)

#graphics 	= $(Graphics_S:.s=.obj)

libs 		= $(LIB_PATH)/cate$(compileType).lib

lists 		= $(SystemC_S:.s=.lst)
lists 		+= $(SharedC_S:.s=.lst)
lists 		+= $(SystemZ_S:.s=.lst)
lists 		+= $(SharedZ_S:.s=.lst)
lists 		+= $(Bank1_C:.c=.lst)
lists 		+= $(Bank1_ASM:.asm=.lst)
lists 		+= $(Bank2_C:.c=.lst)
lists 		+= $(Bank2_ASM:.asm=.lst)
lists 		+= $(Bank3_C:.c=.lst)
lists 		+= $(Bank3_ASM:.asm=.lst)

all: $(name).$(extension)

$(name).$(extension): Bank00.bin Bank01.bin Bank02.bin Bank03.bin makefile
	copy /Y /B Bank*.bin $@
	$(TOOLS_PATH)/PadFile 255 $(romSize) $(name).$(extension)
	$(TOOLS_PATH)/MSChecksumFixer $(name).$(extension)
	$(TOOLS_PATH)/CreateComments $(mameSystem) $(cpuTag) Bank00.symbols.txt $(name).$(extension) ../../mame/comments
	$(TOOLS_PATH)/CreateSym Bank00.symbols.txt $(name).sym

Bank00.bin: $(Bank0_Obj)
	$(BIN_PATH)/LinkLE $@ $(bank0seg) $(dseg) $(Bank0_Obj)

Bank01.bin: $(Bank1_Obj) $(libs)
	$(BIN_PATH)/LinkLE $@ $(cseg) $(dseg) $(bank0seg) $(Bank1_Obj) $(libs)

Bank02.bin: $(Bank2_Obj) $(libs)
	$(BIN_PATH)/LinkLE $@ $(cseg) $(dseg) $(bank0seg) $(Bank2_Obj) $(libs)

Bank03.bin: $(Bank3_Obj) $(libs)
	$(BIN_PATH)/LinkLE $@ $(cseg) $(dseg) $(bank0seg) $(Bank3_Obj) $(libs)

clean:
	rm -f $(bankObjects)
	rm -f $(graphics)
	rm -f $(lists)
	rm -f $(name).$(extension)
	rm -f $(name).sym
	rm -f Bank*.bin
	rm -f Bank*.symbols.txt

depend:
	makedepend -fmakefile $(Bank1_C) $(Bank2_C) $(Bank3_C) 
	rm makefile.bak

%.asm: %.c
	$(BIN_PATH)/Cate$(compileType) $<

%.obj: %.asm
	$(BIN_PATH)/Asm$(compileType) -v2 $<
	
%.obj: %.s
	$(BIN_PATH)/Asm$(compileType) -v2 $<
# DO NOT DELETE

Bank1/Bank.obj: SystemLib/Include/Bank.h
Bank2/GameOver.obj: SystemLib/Include/Graphics.h
Bank2/Title.obj: SystemLib/Include/Graphics.h
Bank3/Bank.obj: Bank3/Game.h SystemLib/Include/Graphics.h
Bank3/Bank.obj: SystemLib/Include/Bank.h
