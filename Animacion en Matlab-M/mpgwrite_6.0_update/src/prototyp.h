/*===========================================================================*
 * prototypes.h								     *
 *									     *
 *	miscellaneous prototypes					     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/prototyp.h,v 1.1 1994/01/07 17:05:21 daf Exp $
 *  $Log: prototyp.h,v $
 * Revision 1.1  1994/01/07  17:05:21  daf
 * Initial revision
 *
 * Revision 1.2  1993/07/22  22:24:23  keving
 * nothing
 *
 * Revision 1.1  1993/07/09  00:17:23  keving
 * nothing
 *
 */


/*==============*
 * HEADER FILES *
 *==============*/

#include "general.h"
#include "ansi.h"
#include "frame.h"


/*===============================*
 * EXTERNAL PROCEDURE prototypes *
 *===============================*/

int	GetBQScale _ANSI_ARGS_((void));
int	GetPQScale _ANSI_ARGS_((void));
void	ResetBFrameStats _ANSI_ARGS_((void));
void	ResetPFrameStats _ANSI_ARGS_((void));
void	SetSearchRange _ANSI_ARGS_((int pixels));
void	ResetIFrameStats _ANSI_ARGS_((void));
void	SetPixelSearch _ANSI_ARGS_((char *searchType));
void	SetIQScale _ANSI_ARGS_((int qI));
void	SetPQScale _ANSI_ARGS_((int qP));
void	SetBQScale _ANSI_ARGS_((int qB));
float	EstimateSecondsPerIFrame _ANSI_ARGS_((void));
float	EstimateSecondsPerPFrame _ANSI_ARGS_((void));
float	EstimateSecondsPerBFrame _ANSI_ARGS_((void));
void	SetGOPSize _ANSI_ARGS_((int size));
void	SetStatFileName _ANSI_ARGS_((char *fileName));
void	SetSlicesPerFrame _ANSI_ARGS_((int number));
void	SetBlocksPerSlice _ANSI_ARGS_((void));


void DCTFrame _ANSI_ARGS_((MpegFrame * mf));

void PPMtoYCC _ANSI_ARGS_((MpegFrame * mf));

void	MotionSearchPreComputation _ANSI_ARGS_((MpegFrame *frame));
boolean	PMotionSearch _ANSI_ARGS_((LumBlock currentBlock, MpegFrame *prev,
				   int by, int bx, int *motionY, int *motionX));
void	ComputeHalfPixelData _ANSI_ARGS_((MpegFrame *frame));
void mp_validate_size _ANSI_ARGS_((int *x, int *y));

/* block.c */
void	BlockToData _ANSI_ARGS_((uint8 **data, Block block, int by, int bx));
void	AddMotionBlock _ANSI_ARGS_((Block block, uint8 **prev, int by, int bx,
		       int my, int mx));
void	AddBMotionBlock _ANSI_ARGS_((Block block, uint8 **prev, uint8 **next,
				     int by, int bx, int mode,
				     int fmy, int fmx, int bmy, int bmx));

void	BlockifyFrame _ANSI_ARGS_((MpegFrame *frame));



extern void	SetFCode _ANSI_ARGS_((void));


