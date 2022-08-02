/*===========================================================================*
 * iframe.c								     *
 *									     *
 *	Procedures concerned with the I-frame encoding			     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	GenIFrame							     *
 *	SetSlicesPerFrame						     *
 *	SetBlocksPerSlice						     *
 *	SetIQScale							     *
 *	ResetIFrameStats						     *
 *	ShowIFrameSummary						     *
 *	EstimateSecondsPerIFrame					     *
 *	EncodeYDC							     *
 *	EncodeCDC							     *
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

/*
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/iframe.c,v 1.5 1994/01/14 14:09:49 daf Exp $
 *  $Log: iframe.c,v $
 * Revision 1.5  1994/01/14  14:09:49  daf
 * Removed calls to exit().
 *
 * Revision 1.4  94/01/11  22:54:09  daf
 * Modified for PC compatibility
 * .\
 * 
 * Revision 1.3  1994/01/11  21:46:53  daf
 * Modified for PC compatibility
 *
 * Revision 1.2  1994/01/07  17:27:06  daf
 * Modified for use as .mex file.
 *
 * Revision 1.6  1993/07/22  22:23:43  keving
 * nothing
 *
 * Revision 1.5  1993/06/30  20:06:09  keving
 * nothing
 *
 * Revision 1.4  1993/06/03  21:08:08  keving
 * nothing
 *
 * Revision 1.3  1993/03/04  22:24:06  keving
 * nothing
 *
 * Revision 1.2  1993/02/19  18:10:02  keving
 * nothing
 *
 * Revision 1.1  1993/02/18  22:56:39  keving
 * nothing
 *
 *
 */


/*==============*
 * HEADER FILES *
 *==============*/

/*#include <sys/times.h>*/
#include <sys/types.h>
#include "all.h"
#include "mtypes.h"
#include "frames.h"
#include "prototyp.h"
#include "mpeg.h"
#include "param.h"
#include "mheaders.h"
#include "fsize.h"
#include "parallel.h"
#include "postdct.h"
#include "mex.h"     /* needed for mexErrMsgTxt */


/*==================*
 * STATIC VARIABLES *
 *==================*/

static int numBlocks = 0;
static int numBits;
static int numFrames = 0;
static int numFrameBits = 0;
static int32 totalTime = 0;
static float	totalSNR = 0.0;
static float	totalPSNR = 0.0;


/*==================*
 * GLOBAL VARIABLES *
 *==================*/

int	qscaleI;
int	slicesPerFrame;
int	blocksPerSlice;
int	fCode;
boolean	printSNR = FALSE;
boolean	decodeRefFrames = FALSE;


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/


/*===========================================================================*
 *
 * SetFCode
 *
 *	set the forward_f_code and backward_f_code according to the search
 *	range.  Must be called AFTER pixelFullSearch and searchRange have
 *	been initialized.  Irrelevant for I-frames, but computation is
 *	negligible (done only once, as well)
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    fCode
 *
 *===========================================================================*/
void
SetFCode()
{
    int	    range;

    if ( pixelFullSearch ) {
	range = searchRange;
    } else {
	range = searchRange*2;
    }

    if ( range < 256 ) {
	if ( range < 64 ) {
	    if ( range < 32 ) {
		fCode = 1;
	    } else {
		fCode = 2;
	    }
	} else {
	    if ( range < 128 ) {
		fCode = 3;
	    } else {
		fCode = 4;
	    }
	}
    } else {
	if ( range < 1024 ) {
	    if ( range < 512 ) {
		fCode = 5;
	    } else {
		fCode = 6;
	    }
	} else {
	    if ( range < 2048 ) {
		fCode = 7;
	    } else {
		mexErrMsgTxt("Error: invalid search range.");
	    }
	}
    }
}


/*===========================================================================*
 *
 * SetSlicesPerFrame
 *
 *	set the number of slices per frame
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    slicesPerFrame
 *
 *===========================================================================*/
void
SetSlicesPerFrame(number)
    int number;
{
    slicesPerFrame = number;
}


/*===========================================================================*
 *
 * SetBlocksPerSlice
 *
 *	set the number of blocks per slice, based on slicesPerFrame
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    blocksPerSlice
 *
 *===========================================================================*/
void
SetBlocksPerSlice()
{
    int	    totalBlocks;

    totalBlocks = (Fsize_y/16)*(Fsize_x/16);

    if ( slicesPerFrame > totalBlocks ) {
	blocksPerSlice = 1;
    } else {
	blocksPerSlice = totalBlocks/slicesPerFrame;
    }
}


/*===========================================================================*
 *
 * SetIQScale
 *
 *	set the I-frame Q-scale
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    qscaleI
 *
 *===========================================================================*/
void
SetIQScale(qI)
int qI;
{
    qscaleI = qI;
}


/*===========================================================================*
 *
 * GenIFrame
 *
 *	generate an I-frame; appends result to bb
 *
 * RETURNS:	I-frame appended to bb
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
GenIFrame(bb, current)
    BitBucket *bb;
    MpegFrame *current;
{
    register int x, y;
    register int index;
    FlatBlock	fb[6];
    Block	dec[6];
    int32 y_dc_pred, cr_dc_pred, cb_dc_pred;
    int totalBits;
    int	totalFrameBits;
/*
    struct tms timeBuffer;
    int32    startTime, endTime;
*/
    int	    frameBlocks;
    float   snr[3], psnr[3];

    /* set-up for statistics */
    numFrames++;
    totalFrameBits = bb->cumulativeBits;
/*
    times(&timeBuffer);
    startTime = timeBuffer.tms_utime + timeBuffer.tms_stime;
*/

    Frame_AllocBlocks(current);
    BlockifyFrame(current);

    DBG_PRINT(("Generating iframe\n"));

    Mhead_GenPictureHeader(bb, I_FRAME, current->id, fCode);
    Mhead_GenSliceHeader(bb, 1, qscaleI, NULL, 0);

    if ( referenceFrame == DECODED_FRAME ) {
	Frame_AllocDecoded(current, TRUE);
    } else if ( printSNR ) {
	Frame_AllocDecoded(current, FALSE);
    }

    y_dc_pred = cr_dc_pred = cb_dc_pred = 128;
    totalBits = bb->cumulativeBits;
    frameBlocks = 0;
    for (y = 0; y < Fsize_y / 8; y += 2) {
	for (x = 0; x < Fsize_x / 8; x += 2) {
	    /* DCT this macroblock */
	    mp_fwd_dct_block(current->y_blocks[y][x]);
	    mp_fwd_dct_block(current->y_blocks[y][x+1]);
	    mp_fwd_dct_block(current->y_blocks[y+1][x]);
	    mp_fwd_dct_block(current->y_blocks[y+1][x+1]);
	    mp_fwd_dct_block(current->cr_blocks[y>>1][x>>1]);
	    mp_fwd_dct_block(current->cb_blocks[y>>1][x>>1]);

	    if ( (frameBlocks % blocksPerSlice == 0) && (frameBlocks != 0) ) {
		/* create a new slice */
		Mhead_GenSliceEnder(bb);
		Mhead_GenSliceHeader(bb, 1+(y/2), qscaleI, NULL, 0);
		y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

		GEN_I_BLOCK(I_FRAME, current, bb, 1+(x/2), qscaleI);
	    } else {
		GEN_I_BLOCK(I_FRAME, current, bb, 1, qscaleI);
	    }

	    if ( decodeRefFrames ) {
		/* need to decode block we just encoded */
		Mpost_UnQuantZigBlock(fb[0], dec[0], qscaleI, TRUE);
		Mpost_UnQuantZigBlock(fb[1], dec[1], qscaleI, TRUE);
		Mpost_UnQuantZigBlock(fb[2], dec[2], qscaleI, TRUE);
		Mpost_UnQuantZigBlock(fb[3], dec[3], qscaleI, TRUE);
		Mpost_UnQuantZigBlock(fb[4], dec[4], qscaleI, TRUE);
		Mpost_UnQuantZigBlock(fb[5], dec[5], qscaleI, TRUE);

		/* now, reverse the DCT transform */
		for ( index = 0; index < 6; index++ ) {
		    j_rev_dct((int16 *)dec[index]);		
		}

		/* now, unblockify */
		BlockToData(current->decoded_y, dec[0], y, x);
		BlockToData(current->decoded_y, dec[1], y, x+1);
		BlockToData(current->decoded_y, dec[2], y+1, x);
		BlockToData(current->decoded_y, dec[3], y+1, x+1);
		BlockToData(current->decoded_cb, dec[4], y>>1, x>>1);
		BlockToData(current->decoded_cr, dec[5], y>>1, x>>1);
	    }

	    numBlocks++;
	    frameBlocks++;
	}
    }

    if ( printSNR ) {
        ComputeSNR(current->orig_y, current->decoded_y, Fsize_y, Fsize_x,
		   &snr[0], &psnr[0]);
        ComputeSNR(current->orig_cb, current->decoded_cb, Fsize_y/2, Fsize_x/2,
		   &snr[1], &psnr[1]);
        ComputeSNR(current->orig_cr, current->decoded_cr, Fsize_y/2, Fsize_x/2,
		   &snr[2], &psnr[2]);

	totalSNR += snr[0];
	totalPSNR += psnr[0];
    }

/*
    if ( (referenceFrame == DECODED_FRAME) && NonLocalRefFrame(current->id) ) {
	if ( remoteIO ) {
	    SendDecodedFrame(current);
	} else {
	    WriteDecodedFrame(current);
	}

	* now, tell decode server it is ready *
	NotifyDecodeServerReady(current->id);
    }
*/

    numBits += (bb->cumulativeBits-totalBits);

    DBG_PRINT(("End of frame\n"));

    Mhead_GenSliceEnder(bb);

/*
    times(&timeBuffer);
    endTime = timeBuffer.tms_utime + timeBuffer.tms_stime;
    totalTime += (endTime-startTime);
*/

    numFrameBits += (bb->cumulativeBits-totalFrameBits);

/*
    if ( (! childProcess) && frameSummary ) {
	fprintf(stdout, "FRAME %d (I):  %ld seconds\n", 
		current->id, (long)((endTime-startTime)/60));
	if ( printSNR ) {
	    fprintf(stdout, "FRAME %d:  SNR:  %.1f\t%.1f\t%.1f\tPSNR:  %.1f\t%.1f\t%.1f\n",
		    current->id, snr[0], snr[1], snr[2],
		    psnr[0], psnr[1], psnr[2]);
	}
    }
*/
}


/*===========================================================================*
 *
 * ResetIFrameStats
 *
 *	reset the I-frame statistics
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
ResetIFrameStats()
{
    numBlocks = 0;
    numBits = 0;
    numFrames = 0;
    numFrameBits = 0;
    totalTime = 0;
}


/*===========================================================================*
 *
 * ShowIFrameSummary
 *
 *	prints out statistics on all I-frames
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
void
ShowIFrameSummary(inputFrameBits, totalBits, fpointer)
    int inputFrameBits;
    int32 totalBits;
    FILE *fpointer;
{
    if ( numFrames == 0 ) {
	return;
    }

    fprintf(fpointer, "-------------------------\n");
    fprintf(fpointer, "*****I FRAME SUMMARY*****\n");
    fprintf(fpointer, "-------------------------\n");

    fprintf(fpointer, "  Blocks:    %5d     (%6d bits)     (%5d bpb)\n",
	    numBlocks, numBits, numBits/numBlocks);
    fprintf(fpointer, "  Frames:    %5d     (%6d bits)     (%5d bpf)     (%2.1f%% of total)\n",
	    numFrames, numFrameBits, numFrameBits/numFrames,
	    100.0*(float)numFrameBits/(float)totalBits);
    fprintf(fpointer, "  Compression:  %3d:1\n",
	    numFrames*inputFrameBits/numFrameBits);
    if ( printSNR )
	fprintf(fpointer, "  Avg Y SNR/PSNR:  %.1f     %.1f\n",
		totalSNR/(float)numFrames, totalPSNR/(float)numFrames);
    fprintf(fpointer, "  Seconds:  %9ld     (%9ld spf)     (%9ld bps)\n",
	    (long)(totalTime/60), (long)(totalTime/(60*numFrames)),
	    (long)(60.0*(float)numFrames*(float)inputFrameBits/(float)totalTime));
}
*/


/*===========================================================================*
 *
 * EstimateSecondsPerIFrame
 *
 *	estimates the number of seconds required per I-frame
 *
 * RETURNS:	seconds (floating point value)
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
float
EstimateSecondsPerIFrame()
{
    return (float)totalTime/(60.0*(float)numFrames);
}
*/


/*===========================================================================*
 *
 * EncodeYDC
 *
 *	Encode the DC portion of a DCT of a luminance block
 *
 * RETURNS:	result appended to bb
 *
 * SIDE EFFECTS:    updates pred_term
 *
 *===========================================================================*/
void
EncodeYDC(dc_term, pred_term, bb)
    int32 dc_term;
    int32 *pred_term;
    BitBucket *bb;
{
    int ydiff, ydiff_abs;

    ydiff = (dc_term - (*pred_term));
    if (ydiff > 255) {
	ydiff = 255;
    } else if (ydiff < -255) {
	ydiff = -255;
    }

    ydiff_abs = ABS(ydiff);

    if (ydiff_abs == 0) {
	Bitio_Write(bb, 0x4, 3);
    } else if (ydiff_abs & 0x80) {
	Bitio_Write(bb, 0x7e, 7);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 8);
	} else
	    Bitio_Write(bb, ~ydiff_abs, 8);
    } else if (ydiff_abs & 0x40) {
	Bitio_Write(bb, 0x3e, 6);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 7);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 7);
	}
    } else if (ydiff_abs & 0x20) {
	Bitio_Write(bb, 0x1e, 5);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 6);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 6);
	}
    } else if (ydiff_abs & 0x10) {
	Bitio_Write(bb, 0xe, 4);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 5);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 5);
	}
    } else if (ydiff_abs & 0x08) {
	Bitio_Write(bb, 0x6, 3);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 4);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 4);
	}
    } else if (ydiff_abs & 0x04) {
	Bitio_Write(bb, 0x5, 3);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 3);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 3);
	}
    } else if (ydiff_abs & 0x02) {
	Bitio_Write(bb, 0x1, 2);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 2);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 2);
	}
    } else if (ydiff_abs & 0x01) {
	Bitio_Write(bb, 0x0, 2);
	if (ydiff > 0) {
	    Bitio_Write(bb, ydiff_abs, 1);
	} else {
	    Bitio_Write(bb, ~ydiff_abs, 1);
	}
    } else {
	mexErrMsgTxt("ERROR in EncodeYDC");
    }

    (*pred_term) += ydiff;
}


/*===========================================================================*
 *
 * EncodeCDC
 *
 *	Encode the DC portion of a DCT of a chrominance block
 *
 * RETURNS:	result appended to bb
 *
 * SIDE EFFECTS:    updates pred_term
 *
 *===========================================================================*/
void
EncodeCDC(dc_term, pred_term, bb)
    int32 dc_term;
    int32 *pred_term;
    BitBucket *bb;
{
    int cdiff, cdiff_abs;

    cdiff = (dc_term - (*pred_term));
    if (cdiff > 255) {
	cdiff = 255;
    } else if (cdiff < -255) {
	cdiff = -255;
    }

    cdiff_abs = ABS(cdiff);

    if (cdiff_abs == 0) {
	Bitio_Write(bb, 0x0, 2);
    } else if (cdiff_abs & 0x80) {
	Bitio_Write(bb, 0xfe, 8);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 8);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 8);
	}
    } else if (cdiff_abs & 0x40) {
	Bitio_Write(bb, 0x7e, 7);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 7);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 7);
	}
    } else if (cdiff_abs & 0x20) {
	Bitio_Write(bb, 0x3e, 6);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 6);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 6);
	}
    } else if (cdiff_abs & 0x10) {
	Bitio_Write(bb, 0x1e, 5);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 5);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 5);
	}
    } else if (cdiff_abs & 0x08) {
	Bitio_Write(bb, 0xe, 4);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 4);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 4);
	}
    } else if (cdiff_abs & 0x04) {
	Bitio_Write(bb, 0x6, 3);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 3);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 3);
	}
    } else if (cdiff_abs & 0x02) {
	Bitio_Write(bb, 0x2, 2);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 2);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 2);
	}
    } else if (cdiff_abs & 0x01) {
	Bitio_Write(bb, 0x1, 2);
	if (cdiff > 0) {
	    Bitio_Write(bb, cdiff_abs, 1);
	} else {
	    Bitio_Write(bb, ~cdiff_abs, 1);
	}
    } else {
	mexErrMsgTxt("ERROR in EncodeCDC");
    }

    (*pred_term) += cdiff;
}


void
ComputeSNR(origData, newData, ySize, xSize, snr, psnr)
     register uint8 **origData;
     register uint8 **newData;
     int ySize;
     int xSize;
     float *snr;
     float *psnr;
{
    register int32	tempInt;
    register int y, x;
    int32	varOrig = 0;
    int32	varDiff = 0;

    /* compute Y-plane SNR */
    for ( y = 0; y < ySize; y++ ) {
	for ( x = 0; x < xSize; x++ ) {
	    tempInt = origData[y][x];
	    varOrig += (tempInt*tempInt);
	}
    }

    for ( y = 0; y < ySize; y++ ) {
	for ( x = 0; x < xSize; x++ ) {
	    tempInt = (origData[y][x]-newData[y][x]);
	    varDiff += (tempInt*tempInt);
	}
    }

    *snr = 10.0*log10((double)varOrig/(double)varDiff);
    *psnr = 20.0*log10(255.0/sqrt((double)varDiff/(double)(ySize*xSize)));
}


void
WriteDecodedFrame(frame)
    MpegFrame *frame;
{
    FILE    *fpointer;
    char    fileName[256];
    int	width, height;
    register int y;

    /* need to save decoded frame to disk because it might be accessed
       by another process */

    width = Fsize_x;
    height = Fsize_y;

    sprintf(fileName, "%s.decoded.%d", outputFileName, frame->id);
    fprintf(stdout, "outputting to %s\n", fileName);
    fflush(stdout);

    fpointer = fopen(fileName, "w");

	for ( y = 0; y < height; y++ ) {
	    fwrite(frame->decoded_y[y], 1, width, fpointer);
	}

	for (y = 0; y < height / 2; y++) {			/* U */
	    fwrite(frame->decoded_cb[y], 1, width / 2, fpointer);
	}

	for (y = 0; y < height / 2; y++) {			/* V */
	    fwrite(frame->decoded_cr[y], 1, width / 2, fpointer);
	}

    fclose(fpointer);
}










