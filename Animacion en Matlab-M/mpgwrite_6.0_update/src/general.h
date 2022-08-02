/*===========================================================================*
 * general.h								     *
 *									     *
 *	very general stuff						     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/general.h,v 1.1 1994/01/07 17:05:21 daf Exp $
 *  $Log: general.h,v $
 * Revision 1.1  1994/01/07  17:05:21  daf
 * Initial revision
 *
 * Revision 1.4  1993/07/22  22:24:23  keving
 * nothing
 *
 * Revision 1.3  1993/07/09  00:17:23  keving
 * nothing
 *
 * Revision 1.2  1993/06/03  21:08:53  keving
 * nothing
 *
 * Revision 1.1  1993/02/22  22:39:19  keving
 * nothing
 *
 */


#ifndef GENERAL_INCLUDED
#define GENERAL_INCLUDED


/* prototypes for library procedures
 *
 * if your /usr/include headers do not have these, then pass -DMISSING_PROTOS
 * to your compiler
 *
 */ 
#ifdef MISSING_PROTOS
int fprintf();
int fwrite();
int fread();
int fflush();
int fclose();

int sscanf();
int bzero();
int bcopy();
int system();
int time();
int perror();

int socket();
int bind();
int listen();
int accept();
int connect();
int close();
int read();
int write();

int pclose();

#endif


/*===========*
 * CONSTANTS *
 *===========*/

#ifndef NULL
#define NULL 0
#endif

#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif

#define SPACE ' '
#define TAB '\t'
#define SEMICOLON ';'
#define NULL_CHAR '\0'
#define NEWLINE '\n'


/*==================*
 * TYPE DEFINITIONS *
 *==================*/

typedef int boolean;

typedef unsigned char uint8;
typedef char int8;
typedef unsigned short uint16;
typedef short int16;

    /* LONG_32 should only be defined iff
     *	    1) long's are 32 bits and
     *	    2) int's are not
     */
#ifdef LONG_32		
typedef unsigned long uint32;
typedef long int32;
#else
typedef unsigned int uint32;
typedef int int32;
#endif


#endif
