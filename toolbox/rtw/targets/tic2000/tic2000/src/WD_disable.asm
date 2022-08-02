; $Revision: 1.1 $
***********************************************************************
* File: WD_disable.asm
* Devices: TMS320LF240x/xA
***********************************************************************
    .def wd_disable
    .ref _c_int0

WDCR            .set 7029h              ;WD timer control reg
DP_PF1          .set 224                ;sys regs, WD, SPI, SCI, (0x7000 - 0x707F)


***********************************************************************
* Function: wd_disable
*
* Description: Disables the watchdog timer
***********************************************************************
	.text
wd_disable:
        LDP     #DP_PF1         ;set data page
        SPLK    #11101000b, WDCR
;                ||||||||
;                76543210
* bit 7         1:       clear WD flag
* bit 6         1:       disable the dog
* bit 5-3       101:     must be written as 101
* bit 2-0       000:     WDCLK divider = 1

	B _c_int0             ;Branch to start of boot.asm in RTS library

;end wd_disable
***********************************************************************

	.end                    ; end of file CodeStartBranch.asm
