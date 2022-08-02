/*
 * File: main.c
 *
 * Abstract:
 *    Main program for MPC555 auto_flash program.
 *
 *    This program will be linked with the file srec_c.c and
 *    srec_c.h. srec_c.* containing the compressed data which
 *    is to be flashed to the CMF array. See the makefile
 *    for more details on this process.
 *    
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:24:16 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include <stdlib.h>

/* ------------------ INCLUDES --------------------------*/
/* MPC555 register mappings */
#include "mpc5xx.h"
/* CMF Flash Drivers */
#include "flash_driver.h"
/* Functions for decoding the compressed data */
#include "huff_decode.h"
/* Automatically generated along with srec_c.c. These
 * two files contain the compressed data to be written
 * to flash */
#include "srec_c.h" 


/* Callback for decoded symbols */
int callback( unsigned char symbol, int idx, void * userdata );

/* Allows the debugger to see the FLASH_DRIVER */
volatile FlashProgrammerDiagonistics * FLASH_DIAGNOSTICS_PTR = &FLASH_DIAGNOSTICS; 

unsigned char * address;
SRecord * rec;

UINT8 main( void ) { 

   int i;

   /* return value of the decoder */
   int success = 1;


   /* Initialize the CMF Array for download */
   FLASH_DRIVER.initialize(0,(unsigned char * ) 0,1,1);

   /* Process all the records and write them out to flash */
   for (i = 0;i<NUMBER_OF_RECORDS;i++){
      rec = &srecord[i];
		success = decode_huffman_data(
				state_table,		/* The state transition table */
				symbol_decode,		/* The symbol decode table */
				(unsigned char * ) rec->data,			/* The compressed data */
				rec->count,			/* The length of the compressed data */
				callback,			/* A callback for symbol decoding */
				NULL);				/* No userdata required */
      if (!success){
         break;
      }
   }

   if ( success ){
      /* Finish the flash write process */
      FLASH_DRIVER.flush();
   }else{
      /* FLASH PROGRAMMING FAILED
       *
       * The contents of the below variable is a pointer to a struct of 
       *
		 * typedef struct {
		 *   char * driverSpecificIdentification;
		 *   unsigned int driverSpecificErrorCode;
		 *   char * driverSpecificErrorMessage;
		 * } FlashProgrammerDiagonistics;
       *
       * You can report the error code to Mathworks technical support to 
       * find out why your flash driver has failed. Before reporting a fault
       * check these common problems.
       *
       * Is your MPC555 development board using a different crystal to the
       * 20Mhz crystal used in the default Embedded Target For MPC555 library. 
       * If so then read the user documentation on how to configure the tool
       * for non default hardware.
       *
       * Is the flash programming voltage set. On the Phytec development board
       * JP4 must be closed to flash programming to work.
       */

       /* FLASH FAILED */ *FLASH_DIAGNOSTICS_PTR; /* FLASH FAILED */
   }

   return 0;
}


int callback( unsigned char symbol, int idx, void * userdata ){
      /* The return status of the flash driver */
      int flashstatus;

		/* Program the decoded symbol to flash */
      flashstatus = FLASH_DRIVER.program(((unsigned char *) (rec->address)) + idx,
            &symbol,
            1, 1 );

      if ( flashstatus == FLASH_PROGRAMMING_OK ){
         return 1;
      }else{
         return 0;
      }
}




