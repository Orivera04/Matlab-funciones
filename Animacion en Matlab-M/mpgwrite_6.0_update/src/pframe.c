/*===========================================================================*
 * pframe.c								     *
 *									     *
 *	Procedures concerned with generation of P-frames		     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	GenPFrame							     *
 *	ResetPFrameStats						     *
 *	ShowPFrameSummary						     *
 *	EstimateSecondsPerPFrame					     *
 *	ComputeHalfPixelData						     *
 *	SetPQScale							     *
 *	GetPQScale							     *
 *                                                                           *
 * NOTE:  when motion vectors are passed as arguments, they are passed as    *
 *        twice their value.  In other words, a motion vector of (3,4) will  *
 *        be passed as (6,8).  This allows half-pixel motion vectors to be   *
 *        passed as integers.  This is true throughout the program.          *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/pframe.c,v 1.5 1994/01/11 22:54:34 daf Exp $
 *  $Log: pframe.c,v $
 * Revision 1.5  1994/01/11  22:54:34  daf
 * Modified for PC compatibility
 *
 * Revision 1.4  1994/01/11  21:47:42  daf
 * Modified for PC compatibility
 *
 * Revision 1.3  1994/01/11  20:46:06  daf
 * Modified for PC compatibility
 *
 * Revision 1.2  1994/01/07  17:27:52  daf
 * Modified for use as .mex file.
 *
 * Revision 1.5  1993/07/22  22:23:43  keving
 * nothing
 *
 * Revision 1.4  1993/06/30  20:06:09  keving
 * nothing
 *
 * Revision 1.3  1993/06/03  21:08:08  keving
 * nothing
 *
 * Revision 1.2  1993/03/02  23:03:42  keving
 * nothing
 *
 * Revision 1.1  1993/02/19  19:14:12  keving
 * nothing
 *
 */


/*==============*
 * HEADER FILES *
 *==============*/

/*#include <sys/times.h>*/
#include <sys/types.h>
#include "all.h"
#include "mtypes.h"
#include "bitio.h"
#include "frames.h"
#include "prototyp.h"
#include "param.h"
#include "mheaders.h"
#include "fsize.h"
#include "postdct.h"
#include "mpeg.h"
#include "parallel.h"


/*==================*
 * STATIC VARIABLES *
 *==================*/

static int32	zeroDiff;
static int numPIBlocks = 0;
static int numPPBlocks = 0;
static int numPSkipped = 0;
static int numPIBits = 0;
static int numPPBits = 0;
static int numFrames = 0;
static int numFrameBits = 0;
static int32 totalTime = 0;
static int qscaleP;
static float	totalSNR = 0.0;
static float	totalPSNR = 0.0;


/*===============================*
 * INTERNAL PROCEDURE prototypes *
 *===============================*/

static boolean	ZeroMotionBetter _ANSI_ARGS_((LumBlock currentBlock,
					      MpegFrame *prev, int by, int bx,
					      int my, int mx));
static boolean	DoIntraCode _ANSI_ARGS_((LumBlock currentBlock,
					 MpegFrame *prev, int by, int bx,
					 int motionY, int motionX));
static boolean	ZeroMotionSufficient _ANSI_ARGS_((LumBlock currentBlock,
						  MpegFrame *prev,
						  int by, int bx));

#ifdef BLEAH
static void	ComputeAndPrintPframeMAD _ANSI_ARGS_((LumBlock currentBlock,
						      MpegFrame *prev,
						      int by, int bx,
						      int my, int mx,
						      int numBlock));
#endif


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * GenPFrame
 *
 *	generate a P-frame from previous frame, adding the result to the
 *	given bit bucket
 *
 * RETURNS:	frame appended to bb
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
GenPFrame(bb, current, prev)
    BitBucket *bb;
    MpegFrame *current;
    MpegFrame *prev;
{
    FlatBlock fba[6], fb[6];
    Block	dec[6];
    int32 y_dc_pred, cr_dc_pred, cb_dc_pred;
    int x, y;
    int	motionX = 0, motionY = 0;
    int	oldMotionX = 0, oldMotionY = 0;
    int	offsetX, offsetY;
    int	tempX, tempY;
    int	motionXrem, motionXquot;
    int	motionYrem, motionYquot;
    int	pattern;
    int	    mbAddrInc = 1;
    boolean	useMotion;
    int numIBlocks = 0;
    int	numPBlocks = 0;
    int	numSkipped = 0;
    int	numIBits = 0;
    int numPBits = 0;
    int totalBits;
    int	totalFrameBits;
/*
    struct tms timeBuffer;
    int32    startTime, endTime;
*/
    int numBlocks = -1;
    int	lastBlockX, lastBlockY;
    int	lastX, lastY;
    int	fy, fx;
    LumBlock currentBlock;
    register int ix, iy;
    int	frameBlocks;
    int slicePos;
    register int index;
    float   snr[3], psnr[3];

    numFrames++;
    totalFrameBits = bb->cumulativeBits;
/*
    times(&timeBuffer);
    startTime = timeBuffer.tms_utime + timeBuffer.tms_stime;
*/

    DBG_PRINT(("Generating pframe\n"));

    Mhead_GenPictureHeader(bb, P_FRAME, current->id, fCode);

    DBG_PRINT(("Slice Header\n"));
    Mhead_GenSliceHeader(bb, 1, qscaleP, NULL, 0);

    if ( referenceFrame == DECODED_FRAME ) {
	Frame_AllocDecoded(current, TRUE);
    } else if ( printSNR ) {
	Frame_AllocDecoded(current, FALSE);
    }

    /* don't do dct on blocks yet */
    Frame_AllocBlocks(current);
    BlockifyFrame(current);

    /* for I-blocks */
    y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

    totalBits = bb->cumulativeBits;

    if ( (! pixelFullSearch) && (! prev->halfComputed) ) {
	ComputeHalfPixelData(prev);
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
		Mhead_GenSliceHeader(bb, 1+(y/2), qscaleP, NULL, 0);

		/* reset everything */
		oldMotionX = 0;		oldMotionY = 0;
		y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

		mbAddrInc = 1+(x/2);
	    }

	    numBlocks++;
	    frameBlocks++;

	    /* compute currentBlock */
	    BLOCK_TO_FRAME_COORD(y, x, fy, fx);
	    for ( iy = 0; iy < 16; iy++ ) {
		for ( ix = 0; ix < 16; ix++ ) {
		    currentBlock[iy][ix] = (int16)current->orig_y[fy+iy][fx+ix];
		}
	    }

	    /* see if we should use motion vectors, and if so, what those
	     * vectors should be
	     */
	    if ( ZeroMotionSufficient(currentBlock, prev, y, x) ) {
		motionX = 0;
		motionY = 0;
		pattern = 63;
		useMotion = TRUE;
	    } else {
		useMotion = PMotionSearch(currentBlock, prev, y, x,
					  &motionY, &motionX);

		pattern = 63;

		if ( useMotion ) {
		    if ( ZeroMotionBetter(currentBlock, prev, y, x, motionY,
					  motionX) ) {
			motionX = 0;
			motionY = 0;
			pattern = 63;
		    }

		    useMotion = (! DoIntraCode(currentBlock, prev, y, x,
					       motionY, motionX));
		}
	    }

	    if ( ! useMotion ) {
		/* output I-block inside a P-frame */
		numIBlocks++;

		/* calculate forward dct's */
		mp_fwd_dct_block(current->y_blocks[y][x]);
		mp_fwd_dct_block(current->y_blocks[y][x+1]);
		mp_fwd_dct_block(current->y_blocks[y+1][x]);
		mp_fwd_dct_block(current->y_blocks[y+1][x+1]);
		mp_fwd_dct_block(current->cb_blocks[y >> 1][x >> 1]);
		mp_fwd_dct_block(current->cr_blocks[y >> 1][x >> 1]);

		GEN_I_BLOCK(P_FRAME, current, bb, mbAddrInc, qscaleP);
		mbAddrInc = 1;

		numIBits += (bb->cumulativeBits-totalBits);
		totalBits = bb->cumulativeBits;

		/* reset because intra-coded */
		oldMotionX = 0;		oldMotionY = 0;

		if ( decodeRefFrames ) {
		    /* need to decode block we just encoded */
		    Mpost_UnQuantZigBlock(fb[0], dec[0], qscaleP, TRUE);
		    Mpost_UnQuantZigBlock(fb[1], dec[1], qscaleP, TRUE);
		    Mpost_UnQuantZigBlock(fb[2], dec[2], qscaleP, TRUE);
		    Mpost_UnQuantZigBlock(fb[3], dec[3], qscaleP, TRUE);
		    Mpost_UnQuantZigBlock(fb[4], dec[4], qscaleP, TRUE);
		    Mpost_UnQuantZigBlock(fb[5], dec[5], qscaleP, TRUE);

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
	    } else {
		/* USE MOTION VECTORS */
		numPBlocks++;

		/* reset because non-intra-coded */
		y_dc_pred = cr_dc_pred = cb_dc_pred = 128;

#ifdef BLEAH
    ComputeAndPrintPframeMAD(currentBlock, prev, y, x, motionY, motionX, numBlocks);
#endif

		ComputeDiffDCTs(current, prev, y, x, motionY, motionX,
				pattern);

		if ( pixelFullSearch ) {	/* should be even */
		    motionY /= 2;
		    motionX /= 2;
		}

		/* transform the motion vector into the appropriate values */
		offsetX = motionX - oldMotionX;
		offsetY = motionY - oldMotionY;

		ENCODE_MOTION_VECTOR(offsetX, offsetY, motionXquot,
				     motionYquot, motionXrem, motionYrem,
				     FORW_F);

#ifdef BLEAH
    if ( (motionX != 0) || (motionY != 0) ) {
    fprintf(stdout, "FRAME (y, x)  %d, %d (block %d)\n", y, x, numBlocks);
    fprintf(stdout, "motionX = %d, motionY = %d\n", motionX, motionY);
    fprintf(stdout, "    mxq, mxr = %d, %d    myq, myr = %d, %d\n",
	    motionXquot, motionXrem, motionYquot, motionYrem);
}
#endif

		oldMotionX = motionX;
		oldMotionY = motionY;

		if ( pixelFullSearch ) {/* reset for use with PMotionSearch */
		    motionY *= 2;
		    motionX *= 2;
		}

		/* create flat blocks and update pattern if necessary */
	if ( (pattern & 0x20) && 
	     (! Mpost_QuantZigBlock(current->y_blocks[y][x], fba[0],
				   qscaleP, FALSE)) ) {
		pattern ^= 0x20;
	}
	if ( (pattern & 0x10) && 
	     (! Mpost_QuantZigBlock(current->y_blocks[y][x+1], fba[1],
				   qscaleP, FALSE)) ) {
		pattern ^= 0x10;
	}
	if ( (pattern & 0x8) && 
	     (! Mpost_QuantZigBlock(current->y_blocks[y+1][x], fba[2],
				   qscaleP, FALSE)) ) {
		pattern ^= 0x8;
	}
	if ( (pattern & 0x4) && 
	     (! Mpost_QuantZigBlock(current->y_blocks[y+1][x+1], fba[3],
				   qscaleP, FALSE)) ) {
		pattern ^= 0x4;
	}
	if ( (pattern & 0x2) && 
	     (! Mpost_QuantZigBlock(current->cb_blocks[y >> 1][x >> 1], fba[4],
				   qscaleP, FALSE)) ) {
		pattern ^= 0x2;
	}
	if ( (pattern & 0x1) && 
	     (! Mpost_QuantZigBlock(current->cr_blocks[y >> 1][x >> 1], fba[5],
				   qscaleP, FALSE)) ) {
		pattern ^= 0x1;
	}

	if ( decodeRefFrames ) {
	    if ( pattern & 0x20 ) {
		Mpost_UnQuantZigBlock(fba[0], dec[0], qscaleP, FALSE);
	    } else {
		memset((char *)dec[0], 0, sizeof(Block));
	    }
	    if ( pattern & 0x10 ) {
		Mpost_UnQuantZigBlock(fba[1], dec[1], qscaleP, FALSE);
	    } else {
		memset((char *)dec[1], 0, sizeof(Block));
	    }
	    if ( pattern & 0x8 ) {
		Mpost_UnQuantZigBlock(fba[2], dec[2], qscaleP, FALSE);
	    } else {
		memset((char *)dec[2], 0, sizeof(Block));
	    }
	    if ( pattern & 0x4 ) {
		Mpost_UnQuantZigBlock(fba[3], dec[3], qscaleP, FALSE);
	    } else {
		memset((char *)dec[3], 0, sizeof(Block));
	    }
	    if ( pattern & 0x2 ) {
		Mpost_UnQuantZigBlock(fba[4], dec[4], qscaleP, FALSE);
	    } else {
	        memset((char *)dec[4], 0, sizeof(Block));
	    }
	    if ( pattern & 0x1 ) {
		Mpost_UnQuantZigBlock(fba[5], dec[5], qscaleP, FALSE);
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
	    AddMotionBlock(dec[0], prev->decoded_y, y, x, motionY, motionX);
	    AddMotionBlock(dec[1], prev->decoded_y, y, x+1, motionY, motionX);
	    AddMotionBlock(dec[2], prev->decoded_y, y+1, x, motionY, motionX);
	    AddMotionBlock(dec[3], prev->decoded_y, y+1, x+1, motionY, motionX);
	    AddMotionBlock(dec[4], prev->decoded_cb, y>>1, x>>1, motionY/2, motionX/2);
	    AddMotionBlock(dec[5], prev->decoded_cr, y>>1, x>>1, motionY/2, motionX/2);

	    /* now, unblockify */
	    BlockToData(current->decoded_y, dec[0], y, x);
	    BlockToData(current->decoded_y, dec[1], y, x+1);
	    BlockToData(current->decoded_y, dec[2], y+1, x);
	    BlockToData(current->decoded_y, dec[3], y+1, x+1);
	    BlockToData(current->decoded_cb, dec[4], y>>1, x>>1);
	    BlockToData(current->decoded_cr, dec[5], y>>1, x>>1);
	}

		if ( (motionX == 0) && (motionY == 0) ) {
		    if ( pattern == 0 ) {
			/* can only skip if:
			 *     1)  not the last block in frame
			 *     2)  not the last block in slice
			 *     3)  not the first block in slice
			 */
			if ( ((y < lastY) || (x < lastX)) &&
			     (slicePos+1 != blocksPerSlice) &&
			     (slicePos != 0) ) {
			    mbAddrInc++;	/* skipped macroblock */
			    numSkipped++;
			    numPBlocks--;
			} else {    /* last macroblock */
		Mhead_GenMBHeader(bb, 2 /* pict_code_type */, mbAddrInc /* addr_incr */,
			  0 /* mb_quant */, 0 /* q_scale */,
			  fCode /* forw_f_code */, 1 /* back_f_code */,
			  0 /* horiz_forw_r */, 0 /* vert_forw_r */,
			  0 /* horiz_back_r */, 0 /* vert_back_r */,
			  0 /* motion_forw */, 0 /* m_horiz_forw */,
			  0 /* m_vert_forw */, 0 /* motion_back */,
			  0 /* m_horiz_back */, 0 /* m_vert_back */,
			  1 /* mb_pattern */, 0 /* mb_intra */);
			mbAddrInc = 1;

			    Bitio_Write(bb, 0x2, 2); /* first coeff */
			    Bitio_Write(bb, 0x2, 2); /* end of block */
			}
		    } else {
			DBG_PRINT(("MB Header(%d,%d)\n", x, y));
		Mhead_GenMBHeader(bb, 2 /* pict_code_type */, mbAddrInc /* addr_incr */,
			  0 /* mb_quant */, 0 /* q_scale */,
			  fCode /* forw_f_code */, 1 /* back_f_code */,
			  0 /* horiz_forw_r */, 0 /* vert_forw_r */,
			  0 /* horiz_back_r */, 0 /* vert_back_r */,
			  0 /* motion_forw */, 0 /* m_horiz_forw */,
			  0 /* m_vert_forw */, 0 /* motion_back */,
			  0 /* m_horiz_back */, 0 /* m_vert_back */,
			  pattern /* mb_pattern */, 0 /* mb_intra */);
			mbAddrInc = 1;
		    }
		} else {
	    DBG_PRINT(("MB Header(%d,%d)\n", x, y));
	    Mhead_GenMBHeader(bb, 2 /* pict_code_type */, mbAddrInc /* addr_incr */,
		      0 /* mb_quant */, 0 /* q_scale */,
		      fCode /* forw_f_code */, 1 /* back_f_code */,
		      motionXrem /* horiz_forw_r */, motionYrem /* vert_forw_r */,
		      0 /* horiz_back_r */, 0 /* vert_back_r */,
		      1 /* motion_forw */, motionXquot /* m_horiz_forw */,
		      motionYquot /* m_vert_forw */, 0 /* motion_back */,
		      0 /* m_horiz_back */, 0 /* m_vert_back */,
		      pattern /* mb_pattern */, 0 /* mb_intra */);
		    mbAddrInc = 1;
		}

		/* now output the difference */
		for ( tempX = 0; tempX < 6; tempX++ ) {
		    if ( GET_ITH_BIT(pattern, 5-tempX) ) {
			Mpost_RLEHuffPBlock(fba[tempX], bb);
		    }
		}

		numPBits += (bb->cumulativeBits-totalBits);
		totalBits = bb->cumulativeBits;
	    }
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

    Mhead_GenSliceEnder(bb);

    /* UPDATE STATISTICS */
/*
    times(&timeBuffer);
    endTime = timeBuffer.tms_utime + timeBuffer.tms_stime;
    totalTime += (endTime-startTime);
*/
/*
    if ( (! childProcess) && frameSummary ) {
	fprintf(stdout, "FRAME %d (P):  I BLOCKS:  %d;  P BLOCKS:  %d   SKIPPED:  %d  (%ld seconds)\n",
		current->id, numIBlocks, numPBlocks, numSkipped, (long)(endTime-startTime)/60);
	if ( printSNR ) {
	    fprintf(stdout, "FRAME %d:  SNR:  %.1f\t%.1f\t%.1f\tPSNR:  %.1f\t%.1f\t%.1f\n",
		    current->id, snr[0], snr[1], snr[2],
		    psnr[0], psnr[1], psnr[2]);
	}
    }
*/

    numFrameBits += (bb->cumulativeBits-totalFrameBits);
    numPIBlocks += numIBlocks;
    numPPBlocks += numPBlocks;
    numPSkipped += numSkipped;
    numPIBits += numIBits;
    numPPBits += numPBits;

/*
   if ( (referenceFrame == DECODED_FRAME) && NonLocalRefFrame(current->id) ) {
       if ( remoteIO ) {
       SendDecodedFrame(current);
   } else {
       WriteDecodedFrame(current);
   }
   
       NotifyDecodeServerReady(current->id);
   }
*/
}
       

/*===========================================================================*
 *
 * ResetPFrameStats
 *
 *	reset the P-frame statistics
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
ResetPFrameStats()
{
    numPIBlocks = 0;
    numPPBlocks = 0;
    numPSkipped = 0;
    numPIBits = 0;
    numPPBits = 0;
    numFrames = 0;
    numFrameBits = 0;
    totalTime = 0;
}


/*===========================================================================*
 *
 * SetPQScale
 *
 *	set the P-frame Q-scale
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    qscaleP
 *
 *===========================================================================*/
void
SetPQScale(qP)
    int qP;
{
    qscaleP = qP;
}


/*===========================================================================*
 *
 * GetPQScale
 *
 *	return the P-frame Q-scale
 *
 * RETURNS:	the P-frame Q-scale
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
int
GetPQScale()
{
    return qscaleP;
}


/*===========================================================================*
 *
 * ShowPFrameSummary
 *
 *	print a summary of information on encoding P-frames
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
void
ShowPFrameSummary(inputFrameBits, totalBits, fpointer)
    int inputFrameBits;
    int32 totalBits;
    FILE *fpointer;
{
    if ( numFrames == 0 ) {
	return;
    }

    fprintf(fpointer, "-------------------------\n");
    fprintf(fpointer, "*****P FRAME SUMMARY*****\n");
    fprintf(fpointer, "-------------------------\n");

    if ( numPIBlocks != 0 ) {
	fprintf(fpointer, "  I Blocks:  %5d     (%6d bits)     (%5d bpb)\n",
		numPIBlocks, numPIBits, numPIBits/numPIBlocks);
    } else {
	fprintf(fpointer, "  I Blocks:  %5d\n", 0);
    }

    if ( numPPBlocks != 0 ) {
	fprintf(fpointer, "  P Blocks:  %5d     (%6d bits)     (%5d bpb)\n",
		numPPBlocks, numPPBits, numPPBits/numPPBlocks);
    } else {
	fprintf(fpointer, "  P Blocks:  %5d\n", 0);
    }

    fprintf(fpointer, "  Skipped:   %5d\n", numPSkipped);

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
 * EstimateSecondsPerPFrame
 *
 *	compute an estimate of the number of seconds required per P-frame
 *
 * RETURNS:	the estimate, in seconds
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
float
EstimateSecondsPerPFrame()
{
    if ( numFrames == 0 ) {
	return 10.0;
    } else {
	return (float)totalTime/(60.0*(float)numFrames);
    }
}
*/


/*===========================================================================*
 *
 * ComputeHalfPixelData
 *
 *	compute all half-pixel data required for half-pixel motion vector
 *	search (luminance only)
 *
 * RETURNS:	frame->halfX, ->halfY, and ->halfBoth modified
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
ComputeHalfPixelData(frame)
    MpegFrame *frame;
{
    register int x, y;

    /* we add 1 before dividing by 2 because .5 is supposed to be rounded up
     * (see MPEG-1, page D-31)
     */

    if ( frame->halfX == NULL ) {	    /* need to allocate memory */
        Frame_AllocHalf(frame);
    }

    /* compute halfX */
    for ( y = 0; y < Fsize_y; y++ ) {
	for ( x = 0; x < Fsize_x-1; x++ ) {
	    frame->halfX[y][x] = (frame->ref_y[y][x]+
				  frame->ref_y[y][x+1]+1)/2;
	}
    }

    /* compute halfY */
    for ( y = 0; y < Fsize_y-1; y++ ) {
	for ( x = 0; x < Fsize_x; x++ ) {
	    frame->halfY[y][x] = (frame->ref_y[y][x]+
				  frame->ref_y[y+1][x]+1)/2;
	}
    }

    /* compute halfBoth */
    for ( y = 0; y < Fsize_y-1; y++ ) {
	for ( x = 0; x < Fsize_x-1; x++ ) {
	    frame->halfBoth[y][x] = (frame->ref_y[y][x]+
				     frame->ref_y[y][x+1]+
				     frame->ref_y[y+1][x]+
				     frame->ref_y[y+1][x+1]+2)/4;
	}
    }

    frame->halfComputed = TRUE;
}


/*=====================*
 * INTERNAL PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 *			      USER-MODIFIABLE
 *
 * ZeroMotionBetter
 *
 *	decide if (0,0) motion is better than the given motion vector
 *
 * RETURNS:	TRUE if (0,0) is better, FALSE if (my,mx) is better
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITIONS:	The relevant block in 'current' is valid (it has not
 *			been dct'd).  'zeroDiff' has already been computed
 *			as the LumMotionError() with (0,0) motion
 *
 * NOTES:	This procedure follows the algorithm described on
 *		page D-48 of the MPEG-1 specification
 *
 *===========================================================================*/
static boolean
ZeroMotionBetter(currentBlock, prev, by, bx, my, mx)
    LumBlock currentBlock;
    MpegFrame *prev;
    int by;
    int bx;
    int my;
    int mx;
{
    int	bestDiff;

    bestDiff = LumMotionError(currentBlock, prev, by, bx, my, mx, 0x7fffffff);

    if ( zeroDiff < 256*3 ) {
	if ( 2*bestDiff >= zeroDiff ) {
	    return TRUE;
	}
    } else {
	if ( 11*bestDiff >= 10*zeroDiff ) {
	    return TRUE;
	}
    }

    return FALSE;
}


/*===========================================================================*
 *
 *			      USER-MODIFIABLE
 *
 * DoIntraCode
 *
 *	decide if intra coding is necessary
 *
 * RETURNS:	TRUE if intra-block coding is better; FALSE if not
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITIONS:	The relevant block in 'current' is valid (it has not
 *			been dct'd).
 *
 * NOTES:	This procedure follows the algorithm described on
 *		page D-49 of the MPEG-1 specification
 *
 *===========================================================================*/
static boolean
DoIntraCode(currentBlock, prev, by, bx, motionY, motionX)
    LumBlock currentBlock;
    MpegFrame *prev;
    int by;
    int bx;
    int motionY;
    int motionX;
{
    int	    x, y;
    int32 sum = 0, vard = 0, varc = 0, dif;
    int32 currPixel, prevPixel;
    LumBlock	motionBlock;
    int	    fy, fx;

    ComputeMotionLumBlock(prev, by, bx, motionY, motionX, motionBlock);

    MOTION_TO_FRAME_COORD(by, bx, 0, 0, fy, fx);

    for ( y = 0; y < 16; y++ ) {
	for ( x = 0; x < 16; x++ ) {
	    currPixel = currentBlock[y][x];
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
 *			      USER-MODIFIABLE
 *
 * ZeroMotionSufficient
 *
 *	decide if zero motion is sufficient without DCT correction
 *
 * RETURNS:	TRUE no DCT required; FALSE otherwise
 *
 * SIDE EFFECTS:    none
 *
 * PRECONDITIONS:	The relevant block in 'current' is raw YCC data
 *
 *===========================================================================*/
static boolean
ZeroMotionSufficient(currentBlock, prev, by, bx)
    LumBlock currentBlock;
    MpegFrame *prev;
    int by;
    int bx;
{
    LumBlock	motionBlock;
    register int    fy, fx;
    register int    x, y;

    fy = by*DCTSIZE;
    fx = bx*DCTSIZE;
    for ( y = 0; y < 16; y++ ) {
	for ( x = 0; x < 16; x++ ) {
	    motionBlock[y][x] = prev->ref_y[fy+y][fx+x];
	}
    }

    zeroDiff = LumBlockMAD(currentBlock, motionBlock, 0x7fffffff);

    return (zeroDiff <= 256);
}
			     

#ifdef UNUSED_PROCEDURES
static void
ComputeAndPrintPframeMAD(currentBlock, prev, by, bx, my, mbx, numBlock)
    LumBlock currentBlock;
    MpegFrame *prev;
    int by;
    int bx;
    int my;
    int mx;
    int numBlock;
{
    LumBlock	lumMotionBlock;
    int32   mad;

    ComputeMotionLumBlock(prev, by, bx, my, mx, lumMotionBlock);

    mad = LumBlockMAD(currentBlock, lumMotionBlock, 0x7fffffff);

    fprintf(stdout, "%d %d\n", numBlock, mad);
}
#endif










































