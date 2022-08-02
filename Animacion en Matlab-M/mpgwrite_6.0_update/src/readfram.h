/*===========================================================================*
 * readframe.h								     *
 *									     *
 *	stuff dealing with reading frames				     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/readfram.h,v 1.1 1994/01/07 17:05:21 daf Exp $
 *  $Log: readfram.h,v $
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


/*===========*
 * CONSTANTS *
 *===========*/

#define	PPM_FILE_TYPE	0
#define YUV_FILE_TYPE	2
#define ANY_FILE_TYPE	3
#define BASE_FILE_TYPE	4
#define PNM_FILE_TYPE	5
#define SUB4_FILE_TYPE	6


/*===============================*
 * EXTERNAL PROCEDURE prototypes *
 *===============================*/

extern void	ReadFrame _ANSI_ARGS_((MpegFrame *frame, char *fileName,
				       char *conversion, boolean addPath));
extern void	SetFileType _ANSI_ARGS_((char *conversion));
extern void	SetFileFormat _ANSI_ARGS_((char *format));
extern FILE	*ReadIOConvert _ANSI_ARGS_((char *fileName));

