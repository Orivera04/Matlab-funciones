/* $Revision: 1.1 $ */
//
//      TMDX ALPHA RELEASE
//      Intended for product evaluation purposes
//
//###########################################################################
//
// FILE:	DSP28_GlobalVariableDefs.c
//
// TITLE:	DSP28 Global Variables and Data Section Pragmas.
//
//###########################################################################
//
//  Ver | dd mmm yyyy | Who  | Description of changes
// =====|=============|======|===============================================
//  0.55| 06 May 2002 | L.H. | EzDSP Alpha Release
//  0.56| 21 May 2002 | L.H. | Corrected case typo - PIE -> Pie
//  0.57| 27 May 2002 | L.H. | No change
//  0.58| 29 Jun 2002 | L.H. | Changed PieCtrl to PieCtrlRegs for consistancy 
//###########################################################################



//---------------------------------------------------------------------------
// Define Global Peripheral Variables:
//

#include "DSP24_Device.h"

volatile unsigned int *MMREGS = 0x0000;      /* LF2407EVM Memory/Register Pointer */








