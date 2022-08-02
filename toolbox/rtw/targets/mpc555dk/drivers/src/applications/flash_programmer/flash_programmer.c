/*
 * File: main.c
 *
 * Abstract:
*    Main program for MPC555 bootloader
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:11 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include <stdlib.h>
#include "mpc5xx.h"
#include "simple_can_driver.h"
#include "ccp_target.h"
#include "serial_boot.h"
#include "ccp_network.h"
#include "ccp_boot_data.h"
#include "flash_driver.h"

#define DEFAULT_CCP_CRO_ID 0x6FA
#define DEFAULT_CCP_DTO_ID 0x6FB

/* Global Variables 
 *
 * Function pointers to functions that 
 * can transmit and receive CCP messages
 *
 * These can be set once the transport layer
 * has been selected */
RECEIVE_CCP_MESSAGE RxCCP;
TRANSMIT_CCP_MESSAGE TxCCP;

extern IGNORE_EXECUTE_FROM_FLASH;

UINT8 main() { 

	/* Prevent the flash program from trying to execute the 
	 * application once it has finished downloading */
	IGNORE_EXECUTE_FROM_FLASH = 1;

	setupCanModuleBoot(DEFAULT_NUM_QUANTA,
			DEFAULT_SAMPLE_POINT,
			DEFAULT_BIT_RATE);
	initCanModuleRxTxBoot(DEFAULT_CCP_CRO_ID, DEFAULT_CCP_DTO_ID);
	initSerialModuleBoot();

	while( 1 ) {
		UINT8 msg[8];
		if ( receiveCanFrameBoot(msg) ) {
			RxCCP = (RECEIVE_CCP_MESSAGE) receiveCanFrameBoot;
			TxCCP = (TRANSMIT_CCP_MESSAGE) sendCanFrameBoot;
			/* Start the bootloader and never return */
			ccpKernelLoop(msg,
					CCP_SESSION_STATUS_DISCONNECTED);
			exit(1);
		}
		/* check for serial comms */
		if (receiveTargetAliveByte()) {
			RxCCP = (RECEIVE_CCP_MESSAGE) receiveSerialCCPMessage; 
			TxCCP = (TRANSMIT_CCP_MESSAGE) sendSerialCCPMessage;
			/* sync with host before 
			 * starting CCP kernel */
			syncWithHost();
			/* receive the first CCP message */
			waitForSerialCCPMessage(msg); 
			ccpKernelLoop(msg, 
					CCP_SESSION_STATUS_DISCONNECTED);
			exit(1);
		}
	}

}


/* Stub out executeFromFlash */
void executeFromRam(void){
}

int IGNORE_EXECUTE_FROM_FLASH = 0;

/* Tub out executeFromFlash */
void executeFromFlash(void){
}

/* Stub out run_app_from_ram */
void run_app_from_ram(){
}

/* Provide the program prepare command */
void program_prepare(DOWNLOAD_TYPE type){
      /* No action */
      switch (type){
          case FLASH_DOWNLOAD:
              FLASH_DRIVER.initialize((unsigned char * ) 0);
              break;
      }
}


/* Do not require any user intialization code but must provide
 * a stub */
void usr_init(void ){
}
