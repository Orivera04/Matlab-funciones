/*===========================================================================*
 * postdct.c								     *
 *									     *
 *	Procedures concerned with MPEG post-DCT processing:		     *
 *	    quantization and RLE Huffman encoding			     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	Mpost_QuantZigBlock						     *
 *	Mpost_RLEHuffIBlock						     *
 *	Mpost_RLEHuffPBlock						     *
 *	Mpost_UnQuantZigBlock						     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/postdct.c,v 1.3 1994/01/12 09:54:55 daf Exp $
 *  $Log: postdct.c,v $
 * Revision 1.3  1994/01/12  09:54:55  daf
 * Added include for mex.h.
 *
 * Revision 1.2  94/01/11  15:46:51  15:46:51  daf (David Foti)
 * Removed exit calls.
 * 
 * Revision 1.1  1994/01/07  17:05:21  daf
 * Initial revision
 *
 * Revision 1.11  1993/07/22  22:23:43  keving
 * nothing
 *
 * Revision 1.10  1993/06/30  20:06:09  keving
 * nothing
 *
 * Revision 1.9  1993/06/03  21:08:08  keving
 * nothing
 *
 * Revision 1.8  1993/02/24  18:57:19  keving
 * nothing
 *
 * Revision 1.7  1993/02/23  22:58:36  keving
 * nothing
 *
 * Revision 1.6  1993/02/23  22:54:56  keving
 * nothing
 *
 * Revision 1.5  1993/02/17  23:18:20  dwallach
 * checkin prior to keving's joining the project
 *
 * Revision 1.4  1993/01/18  10:20:02  dwallach
 * *** empty log message ***
 *
 * Revision 1.3  1993/01/18  10:17:29  dwallach
 * RCS headers installed, code indented uniformly
 *
 * Revision 1.3  1993/01/18  10:17:29  dwallach
 * RCS headers installed, code indented uniformly
 *
 */


/*==============*
 * HEADER FILES *
 *==============*/

#include <assert.h>
#include "all.h"
#include "mtypes.h"
#include "bitio.h"
#include "huff.h"
#include "postdct.h"
#include "mex.h" /* needed for mexErrMsgTxt prototype */


/*==================*
 * STATIC VARIABLES *
 *==================*/

/* ZAG[i] is the natural-order position of the i'th element of zigzag order. */
static int ZAG[] = {
    0, 1, 8, 16, 9, 2, 3, 10,
    17, 24, 32, 25, 18, 11, 4, 5,
    12, 19, 26, 33, 40, 48, 41, 34,
    27, 20, 13, 6, 7, 14, 21, 28,
    35, 42, 49, 56, 57, 50, 43, 36,
    29, 22, 15, 23, 30, 37, 44, 51,
    58, 59, 52, 45, 38, 31, 39, 46,
    53, 60, 61, 54, 47, 55, 62, 63
};


/*
 * possible optimization: reorder the qtable in the correct zigzag order, to
 * reduce the number of necessary lookups
 *
 * this table comes from the MPEG draft, p. D-16, Fig. 2-D.15.
 */
static int qtable[] = {
    8, 16, 19, 22, 26, 27, 29, 34,
    16, 16, 22, 24, 27, 29, 34, 37,
    19, 22, 26, 27, 29, 34, 34, 38,
    22, 22, 26, 27, 29, 34, 37, 40,
    22, 26, 27, 29, 32, 35, 40, 48,
    26, 27, 29, 32, 35, 40, 48, 58,
    26, 27, 29, 34, 38, 46, 56, 69,
    27, 29, 35, 38, 46, 56, 69, 83
};


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * Mpost_UnQuantZigBlock
 *
 *	unquantize and zig-zag (decode) a single block
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Mpost_UnQuantZigBlock(in, out, qscale, iblock)
    FlatBlock in;
    Block out;
    int qscale;
    boolean iblock;
{
    register int index;
    int	    start;
    int	    position;
    register int	    qentry;
    int	    level, coeff;

    if ( iblock ) {
	((int16 *)out)[0] = (int16)(in[0]*qtable[0]);

	start = 1;
    } else {
	start = 0;
    }

    for ( index = start; index < DCTSIZE_SQ; index++ ) {
	position = ZAG[index];

	if (iblock) {
	    qentry = qtable[position] * qscale;
	} else {
	    qentry = 16 * qscale;
	}

	level = in[index];

	if ( iblock ) {
	    coeff = (2*level*qentry) >> 4;
	    if ( (coeff & 1) == 0 ) {
		if ( coeff < 0 ) {
		    coeff++;
		} else if ( coeff > 0 ) {
		    coeff--;
		}
	    }

	    if ( coeff > 2047 ) {
		coeff = 2047;
	    } else if ( coeff < -2048 ) {
		coeff = -2048;
	    }
	} else {
	    if ( level == 0 ) {
		coeff = 0;
	    } else if ( level < 0 ) {
		coeff = (((2*level)-1)*qentry) >> 4;
		if ( (coeff & 1) == 0 ) {
		    coeff++;
		}
	    } else {
		coeff = (((2*level)+1)*qentry) >> 4;
		if ( (coeff & 1) == 0 ) {
		    coeff--;
		}
	    }

	    if ( coeff > 2047 ) {
		coeff = 2047;
	    } else if ( coeff < -2048 ) {
		coeff = -2048;
	    }
	}

	((int16 *)out)[position] = coeff;
    }
}


/*===========================================================================*
 *
 * Mpost_QuantZigBlock
 *
 *	quantize and zigzags a block
 *
 * RETURNS:	TRUE iff resulting output is non-zero, FALSE if all zero
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
boolean
Mpost_QuantZigBlock(in, out, qscale, iblock)
    Block in;
    FlatBlock out;
    register int qscale;
    int iblock;
{
    register int i;
    register int16 temp;
    register int qentry;
    register int position;
    boolean nonZero = FALSE;

    DBG_PRINT(("Mpost_QuantZigBlock...\n"));
    if (iblock) {
	/*
	 * the DC coefficient is handled specially -- it's not
	 * sensitive to qscale, but everything else is
	 */
	temp = ((int16 *) in)[ZAG[0]];
	qentry = qtable[ZAG[0]];

        if (temp < 0) {
            temp = -temp;
            temp += qentry >> 1;
            temp /= qentry;
            temp = -temp;
	} else {
            temp += qentry >> 1;
            temp /= qentry;
	}
	if ( temp != 0 ) {
	    nonZero = TRUE;
	}
	out[0] = temp;

	for (i = 1; i < DCTSIZE_SQ; i++) {
	    position = ZAG[i];
	    temp = ((int16 *) in)[position];

	    qentry = qtable[position] * qscale;

	    /* see 1993 MPEG doc, section D.6.3.4 */
	    if (temp < 0) {
		temp = -temp;
		temp = (temp << 3);
		temp += (qentry >> 1);
		temp /= qentry;
		temp = -temp;
	    } else {
		temp = (temp << 3);
		temp += (qentry >> 1);
		temp /= qentry;
	    }

	    if ( temp != 0 ) {
		nonZero = TRUE;
	    }
	    out[i] = temp;
	}
    } else {
	for (i = 0; i < DCTSIZE_SQ; i++) {
	    position = ZAG[i];
	    temp = ((int16 *) in)[position];

	    /* multiply by 16 */
	    qentry = qscale << 4;

	    /* see 1993 MPEG doc, D.6.4.5 */
	    temp = (temp << 3);
	    temp /= qentry;

	    if ( temp != 0 ) {
		nonZero = TRUE;
	    }
	    out[i] = temp;
	}
    }

    return nonZero;
}



/*===========================================================================*
 *
 * Mpost_RLEHuffIBlock
 *
 *	generate the huffman bits from an I-block
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Mpost_RLEHuffIBlock(in, out)
    FlatBlock in;
    BitBucket *out;
{
    register int i;
    register int nzeros = 0;
    register int16 cur;
    register int16 acur;
    register uint32 code;
    register int nbits;

    /*
     * yes, Virginia, we start at 1.  The DC coefficient is handled
     * specially, elsewhere.  Not here.
     */
    for (i = 1; i < DCTSIZE_SQ; i++) {
	cur = in[i];
	acur = ABS(cur);
	if (cur) {
	    if ( (nzeros < HUFF_MAXRUN) && (acur < huff_maxlevel[nzeros])) {
	        /*
		 * encode using the Huffman tables
		 */

		code = (huff_table[nzeros])[acur];
		nbits = (huff_bits[nzeros])[acur];

		if (cur < 0) {
		    code |= 1;	/* the sign bit */
		}
		Bitio_Write(out, code, nbits);
	    } else {
		/*
		 * encode using the escape code
		 */
		Bitio_Write(out, 0x1, 6);	/* ESCAPE */
		Bitio_Write(out, nzeros, 6);	/* Run-Length */

		/*
	         * this shouldn't happen, but the other
	         * choice is to bomb out and dump core...
	         */
		if (cur < -255) {
		    cur = -255;
		} else if (cur > 255) {
		    cur = 255;
		}

		DBG_PRINT(("Level\n"));
		if (acur < 128) {
		    Bitio_Write(out, cur, 8);
		} else {
		    if (cur < 0) {
			Bitio_Write(out, 0x8001 + cur + 255, 16);
		    } else {
			Bitio_Write(out, cur, 16);
		    }
		}
	    }
	    nzeros = 0;
	} else {
	    nzeros++;
	}
    }
    DBG_PRINT(("End of block\n"));
    Bitio_Write(out, 0x2, 2);	/* end of block marker */
}


/*===========================================================================*
 *
 * Mpost_RLEHuffPBlock
 *
 *	generate the huffman bits from an P-block
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
void
Mpost_RLEHuffPBlock(in, out)
    FlatBlock in;
    BitBucket *out;
{
    register int i;
    register int nzeros = 0;
    register int16 cur;
    register int16 acur;
    register uint32 code;
    register int nbits;
    boolean first_dct = TRUE;

    /*
     * yes, Virginia, we start at 0.
     */
    for (i = 0; i < DCTSIZE_SQ; i++) {
	cur = in[i];
	acur = ABS(cur);
	if (cur) {
	    if (nzeros < HUFF_MAXRUN && acur < huff_maxlevel[nzeros]) {
	        /*
		 * encode using the Huffman tables
		 */

		DBG_PRINT(("rle_huff %02d: Run %02d, Level %02d\n", i, nzeros, cur));
		assert(cur);

		if ( first_dct && (nzeros == 0) && (acur == 1) ) {
		    /* actually, only needs = 0x2 */
		    code = (cur == 1) ? 0x2 : 0x3;
		    nbits = 2;
		} else {
		    code = (huff_table[nzeros])[acur];
		    nbits = (huff_bits[nzeros])[acur];
		}

		assert(nbits);

		if (cur < 0) {
		    code |= 1;	/* the sign bit */
		}
		Bitio_Write(out, code, nbits);
		first_dct = FALSE;
	    } else {
		/*
		 * encode using the escape code
		 */
		DBG_PRINT(("Escape\n"));
		Bitio_Write(out, 0x1, 6);	/* ESCAPE */
		DBG_PRINT(("Run Length\n"));
		Bitio_Write(out, nzeros, 6);	/* Run-Length */

		assert(cur != 0);

		/*
	         * this shouldn't happen, but the other
	         * choice is to bomb out and dump core...
	         */
		if (cur < -255) {
		    cur = -255;
		} else if (cur > 255) {
		    cur = 255;
		}

		DBG_PRINT(("Level\n"));
		if (acur < 128) {
		    Bitio_Write(out, cur, 8);
		} else {
		    if (cur < 0) {
			Bitio_Write(out, 0x8001 + cur + 255, 16);
		    } else {
			Bitio_Write(out, cur, 16);
		    }
		}

		first_dct = FALSE;
	    }
	    nzeros = 0;
	} else {
	    nzeros++;
	}
    }

    /* actually, should REALLY return FALSE and not use this! */
    if ( first_dct ) {	/* have to give a first_dct even if all 0's */
	mexErrMsgTxt("MPEG Decoding error.");
    }

    DBG_PRINT(("End of block\n"));
    Bitio_Write(out, 0x2, 2);	/* end of block marker */
}
