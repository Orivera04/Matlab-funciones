#**************************************************************************
#* FILE NAME: makefile                        COPYRIGHT (c) MOTOROLA 2002 *
#* VERSION: 1.2                                                           *
#*                                                                        *
#* DESCRIPTION: This is the makefile for the MPC5xx header example files. *
#*========================================================================*
#* MAKE: GNU make        VERSION: 3.79.1                                  *
#* AUTHOR: Jeff Loeliger                                                  *
#*                                                                        *
#* HISTORY                                                                *
#* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  *
#* ---   -----------  ---------    ---------------------                  *
#* 1.0   J. Loeliger  19/Jan/99    Initial version of file.               *
#* 1.1   J. Loeliger  03/Oct/00    Fixed several typos.                   *
#* 1.2   J. Loeliger  19/Apr/02    Merge all MPC5xx files together.       *
#**************************************************************************

CC = dcc
AS = das
LD = dld 
CFLAGS = -tPPC555EH -g3 -c
ASFLAGS = -tPPC555EH 
LDFLAGS = -tPPC555EH mpc500.dld -m2
LIBS = -li -lchar

OBJS = crt0m500.o 

all: samp555.elf samp561.elf samp563.elf samp565.elf

samp555.elf : samp555.o $(OBJS) makefile mpc500.dld
	$(LD) $(LDFLAGS) $(OBJS) samp555.o $(LIBS) -o ${@F} > mem555.map

samp555.o : samp555.c mpc555.h makefile
	$(CC) $(CFLAGS) $< -o $@

samp561.elf : samp561.o $(OBJS) makefile mpc500.dld
	$(LD) $(LDFLAGS) $(OBJS) samp561.o $(LIBS) -o ${@F} > mem561.map

samp561.o : samp561.c mpc561.h makefile
	$(CC) $(CFLAGS) $< -o $@

samp563.elf : samp563.o $(OBJS) makefile mpc500.dld
	$(LD) $(LDFLAGS) $(OBJS) samp563.o $(LIBS) -o ${@F} > mem563.map

samp563.o : samp563.c mpc563.h makefile
	$(CC) $(CFLAGS) $< -o $@

samp565.elf : samp565.o $(OBJS) makefile mpc500.dld
	$(LD) $(LDFLAGS) $(OBJS) samp565.o $(LIBS) -o ${@F} > mem565.map

samp565.o : samp565.c mpc565.h makefile
	$(CC) $(CFLAGS) $< -o $@

crt0m500.o : crt0m500.s makefile
	$(AS) $(ASFLAGS) $< 

ex_funcs.o : ex_funcs.c m_common.h makefile
	$(CC) $(CFLAGS) -Xnested-interrupts $< -o $@


mpc565.h : m_common.h m_flash.h m_mios.h m_qadc64.h m_qsmcm.h \
           m_sram.h m_toucan.h m_tpu3.h m_usiu.h makefile

# Dummy targets needed by some versions of make
makefile :

clean:
	del *.o *.elf *.map
	del *.ou1 *.db *.db2 *.blk
	del *.?~ a.out



