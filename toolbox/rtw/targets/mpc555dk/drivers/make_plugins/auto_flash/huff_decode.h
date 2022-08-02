/********************************************
* File : huff_decode.h
*
* Abstract:
*	Header file for the embedded huffman decoder. The routines
*	here decompress a block of huffman encoded data.
* 		
* $Revision: 1.1.6.2 $
* $Date: 2004/04/19 01:24:15 $ 
*
* Copyright 2002-2003 The MathWorks, Inc.
* ********************************************/

#ifndef __HUFF_DECODE_H__
#define __HUFF_DECODE_H__

/**************************************************************
 * Function Pointer Typedef
 *    HuffmanDecoderCallback
 *
 * Purpose
 *    To be notified of symbol decodes
 *
 * Arguments
 *    symbol   -  The currently decoded symbol
 *    idx      -  The number of the symbol in the decode sequence
 *    userdata -  Extra data passed to the callback ( Optional )
 *
 * Returns
 *    1        -  Success
 *    0        -  Failure - will terminate the decoding of the file
 *
 * */
typedef int ( * HuffmanDecoderCallback) ( unsigned char symbol, int idx, void * userdata );

/***************************************************************
 * Function
 *
 *    decode_huffman_data
 *
 * Purpose
 *
 *    Decode a block of huffman encoded data
 *
 * Arguments
 *
 *    state_table    -  A table of state transitions. It will have 255 states and two transitions
 *                      per state. 254 is the starting state. Any transition to state 254 indicates
 *                      a symbol decode is required
 *    symbol_decoder -  A table of symbol decodes. Whenever a transition to state 254 is made from
 *                      the current state, the current state is used as an index into the symbol
 *                      decoder. If the current bit is 0 then then the first symbol is used. If the
 *                      current bit is 1 then the next symbol is used.
 *    data           -  The data block to decode
 *    len            -  The length of the data to decode
 *    cb             -  The callback function to call when a symbol is decoded
 *    userdata       -  Some data to pass to the callback function when a symbol is decoded. This
 *                      is user optional.
 *
 * Returns 
 *    1     if sucessfull
 *    0     if not successfull. This may be that the
 *          callback function failed.
 *
 * */
extern int decode_huffman_data(
      unsigned char state_table[][2],
      unsigned char symbol_decoder[][2],
      unsigned char * data,
      int len,
      HuffmanDecoderCallback cb, void * userdata );

#endif
