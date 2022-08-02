/*===========================================================================*
 * fsize.c								     *
 *									     *
 *	procedures to keep track of frame size				     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	Fsize_Reset							     *
 *	Fsize_Note							     *
 *	Fsize_Validate							     *
 *									     *
 * EXPORTED VARIABLES:							     *
 *	Fsize_x								     *
 *	Fsize_y								     *
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

/************************************************************************
                            R C S Information
*************************************************************************/

/* $Log: fsize.c,v $
 * Revision 1.3  1994/01/14  14:12:37  daf
 * Removed calls to exit().
 *
 * Revision 1.2  94/01/12  20:16:47  daf
 * Added RCS info.
 * 
 * revision 1.1    locked by: daf;
 * date: 1994/01/07 17:05:21;  author: daf;  state: Exp;
 * Initial revision
*/


/*==============*
 * HEADER FILES *
 *==============*/

#include "all.h"
#include "fsize.h"
#include "dct.h"
#include "mex.h"   /* needed for mexErrMsgTxt */


/*==================*
 * GLOBAL VARIABLES *
 *==================*/
int Fsize_x = 0;
int Fsize_y = 0;


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * Fsize_Reset
 *
 *	reset the frame size to 0
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    Fsize_x, Fsize_y
 *
 *===========================================================================*/
void
Fsize_Reset()
{
    Fsize_x = Fsize_y = 0;
}


/*===========================================================================*
 *
 * Fsize_Validate
 *
 *	make sure that the x, y values are 16-pixel aligned
 *
 * RETURNS:	modifies the x, y values to 16-pixel alignment
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Fsize_Validate(x, y)
    int *x;
    int *y;
{
    *x &= ~(DCTSIZE * 2 - 1);
    *y &= ~(DCTSIZE * 2 - 1);
}


/*===========================================================================*
 *
 * Fsize_Note
 *
 *	note the given frame size and modify the global values as appropriate
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    Fsize_x, Fsize_y
 *
 *===========================================================================*/
void
Fsize_Note(id, width, height)
    int id;
    int width;
    int height;
{
    if (Fsize_x == 0) {
	Fsize_x = width;
	Fsize_y = height;
	Fsize_Validate(&Fsize_x, &Fsize_y);
    } else if (width < Fsize_x || height < Fsize_y) {
	mexErrMsgTxt("Error: a frame has an incorrect size.");
    }
}
