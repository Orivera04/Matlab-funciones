# TASKING EDE (Windows based integrated Embedded Development Environment)
#
# This makefile has been generated by TASKING EDE
#
# Toolchain: TASKING Tools for C166/ST10 v8.0 r2
#

PROJ    = pc167cs
PROJDIR = d:\aetargets\matlab\toolbox\rtw\targets\c166\tasking\make\phycore_c167cs_v80
PRODDIR = d:\applications\c166_80r2

BINDIR  = $(PRODDIR)\bin
INCDIR  = $(PRODDIR)\include
LIBDIR  = $(PRODDIR)\lib

CC166BIN = $(PRODDIR)\bin
	export CC166BIN

OPT_CC  = -Ms -Wcp-D_USMLIB=  -Wcp-I"$(PRODDIR)\include" -Wc-I"$(PRODDIR)\include" -Wc-xmifp -DCPUTYPE=0x167 -Wc-Bhoeufmknladij         -Wc-OB -Wc-OE -Wc-zswitch_tabmem_default -Wc-zautobitastruct-4 -Wc-zautobita-0 -FSC -noc++ -Wc-A1 -Wc-zvolatile_union -Wc-O1 -Wc-g -Wc-newerr -Wc-s -tmp "-WaPR($*.lst)" -WaPL(60) -WaPW(120) -WaTA(8) -WaWA(1) -WaEXTEND -WaNOM166 -WaSN(reg167cs.def)
OPT_MPP = DEF(_EXT,1) DEF(_EXT2,0) DEF(_EXT22,0) DEF(_EXTMAC,0) DEF(MODEL,SMALL) DEF(_USRSTACK,0) DEF(_SINGLE_FP,0) WA(1) INC('$(PRODDIR)\include')
OPT_LC  = -trap -libfmtiol PRINT("$*.map") -Ms -xmifp -Bhoeufmknladij  -cf "_pc167cs.ilo"
OPT_OPIHEX = -l32
OPT_XVW = -G "." -tcfg "d:\aetargets\matlab\toolbox\rtw\targets\c166\tasking\make\phycore_c167cs_v80\_pc167cs.cfg" -D RS232,COM1:,19200 --single_instance -i --load_application_download=true --enable_flash=true --load_application_signal=true --load_application_program_reset=true --load_application_target_reset=true --load_application_goto_main=true --load_application_break_on_exit=true -a 100 -b 200 -s 26

all : $(PROJ).abs $(PROJ).hex

main.obj : main.c

ifdef CPREPROCESS
		@echo Preprocessing ${*F}.c
		@$(PRODDIR)\bin\cc166.exe -E -o "$*.i" main.c -f <<EOF
		${separate "\n" $(OPT_CC) }
		EOF
endif

		@echo Compiling and assembling ${*F}.c
		@$(PRODDIR)\bin\cc166.exe -f <<EOF -c main.c
		${separate "\n" -o $@ $(OPT_CC) }
		EOF

start.src : start.asm $(PRODDIR)\include\head.asm $(PRODDIR)\include\_c_init.asm
	@echo Preprocessing ${*F}.asm
		@$(PRODDIR)\bin\m166.exe start.asm to $@ -f <<EOF
		${separate "\n" $(OPT_MPP) }
		EOF

start.obj : start.src
	@echo Assembling ${*F}.src
		@$(PRODDIR)\bin\cc166.exe -f <<EOF -c start.src
		${separate "\n" -o $@ $(OPT_CC) }
		EOF

$(PROJ).out : main.obj start.obj _pc167cs.ilo
	@echo Linking and locating to ${*F}.out
		@$(PRODDIR)\bin\cc166.exe $(LINKCPP) -o $@ -f <<EOF 
		${separate "\n" $(match .obj $!) $(match .lno $!) $(match .lib $!) $(OPT_LC)}
		EOF

$(PROJ).abs : $(PROJ).out
	@echo Converting ${*F}.out to ${*F}.abs in IEEE-695 format
		@$(PRODDIR)\bin\ieee166.exe  $! $@

$(PROJ).hex : $(PROJ).out
	@echo Converting ${*F}.out to ${*F}.hex in Intel Hex format
		@$(PRODDIR)\bin\ihex166.exe $(OPT_OPIHEX) $! $@

clean :
	$(exist main.obj del main.obj)
	$(exist start.src del start.src)
	$(exist start.obj del start.obj)
	$(exist $(PROJ).out del $(PROJ).out)
	$(exist $(PROJ).abs del $(PROJ).abs)
	$(exist $(PROJ).hex del $(PROJ).hex)

# Copyright 1997-2003 Altium BV
# Serial#:	093051
# EDE Version:	3.4r1 (Build 119)
