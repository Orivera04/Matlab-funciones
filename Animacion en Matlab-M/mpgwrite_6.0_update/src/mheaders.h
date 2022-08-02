/*===========================================================================*
 * mheaders.h								     *
 *									     *
 *	MPEG headers							     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/mheaders.h,v 1.1 1994/01/07 17:05:21 daf Exp $
 *  $Log: mheaders.h,v $
 * Revision 1.1  1994/01/07  17:05:21  daf
 * Initial revision
 *
 * Revision 1.1  1993/07/22  22:24:23  keving
 * nothing
 *
 *
 */


#ifndef MHEADERS_INCLUDED
#define MHEADERS_INCLUDED


/*==============*
 * HEADER FILES *
 *==============*/

#include "general.h"
#include "ansi.h"
#include "bitio.h"


/*===============================*
 * EXTERNAL PROCEDURE prototypes *
 *===============================*/

void	SetGOPStartTime _ANSI_ARGS_((int index));
void	Mhead_GenSequenceHeader _ANSI_ARGS_((BitBucket *bbPtr,
            uint32 hsize, uint32 vsize,
            int32 pratio, int32 pict_rate,
            int32 bit_rate, int32 buf_size,
            int32 c_param_flag, uint8 *iq_matrix,
            uint8 *niq_matrix, uint8 *ext_data,
            int32 ext_data_size, uint8 *user_data, int32 user_data_size));
void	Mhead_GenSequenceEnder _ANSI_ARGS_((BitBucket *bbPtr));
void	Mhead_GenGOPHeader _ANSI_ARGS_((BitBucket *bbPtr,
	   int32 drop_frame_flag,
           int32 tc_hrs, int32 tc_min,
           int32 tc_sec, int32 tc_pict,
           int32 closed_gop, int32 broken_link,
           uint8 *ext_data, int32 ext_data_size,
           uint8 *user_data, int32 user_data_size));
void	Mhead_GenPictureHeader _ANSI_ARGS_((BitBucket *bbPtr, int frameType,
					    int pictCount, int f_code));
void	Mhead_GenSliceHeader _ANSI_ARGS_((BitBucket *bbPtr, uint32 slicenum,
					  uint32 qscale, uint8 *extra_info,
					  uint32 extra_info_size));
void	Mhead_GenSliceEnder _ANSI_ARGS_((BitBucket *bbPtr));
void	Mhead_GenMBHeader _ANSI_ARGS_((BitBucket *bbPtr,
	  uint32 pict_code_type, uint32 addr_incr,
          uint32 mb_quant, uint32 q_scale,
          uint32 forw_f_code, uint32 back_f_code,
          uint32 horiz_forw_r, uint32 vert_forw_r,
          uint32 horiz_back_r, uint32 vert_back_r,
          int32 motion_forw, int32 m_horiz_forw,
          int32 m_vert_forw, int32 motion_back,
          int32 m_horiz_back, int32 m_vert_back,
          uint32 mb_pattern, uint32 mb_intra));


#endif /* MHEADERS_INCLUDED */
