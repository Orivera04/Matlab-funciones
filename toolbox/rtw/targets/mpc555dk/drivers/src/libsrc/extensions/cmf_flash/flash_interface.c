
/*
 * File: flash_interface.c
 *
 * Abstract :
 * 	Provides the high level API for interfacing the the MPC5XX flash drivers.
 * 	
 * 	One of
 *
 * 	MPC555_VARIANT
 * 	MPC565_VARIANT
 * 	MPC563_VARIANT 
 * 	etc
 *
 * 	should be supplied when compiling this file to get it to build for
 * 	the correct platform.
 *
 * Notes :
 *    The low level flash is assumed to be broken into blocks and pages. Blocks
 *    are the smallest unit of memory that can be cleared in one operation and
 *    pages are the smallest unit of memory that can be written in one
 *    operation.
 *
 *    This flash_interface buffers the incoming data before writing it to flash. The
 *    flash output device is considered to be a stream. Once an area in memory is written
 *    it cannot be re-written. An attempt to do so will cause the flash_program command
 *    to assert an error. If a user specifies a write address further on than the last
 *    write point then the gap will be filled with 0xFF.
 *    
 *    As the stream crosses the block boundary and if the auto_clear flag is set the 
 *    flash_interface will clear the block of memory.
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2003/12/11 03:49:01 $
 *
 * Copyright 2003 The MathWorks, Inc.
 **/
#include "flash_driver.h"

#ifdef MPC555_VARIANT
   /* 555 cmf driver */
#include "cmf_flash.h"
#else
   #ifdef MPC561_VARIANT
      /* 561 custom driver */
      #include "custom_flash.h"
   #else
      #ifdef MPC562_VARIANT
         /* 562 custom driver */
         #include "custom_flash.h"
      #else
         /* all other variants use c3f driver */
         #include "c3f_flash.h"
      #endif
   #endif
#endif

#define PAGE_SIZE_UI (PAGE_SIZE / sizeof(unsigned int) + ( PAGE_SIZE % sizeof(unsigned int)) > 0 )

#define NO_BLOCK_SELECTED -1
static struct {
   int block;
   unsigned int page;
   unsigned int page_offset;
   union {
      unsigned int UI[PAGE_SIZE_UI];
      unsigned char UC[PAGE_SIZE];
   }data;
} write_buffer; 

#define min(a,b) ( (a) < (b) ? (a) : (b) )
#define PAGES_IN_BLOCK (BLOCK_SIZE / PAGE_SIZE)
#define FALSE 0
#define TRUE  (!FALSE)

/* ----------------------------------------
 * Flash Interface Prototypes
 * ----------------------------------------*/

/* Flash Interface Functions Prototypes ( See flash_driver.h for documentation ) */
static unsigned int flash_initialize( unsigned char * base_addr );
static unsigned int flash_program(unsigned char * address, unsigned char * bytes, const int number_of_bytes, const int auto_clear);
static unsigned int flash_clear(unsigned char * address);
static unsigned int flash_flush();

/* Exported Flash Driver Struct */
FlashDriver FLASH_DRIVER = { flash_initialize, flash_program, flash_clear, flash_flush };

/* Local Function Prototypes */
static void 		InitBuffer();
static int 			GotoNextFlashPage(int auto_clear);
static int  		CopyToBuffer(const void *v2, const unsigned int n);
static void 		ClearBuffer();
static int 			ClearAdress(unsigned char * address);


/* **********************************************
 * Flash Interface Function Implementation
 *
 * See flash_driver.h for interface specification
 * ********************************************** */

/** flash_initialize */
static unsigned int flash_initialize( unsigned char * base_addr ){
    /* Initialize the buffer */
    InitBuffer();
	 Initialize(base_addr);
}

/** flash_program */
static unsigned int flash_program(unsigned char * address, unsigned char * bytes,
      const int number_of_bytes, const int auto_clear){

   int   block,         // The block that the address falls within
         block_offset,  // The address offset from the closest block boundary
         page,          // The page withing the block that the address falls in
         page_offset,   // The offset within the page that the adddress falls in
         retCode;       // The return code of calls to the flash driver

   /* Which block are we being asked to processes ? */
   block = (UINT32) address / BLOCK_SIZE;
   block_offset = (UINT32) address % BLOCK_SIZE;

   /* Each block is subdivided into pages */
   page = block_offset / PAGE_SIZE;
   page_offset = block_offset % PAGE_SIZE;

   /* Check to see if the caller has requested a write to a new
    * page or the current page. If it is a new page then flush
    * the buffer to flash.
    * */
   if ( block == write_buffer.block && page == write_buffer.page  ){
      /* We are in the same block and page as a previous write */
      if ( page_offset < write_buffer.page_offset ){
         /* The requested write point is lower in flash than the next
          * available write point so return an error. */
         return FLASH_PROGRAMMING_ERROR;
      }
		write_buffer.page_offset = page_offset;
   }else{

      /* Flush the buffer */
      if ( flash_flush() != FLASH_PROGRAMMING_OK ){
         return FLASH_PROGRAMMING_ERROR;
      }

      /* If we have moved to a new block and autoclear is set then erase the block */
      if ( write_buffer.block != block && auto_clear ){
         if ( ClearBlock(block) != FLASH_PROGRAMMING_OK ){
            return FLASH_PROGRAMMING_ERROR;
         }
      }

      /* Update current position */
      write_buffer.block = block;
      write_buffer.page = page; 
      write_buffer.page_offset = page_offset; 

   }


   /* The input buffer may span more than one page.
    *
    * First work out the total number of pages that are required to be written to. You need
    * to add the current page offset to calculate this correctly.
    *
    * Next loop over the input buffer and write it out one page at a time. flash_flush
    * will be called whenever a page becomes complete.
    * */

   {
      unsigned char * source_data   = bytes;
      unsigned char * end_data      = bytes + number_of_bytes;
      int             write_length  = 0; 

#define BYTES_LEFT_IN_DATA  (int) ( end_data - source_data )
#define BYTES_LEFT_IN_PAGE  (int) ( PAGE_SIZE - write_buffer.page_offset )
#define IS_BUFFER_FULL      (int) ( write_buffer.page_offset == PAGE_SIZE )

      while ( (source_data+=write_length) < end_data ){

         /* Work out how many bytes to write to the buffer */
         write_length = min(BYTES_LEFT_IN_DATA, BYTES_LEFT_IN_PAGE); 

         /* Copy the data to the buffer */
         if (! CopyToBuffer(source_data, write_length) ){
            return FLASH_PROGRAMMING_ERROR;
         }

         /* Check to see if we need to flush the buffer */
         if ( IS_BUFFER_FULL && !( flash_flush() && GotoNextFlashPage(auto_clear ) ) ){
               return FLASH_PROGRAMMING_ERROR;
         }
      }
   }
   return FLASH_PROGRAMMING_OK;
}

static unsigned int flash_clear(unsigned char * address){
	return ClearAdress(address);
}

static unsigned int flash_flush(){
   /* Write the buffer to flash */
   if(write_buffer.block != NO_BLOCK_SELECTED){
      if (!WritePage(write_buffer.block, write_buffer.page, (char *)&write_buffer.data.UC[0])){
         return FLASH_PROGRAMMING_ERROR;
      }
      ClearBuffer();
   }
   return FLASH_PROGRAMMING_OK;
}

/* **********************************************
 * Local Interface Function Implementation
 * ********************************************** */

/* Clear the write buffer */
static void ClearBuffer(){
   int i=PAGE_SIZE_UI;
   unsigned int * p = &write_buffer.data.UI[0];
   do {
	  i--;
     *p++ = ~0;
   }while(i>0);
}

/* Initialize the transmit buffer */
static void InitBuffer(){
	write_buffer.block = NO_BLOCK_SELECTED; 
	write_buffer.page = 0;
	write_buffer.page_offset = 0;
   ClearBuffer();
}

/* Function : CopyToBuffer
 *
 * Purpose : Copy data to the data buffer. 
 *
 * Note : The offset is handled automatically.
 *
 * */
static int CopyToBuffer(const void *v2, const unsigned int n){

   char * s1 = (char *) & write_buffer.data.UC[write_buffer.page_offset];
   const char * s2 = (char *) v2; 
	unsigned int m = n;
   
   if ( ( write_buffer.page_offset + n ) > PAGE_SIZE ){
      return FALSE;
   }

   /* Perform the copy */
	if ( m!=0 ){
		do{
			*s1++=*s2++;
		}while(--m!=0);
	}

   /* Increment the page offset */
   write_buffer.page_offset+=n;

   return TRUE;
}

/* Function
 *    GotoNextFlashPage
 *
 * Purpose
 *    Move buffer and write position to the next page. If the
 *    buffer crosses a block boundary and auto_clear is set then
 *    clear that block.
 *
 * Parameters
 *    autoclear - If TRUE then clear any new block encountered 
 *
 * Returns
 *    FLASH_PROGRAMMING_OK        
 *    FLASH_PROGRAMMING_ERROR     - If there was a problem
 **/
static int GotoNextFlashPage(int auto_clear){
      write_buffer.page ++;
      if ( write_buffer.page == PAGES_IN_BLOCK ){
         /* Moved to the next block */
         write_buffer.block++;
         if ( auto_clear &&  ! ClearBlock(write_buffer.block) ){
               return FLASH_PROGRAMMING_ERROR;
         }
         write_buffer.page = 0;
      }
      write_buffer.page_offset = 0;
      return FLASH_PROGRAMMING_OK;
}

static int ClearAdress(unsigned char * address){
   int    block,         // The block that the address falls within
          block_offset;  // The address offset from the closest block boundary

   block = (UINT32) address / BLOCK_SIZE;
   block_offset = (UINT32) address % BLOCK_SIZE;

   if ( block_offset != 0 ){
      return FLASH_PROGRAMMING_ERROR; 
   }

   if (!ClearBlock(block)){
      return FLASH_PROGRAMMING_ERROR;
   }

   return FLASH_PROGRAMMING_OK;
}


