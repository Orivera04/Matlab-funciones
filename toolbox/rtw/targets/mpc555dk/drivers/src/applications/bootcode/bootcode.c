
 /*
 * File : bootcode.c
 *
 * Abstract:
 * 	Utility functions for the bootloader
 *
 * $Revision: 1.4.4.3 $
 * $Date: 2004/04/19 01:24:56 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include "mpc5xx.h"
#include "ccp_boot_data.h"
#include "flash_driver.h"
#include "simple_can_driver.h"
#include "bootcode.h"
#include "ccp_target.h"
#include "run_app.h"


void executeFromRam(void){
   /* the download has finished - 
    * we cannot reset the processor otherwise external RAM will
    * be corrupted.
    *
    * Instead, we jump directly to the application without resetting */
	run_app_from_ram();
}

int IGNORE_EXECUTE_FROM_FLASH = 0;

void executeFromFlash(void){
   /* the download has finished -
    * we reset the processor to restore modules to their reset state.
    *
    * Setting up the boot_action to EXECUTE_FLASH_APP will cause the
    * bootcode to jump straight into execution of the downloaded flash
    * application immediately after the reset */
	if ( !IGNORE_EXECUTE_FROM_FLASH){
		ccpBootData.ccp_application_key_1 = CCP_DATA_APPLICATION_KEY;
		ccpBootData.ccp_application_key_2 = CCP_DATA_APPLICATION_KEY;
		ccpBootData.boot_action = EXECUTE_FLASH_APP;
      
      while (1) {
         /* Reset via a watchdog timer timeout */
      }
	}
}

void program_prepare(DOWNLOAD_TYPE type){
      /* No action */
      switch (type){
          case RAM_DOWNLOAD:
              break;
          case FLASH_DOWNLOAD:
              FLASH_DRIVER.initialize((unsigned char * ) 0);
              break;
      }
}

