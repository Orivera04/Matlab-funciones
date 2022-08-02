/*===========================================================================*
 * frames.h								     *
 *									     *
 *	stuff dealing with frames					     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/frames.h,v 1.1 1994/01/07 17:05:21 daf Exp $
 *  $Log: frames.h,v $
 * Revision 1.1  1994/01/07  17:05:21  daf
 * Initial revision
 *
 * Revision 1.5  1993/07/22  22:24:23  keving
 * nothing
 *
 * Revision 1.4  1993/07/09  00:17:23  keving
 * nothing
 *
 * Revision 1.3  1993/06/03  21:08:53  keving
 * nothing
 *
 * Revision 1.2  1993/03/02  19:00:27  keving
 * nothing
 *
 * Revision 1.1  1993/02/19  20:15:51  keving
 * nothing
 *
 */


#ifndef FRAMES_INCLUDED
#define FRAMES_INCLUDED

/*==============*
 * HEADER FILES *
 *==============*/

#include "ansi.h"
#include "mtypes.h"
#include "mheaders.h"
#include "frame.h"


/*===========*
 * CONSTANTS *
 *===========*/

#define I_FRAME	1
#define P_FRAME 2
#define	B_FRAME	3

#define LUM_BLOCK   0
#define	CHROM_BLOCK 1
#define	CR_BLOCK    2
#define CB_BLOCK    3

#define	MOTION_FORWARD	    0
#define MOTION_BACKWARD	    1
#define MOTION_INTERPOLATE  2


#define USE_HALF    0
#define	USE_FULL    1

    /* motion vector stuff */
#define FORW_F_CODE fCode	    /* from picture header */
#define BACK_F_CODE fCode
#define FORW_F	(1 << (FORW_F_CODE - 1))
#define	BACK_F	(1 << (BACK_F_CODE - 1))
#define RANGE_NEG	(-(1 << (3 + FORW_F_CODE)))
#define RANGE_POS	((1 << (3 + FORW_F_CODE))-1)
#define MODULUS		(1 << (4 + FORW_F_CODE))

#define ORIGINAL_FRAME	0
#define DECODED_FRAME	1


/*=======================*
 * STRUCTURE DEFINITIONS *
 *=======================*/

typedef	struct FrameTableStruct {
    MpegFrame *frame;	    /* this changes during execution */

    /* the following are all initted once and never changed */
    /* (they depend only on the pattern */

    struct FrameTableStruct *next;
    struct FrameTableStruct *prev;

    /* nextOutput is a pointer to next frame table entry to output */
    struct FrameTableStruct *nextOutput;

    boolean	freeNow;	/* TRUE iff no frames point back to this */

    int number;

    int	bFrameNumber;		/* actual frame number, if a b-frame */
    
} FrameTable;


/*==================*
 * TYPE DEFINITIONS *
 *==================*/

    /* none */


void	EncodeYDC _ANSI_ARGS_((int32 dc_term, int32 *pred_term, BitBucket *bb));
void EncodeCDC _ANSI_ARGS_((int32 dc_term, int32 *pred_term, BitBucket *bb));


/*========*
 * MACROS *
 *========*/

#define FRAME_TYPE(num)	    framePattern[num % framePatternLen]

/* return ceiling(a/b) where a, b are ints, using temp value c */
#define int_ceil_div(a,b,c)   ((b*(c = a/b) < a) ? (c+1) : c)
#define int_floor_div(a,b,c)	((b*(c = a/b) > a) ? (c-1) : c)


#define COMPUTE_BLOCK(block, qscale, n) {			\
	Mpost_QuantZigBlock(block, fb[n], qscale, TRUE);	\
	EncodeYDC(fb[n][0], &y_dc_pred, bb);			\
	Mpost_RLEHuffIBlock(fb[n], bb);				\
    }



/* assumes many things:
 * block indices are (y,x)
 * variables y_dc_pred, cr_dc_pred, and cb_dc_pred
 * flat block fb exists
 */
#define	GEN_I_BLOCK(frameType, frame, bb, mbAI, qscale)	{		    \
	Mhead_GenMBHeader(bb,						    \
		    frameType /* pict_code_type */, mbAI /* addr_incr */,   \
		    0 /* mb_quant */, 0 /* q_scale */,			    \
		    0 /* forw_f_code */, 0 /* back_f_code */,		    \
		    0 /* horiz_forw_r */, 0 /* vert_forw_r */,		    \
		    0 /* horiz_back_r */, 0 /* vert_back_r */,		    \
		    0 /* motion_forw */, 0 /* m_horiz_forw */,		    \
		    0 /* m_vert_forw */, 0 /* motion_back */,		    \
		    0 /* m_horiz_back */, 0 /* m_vert_back */,		    \
		    0 /* mb_pattern */, 1 /* mb_intra */);		    \
									    \
	/* Y blocks */							    \
	COMPUTE_BLOCK(frame->y_blocks[y][x], qscale, 0);			    \
	COMPUTE_BLOCK(frame->y_blocks[y][x+1], qscale, 1);			    \
	COMPUTE_BLOCK(frame->y_blocks[y+1][x], qscale, 2);			    \
	COMPUTE_BLOCK(frame->y_blocks[y+1][x+1], qscale, 3);		    \
									    \
	/* CB block */							    \
	Mpost_QuantZigBlock(frame->cb_blocks[y >> 1][x >> 1], fb[4], qscale, TRUE); \
	EncodeCDC(fb[4][0], &cb_dc_pred, bb);					    \
	Mpost_RLEHuffIBlock(fb[4], bb);					    \
									    \
	/* CR block */							    \
	Mpost_QuantZigBlock(frame->cr_blocks[y >> 1][x >> 1], fb[5], qscale, TRUE); \
	EncodeCDC(fb[5][0], &cr_dc_pred, bb);					    \
	Mpost_RLEHuffIBlock(fb[5], bb);					    \
    }


#define	BLOCK_TO_FRAME_COORD(bx1, bx2, x1, x2) {    \
	x1 = (bx1)*DCTSIZE;			    \
	x2 = (bx2)*DCTSIZE;			    \
    }

#define MOTION_TO_FRAME_COORD(bx1, bx2, mx1, mx2, x1, x2) { \
	x1 = (bx1)*DCTSIZE+(mx1);			    \
	x2 = (bx2)*DCTSIZE+(mx2);			    \
    }

#define COORD_IN_FRAME(fy,fx, type)					\
    ((type == LUM_BLOCK) ?						\
     ((fy >= 0) && (fx >= 0) && (fy < Fsize_y) && (fx < Fsize_x)) :	\
     ((fy >= 0) && (fx >= 0) && (fy < Fsize_y/2) && (fx < Fsize_x/2)))

#define ENCODE_MOTION_VECTOR(x,y,xq, yq, xr, yr, f) {			\
	int	tempC;							\
									\
	if ( x < RANGE_NEG )	    tempX = x + MODULUS;		\
	else if ( x > RANGE_POS ) tempX = x - MODULUS;			\
	else				    tempX = x;			\
									\
	if ( y < RANGE_NEG )	    tempY = y + MODULUS;		\
	else if ( y > RANGE_POS ) tempY = y - MODULUS;			\
	else				    tempY = y;			\
									\
	if ( tempX >= 0 ) {						\
	    xq = int_ceil_div(tempX, f, tempC);				\
	    xr = f - 1 + tempX - xq*f;					\
	} else {							\
	    xq = int_floor_div(tempX, f, tempC);			\
	    xr = f - 1 - tempX + xq*f;					\
	}								\
									\
	if ( tempY >= 0 ) {						\
	    yq = int_ceil_div(tempY, f, tempC);				\
	    yr = f - 1 + tempY - yq*f;					\
	} else {							\
	    yq = int_floor_div(tempY, f, tempC);			\
	    yr = f - 1 - tempY + yq*f;					\
	}								\
    }


/*===============================*
 * EXTERNAL PROCEDURE prototypes *
 *===============================*/

void	ComputeBMotionLumBlock _ANSI_ARGS_((MpegFrame *prev, MpegFrame *next,
			       int by, int bx, int mode, int fmy, int fmx,
			       int bmy, int bmx, LumBlock motionBlock));
int	BMotionSearch _ANSI_ARGS_((LumBlock currentBlock, MpegFrame *prev, MpegFrame *next,
		      int by, int bx, int *fmy, int *fmx, int *bmy, int *bmx, int oldMode));


void	ComputeDiffDCTs _ANSI_ARGS_((MpegFrame *current, MpegFrame *prev, int by, int bx,
			int my, int mx, int pattern));
void	ComputeDiffDCTBlock _ANSI_ARGS_((Block current, Block motionBlock));
void	ComputeMotionBlock _ANSI_ARGS_((uint8 **prev, int by, int bx, int my, int mx,
			   Block motionBlock));
void	ComputeMotionLumBlock _ANSI_ARGS_((MpegFrame *prevFrame, int by,
					   int bx, int my, int mx,
					   LumBlock motionBlock));
int32	ComputeBlockMAD _ANSI_ARGS_((Block current, Block prev));

void	GenIFrame _ANSI_ARGS_((BitBucket *bb, MpegFrame *mf));
void	GenPFrame _ANSI_ARGS_((BitBucket *bb, MpegFrame *current, MpegFrame *prev));
void	GenBFrame _ANSI_ARGS_((BitBucket *bb, MpegFrame *curr, MpegFrame *prev, MpegFrame *next));

void	ShowIFrameSummary _ANSI_ARGS_((int inputFrameBits, int32 totalBits, FILE *fpointer));
void	ShowPFrameSummary _ANSI_ARGS_((int inputFrameBits, int32 totalBits, FILE *fpointer));
void	ShowBFrameSummary _ANSI_ARGS_((int inputFrameBits, int32 totalBits, FILE *fpointer));


/* DIFFERENCE FUNCTIONS */

int32    LumBlockMAD _ANSI_ARGS_((LumBlock currentBlock, LumBlock motionBlock, int32 bestSoFar));
int32    LumBlockMSE _ANSI_ARGS_((LumBlock currentBlock, LumBlock motionBlock, int32 bestSoFar));
int32	LumMotionError _ANSI_ARGS_((LumBlock currentBlock, MpegFrame *prev,
				    int by, int bx, int my, int mx,
				    int32 bestSoFar));
int32	LumAddMotionError _ANSI_ARGS_((LumBlock currentBlock,
				       LumBlock blockSoFar, MpegFrame *prev,
				       int by, int bx, int my, int mx,
				       int32 bestSoFar));
int32	LumMotionErrorA _ANSI_ARGS_((LumBlock current, MpegFrame *prevFrame,
				     int by, int bx, int my, int mx,
				     int32 bestSoFar));
int32	LumMotionErrorB _ANSI_ARGS_((LumBlock current, MpegFrame *prevFrame,
				     int by, int bx, int my, int mx,
				     int32 bestSoFar));
int32	LumMotionErrorC _ANSI_ARGS_((LumBlock current, MpegFrame *prevFrame,
				     int by, int bx, int my, int mx,
				     int32 bestSoFar));
int32	LumMotionErrorD _ANSI_ARGS_((LumBlock current, MpegFrame *prevFrame,
				     int by, int bx, int my, int mx,
				     int32 bestSoFar));
int32	LumMotionErrorSubSampled _ANSI_ARGS_((LumBlock currentBlock, MpegFrame *prevFrame,
			  int by, int bx, int my, int mx,
			  int startY, int startX));
void	ComputeSNR _ANSI_ARGS_((uint8 **origData, uint8 **newData,
				int ySize, int xSize,
				float *snr, float *psnr));


/*==================*
 * GLOBAL VARIABLES *
 *==================*/

extern int pixelFullSearch;
extern int searchRange;
extern int qscaleI;
extern int gopSize;
extern int slicesPerFrame;
extern int blocksPerSlice;
extern FrameTable  *frameTable;
extern int referenceFrame;
extern int quietTime;		/* shut up for at least quietTime seconds;
				 * negative means shut up forever
				 */

extern boolean frameSummary;	/* TRUE = frame summaries should be printed */
extern boolean	printSNR;
extern boolean	decodeRefFrames;    /* TRUE = should decode I and P frames */
extern int	fCode;


#endif /* FRAMES_INCLUDED */
