/*
 * File: cmf_flash.c
 *
 * Abstract :
 * 	API implementation for CMF drivers
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:25:18 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 **/
#include "cmf_flash.h"

/* Generic Flash Driver API */
#include "flash_driver.h" 

#define DEMO_PASS   0x00
#define DEMO_FAIL   0xFF

#define MSB 0x80


extern unsigned int PPCCMF300[];
extern const unsigned int gmd_pi[];
extern const unsigned int gmd_pe[];
extern const unsigned int gmd_pp[];
extern const unsigned int gmd_bc[];
extern const unsigned int gmd_pv[];
extern const unsigned int gmd_cs[];
extern const unsigned int gmd_cc[];
/*
UINT8 ParallelInit		( tCMF_PART *cmfPart );
UINT8 ParallelErase		( tCMF_PART *cmfPart,
                     	  tCMF_ERASE_DATA *eraseData,
                     	  UINT8 *enabledBlocks,
                     	  void (*CallBack)(void) );
UINT8 BlankCheck		( tCMF_PART *cmfPart,
                  		  UINT32 dest,
                  		  UINT32 size,
                  		  BOOL shadow,
                  		  tCMF_COMP_DATA *cmfCompare,
                  		  void (*CallBack)(void) );
UINT8 ParallelProgram	( tCMF_PART *cmfPart,
                       	  tCMF_PROGRAM_DATA *programData,
                       	  UINT8 *enabledBlocks,
                       	  UINT32 source,
                       	  UINT32 offset,
                       	  UINT16 pagesetNum,
                       	  BOOL shadow,
                       	  void (*CallBack)(void) );
UINT8 ParallelVerify	( tCMF_PART *cmfPart,
                      	  UINT8 *enabledBlocks,
                      	  UINT32 source,
                      	  UINT32 offset,
                      	  UINT16 pagesetNum,
                      	  BOOL shadow,
                      	  tCMF_COMP_DATA *cmfCompare,
                      	  void (*CallBack)(void) );
UINT8 ChangeCensor		( tCMF_PART *cmfPart,
                    	  tCMF_CENSOR_DATA *censorData,
                    	  UINT8 module,
                    	  UINT8 censorValue,
                    	  UINT8 deviceMode,
                    	  void (*CallBack)(void) );
UINT8 CheckSum			( tCMF_PART *cmfPart,
                		  UINT32 dest,
                		  UINT32 size,
                		  BOOL shadow,
                		  UINT8 *sum,
                		  void (*CallBack)(void) );
*/


pPARALLELINIT       _ParallelInit    = (pPARALLELINIT)     gmd_pi;
pPARALLELERASE      _ParallelErase   = (pPARALLELERASE)    gmd_pe;
pBLANKCHECK         _BlankCheck      = (pBLANKCHECK)       gmd_bc;
pPARALLELPROGRAM    _ParallelProgram = (pPARALLELPROGRAM)  gmd_pp;
pPARALLELVERIFY     _ParallelVerify  = (pPARALLELVERIFY)   gmd_pv;
pCHANGECENSOR       _ChangeCensor    = (pCHANGECENSOR)     gmd_cc;
pCHECKSUM           _CheckSum        = (pCHECKSUM)         gmd_cs;

#define ParallelInit (*_ParallelInit)
#define ParallelErase (*_ParallelErase)
#define BlankCheck (*_BlankCheck)
#define ParallelProgram (*_ParallelProgram)
#define ParallelVerify (*_ParallelVerify)
#define ChangeCensor (*_ChangeCensor)
#define CheckSum (*_CheckSum)

/* Exported Diagnostics Struct */
FlashProgrammerDiagonistics FLASH_DIAGNOSTICS = { "MPC555_INTERNAL_CMF_DRIVER", 0, "SUCCESS" };

/* Static Functions */
static void EnableBlockSetup(UINT8 * enabledBlocks,int block);
static void CallBack ();

/* Global Static Data */
static pCMF_PART           cmfPart         = (pCMF_PART)         0;
static pCMF_ERASE_DATA     eraseData       = (pCMF_ERASE_DATA)   0;
static pCMF_CENSOR_DATA    censorData      = (pCMF_CENSOR_DATA)  0;
static pCMF_PROGRAM_DATA   programData     = (pCMF_PROGRAM_DATA) 0;
static pCMF_COMP_DATA      compData        = (pCMF_COMP_DATA)    0;
    
static UINT16 *gmd_data = (UINT16*) PPCCMF300;



/* Initialize the flash array */
int cmf_Initialize( unsigned char * base_addr ){

	int i;
   int retCode;

   // anchor GMD data objects from PPCCMF300 (c-array format)
   if(gmd_data[GMDIO_OFFSET_PART_DESCRIPTION/2] != 0xFFFF)
      cmfPart = (pCMF_PART) ((UINT32)PPCCMF300 + gmd_data[GMDIO_OFFSET_PART_DESCRIPTION/2]);

   if(gmd_data[GMDIO_OFFSET_PROGRAM_DATA/2] != 0xFFFF)
      programData = (pCMF_PROGRAM_DATA) ((UINT32)PPCCMF300 + gmd_data[GMDIO_OFFSET_PROGRAM_DATA/2]);

   if(gmd_data[GMDIO_OFFSET_ERASE_DATA/2] != 0xFFFF)
      eraseData = (pCMF_ERASE_DATA) ((UINT32)PPCCMF300 + gmd_data[GMDIO_OFFSET_ERASE_DATA/2]);

   if(gmd_data[GMDIO_OFFSET_CENSOR_DATA/2] != 0xFFFF)
      censorData = (pCMF_CENSOR_DATA) ((UINT32)PPCCMF300 + gmd_data[GMDIO_OFFSET_CENSOR_DATA/2]);

   if(gmd_data[GMDIO_OFFSET_COMP_DATA/2] != 0xFFFF)
      compData = (pCMF_COMP_DATA) ((UINT32)PPCCMF300 +  gmd_data[GMDIO_OFFSET_COMP_DATA/2]);

    cmfPart->enabledBlocks[CMF_MODULE_A] = 0xFF;            // enable all Blocks in module A
    cmfPart->enabledBlocks[CMF_MODULE_B] = 0xFC;            // enable all Blocks in module B
    
    cmfPart->enableBDM = FALSE;                 			// don't enter BDM after func exit

    cmfPart->arrayBase = (UINT32) base_addr ;               // Assign the base address of the 
                                                            // flash. This must be compatible
                                                            // with the immr.
    /* call ParallelInit */

    retCode = ParallelInit( cmfPart);
    if( retCode != CMF_OK){
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "cmf_initialize:ParallelInit";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = retCode;
      return FLASH_PROGRAMMING_ERROR;
    }

	 return FLASH_PROGRAMMING_OK;
}








/* ---------------------------------------------------------------------
 *                      STATIC FUNCTIONS
 * ------------------------------------------------------------------- */


/* Function
 *    cmf_WritePage
 *
 * Purpose
 *    To write a single page of flash to the CMF array
 *
 * Arguments
 *    block    -  The numbered block to write
 *    page     -  The page within the block to write
 *    buffer   -  The source of the data to write
 *
 * Returns
 *    FLASH_PROGRAMMING_OK
 *    FLASH_PROGRAMMING_ERROR    -  If there was a problem
 **/
int cmf_WritePage(int block , int page, char * buffer){

   UINT8   enabledBlocks[CMF_MODULES];
   VUINT8  returnCode; // defined as volatile variable for avoiding from being optimized and user can see it in debug mode
   UINT32  offset;

   // calculate offset into block
   offset = page * PAGE_SIZE;

   /* Determine which block to enable */
   EnableBlockSetup(enabledBlocks,block);

   // ParalleProgram( cmfPart, programData, enabledBlocks, (UINT32)source, offset, pagesetNum, shadow, CallBack );
   returnCode = ParallelProgram( cmfPart, programData, enabledBlocks, (UINT32)buffer, offset, 1, MAIN_ARRAY, CallBack );
   if(returnCode!=CMF_OK) {
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "WritePage:ParallelProgram";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR;
   }

   // verify the block
   // ParallelVerify ( cmfPart, enabledBlocks, (UINT32)source, offset, pagesetNum, shadow, cmfCompare, CallBack ); 
   returnCode = ParallelVerify( cmfPart, enabledBlocks, (UINT32)buffer, offset,  1, MAIN_ARRAY, compData, CallBack);
   if(returnCode!=CMF_OK){
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "WritePage:ParallelVerify";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR;
   }

   return FLASH_PROGRAMMING_OK;
}

/* Function
 *    cmf_ClearBlock
 *
 * Purpose
 *    To clear a single CMF block
 *
 * Arguments
 *    block    -  The numbered CMF block to clear
 *
 * Returns
 *    FLASH_PROGRAMMING_OK
 *    FLASH_PROGRAMMING_ERROR    -  If there was a problem.
 **/   
int cmf_ClearBlock( int block ){

   UINT8   enabledBlocks[CMF_MODULES];
   VUINT8  returnCode; // defined as volatile variable for avoiding from being optimized and user can see it in debug mode
   UINT32 offset;

   UINT32   dest, size;

   /* Determine which block to enable */
   EnableBlockSetup(enabledBlocks,block);

   /* Erase the page */
   returnCode = ParallelErase( cmfPart, eraseData, enabledBlocks, CallBack );
   if(returnCode != CMF_OK){ 
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "ClearBlock:ParallelErase";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR ;
   }

    // BlankCheck( cmfPart, dest, size, shadow, cmfCompare, CallBack ); 
    returnCode = BlankCheck( cmfPart, block * BLOCK_SIZE, BLOCK_SIZE, MAIN_ARRAY, compData, CallBack );
    if(returnCode!=CMF_OK){
        FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "ClearBlock:BlankCheck";
        FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
        return FLASH_PROGRAMMING_ERROR;
    }

   return FLASH_PROGRAMMING_OK;
}

/* Function
 *    EnableBlockSetup
 *
 * Purpose
 *    Configure the enabledBlocks bitmasks. Only the mask for the specified
 *    block will be enabled. 
 *
 * Arguments
 *    enabledBlocks  -  The array of bitmasks for CMF_MODULE_A and CMF_MODULE_B
 *    block          -  The block index to enable
 *
 **/ 
static void EnableBlockSetup(UINT8 * enabledBlocks,int block){
   /* Determine which block to enable */
   if ( block < BLOCKS_IN_MODULE_A ){
      enabledBlocks[CMF_MODULE_A] = (UINT8) ( MSB >> block );       
      enabledBlocks[CMF_MODULE_B] = 0;
   }else{
      enabledBlocks[CMF_MODULE_A] = 0;
      enabledBlocks[CMF_MODULE_B] = (UINT8) ( MSB >> (block - BLOCKS_IN_MODULE_A ));
   }
}

static void CallBack (){
}

