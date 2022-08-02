#ifndef __GENERIC_MPC555_FLASH_DRIVER__
#define __GENERIC_MPC555_FLASH_DRIVER__
#include <stdlib.h>


#define FLASH_PROGRAMMING_ERROR 0
#define FLASH_PROGRAMMING_OK (!FLASH_PROGRAMMING_ERROR) 

 /*
 * File: flash_driver.h
 *
 * Abstract:
 *    generic flash API
 *
 * $Revision: 1.1.6.3 $
 * $Date: 2004/04/19 01:25:37 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 *
 */

/** flash_initialize
 *  
 *  Initialize the flash array
 *
 *  @param base_addr	   The base address of the flash array
 *
 *  @returns FLASH_PROGRAMMING_ERROR | FLASH_PROGRAMMING_OK
 *
 *  */
typedef unsigned int (* typeFlashInitialize)( unsigned char * base_addr );

/** flash_program
 *
 * Program the CMF array
 *
 * @param address The address at which to start programming
 * @param bytes The array of data of which to write
 * @param number_of_bytes The number of bytes in the array 
 * @param auto_clear 1 to clear each new block as it is encountered or 0 to
 * assume that the blocks have been pre-cleared
 *
 *  @returns FLASH_PROGRAMMING_ERROR | FLASH_PROGRAMMING_OK
 * */
typedef unsigned int (* typeFlashProgram)(unsigned char * address, unsigned char * bytes,
      const int number_of_bytes, const int auto_clear);

/** flash_clear
 *
 * Clear the block associated with the address
 *
 * @param address. The entire block in which the address resides will
 * be cleared.
 *
 *  @returns FLASH_PROGRAMMING_ERROR | FLASH_PROGRAMMING_OK
 *
 * */
typedef unsigned int (* typeFlashClear)(unsigned char * address);

/** flash_flush
 *
 * write out any buffered up data to the flash array. This must
 * be called to finish the write process
 *
 *  @returns FLASH_PROGRAMMING_ERROR | FLASH_PROGRAMMING_OK
 *
 * */
typedef unsigned int (* typeFlashFlush)();

/** Driver Interface Structure */
typedef struct {
  typeFlashInitialize initialize;
  typeFlashProgram program;
  typeFlashClear clear;
  typeFlashFlush flush;
} FlashDriver;

/** Error Code Information Structore */
typedef struct {
   char * driverSpecificIdentification;
   unsigned int driverSpecificErrorCode;
   char * driverSpecificErrorMessage;
} FlashProgrammerDiagonistics;

/* ---------------- Default Driver   -------------------
 *
 * The default driver should allways be the CMF array
 * driver. To access the default driver the programmer
 * should use the macro
 *
 * FLASH_DRIVER.<api_method>
 *
 * */

extern FlashDriver FLASH_DRIVER;

/* FlashProgrammerDiagonistics 
 *
 * is the diagnostics structure for flash programming. 
 * Implementing drivers are expected to support this structure.
 * It is declared volatile so that the compiler does not
 * optimize out references to it.
 * */
extern FlashProgrammerDiagonistics FLASH_DIAGNOSTICS;


#endif
