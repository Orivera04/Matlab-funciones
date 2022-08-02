/*===========================================================================*
 * bframe.c								     *
 *									     *
 *	Procedures concerned with the B-frame encoding			     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	GenBFrame							     *
 *	ResetBFrameStats						     *
 *	ShowBFrameSummary						     *
 *	EstimateSecondsPerBFrame					     *
 *	ComputeBMotionLumBlock						     *
 *	SetBQScale							     *
 *	GetBQScale							     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/bframe.c,v 1.4 1994/01/11 22:54:23 daf Exp $
 *  $Log: bframe.c,v $
 * Revision 1.4  1994/01/11  22:54:23  daf
 * Modified for PC compatibility
 *
 * Revision 1.3  1994/01/11  21:45:06  daf
 * Modified for PC compatibility
 *
 * Revision 1.2  1994/01/07  17:28:26  daf
 * Modified for use as .mex file.
 *
 * Revision 1.5  1993/07/30  19:24:04  keving
 * nothing
 *
 * Revision 1.4  1993/07/22  22:23:43  keving
 * nothing
 *
 * Revision 1.3  1993/06/30  20:06:09  keving
 * nothing
 *
 * Revision 1.2  1993/06/03  21:08:08  keving
 * nothing
 *
 * Revision 1.1  1993/02/19  19:14:28  keving
 * nothing
 *
 */


/*==============*
 * HEADER FILES *
 *==============*/

#include "all.h"
/*#include <sys/times.h>*/
#include <sys/types.h>
#include "mtypes.h"
#include "bitio.h"
#include "frames.h"
#include "prototyp.h"
#include "fsize.h"
#include "param.h"
#include "mheaders.h"
#include "postdct.h"


/*==================*
 * STATIC VARIABLES *
 *==================*/

static int numBIBlocks = 0;
static int numBBBlocks = 0;
static int numBSkipped = 0;
static int numBIBits = 0;
static int numBBBits = 0;
static int numFrames = 0;
static int numFrameBits = 0;
static int32 totalTime = 0;
static int qscaleB;
static float    totalSNR = 0.0;
static float	totalPSNR = 0.0;


/*===============================*
 * INTERNAL PROCEDURE prototypes *
 *===============================*/

static boolean	MotionSufficient _ANSI_ARGS_((LumBlock currBlock, MpegFrame *prev, MpegFrame *next,
			 int by, int bx, int mode, int fmy, int fmx,
			 int bmy, int bmx));
static void	ComputeBMotionBlock _ANSI_ARGS_((MpegFrame *prev, MpegFrame *next,
			       int by, int bx, int mode, int fmy, int fmx,
			       int bmy, int bmx, Block motionBlock, int type));
static void	ComputeBDiffDCTs _ANSI_ARGS_((MpegFrame *current, MpegFrame *prev, MpegFrame *next,
			 int by, int bx, int mode, int fmy, int fmx, 
			 int bmy, int bmx, int pattern));
static boolean	DoBIntraCode _ANSI_ARGS_((MpegFrame *current, MpegFrame *prev, MpegFrame *next,
		     int by, int bx, int mode, int fmy, int fmx, int bmy,
		     int bmx));


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * GenBFrame
 *
 *	generate a B-frame from previous and next frames, adding the result
 *	to the given bit bucket
 *
 * RETURNS:	frame appended to bb
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
GenBFrame(bb, curr, prev, next)
    BitBucket *bb;
    MpegFrame *curr;
    MpegFrame *prev;
    MpegFrame *next;
{
    FlatBlock fba[6], fb[6];
    Block	dec[6];
    int32 y_dc_pred, cr_dc_pred, cb_dc_pred;
    int x, y;
    int	fMotionX = 0, fMotionY = 0;
    int bMotionX = 0, bMotionY = 0;
    int	oldFMotionX = 0, oldFMotionY = 0;
    int oldBMotionX = 0, oldBMotionY = 0;
    int	oldMode = MOTION_FORWARD;
    int	mode = MOTION_FORWARD;
    int	offsetX, offsetY;
    int	tempX, tempY;
    int	fMotionXrem = 0, fMotionXquot = 0;
    int	fMotionYrem = 0, fMotionYquot = 0;
    int	bMotionXrem = 0, bMotionXquot = 0;
    int	bMotionYrem = 0, bMotionYquot = 0;
    int	pattern;
    int	numIBlocks = 0;
    int numBBlocks = 0;
    int numSkipped = 0;
    int	numIBits = 0;
    int	numBBits = 0;
    int	totalBits;
    int	mbAddrInc = 1;
    boolean	lastIntra = TRUE;
    int	    motionForward, motionBackward;
    int	    totalFrameBits;
/*
    struct tms timeBuffer;
    int32    startTime, endTime;
*/
    int lastX, lastY;
    int lastBlockX, lastBlockY;
    register int ix, iy;
    LumBlock currentBlock;
    int fy, fx;
    boolean	result;
    int	frameBlocks;
    int	    slicePos;
    float   snr[3], psnr[3];
    int	    index;

    numFrames++;
    totalFrameBits = bb->cumulativeBits;
/*
    times(&timeBuffer);
    startTime = timeBuffer.tms_utime + timeBuffer.tms_stime;
*/

    Mhead_GenPictureHeader(bb, B_FRAME, curr->id, fCode);
    Mhead_GenSliceHeader(bb, 1, qscaleB, NULL, 0);

    Frame_AllocBlocks(curr);
    BlockifyFrame(curr);

    if ( printSNR ) {
	Frame_AllocDecoded(curr, FALSE);
    }

    /* for I-blocks */
    y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

    totalBits = bb->cumulativeBits;

    if ( ! pixelFullSearch ) {
	if ( ! prev->halfComputed ) {
	    ComputeHalfPixelData(prev);
	}

	if ( ! next->halfComputed ) {
	    ComputeHalfPixelData(next);
	}
    }

    lastBlockX = Fsize_x/8;
    lastBlockY = Fsize_y/8;
    lastX = lastBlockX-2;
    lastY = lastBlockY-2;
    frameBlocks = 0;

    for (y = 0; y < lastBlockY; y += 2) {
	for (x = 0; x < lastBlockX; x += 2) {
	    slicePos = (frameBlocks % blocksPerSlice);

	    if ( (slicePos == 0) && (frameBlocks != 0) ) {
		Mhead_GenSliceEnder(bb);
		Mhead_GenSliceHeader(bb, 1+(y/2), qscaleB, NULL, 0);

		/* reset everything */
		oldFMotionX = 0;	oldFMotionY = 0;
		oldBMotionX = 0;	oldBMotionY = 0;
		oldMode = MOTION_FORWARD;
		lastIntra = TRUE;
		y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

		mbAddrInc = 1+(x/2);
	    }

	    frameBlocks++;

	    /* compute currentBlock */
	    BLOCK_TO_FRAME_COORD(y, x, fy, fx);
	    for ( iy = 0; iy < 16; iy++ ) {
		for ( ix = 0; ix < 16; ix++ ) {
		    currentBlock[iy][ix] = (int16)curr->orig_y[fy+iy][fx+ix];
		}
	    }

/* STEP 1:  Select Forward, Backward, or Interpolated motion vectors */
	    /* see if old motion is good enough */
	    /* but force last block to be non-skipped */
	    /* can only skip if:
	     *     1)  not the last block in frame
	     *     2)  not the last block in slice
	     *     3)  not the first block in slice
	     *	   4)  previous block was not intra-coded
	     */
	    if ( ((y < lastY) || (x < lastX)) &&
		 (slicePos+1 != blocksPerSlice) &&
		 (slicePos != 0) &&
		 (! lastIntra) ) {
		if ( pixelFullSearch ) {
		    result = MotionSufficient(currentBlock, prev, next, y, x, oldMode,
					      2*oldFMotionY, 2*oldFMotionX,
					      2*oldBMotionY, 2*oldBMotionX);
		} else {
		    result = MotionSufficient(currentBlock, prev, next, y, x, oldMode,
				      oldFMotionY, oldFMotionX,
				      oldBMotionY, oldBMotionX);
		}
	    } else {
		result = FALSE;
	    }

	    if ( result ) {
		/* skipped macro block */
		mbAddrInc++;
		numSkipped++;

		/* decode skipped block */
		if ( printSNR ) {
		    int	fmy, fmx, bmy, bmx;

		    memset((char *)dec[0], 0, sizeof(Block)); 
		    memset((char *)dec[1], 0, sizeof(Block)); 
		    memset((char *)dec[2], 0, sizeof(Block)); 
		    memset((char *)dec[3], 0, sizeof(Block)); 
		    memset((char *)dec[4], 0, sizeof(Block)); 
		    memset((char *)dec[5], 0, sizeof(Block)); 

		    if ( pixelFullSearch ) {
			fmy = 2*oldFMotionY;
			fmx = 2*oldFMotionX;
			bmy = 2*oldBMotionY;
			bmx = 2*oldBMotionX;
		    } else {
			fmy = oldFMotionY;
			fmx = oldFMotionX;
			bmy = oldBMotionY;
			bmx = oldBMotionX;
		    }

		    /* now add the motion block */
		    AddBMotionBlock(dec[0], prev->decoded_y,
				    next->decoded_y, y, x, mode,
				    fmy, fmx, bmy, bmx);
		    AddBMotionBlock(dec[1], prev->decoded_y,
				    next->decoded_y, y, x+1, mode,
				    fmy, fmx, bmy, bmx);
		    AddBMotionBlock(dec[2], prev->decoded_y,
				    next->decoded_y, y+1, x, mode,
				    fmy, fmx, bmy, bmx);
		    AddBMotionBlock(dec[3], prev->decoded_y,
				    next->decoded_y, y+1, x+1, mode,
				    fmy, fmx, bmy, bmx);
		    AddBMotionBlock(dec[4], prev->decoded_cb,
				    next->decoded_cb, y>>1, x>>1, mode,
				    fmy/2, fmx/2,
				    bmy/2, bmx/2);
		    AddBMotionBlock(dec[5], prev->decoded_cr,
				    next->decoded_cb, y>>1, x>>1, mode,
				    fmy/2, fmx/2,
				    bmy/2, bmx/2);

		    /* now, unblockify */
		    BlockToData(curr->decoded_y, dec[0], y, x);
		    BlockToData(curr->decoded_y, dec[1], y, x+1);
		    BlockToData(curr->decoded_y, dec[2], y+1, x);
		    BlockToData(curr->decoded_y, dec[3], y+1, x+1);
		    BlockToData(curr->decoded_cb, dec[4], y>>1, x>>1);
		    BlockToData(curr->decoded_cr, dec[5], y>>1, x>>1);
		}
	    } else {
		/* do bsearch */
		mode = BMotionSearch(currentBlock, prev, next, y, x, &fMotionY,
				     &fMotionX, &bMotionY, &bMotionX, mode);

		pattern = 63;

/* STEP 2:  INTRA OR NON-INTRA CODING */
		if ( DoBIntraCode(curr, prev, next, y, x, mode, fMotionY,
				  fMotionX, bMotionY, bMotionX) ) {
		    /* output I-block inside a P-frame */
		    numIBlocks++;

		    /* calculate forward dct's */
		    mp_fwd_dct_block(curr->y_blocks[y][x]);
		    mp_fwd_dct_block(curr->y_blocks[y][x+1]);
		    mp_fwd_dct_block(curr->y_blocks[y+1][x]);
		    mp_fwd_dct_block(curr->y_blocks[y+1][x+1]);
		    mp_fwd_dct_block(curr->cb_blocks[y >> 1][x >> 1]);
		    mp_fwd_dct_block(curr->cr_blocks[y >> 1][x >> 1]);

		    GEN_I_BLOCK(B_FRAME, curr, bb, mbAddrInc, qscaleB);

		    mbAddrInc = 1;

		    numIBits += (bb->cumulativeBits-totalBits);
		    totalBits = bb->cumulativeBits;

		    /* reset because intra-coded */
		    oldFMotionX = 0;		oldFMotionY = 0;
		    oldBMotionX = 0;		oldBMotionY = 0;
		    oldMode = MOTION_FORWARD;
		    lastIntra = TRUE;

		    if ( printSNR ) {
			/* need to decode block we just encoded */
			Mpost_UnQuantZigBlock(fb[0], dec[0], qscaleB, TRUE);
			Mpost_UnQuantZigBlock(fb[1], dec[1], qscaleB, TRUE);
			Mpost_UnQuantZigBlock(fb[2], dec[2], qscaleB, TRUE);
			Mpost_UnQuantZigBlock(fb[3], dec[3], qscaleB, TRUE);
			Mpost_UnQuantZigBlock(fb[4], dec[4], qscaleB, TRUE);
			Mpost_UnQuantZigBlock(fb[5], dec[5], qscaleB, TRUE);

			/* now, reverse the DCT transform */
			for ( index = 0; index < 6; index++ ) {
			    j_rev_dct((int16 *)dec[index]);
			}

			/* now, unblockify */
			BlockToData(curr->decoded_y, dec[0], y, x);
			BlockToData(curr->decoded_y, dec[1], y, x+1);
			BlockToData(curr->decoded_y, dec[2], y+1, x);
			BlockToData(curr->decoded_y, dec[3], y+1, x+1);
			BlockToData(curr->decoded_cb, dec[4], y>>1, x>>1);
			BlockToData(curr->decoded_cr, dec[5], y>>1, x>>1);
		    }
		} else {
/* STEP 3:  CODED OR NOT CODED */		    
		    /* make special cases for (0,0) motion???? */
		    lastIntra = FALSE;
		    /* USE MOTION VECTORS */
		    numBBlocks++;

		    /* reset because non-intra-coded */
		    y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

		    ComputeBDiffDCTs(curr, prev, next, y, x, mode, fMotionY,
				     fMotionX, bMotionY, bMotionX, pattern);

		    if ( pixelFullSearch ) {
			fMotionX /= 2;	    fMotionY /= 2;
			bMotionX /= 2;	    bMotionY /= 2;
		    }

/* should really check to see if same motion as previous block, and see if
pattern is 0, then skip it! */

 		    motionForward = ((mode != MOTION_BACKWARD) ? 1 : 0);
		    motionBackward = ((mode != MOTION_FORWARD) ? 1 : 0);

		    if ( motionForward ) {
			/* transform the fMotion vector into the appropriate values */
			offsetX = fMotionX - oldFMotionX;
			offsetY = fMotionY - oldFMotionY;

			ENCODE_MOTION_VECTOR(offsetX, offsetY, fMotionXquot,
					 fMotionYquot, fMotionXrem, fMotionYrem,
					 FORW_F);

			oldFMotionX = fMotionX;		oldFMotionY = fMotionY;
		    }

		    if ( motionBackward ) {
			/* transform the bMotion vector into the appropriate values */
			offsetX = bMotionX - oldBMotionX;
			offsetY = bMotionY - oldBMotionY;
			ENCODE_MOTION_VECTOR(offsetX, offsetY, bMotionXquot,
					 bMotionYquot, bMotionXrem, bMotionYrem,
					 BACK_F);

			oldBMotionX = bMotionX;		oldBMotionY = bMotionY;
		    }

		    oldMode = mode;

		    if ( pixelFullSearch ) {
			fMotionX *= 2;	fMotionY *= 2;
			bMotionX *= 2;	bMotionY *= 2;
		    }

		/* create flat blocks and update pattern if necessary */
	if ( (pattern & 0x20) && 
	     (! Mpost_QuantZigBlock(curr->y_blocks[y][x], fba[0],
				   qscaleB, FALSE)) ) {
		pattern ^= 0x20;
	}
	if ( (pattern & 0x10) && 
	     (! Mpost_QuantZigBlock(curr->y_blocks[y][x+1], fba[1],
				   qscaleB, FALSE)) ) {
		pattern ^= 0x10;
	}
	if ( (pattern & 0x8) && 
	     (! Mpost_QuantZigBlock(curr->y_blocks[y+1][x], fba[2],
				   qscaleB, FALSE)) ) {
		pattern ^= 0x8;
	}
	if ( (pattern & 0x4) && 
	     (! Mpost_QuantZigBlock(curr->y_blocks[y+1][x+1], fba[3],
				   qscaleB, FALSE)) ) {
		pattern ^= 0x4;
	}
	if ( (pattern & 0x2) && 
	     (! Mpost_QuantZigBlock(curr->cb_blocks[y >> 1][x >> 1], fba[4],
				   qscaleB, FALSE)) ) {
		pattern ^= 0x2;
	}
	if ( (pattern & 0x1) && 
	     (! Mpost_QuantZigBlock(curr->cr_blocks[y >> 1][x >> 1], fba[5],
				   qscaleB, FALSE)) ) {
		pattern ^= 0x1;
	}

		    if ( printSNR ) {
			if ( pattern & 0x20 ) {
			    Mpost_UnQuantZigBlock(fba[0], dec[0], qscaleB, FALSE);
			} else {
			    memset((char *)dec[0], 0, sizeof(Block));
			}
			if ( pattern & 0x10 ) {
			    Mpost_UnQuantZigBlock(fba[1], dec[1], qscaleB, FALSE);
			} else {
			    memset((char *)dec[1], 0, sizeof(Block));
			}
			if ( pattern & 0x8 ) {
			    Mpost_UnQuantZigBlock(fba[2], dec[2], qscaleB, FALSE);
			} else {
			    memset((char *)dec[2], 0, sizeof(Block));
			}
			if ( pattern & 0x4 ) {
			    Mpost_UnQuantZigBlock(fba[3], dec[3], qscaleB, FALSE);
			} else {
			    memset((char *)dec[3], 0, sizeof(Block));
			}
			if ( pattern & 0x2 ) {
			    Mpost_UnQuantZigBlock(fba[4], dec[4], qscaleB, FALSE);
			} else {
			    memset((char *)dec[4], 0, sizeof(Block));
			}
			if ( pattern & 0x1 ) {
			    Mpost_UnQuantZigBlock(fba[5], dec[5], qscaleB, FALSE);
			} else {
			    memset((char *)dec[5], 0, sizeof(Block));
			}

			/* now, reverse the DCT transform */
			for ( index = 0; index < 6; index++ ) {
			    if ( GET_ITH_BIT(pattern, 5-index) ) {
				j_rev_dct((int16 *)dec[index]);
			    }
			}

			/* now add the motion block */
			AddBMotionBlock(dec[0], prev->decoded_y,
					next->decoded_y, y, x, mode,
					fMotionY, fMotionX, bMotionY, bMotionX);
			AddBMotionBlock(dec[1], prev->decoded_y,
					next->decoded_y, y, x+1, mode,
					fMotionY, fMotionX, bMotionY, bMotionX);
			AddBMotionBlock(dec[2], prev->decoded_y,
					next->decoded_y, y+1, x, mode,
					fMotionY, fMotionX, bMotionY, bMotionX);
			AddBMotionBlock(dec[3], prev->decoded_y,
					next->decoded_y, y+1, x+1, mode,
					fMotionY, fMotionX, bMotionY, bMotionX);
			AddBMotionBlock(dec[4], prev->decoded_cb,
					next->decoded_cb, y>>1, x>>1, mode,
					fMotionY/2, fMotionX/2,
					bMotionY/2, bMotionX/2);
			AddBMotionBlock(dec[5], prev->decoded_cr,
					next->decoded_cr, y>>1, x>>1, mode,
					fMotionY/2, fMotionX/2,
					bMotionY/2, bMotionX/2);

			/* now, unblockify */
			BlockToData(curr->decoded_y, dec[0], y, x);
			BlockToData(curr->decoded_y, dec[1], y, x+1);
			BlockToData(curr->decoded_y, dec[2], y+1, x);
			BlockToData(curr->decoded_y, dec[3], y+1, x+1);
			BlockToData(curr->decoded_cb, dec[4], y>>1, x>>1);
			BlockToData(curr->decoded_cr, dec[5], y>>1, x>>1);
		    }

	    DBG_PRINT(("MB Header(%d,%d)\n", x, y));
	    Mhead_GenMBHeader(bb, 3 /* pict_code_type */, mbAddrInc /* addr_incr */,
		      0 /* mb_quant */, 0 /* q_scale */,
		      fCode /* forw_f_code */, fCode /* back_f_code */,
		      fMotionXrem /* horiz_forw_r */, fMotionYrem /* vert_forw_r */,
		      bMotionXrem /* horiz_back_r */, bMotionYrem /* vert_back_r */,
		      motionForward /* motion_forw */, fMotionXquot /* m_horiz_forw */,
		      fMotionYquot /* m_vert_forw */, motionBackward /* motion_back */,
		      bMotionXquot /* m_horiz_back */, bMotionYquot /* m_vert_back */,
		      pattern /* mb_pattern */, 0 /* mb_intra */);
		    mbAddrInc = 1;

		/* now output the difference */
		for ( tempX = 0; tempX < 6; tempX++ ) {
		    if ( GET_ITH_BIT(pattern, 5-tempX) ) {
			Mpost_RLEHuffPBlock(fba[tempX], bb);
		    }
		}

		    numBBits += (bb->cumulativeBits-totalBits);
		    totalBits = bb->cumulativeBits;
		}
	    }
	}
    }

    if ( printSNR ) {
        ComputeSNR(curr->orig_y, curr->decoded_y, Fsize_y, Fsize_x,
		   &snr[0], &psnr[0]);
        ComputeSNR(curr->orig_cb, curr->decoded_cb, Fsize_y/2, Fsize_x/2,
		   &snr[1], &psnr[1]);
        ComputeSNR(curr->orig_cr, curr->decoded_cr, Fsize_y/2, Fsize_x/2,
		   &snr[2], &psnr[2]);

	totalSNR += snr[0];
	totalPSNR += psnr[0];
    }

    Mhead_GenSliceEnder(bb);

/*
    times(&timeBuffer);
    endTime = timeBuffer.tms_utime + timeBuffer.tms_stime;
    totalTime += (endTime-startTime);
*/

/*
    if ( (! childProcess) && frameSummary ) {
	fprintf(stdout, "FRAME %d (B):  I BLOCKS:  %d;  B BLOCKS:  %d   SKIPPED:  %d (%ld seconds)\n",
		curr->id, numIBlocks, numBBlocks, numSkipped, (long)((endTime-startTime)/60));
	if ( printSNR )
	    fprintf(stdout, "FRAME %d:  SNR:  %.1f\t%.1f\t%.1f\tPSNR:  %.1f\t%.1f\t%.1f\n",
		    curr->id, snr[0], snr[1], snr[2],
		    psnr[0], psnr[1], psnr[2]);
    }
*/

    numFrameBits += (bb->cumulativeBits-totalFrameBits);
    numBIBlocks += numIBlocks;
    numBBBlocks += numBBlocks;
    numBSkipped += numSkipped;
    numBIBits += numIBits;
    numBBBits += numBBits;
}


/*===========================================================================*
 *
 * SetBQScale
 *
 *	set the B-frame Q-scale
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    qscaleB
 *
 *===========================================================================*/
void
SetBQScale(qB)
    int qB;
{
    qscaleB = qB;
}


/*===========================================================================*
 *
 * GetBQScale
 *
 *	get the B-frame Q-scale
 *
 * RETURNS:	the Q-scale
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
int
GetBQScale()
{
    return qscaleB;
}


/*===========================================================================*
 *
 * ResetBFrameStats
 *
 *	reset the B-frame stats
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
ResetBFrameStats()
{
    numBIBlocks = 0;
    numBBBlocks = 0;
    numBSkipped = 0;
    numBIBits = 0;
    numBBBits = 0;
    numFrames = 0;
    numFrameBits = 0;
    totalTime = 0;
}


/*===========================================================================*
 *
 * ShowBFrameSummary
 *
 *	print out statistics on all B-frames
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
void
ShowBFrameSummary(inputFrameBits, totalBits, fpointer)
    int inputFrameBits;
    int32 totalBits;
    FILE *fpointer;
{
    if ( numFrames == 0 ) {
	return;
    }

    fprintf(fpointer, "-------------------------\n");
    fprintf(fpointer, "*****B FRAME SUMMARY*****\n");
    fprintf(fpointer, "-------------------------\n");

    if ( numBIBlocks != 0 ) {
	fprintf(fpointer, "  I Blocks:  %5d     (%6d bits)     (%5d bpb)\n",
		numBIBlocks, numBIBits, numBIBits/numBIBlocks);
    } else {
	fprintf(fpointer, "  I Blocks:  %5d\n", 0);
    }

    if ( numBBBlocks != 0 ) {
	fprintf(fpointer, "  B Blocks:  %5d     (%6d bits)     (%5d bpb)\n",
		numBBBlocks, numBBBits, numBBBits/numBBBlocks);
    } else {
	fprintf(fpointer, "  B Blocks:  %5d\n", 0);
    }

    fprintf(fpointer, "  Skipped:   %5d\n", numBSkipped);

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
 * ComputeBMotionLumBlock
 *
 *	compute the luminance block resulting from motion compensation
 *
 * RETURNS:	motionBlock modified
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITION:	the motion vectors must be valid!
 *
 *===========================================================================*/
void
ComputeBMotionLumBlock(prev, next, by, bx, mode, fmy, fmx, bmy, bmx, motionBlock)
    MpegFrame *prev;
    MpegFrame *next;
    int by;
    int bx;
    int mode;
    int fmy;
    int fmx;
    int bmy;
    int bmx;
    LumBlock motionBlock;
{
    LumBlock	prevBlock, nextBlock;
    register int	y, x;

    switch(mode) {
	case MOTION_FORWARD:
	    ComputeMotionLumBlock(prev, by, bx, fmy, fmx, motionBlock);
	    break;
	case MOTION_BACKWARD:
	    ComputeMotionLumBlock(next, by, bx, bmy, bmx, motionBlock);
	    break;
	case MOTION_INTERPOLATE:
	    ComputeMotionLumBlock(prev, by, bx, fmy, fmx, prevBlock);
	    ComputeMotionLumBlock(next, by, bx, bmy, bmx, nextBlock);

	    for ( y = 0; y < 16; y++ ) {
		for ( x = 0; x < 16; x++ ) {
		    motionBlock[y][x] = (prevBlock[y][x]+nextBlock[y][x]+1)/2;
		}
	    }
	    break;
    }
}


/*===========================================================================*
 *
 * EstimateSecondsPerBFrame
 *
 *	estimate the seconds to compute a B-frame
 *
 * RETURNS:	the time, in seconds
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
float
EstimateSecondsPerBFrame()
{
    if ( numFrames == 0 ) {
	return 20.0;
    } else {
	return (float)totalTime/(60.0*(float)numFrames);
    }
}
*/


/*=====================*
 * INTERNAL PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * ComputeBMotionBlock
 *
 *	compute the block resulting from motion compensation
 *
 * RETURNS:	motionBlock is modified
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITION:	the motion vectors must be valid!
 *
 *===========================================================================*/
static void
ComputeBMotionBlock(prev, next, by, bx, mode, fmy, fmx, bmy, bmx, motionBlock, type)
    MpegFrame *prev;
    MpegFrame *next;
    int by;
    int bx;
    int mode;
    int fmy;
    int fmx;
    int bmy;
    int bmx;
    Block motionBlock;
    int type;
{
    Block	prevBlock, nextBlock;
    register int	y, x;

    switch(mode) {
	case MOTION_FORWARD:
	    if ( type == LUM_BLOCK ) {
		ComputeMotionBlock(prev->ref_y, by, bx, fmy, fmx, motionBlock);
	    } else if ( type == CB_BLOCK ) {
		ComputeMotionBlock(prev->ref_cb, by, bx, fmy, fmx, motionBlock);
	    } else if ( type == CR_BLOCK ) {
		ComputeMotionBlock(prev->ref_cr, by, bx, fmy, fmx, motionBlock);
	    }
	    break;
	case MOTION_BACKWARD:
	    if ( type == LUM_BLOCK ) {
		ComputeMotionBlock(next->ref_y, by, bx, bmy, bmx, motionBlock);
	    } else if ( type == CB_BLOCK ) {
		ComputeMotionBlock(next->ref_cb, by, bx, bmy, bmx, motionBlock);
	    } else if ( type == CR_BLOCK ) {
		ComputeMotionBlock(next->ref_cr, by, bx, bmy, bmx, motionBlock);
	    }
	    break;
	case MOTION_INTERPOLATE:
	    if ( type == LUM_BLOCK ) {
		ComputeMotionBlock(prev->ref_y, by, bx, fmy, fmx, prevBlock);
		ComputeMotionBlock(next->ref_y, by, bx, bmy, bmx, nextBlock);
	    } else if ( type == CB_BLOCK ) {
		ComputeMotionBlock(prev->ref_cb, by, bx, fmy, fmx, prevBlock);
		ComputeMotionBlock(next->ref_cb, by, bx, bmy, bmx, nextBlock);
	    } else if ( type == CR_BLOCK ) {
		ComputeMotionBlock(prev->ref_cr, by, bx, fmy, fmx, prevBlock);
		ComputeMotionBlock(next->ref_cr, by, bx, bmy, bmx, nextBlock);
	    }

	    for ( y = 0; y < 8; y++ ) {
		for ( x = 0; x < 8; x++ ) {
		    motionBlock[y][x] = (prevBlock[y][x]+nextBlock[y][x]+1)/2;
		}
	    }
	    break;
    }
}


/*===========================================================================*
 *
 * ComputeBDiffDCTs
 *
 *	compute the DCT of the error term
 *
 * RETURNS:	appropriate blocks of current will contain the DCTs
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITION:	the motion vectors must be valid!
 *
 *===========================================================================*/
static void
ComputeBDiffDCTs(current, prev, next, by, bx, mode, fmy, fmx, bmy, bmx, pattern)
    MpegFrame *current;
    MpegFrame *prev;
    MpegFrame *next;
    int by;
    int bx;
    int mode;
    int fmy;
    int fmx;
    int bmy;
    int bmx;
    int pattern;
{
    Block   motionBlock;

    if ( pattern & 0x20 ) {
	ComputeBMotionBlock(prev, next, by, bx, mode, fmy, fmx,
			    bmy, bmx, motionBlock, LUM_BLOCK);
	ComputeDiffDCTBlock(current->y_blocks[by][bx], motionBlock);
    }

    if ( pattern & 0x10 ) {
	ComputeBMotionBlock(prev, next, by, bx+1, mode, fmy, fmx,
			    bmy, bmx, motionBlock, LUM_BLOCK);
	ComputeDiffDCTBlock(current->y_blocks[by][bx+1], motionBlock);
    }

    if ( pattern & 0x8 ) {
	ComputeBMotionBlock(prev, next, by+1, bx, mode, fmy, fmx,
			    bmy, bmx, motionBlock, LUM_BLOCK);
	ComputeDiffDCTBlock(current->y_blocks[by+1][bx], motionBlock);
    }

    if ( pattern & 0x4 ) {
	ComputeBMotionBlock(prev, next, by+1, bx+1, mode, fmy, fmx,
			    bmy, bmx, motionBlock, LUM_BLOCK);
	ComputeDiffDCTBlock(current->y_blocks[by+1][bx+1], motionBlock);
    }

    if ( pattern & 0x2 ) {
	ComputeBMotionBlock(prev, next, by>>1, bx>>1, mode, fmy/2, fmx/2,
			    bmy/2, bmx/2, motionBlock, CB_BLOCK);
	ComputeDiffDCTBlock(current->cb_blocks[by >> 1][bx >> 1], motionBlock);
    }

    if ( pattern & 0x1 ) {
	ComputeBMotionBlock(prev, next, by>>1, bx>>1, mode, fmy/2, fmx/2,
			    bmy/2, bmx/2, motionBlock, CR_BLOCK);
	ComputeDiffDCTBlock(current->cr_blocks[by >> 1][bx >> 1], motionBlock);
    }
}


/*===========================================================================*
 *
 *			    USER-MODIFIABLE
 *
 * DoBIntraCode
 *
 *	decides if this block should be coded as intra-block
 *
 * RETURNS:	TRUE if intra-coding should be used; FALSE otherwise
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITION:	the motion vectors must be valid!
 *
 *===========================================================================*/
static boolean
DoBIntraCode(current, prev, next, by, bx, mode, fmy, fmx, bmy, bmx)
    MpegFrame *current;
    MpegFrame *prev;
    MpegFrame *next;
    int by;
    int bx;
    int mode;
    int fmy;
    int fmx;
    int bmy;
    int bmx;
{
    int	    x, y;
    int32 sum = 0, vard = 0, varc = 0, dif;
    int32 currPixel, prevPixel;
    LumBlock	motionBlock;
    int	    fy, fx;

    ComputeBMotionLumBlock(prev, next, by, bx, mode, fmy, fmx,
			   bmy, bmx, motionBlock);

    MOTION_TO_FRAME_COORD(by, bx, 0, 0, fy, fx);

    for ( y = 0; y < 16; y++ ) {
	for ( x = 0; x < 16; x++ ) {
	    currPixel = current->orig_y[fy+y][fx+x];
	    prevPixel = motionBlock[y][x];

	    sum += currPixel;
	    varc += currPixel*currPixel;

	    dif = currPixel - prevPixel;
	    vard += dif*dif;
	}
    }

    vard /= 256;	/* assumes mean is close to zero */
    varc = varc/256 - (sum/256)*(sum/256);

    if ( vard <= 64 ) {
	return FALSE;
    } else if ( vard < varc ) {
	return FALSE;
    } else {
	return TRUE;
    }
}

/*===========================================================================*
 *
 *			    USER-MODIFIABLE
 *
 * MotionSufficient
 *
 *	decides if this motion vector is sufficient without DCT coding
 *
 * RETURNS:	TRUE if no DCT is needed; FALSE otherwise
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITION:	the motion vectors must be valid!
 *
 *===========================================================================*/
static boolean
MotionSufficient(currBlock, prev, next, by, bx, mode, fmy, fmx, bmy, bmx)
    LumBlock currBlock;
    MpegFrame *prev;
    MpegFrame *next;
    int by;
    int bx;
    int mode;
    int fmy;
    int fmx;
    int bmy;
    int bmx;
{
    LumBlock   motionBlock;

    if ( mode != MOTION_BACKWARD ) {
	/* check forward motion for bounds */
	if ( (by*DCTSIZE+(fmy-1)/2 < 0) || ((by+2)*DCTSIZE+(fmy+1)/2-1 >= Fsize_y) ) {
	    return FALSE;
	}
	if ( (bx*DCTSIZE+(fmx-1)/2 < 0) || ((bx+2)*DCTSIZE+(fmx+1)/2-1 >= Fsize_x) ) {
	    return FALSE;
	}
    }

    if ( mode != MOTION_FORWARD ) {
	/* check backward motion for bounds */
	if ( (by*DCTSIZE+(bmy-1)/2 < 0) || ((by+2)*DCTSIZE+(bmy+1)/2-1 >= Fsize_y) ) {
	    return FALSE;
	}
	if ( (bx*DCTSIZE+(bmx-1)/2 < 0) || ((bx+2)*DCTSIZE+(bmx+1)/2-1 >= Fsize_x) ) {
	    return FALSE;
	}
    }

    ComputeBMotionLumBlock(prev, next, by, bx, mode, fmy, fmx,
			   bmy, bmx, motionBlock);

    return (LumBlockMAD(currBlock, motionBlock, 0x7fffffff) <= 512);
}
