/*
 * File: cmf_flash.c
 *
 * Abstract :
 * 	API implementation for C3F drivers
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/07/31 18:07:41 $
 *
 * Copyright 2003 The MathWorks, Inc.
 **/

#include "c3f_flash.h"

/* Generic Flash Driver API */
#include "flash_driver.h" 

#define DEMO_PASS       0x00
#define DEMO_FAIL       0xFF
#define BUFFER_SIZE     128             // Number of 32-bit words  

#define MSB 0x80

struct C3F_tag *C3F[C3F_MAX_MODULES];

UINT32  buffer[BUFFER_SIZE];            // Source buffer for program and verify  

/* Local Static Prototypes */
static void EnableBlockSetup(UINT8 * enabledBlocks, UINT8 * enabledSBlocks, int block);


/* Exported Diagnostics Struct */
FlashProgrammerDiagonistics FLASH_DIAGNOSTICS = { "MPC555_INTERNAL_C3F_DRIVER", 0, "SUCCESS" };

asm UINT32 FetchIMMR()
{
   mfspr r3,638
}

void CallBack( void )
{
}

void FlashSetup(UINT32 arrayBase)
{
   UINT32  m;                          // Module index

   // Initialize some variables
   for (m = 0; m < NUM_MODULES ; m++)
   {
      // Set up addresses of flash control registers
      C3F[m] = (struct C3F_tag *)(arrayBase + C3F_ADDR + m * C3F_ADDR_OFFSET);

      // Set up the various flash module control and configuration register fields
      C3F[m]->C3FMCR.SUPV       = 0;  // Set desired bits to 1 to enable corresponding large block as supervisor space
      C3F[m]->C3FMCR.DATA       = 0;  // Set desired bits to 1 to enable corresponding large block as data space
      C3F[m]->C3FMCR.PROTECT    = 0;  // Set desired bits to 1 to erase and write protect corresponding large block
      C3F[m]->C3FMCRE.SBEN      = 0;  // Set desired bits to 1 to enable corresponding small block

      // The following variables have no effect if the corresponding sb_enable[x] bits are not set
      C3F[m]->C3FMCRE.SBSUPV    = 0;  // Set desired bits to 1 to enable corresponding small block as supervisor space
      C3F[m]->C3FMCRE.SBDATA    = 0;  // Set desired bits to 1 to enable corresponding small block as data space
      C3F[m]->C3FMCRE.SBPROTECT = 0;  // Set desired bits to 1 to erase and write protect corresponding small block
   }
}

extern const unsigned int FlashInit_C[];
extern const unsigned int FlashCheckShadow_C[];
extern const unsigned int FlashErase_C[];
extern const unsigned int BlankCheck_C[];
extern const unsigned int FlashProgram_C[];
extern const unsigned int FlashVerify_C[];
extern const unsigned int ChangeCensor_C[];
extern const unsigned int CheckSum_C[];

// Define function pointers of GMD for C3F  
typedef C3F_RESULT (*pFLASHINIT)( UINT8 enabledBDM,                 
      UINT32 *arrayPointer);

typedef C3F_RESULT (*pFLASHCHECKSHADOW)( UINT8 enabledBDM,
      BOOL shadow,                 
      UINT32 dest,          
      UINT32 size,
      UINT32 arrayBase);

typedef C3F_RESULT (*pFLASHERASE)(UINT8 enabledBDM,                 
      void (*CallBack)(void),          
      UINT8 *enabledBlock, 
      UINT8 *enabledSBlock,
      UINT32 arrayBase);

typedef C3F_RESULT (*pBLANKCHECK)(UINT8 enabledBDM,                 
      void (*CallBack)(void),                              
      UINT32 dest,                     
      UINT32 size,                     
      UINT32 *compareAddress,
      UINT32 *compareData,
      UINT32 arrayBase);     

typedef C3F_RESULT (*pFLASHPROGRAM)(UINT8 enabledBDM,                 
      void(*CallBack)(void),                                
      UINT32 dest,                     
      UINT32 size,                     
      UINT32 source,
      UINT32 arrayBase);     

typedef C3F_RESULT (*pFLASHVERIFY) (UINT8 enabledBDM,                 
      void (*CallBack)(void),          
      UINT32 dest,                     
      UINT32 size,                     
      UINT32 source,                   
      UINT32 *compareAddress,
      UINT32 *compareData,
      UINT32 *compareSourceData,
      UINT32 arrayBase);     

typedef C3F_RESULT (*pCHANGECENSOR)(UINT8 enabledBDM,                 
      void(*CallBack)(void),           
      UINT8 module ,                   
      UINT8 censorValue,               
      UINT8 deviceMode,
      UINT32 arrayBase);               

typedef C3F_RESULT (*pCHECKSUM)(UINT8 enabledBDM,                 
      void (*callBack)(void),          
      UINT32 dest,                     
      UINT32 size,                     
      UINT32 *sum,
      UINT32 arrayBase);                    

// Assign function pointers    
pFLASHINIT          _FlashInit          = (pFLASHINIT)           FlashInit_C;
pFLASHCHECKSHADOW   _FlashCheckShadow   = (pFLASHCHECKSHADOW)    FlashCheckShadow_C;
pFLASHERASE         _FlashErase         = (pFLASHERASE)          FlashErase_C;
pBLANKCHECK         _BlankCheck         = (pBLANKCHECK)          BlankCheck_C;
pFLASHPROGRAM       _FlashProgram       = (pFLASHPROGRAM)        FlashProgram_C;
pFLASHVERIFY        _FlashVerify        = (pFLASHVERIFY)         FlashVerify_C;
pCHANGECENSOR       _ChangeCensor       = (pCHANGECENSOR)        ChangeCensor_C;
pCHECKSUM           _CheckSum           = (pCHECKSUM)            CheckSum_C;

#define FlashInit (*_FlashInit)       
#define FlashCheckShadow (*_FlashCheckShadow)
#define FlashErase (*_FlashErase)      
#define BlankCheck (*_BlankCheck)      
#define FlashProgram (*_FlashProgram)    
#define FlashVerify (*_FlashVerify)     
#define ChangeCensor (*_ChangeCensor)    
#define CheckSum (*_CheckSum)        

UINT8   shadow,                         // C3F shadow select flag            
   enabledBDM,                     // BDM select flag                   
   enabledBlocks[C3F_MAX_MODULES], // Enabled array blocks          
   enabledSBlocks[C3F_MAX_MODULES];// Enabled array small blocks    

UINT32  sum;                            // Check sum result              

UINT32  arrayBase;                      // Store starting address of C3F  

C3F_RESULT returnCode;                  // Return code from the demo of  
// each GMD function.                                              

UINT32  i,                              // Index                                 
   m,                              // Module Index                          
   dest,                           // Relative address for C3F              
   source,                         // Source address for program and verify  
   size;                           // C3F size operation applicable         

UINT32  compareAddress,                 // Store the check, program or verify result  
   compareData,
   compareSourceData;      

UINT8   module,                         // C3F module ChangeCensor applied     
   censorValue,                    // CENSOR[0:1] bits intend to change  
   deviceMode;                     // Censor status of the given device  

extern int c3f_Initialize(unsigned char * base_addr){

   /* Force the base address to be 0 */
   if ( base_addr != 0 ){
      return FLASH_PROGRAMMING_ERROR;
   }

   /*========================= Initialize Part =========================*/
   // first check for MPC56x part type  

   enabledBDM = 0;                         // Not enter into BDM after each opration                  
   
   // call FlashInit  
   returnCode = FlashInit( enabledBDM,
         &arrayBase);
   if(returnCode != C3F_OK)
      return(FLASH_PROGRAMMING_ERROR);

   FlashSetup((unsigned long)base_addr);                  // Setup flash map and partitions           

	return FLASH_PROGRAMMING_OK;
}

extern int c3f_ClearBlock(int block){

   UINT8   enabledBlocks[NUM_MODULES];
   UINT8   enabledSBlocks[NUM_MODULES];

   VUINT8  returnCode; // defined as volatile variable for avoiding from being optimized and user can see it in debug mode
   UINT32 offset;

   UINT32   dest, size;

   /* Determine which block to enable */
   EnableBlockSetup(enabledBlocks, enabledSBlocks, block);

   /* Erase the page */
   returnCode = FlashErase( 0, CallBack, enabledBlocks, enabledSBlocks, arrayBase );
   if(returnCode != C3F_OK){ 
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "ClearBlock:FlashErase";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR ;
   }

	returnCode = BlankCheck( enabledBDM,
            CallBack, block * BLOCK_SIZE,
            BLOCK_SIZE,
            &compareAddress,
            &compareData,
            arrayBase);

   if(returnCode!=C3F_OK){
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "ClearBlock:BlankCheck";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR;
   }

   return FLASH_PROGRAMMING_OK;

}

extern int c3f_WritePage(int block, int page, char * buffer){
   UINT8   enabledBlocks[NUM_MODULES];
   UINT8   enabledSBlocks[NUM_MODULES];

   VUINT8  returnCode; // defined as volatile variable for avoiding from being optimized and user can see it in debug mode

   /* Determine which block to enable */
   EnableBlockSetup(enabledBlocks, enabledSBlocks, block);

   /* Unset the shadow flash */
   enabledBDM = 0;
   shadow = FALSE;
   size = PAGE_SIZE;
   source = (UINT32) buffer;
   dest = block * BLOCK_SIZE + page * PAGE_SIZE;
   
   returnCode = FlashCheckShadow(  enabledBDM,
                                    shadow,
                                    dest,
                                    size,
                                    arrayBase);

   if(returnCode!=C3F_OK) {
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "WritePage:FlashCheckShadow";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR;
   }

   /* Program the Flash */
   returnCode = FlashProgram(   enabledBDM,
                               CallBack,
                               dest,
                               size,
                               source,
                               arrayBase);

   if(returnCode!=C3F_OK) {
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "WritePage:FlashProgram";
      FLASH_DIAGNOSTICS.driverSpecificErrorCode = returnCode;
      return FLASH_PROGRAMMING_ERROR;
   }

   // verify the block
	returnCode = FlashVerify(enabledBDM,
            CallBack,
            dest,
            size,
            source,
            &compareAddress,
            &compareData,
            &compareSourceData,
            arrayBase);

   if(returnCode!=C3F_OK){
      FLASH_DIAGNOSTICS.driverSpecificErrorMessage = "WritePage:FlashVerify";
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
 *    enabledBlocks  -  The array of bitmasks for C3F_MODULE_A and C3F_MODULE_B
 *    block          -  The block index to enable
 *
 **/ 
static void EnableBlockSetup(UINT8 * enabledBlocks, UINT8 * enabledSBlocks, int block){
#if NUM_MODULES == 2 
   if ( block < BLOCKS_IN_MODULE_A ){
      enabledBlocks[C3F_MODULE_A] = (UINT8) ( MSB >> block );       
      enabledBlocks[C3F_MODULE_B] = 0;
   }else{
      enabledBlocks[C3F_MODULE_A] = 0;
      enabledBlocks[C3F_MODULE_B] = (UINT8) ( MSB >> (block - BLOCKS_IN_MODULE_A ));
   }
   enabledSBlocks[C3F_MODULE_A] = 0;
   enabledSBlocks[C3F_MODULE_B] = 0;
#else
   enabledBlocks[C3F_MODULE_A] = (UINT8) ( MSB >> block );       
   enabledSBlocks[C3F_MODULE_A] = 0;
#endif
}

