/*===========================================================================*
 * byteorder.h								     *
 *									     *
 *	stuff to handle different byte order				     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/byteord.h,v 1.2 1994/01/11 20:48:47 daf Exp $
 *  $Log: byteord.h,v $
 * Revision 1.2  1994/01/11  20:48:47  daf
 * Modified for PC compatibility
 *
 * Revision 1.1  1994/01/07  17:05:21  daf
 * Initial revision
 *
 * Revision 1.1  1993/07/22  22:24:23  keving
 * nothing
 *
 */


#include "general.h"

#ifdef WIN32
#define FORCE_LITTLE_ENDIAN
#endif
#ifdef FORCE_BIG_ENDIAN
    /* leave byte order as it is */
#define htonl(x) (x)
#define ntohl(x) (x)
#define htons(x) (x)
#define ntohs(x) (x)
#else
#ifdef FORCE_LITTLE_ENDIAN
    /* need to reverse byte order */
    /* note -- we assume here that htonl is called on a variable, not a
     * constant; thus, this is not for general use, but works with bitio.c
     */
#define htonl(x)    \
    ((((unsigned char *)(&x))[0] << 24) |	\
     (((unsigned char *)(&x))[1] << 16) |	\
     (((unsigned char *)(&x))[2] << 8) |	\
     (((unsigned char *)(&x))[3]))
#define ntohl(x)    htonl(x)
#define htons(x)    \
    ((((unsigned char *)(&x))[0] << 8) |	\
     ((unsigned char *)(&x))[1])
#define ntohs(x)    htons(x)
#else
    /* let in.h handle it, if possible */		   
#include <sys/types.h>
#include <netinet/in.h>
#endif /* FORCE_LITTLE_ENDIAN */
#endif /* FORCE_BIG_ENDIAN */
