// DO NOT DOWNLOAD, USE, COPY, MODIFY OR DISTRIBUTE THIS CODE OR ANY PORTIONS 
// THEREOF UNLESS YOU AGREE TO THE FOLLOWING:                                 
// This code is provided "AS IS" without warranty of any kind, to the full    
// extent permitted by law. You may copy, use modify and distribute the code  
// (including modifications) provided you agree to these terms and conditions,
// however you do so at your own risk and you agree to indemnify Metrowerks   
// for any claim resulting from your activities relating to the code. You must
// include all Metrowerks notices with the code. If you make any              
// modifications, you must identify yourself as co-author in the modified     
// code.                                                                      
// (C) Copyright. 2002 Metrowerks Corp. ALL RIGHTS RESERVED.                  
// 
// MC9S12DP256 erasing + unsecuring command file:
// These commands mass erase the chip then program the security byte to 0xFE (unsecured state).

FLASH MEMUNMAP   // do not interact with regular flash programming monitor

//mass erase flash
wb 0x100 0x49    // set FCLKDIV clock divider for a 16 MHz oscillator
wb 0x103 0       // FCFNG select block 0
wb 0x104 0xa4    // FPROT all protection disabled.
wb 0x105 0x30    // clear PVIOL and ACCERR in FSTAT register 
ww 0x9000 0xFFFF // (dummy) write to flash array to buffer address and data
wb 0x106 0x41    // write MASS ERASE command in FCMD register
wb 0x105 0xC0    // clear CBEIF in FSTAT register to execute the command 
wait 10

//mass erase eeprom
wb 0x12  0x01    // set EEPROM at 0-$1000 in INITEE
wb 0x110 0x49    // set ECLKDV clock divider for a 16 MHz oscillator
wb 0x114 0x88    // EPROT all protection disabled
wb 0x115 0x30    // clear PVIOL and ACCERR in ESTAT register 
ww 0x800 0xFFFF  // (dummy) write to eeprom array to buffer address and data
wb 0x116 0x41    // write MASS ERASE command in ECMD register
wb 0x115 0xC0    // clear CBEIF in ESTAT register to execute the command
wait 10

//reprogram Security byte to Unsecure state
wb 0x100 0x49    // set FCLKDIV clock divider for a 16 MHz oscillator
wb 0x103 0       // FCFNG select block 0 
wb 0x104 0xa4    // FPROT all protection disabled. 
wb 0x105 0x30    // clear PVIOL and ACCERR in FSTAT register  
ww 0xFF0E 0xFFFE // write security byte to "Unsecured" state
wb 0x106 0x20    // write MEMORY PROGRAM command in FCMD register
wb 0x105 0xC0    // clear CBEIF in FSTAT register to execute the command 
wait 10

reset

FLASH MEMMAP     // restore regular flash programming monitor


// Evaluate the clock divider to set in ECLKDIV/FCLKDIV registers:

// An average programming clock of 175 kHz is chosen.

// If the oscillator frequency is less than 10 MHz, the value to store
// in ECLKDIV/FCLKDIV is equal to " oscillator frequency (kHz) / 175 ".

// If the oscillator frequency is higher than 10 MHz, the value to store
// in ECLKDIV/FCLKDIV is equal to " oscillator frequency (kHz) / 1400  + 0x40 (to set PRDIV8 flag)".

// Datasheet proposed values:
//
// oscillator frequency     ECLKDIV/FCLKDIV value (hexadecimal)
// 
//  16 MHz            		$49
//   8 MHz            		$27
//   4 MHz            		$13
//   2 MHz             		$9
//   1 MHz             		$4


