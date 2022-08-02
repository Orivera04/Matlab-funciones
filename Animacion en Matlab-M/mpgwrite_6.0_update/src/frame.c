/*===========================================================================*
 * frame.c								     *
 *									     *
 *	basic frame procedures						     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	Frame_Init							     *
 *	Frame_Exit							     *
 *	Frame_New							     *
 *	Frame_Free							     *
 *	Frame_AllocPPM							     *
 *	Frame_AllocBlocks						     *
 *	Frame_AllocYCC							     *
 *	Frame_AllocDecoded						     *
 *	Frame_AllocHalf						             *
 *									     *
 *===========================================================================*/

/*
 * Copyright (c) 1993 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */


/***********************************************************************
                             R C S Information
************************************************************************/
/* $Log: frame.c,v $
 * Revision 1.4  1994/01/14  14:06:06  daf
 * Removed calls to exit().
 *
 * Revision 1.3  94/01/12  20:14:57  daf
 * Added RCS info.
 * 
 * revision 1.2    locked by: daf;
 * date: 1994/01/07 17:19:00;  author: daf;  state: Exp;  lines: +58 -54
 * Modified for use as .mex file.
 *   malloc, free changed to mxCalloc, mxFree.
 * 
 * revision 1.1
 * date: 1994/01/07 17:05:21;  author: daf;  state: Exp;
 * Initial revision
*/


/*==============*
 * HEADER FILES *
 *==============*/

#include "all.h"
#include "mtypes.h"
#include "frames.h"
#include "frame.h"
#include "fsize.h"
#include "dct.h"
#include "mex.h"


/*==================*
 * GLOBAL VARIABLES *
 *==================*/

MpegFrame  *frameMemory[3];  /* only need at most 3 frames in memory at once */


/*===============================*
 * INTERNAL PROCEDURE prototypes *
 *===============================*/

static void FreeFrame _ANSI_ARGS_((MpegFrame * mf));
static MpegFrame *GetUnusedFrame _ANSI_ARGS_((void));
static void ResetFrame _ANSI_ARGS_((int fnumber, int type, MpegFrame *frame));


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * Frame_Init
 *
 *	initializes the memory associated will all frames ever (since we
 *	only need 3 frames in memory at any one time)
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    frameMemory
 *
 *===========================================================================*/
void
Frame_Init()
{
    register int index;

    for ( index = 0; index < 3; index++ ) {
	frameMemory[index] = (MpegFrame *) mxCalloc(1, sizeof(MpegFrame));
	frameMemory[index]->inUse = FALSE;
	frameMemory[index]->ppm_data = NULL;
	frameMemory[index]->rgb_data = NULL;
	frameMemory[index]->orig_y = NULL;	/* if NULL, then orig_cr, orig_cb invalid */
	frameMemory[index]->y_blocks = NULL; /* if NULL, then cr_blocks, cb_blocks invalid */
	frameMemory[index]->decoded_y = NULL;	/* if NULL, then blah blah */
	frameMemory[index]->halfX = NULL;
    }
}


/*===========================================================================*
 *
 * Frame_Exit
 *
 *	frees the memory associated with frames
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    frameMemory
 *
 *===========================================================================*/
void
Frame_Exit()
{
    register int index;

    for ( index = 0; index < 3; index++ ) {
	FreeFrame(frameMemory[index]);
    }
}


/*===========================================================================*
 *
 * Frame_Free
 *
 *	frees the given frame -- allows it to be re-used
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Frame_Free(frame)
    MpegFrame *frame;
{
    frame->inUse = FALSE;
}


/*===========================================================================*
 *
 * Frame_New
 *
 *	finds a frame that isn't currently being used and resets it
 *
 * RETURNS:	the frame
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
MpegFrame *
Frame_New(id, type)
    int id;
    int type;
{
    MpegFrame *frame;

    frame = GetUnusedFrame();
    ResetFrame(id, type, frame);

    return frame;
}


/*===========================================================================*
 *
 * Frame_AllocPPM
 *
 *	allocate memory for ppm data for the given frame, if required
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Frame_AllocPPM(frame)
    MpegFrame *frame;
{
    register int y;

    if ( frame->ppm_data != NULL ) {	/* already allocated */
	return;
    }

    frame->ppm_data = (uint8 **) mxCalloc(Fsize_y, sizeof(uint8 *));
    ERRCHK(frame->ppm_data, "malloc");

    for ( y = 0; y < Fsize_y; y++ ) {
	frame->ppm_data[y] = (uint8 *) mxCalloc(3*Fsize_x, sizeof(uint8));
	ERRCHK(frame->ppm_data[y], "malloc");
    }
}


/*===========================================================================*
 *
 * Frame_AllocBlocks
 *
 *	allocate memory for blocks for the given frame, if required
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Frame_AllocBlocks(frame)
    MpegFrame *frame;
{
    int dctx, dcty;
    int i;

    if ( frame->y_blocks != NULL ) {	    /* already allocated */
	return;
    }

    dctx = Fsize_x / DCTSIZE;
    dcty = Fsize_y / DCTSIZE;

    frame->y_blocks = (Block **) mxCalloc(dcty, sizeof(Block *));
    ERRCHK(frame->y_blocks, "malloc");
    for (i = 0; i < dcty; i++) {
	frame->y_blocks[i] = (Block *) mxCalloc(dctx, sizeof(Block));
	ERRCHK(frame->y_blocks[i], "malloc");
    }

    frame->cr_blocks = (Block **) mxCalloc(dcty / 2, sizeof(Block *));
    frame->cb_blocks = (Block **) mxCalloc(dcty / 2, sizeof(Block *));
    ERRCHK(frame->cr_blocks, "malloc");
    ERRCHK(frame->cb_blocks, "malloc");
    for (i = 0; i < dcty / 2; i++) {
	frame->cr_blocks[i] = (Block *) mxCalloc(dctx / 2, sizeof(Block));
	frame->cb_blocks[i] = (Block *) mxCalloc(dctx / 2, sizeof(Block));
	ERRCHK(frame->cr_blocks[i], "malloc");
	ERRCHK(frame->cb_blocks[i], "malloc");
    }
}


/*===========================================================================*
 *
 * Frame_AllocYCC
 *
 *	allocate memory for YCC info for the given frame, if required
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Frame_AllocYCC(frame)
    MpegFrame *frame;
{
    register int y;

    if ( frame->orig_y != NULL ) {	/* already allocated */
	return /* nothing */ ;
    }

    DBG_PRINT(("ycc_calc:\n"));
    /*
     * first, allocate tons of memory
     */
    frame->orig_y = (uint8 **) mxCalloc(Fsize_y, sizeof(uint8 *));
    ERRCHK(frame->orig_y, "malloc");
    for (y = 0; y < Fsize_y; y++) {
	frame->orig_y[y] = (uint8 *) mxCalloc(Fsize_x, sizeof(uint8));
	ERRCHK(frame->orig_y[y], "malloc");
    }

    frame->orig_cr = (uint8 **) mxCalloc(Fsize_y / 2, sizeof(int8 *));
    ERRCHK(frame->orig_cr, "malloc");
    for (y = 0; y < Fsize_y / 2; y++) {
	frame->orig_cr[y] = (uint8 *) mxCalloc(Fsize_x / 2, sizeof(int8));
	ERRCHK(frame->orig_cr[y], "malloc");
    }

    frame->orig_cb = (uint8 **) mxCalloc(Fsize_y / 2, sizeof(int8 *));
    ERRCHK(frame->orig_cb, "malloc");
    for (y = 0; y < Fsize_y / 2; y++) {
	frame->orig_cb[y] = (uint8 *) mxCalloc(Fsize_x, sizeof(int8));
	ERRCHK(frame->orig_cb[y], "malloc");
    }

    if ( referenceFrame == ORIGINAL_FRAME ) {
	frame->ref_y = frame->orig_y;
	frame->ref_cr = frame->orig_cr;
	frame->ref_cb = frame->orig_cb;
    }
}



/*===========================================================================*
 *
 * Frame_AllocHalf
 *
 *	allocate memory for half-pixel values for the given frame, if required
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Frame_AllocHalf(frame)
    MpegFrame *frame;
{
    register int y;

    if ( frame->halfX != NULL ) {
        return;
    }

	frame->halfX = (uint8 **) mxCalloc(Fsize_y, sizeof(uint8 *));
	ERRCHK(frame->halfX, "malloc");
	frame->halfY = (uint8 **) mxCalloc((Fsize_y-1), sizeof(uint8 *));
	ERRCHK(frame->halfY, "malloc");
	frame->halfBoth = (uint8 **) mxCalloc((Fsize_y-1), sizeof(uint8 *));
	ERRCHK(frame->halfBoth, "malloc");
	for ( y = 0; y < Fsize_y; y++ ) {
	    frame->halfX[y] = (uint8 *) mxCalloc((Fsize_x-1), sizeof(uint8));
	    ERRCHK(frame->halfX[y], "malloc");
	}
	for ( y = 0; y < Fsize_y-1; y++ ) {
	    frame->halfY[y] = (uint8 *) mxCalloc(Fsize_x, sizeof(uint8));
	    ERRCHK(frame->halfY[y], "malloc");
	}
	for ( y = 0; y < Fsize_y-1; y++ ) {
	    frame->halfBoth[y] = (uint8 *) mxCalloc((Fsize_x-1), sizeof(uint8));
	    ERRCHK(frame->halfBoth[y], "malloc");
	}
}


/*===========================================================================*
 *
 * Frame_AllocDecoded
 *
 *	allocate memory for decoded frame for the given frame, if required
 *	if makeReference == TRUE, then makes it reference frame
 * 
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Frame_AllocDecoded(frame, makeReference)
    MpegFrame *frame;
    boolean makeReference;
{
    register int y;

    if ( frame->decoded_y != NULL) {	/* already allocated */
	return;
    }

    /* allocate memory for decoded image */
    /* can probably reuse original image memory, but may decide to use
       it for some reason, so do it this way at least for now -- more
       flexible
     */
    frame->decoded_y = (uint8 **) mxCalloc(Fsize_y, sizeof(uint8 *));
    ERRCHK(frame->decoded_y, "malloc");
    for (y = 0; y < Fsize_y; y++) {
	frame->decoded_y[y] = (uint8 *) mxCalloc(Fsize_x, sizeof(uint8));
	ERRCHK(frame->decoded_y[y], "malloc");
    }

    frame->decoded_cr = (uint8 **) mxCalloc(Fsize_y / 2, sizeof(int8 *));
    ERRCHK(frame->decoded_cr, "malloc");
    for (y = 0; y < Fsize_y / 2; y++) {
	frame->decoded_cr[y] = (uint8 *) mxCalloc(Fsize_x / 2, sizeof(uint8));
	ERRCHK(frame->decoded_cr[y], "malloc");
    }

    frame->decoded_cb = (uint8 **) mxCalloc(Fsize_y / 2, sizeof(int8 *));
    ERRCHK(frame->decoded_cb, "malloc");
    for (y = 0; y < Fsize_y / 2; y++) {
	frame->decoded_cb[y] = (uint8 *) mxCalloc(Fsize_x / 2, sizeof(uint8));
	ERRCHK(frame->decoded_cb[y], "malloc");
    }

    if ( makeReference ) {
	frame->ref_y = frame->decoded_y;
	frame->ref_cr = frame->decoded_cr;
	frame->ref_cb = frame->decoded_cb;
    }
}


/*=====================*
 * INTERNAL PROCEDURES *
 *=====================*/


/*===========================================================================*
 *
 * GetUnusedFrame
 *
 *	return an unused frame
 *
 * RETURNS:	the frame
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
static MpegFrame *
GetUnusedFrame()
{
    register int index;

    for ( index = 0; index < 3; index++ ) {
	if ( ! frameMemory[index]->inUse ) {
	    frameMemory[index]->inUse = TRUE;
	    return frameMemory[index];
	}
    }

    mexErrMsgTxt("ERROR: no unused frames to return.");
}


/*===========================================================================*
 *
 * ResetFrame
 *
 *	reset a frame to the given id and type
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
static void
ResetFrame(id, type, frame)
    int id;
    int type;
    MpegFrame *frame;
{
    switch (type) {
    case 'i':
	frame->type = TYPE_IFRAME;
	break;
    case 'p':
	frame->type = TYPE_PFRAME;
	break;
    case 'b':
	frame->type = TYPE_BFRAME;
	break;
    default:
	mexErrMsgTxt("Error: unsupported frame type.");
    }

    frame->id = id;
    frame->halfComputed = FALSE;
}


/*===========================================================================*
 *
 * FreeFrame
 *
 *	frees the memory associated with the given frame
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
static void
FreeFrame(frame)
    MpegFrame *frame;
{
    int i;

    if (!frame) {
	return;
    }

/*
    if ( frame->ppm_data ) {
	* it may be a little bigger than Fsize_y, but that's fine for
	   our purposes, since we aren't going to free until we exit anyway,
	   so by the time we call this we won't care
	 *
	pnm_freearray(frame->ppm_data, Fsize_y);
	frame->ppm_data = NULL;
    }

    if (frame->rgb_data) {
	pnm_freearray(frame->rgb_data, Fsize_y);
    }
*/

    if (frame->orig_y) {
	for (i = 0; i < Fsize_y; i++) {
	    mxFree(frame->orig_y[i]);
	}
	mxFree(frame->orig_y);

	for (i = 0; i < Fsize_y / 2; i++) {
	    mxFree(frame->orig_cr[i]);
	}
	mxFree(frame->orig_cr);

	for (i = 0; i < Fsize_y / 2; i++) {
	    mxFree(frame->orig_cb[i]);
	}
	mxFree(frame->orig_cb);
    }
    if ( frame->decoded_y ) {
	for (i = 0; i < Fsize_y; i++) {
	    mxFree(frame->decoded_y[i]);
	}
	mxFree(frame->decoded_y);

	for (i = 0; i < Fsize_y / 2; i++) {
	    mxFree(frame->decoded_cr[i]);
	}
	mxFree(frame->decoded_cr);

	for (i = 0; i < Fsize_y / 2; i++) {
	    mxFree(frame->decoded_cb[i]);
	}
	mxFree(frame->decoded_cb);
    }

    if (frame->y_blocks) {
	for (i = 0; i < Fsize_y / DCTSIZE; i++) {
	    mxFree(frame->y_blocks[i]);
	}
	mxFree(frame->y_blocks);

	for (i = 0; i < Fsize_y / (2 * DCTSIZE); i++) {
	    mxFree(frame->cr_blocks[i]);
	}
	mxFree(frame->cr_blocks);

	for (i = 0; i < Fsize_y / (2 * DCTSIZE); i++) {
	    mxFree(frame->cb_blocks[i]);
	}
	mxFree(frame->cb_blocks);
    }
    if ( frame->halfX ) {
	for ( i = 0; i < Fsize_y; i++ ) {
	    mxFree(frame->halfX[i]);
	}
	mxFree(frame->halfX);

	for ( i = 0; i < Fsize_y-1; i++ ) {
	    mxFree(frame->halfY[i]);
	}
	mxFree(frame->halfY);

	for ( i = 0; i < Fsize_y-1; i++ ) {
	    mxFree(frame->halfBoth[i]);
	}
	mxFree(frame->halfBoth);
    }

    mxFree(frame);
}


