/*===========================================================================*
 * param.h								     *
 *									     *
 *	reading the parameter file					     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/param.h,v 1.2 1994/01/07 18:15:56 daf Exp $
 *  $Log: param.h,v $
 * Revision 1.2  1994/01/07  18:15:56  daf
 * Modified for use as .mex file.
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

#include "ansi.h"


/*===========*
 * CONSTANTS *
 *===========*/

#define MAX_MACHINES	    256
#define MAXPATHLEN  1024

#define	ENCODE_FRAMES	0
#define COMBINE_GOPS	1
#define COMBINE_FRAMES	2


/*===============================*
 * EXTERNAL PROCEDURE prototypes *
 *===============================*/

boolean	ReadParamFile _ANSI_ARGS_((char *fileName, int function));
void	GetNthInputFileName _ANSI_ARGS_((char *fileName, int n));


/*==================*
 * GLOBAL VARIABLES *
 *==================*/

extern int numInputFiles;
#ifndef MAIN_FILE
extern char	outputFileName[256];
#endif
extern int	whichGOP;
extern int numMachines;
extern char	machineName[MAX_MACHINES][256];
extern char	userName[MAX_MACHINES][256];
extern char	executable[MAX_MACHINES][1024];
extern char	remoteParamFile[MAX_MACHINES][1024];
extern boolean	remote[MAX_MACHINES];
extern boolean	childProcess;
extern char	currentPath[MAXPATHLEN];
extern char inputConversion[1024];
extern int  yuvWidth, yuvHeight;
extern int  realWidth, realHeight;
extern char ioConversion[1024];
extern char slaveConversion[1024];
