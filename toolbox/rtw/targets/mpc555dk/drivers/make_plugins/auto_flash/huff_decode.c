/********************************************
 * File: huff_decode.c
 *
 *	Abstract:
 *		Source file for the embedded huffman decoder. The routines
 *		here decompress a block of huffman encoded data.
 *
 * $Revision: 1.1.10.2 $
 * $Date: 2004/04/19 01:24:14 $ 
 *
 * Copyright 2002-2003 The MathWorks, Inc.
* ********************************************/

#include <stdlib.h>
#include "huff_decode.h"

#define START_STATE 0 
int decode_huffman_data(
      unsigned char state_table[][2],
      unsigned char symbol_decoder[][2],
      unsigned char * data,
      int len,
      HuffmanDecoderCallback cb, void * userdata ){


   int i,k,bit;
   int state = START_STATE;
   int next_state;
   int symbol_idx = 0;
   /* Iterate over all input bytes */ 
   for (i=len; i>0; i--){ 
      unsigned char current_byte = *data;
      /* Iterate over each bit in the current byte */ 
      for(bit=7; bit>=0; bit--){ 
         k = ( current_byte >> bit ) & 1;
         /* Lookup the next state but do not yet jump to it */
         next_state = state_table[state][k];
         /* Test to see if a symbol has been decoded */
         if (next_state == START_STATE){ 
            /* Notify the user callback that a symbol has been decoded.
             * If the callback returns 0 then the decoding process is
             * terminated and an error is returned*/
            if(!cb(symbol_decoder[state][k], symbol_idx, userdata)){
               return 0;
            }
            /* Increase the count of symbols decoded */
            symbol_idx ++;
         }
         /* Move to the next state */
         state = next_state;
      }
      /* Move to the next byte */
      data ++;
   }
   return 1;
}
