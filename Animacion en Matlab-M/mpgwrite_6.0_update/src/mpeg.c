/*===========================================================================*
 * mpeg.c								     *
 *									     *
 *	Procedures to generate the MPEG sequence			     *
 *									     *
 * EXPORTED PROCEDURES:							     *
 *	SetFramePattern							     *
 *	GetMPEGStream							     *
 *	IncrementTCTime							     *
 *	SetStatFileName							     *
 *	SetGOPSize							     *
 *	PrintStartStats							     *
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
 *  $Header: /home/daf/mpeg/mpgwrite/RCS/mpeg.c,v 1.4 1994/01/11 21:32:45 daf Exp $
 *  $Log: mpeg.c,v $
 * Revision 1.4  1994/01/11  21:32:45  daf
 * Modified for PC compatibility
 *
 * Revision 1.3  1994/01/11  15:46:10  daf
 * Removed exit calls
 *
 * Revision 1.2  1994/01/07  17:21:24  daf
 * Modified for use as .mex file.
 *   malloc, free replaced with mxCalloc, mxFree.
 *   modified to call convert_frame in mpgwrite.c instead of the encoder's
 *     own file reading routines.
 *
 * Revision 1.6  1993/07/22  22:23:43  keving
 * nothing
 *
 * Revision 1.5  1993/06/30  20:06:09  keving
 * nothing
 *
 * Revision 1.4  1993/06/03  21:08:08  keving
 * nothing
 *
 * Revision 1.3  1993/02/19  18:10:12  keving
 * nothing
 *
 * Revision 1.2  1993/02/17  23:18:20  dwallach
 * checkin prior to keving's joining the project
 *
 */


/*==============*
 * HEADER FILES *
 *==============*/

#include "all.h"
#include <time.h>
#include <errno.h>
#include "mtypes.h"
#include "frames.h"
#include "search.h"
#include "mpeg.h"
#include "prototyp.h"
#include "parallel.h"
#include "param.h"
#include "readfram.h"
#include "fsize.h"
#include "mheaders.h"
#include "mex.h"


/*===========*
 * CONSTANTS *
 *===========*/

#define FRAMES_PER_SECOND   30


/*==================*
 * STATIC VARIABLES *
 *==================*/

static int32   diffTime;
static int framesOutput;
static int	    realStart, realEnd;
static int	currentGOP;
static int	    timeMask;
static int	    numI, numP, numB;


/*==================*
 * GLOBAL VARIABLES *
 *==================*/

int         IOtime;
int	    gopSize = 100;  /* default */
int32	    tc_hrs, tc_min, tc_sec, tc_pict;
int	    totalFramesSent;
int	    yuvWidth, yuvHeight;
int	    realWidth, realHeight;
FrameTable *frameTable;
char	    currentPath[MAXPATHLEN];
char	    statFileName[256];
time_t	    timeStart, timeEnd;
FILE	   *statFile;
char	   *framePattern;
int	    framePatternLen;
int	    referenceFrame;


/*
   External Procedure prototype
*/
void convert_frame(MpegFrame *frame, int n);

/*===============================*
 * INTERNAL PROCEDURE prototypes *
 *===============================*/

static void	ShowRmainingTime _ANSI_ARGS_((void));
static void	ComputeDHMSTime _ANSI_ARGS_((int32 someTime, char *timeText));
static void	ComputeGOPFrames _ANSI_ARGS_((int whichGOP, int *firstFrame,
					      int *lastFrame, int numFrames));
static void	PrintEndStats _ANSI_ARGS_((int inputFrameBits, int32 totalBits));
static void	ComputeFrameTable _ANSI_ARGS_((void));
static void	ProcessRefFrame _ANSI_ARGS_((FrameTable *entry,
					      BitBucket *bb, int lastFrame,
					      char *outputFileName));


/*=====================*
 * EXPORTED PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * SetReferenceFrameType
 *
 *	set the reference frame type to be original or decoded
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    referenceFrame
 *
 *===========================================================================*/
void
SetReferenceFrameType(type)
    char *type;
{
    if ( strcmp(type, "ORIGINAL") == 0 ) {
	referenceFrame = ORIGINAL_FRAME;
    } else if ( strcmp(type, "DECODED") == 0 ) {
	referenceFrame = DECODED_FRAME;
    } else {
	mexErrMsgTxt("Error in MPEG file.");
	     
    }
}


/*===========================================================================*
 *
 * SetFramePattern
 *
 *	set the IPB pattern; calls ComputeFrameTable to set up table
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    framePattern, framePatternLen, frameTable
 *
 *===========================================================================*/
void
SetFramePattern(pattern)
    char *pattern;
{
    int len = strlen(pattern);
    char *buf;
    int index;

    if ( ! pattern ) {
	mexErrMsgTxt("Error in MPEG file.");
    }

    if ( pattern[0] != 'i' && pattern[0] != 'I' ) {
	mexErrMsgTxt("Error in MPEG file.");
    }

    buf = (char *)mxCalloc(len+1, sizeof(char));
    ERRCHK(buf, "malloc");

    for ( index = 0; index < len; index++ ) {
	switch( pattern[index] ) {
	    case 'i':    case 'I':	buf[index] = 'i';	    break;
	    case 'p':    case 'P':	buf[index] = 'p';	    break;
	    case 'b':    case 'B':	buf[index] = 'b';	    break;
	    default:
		mexErrMsgTxt("Error in MPEG file.");
	}
    }
    buf[len] = 0;

    framePattern = buf;
    framePatternLen = len;

    ComputeFrameTable();
}


/*===========================================================================*
 *
 * GenMPEGStream
 *
 *	generate an MPEG sequence stream (generally)
 *	if whichGOP == frameStart == -1 then does complete MPEG sequence
 *	if whichGOP != -1 then does numbered GOP only (without sequence
 *			       header)
 *	if frameStart != -1 then does numbered frames only (without any
 *				 sequence or GOP headers)		       
 *
 * RETURNS:	amount of time it took
 *
 * SIDE EFFECTS:    too numerous to mention
 *
 *===========================================================================*/
int32
GenMPEGStream(whichGOP, frameStart, frameEnd, numFrames, ofp, outputFileName)
    int whichGOP;
    int frameStart;
    int frameEnd;
    int numFrames;
    FILE *ofp;
    char *outputFileName;
{
    BitBucket *bb;
    int i;
    char frameType;
    MpegFrame	*frame;
    FrameTable	*entry = NULL;
    int	    firstFrame, lastFrame;
    int  inputFrameBits = 0;
    char    inputFileName[1024];
    time_t  tempTimeStart, tempTimeEnd;

    time(&timeStart);

    ResetIFrameStats();
    ResetPFrameStats();
    ResetBFrameStats();

    Fsize_Reset();

    framesOutput = 0;

    if ( whichGOP != -1 ) {
	ComputeGOPFrames(whichGOP, &firstFrame, &lastFrame, numFrames);

	realStart = firstFrame;
	realEnd = lastFrame;

	if ( FRAME_TYPE(firstFrame) == 'b' ) {
	    /* need to load in previous frame; call it an I frame */
	    frame = Frame_New(firstFrame-1, 'i');

	    time(&tempTimeStart);

	    convert_frame(frame, firstFrame-1);
	   

	    time(&tempTimeEnd);
	    IOtime += (tempTimeEnd-tempTimeStart);

	    /* should put in the correct frameTable place */
	}
    } else if ( frameStart != -1 ) {
	if ( frameEnd > numFrames-1 ) {
	   mexErrMsgTxt("Error in MPEG file.");
	}
	
	realStart = frameStart;
	realEnd = frameEnd;
	
	firstFrame = frameStart;
	lastFrame = frameEnd;

	/* if first frame is P or B, need to read in P or I frame before it */
	if ( FRAME_TYPE(firstFrame) != 'i' ) {
	    entry = &(frameTable[firstFrame % framePatternLen]);
	    
	    firstFrame = firstFrame - (entry->number - entry->prev->number);
	}

	/* if last frame is B, need to read in P or I frame after it */
	if ( (FRAME_TYPE(lastFrame) == 'b') && (lastFrame != numFrames-1) ) {
	    entry = &(frameTable[lastFrame % framePatternLen]);
	    
	    lastFrame = lastFrame + (entry->next->number - entry->number);
	}

	if ( lastFrame > numFrames-1 ) {	    /* can't go last frame! */
	    lastFrame = numFrames-1;
	}
    } else {
	firstFrame = 0;
	lastFrame = numFrames-1;

	realStart = 0;
	realEnd = numFrames-1;
    }

    /* count number of I, P, and B frames */
    numI = 0;	numP = 0;   numB = 0;
    timeMask = 0;
    for ( i = firstFrame; i <= lastFrame; i++ ) {
	frameType = FRAME_TYPE(i);
	switch(frameType) {
	    case 'i':	numI++;	    timeMask |= 0x1;    break;
	    case 'p':	numP++;	    timeMask |= 0x2;	break;
	    case 'b':	numB++;	    timeMask |= 0x4;	break;
	}
    }

/*
    if ( ! childProcess ) {
	PrintStartStats(realStart, realEnd);
    }
*/

    if ( frameStart == -1 ) {
	bb = Bitio_New(ofp);
    } else {
	bb = NULL;
    }

    tc_hrs = 0;	tc_min = 0; tc_sec = 0; tc_pict = 0;
    for ( i = 0; i < firstFrame; i++ ) {
	IncrementTCTime();
    }

    totalFramesSent = firstFrame;
    currentGOP = gopSize;	/* so first I-frame generates GOP Header */

#ifdef BLEAH 
fprintf(stdout, "firstFrame, lastFrame = %d, %d;  real = %d, %d\n",
	firstFrame, lastFrame, realStart, realEnd);
fflush(stdout);
#endif

    for ( i = firstFrame; i <= lastFrame; i++) {
	frameType = FRAME_TYPE(i);

	/* skip non-reference frames */
	if ( frameType == 'b' ) {
	    continue;
	}

	frame = Frame_New(i, frameType);
	if ( (i != firstFrame) && ((i % framePatternLen) == 0) ) {
	    entry = &(frameTable[framePatternLen]);
	} else {
	    entry = &(frameTable[i % framePatternLen]);
	}

	entry->frame = frame;

	time(&tempTimeStart);

	if ( (referenceFrame == DECODED_FRAME) &&
	    ((i < realStart) || (i > realEnd)) ) {
	    /* WaitForDecodedFrame(i); */
	    
	    ReadDecodedRefFrame(frame, i);
	
	} else {
	    convert_frame(frame, i);
	}

	time(&tempTimeEnd);
	IOtime += (tempTimeEnd-tempTimeStart);

	if ( i == firstFrame ) {
	    inputFrameBits = 24*Fsize_x*Fsize_y;
	    SetBlocksPerSlice();

	    if ( (whichGOP == -1) && (frameStart == -1) ) {
		DBG_PRINT(("Generating sequence header\n"));
		Mhead_GenSequenceHeader(bb, Fsize_x, Fsize_y, /* pratio */ 1,
			   /* pict_rate */ -1, /* bit_rate */ -1,
			   /* buf_size */ -1, /*c_param_flag */ 1,
			   /* iq_matrix */ NULL, /* niq_matrix */ NULL,
			   /* ext_data */ NULL, /* ext_data_size */ 0,
			   /* user_data */ NULL, /* user_data_size */ 0);
	    }
	}

	ProcessRefFrame(entry, bb, lastFrame, outputFileName);

	/* in case this is first frame of pattern sequence; put it	
	    back to 0 */
	if ( entry == &frameTable[framePatternLen]) {
	    frameTable[0].frame = frame;
	}
    }

    if ( entry->frame != NULL ) {
	Frame_Free(entry->frame);
    }

    /* SEQUENCE END CODE */
    if ( (whichGOP == -1) && (frameStart == -1) ) {
	Mhead_GenSequenceEnder(bb);
    }
    
    if ( frameStart == -1 ) {
	Bitio_Flush(bb);
	fclose(ofp);

	time(&timeEnd);
	diffTime = (int32)(timeEnd-timeStart);

/*
	if ( ! childProcess ) {
	    PrintEndStats(inputFrameBits, bb->cumulativeBits);
	}
*/
    } else {
	time(&timeEnd);
	diffTime = (int32)(timeEnd-timeStart);

/*	
	if ( ! childProcess ) {
	    PrintEndStats(inputFrameBits, 1);
	}
*/
    }
    
    return diffTime;
}

/*===========================================================================*
 *
 * IncrementTCTime
 *
 *	increment the tc time by one second (and update min, hrs if necessary)
 *	also increments totalFramesSent
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    totalFramesSent, tc_pict, tc_sec, tc_min, tc_hrs
 *
 *===========================================================================*/
void
IncrementTCTime()
{
    totalFramesSent++;
    tc_pict++;
    if ( tc_pict == FRAMES_PER_SECOND ) {
	tc_pict = 0;
	tc_sec++;
	if ( tc_sec == 60 ) {
	    tc_sec = 0;
	    tc_min++;
	    if ( tc_min == 60 ) {
		tc_min = 0;
		tc_hrs++;
	    }
	}
    }
}


/*===========================================================================*
 *
 * SetStatFileName
 *
 *	set the statistics file name
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    statFileName
 *
 *===========================================================================*/
void
SetStatFileName(fileName)
    char *fileName;
{
    strcpy(statFileName, fileName);
}


/*===========================================================================*
 *
 * SetGOPSize
 *
 *	set the GOP size (frames per GOP)
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    gopSize
 *
 *===========================================================================*/
void
SetGOPSize(size)
    int size;
{
    gopSize = size;
}

/*===========================================================================*
 *
 * PrintStartStats
 *
 *	print out the starting statistics (stuff from the param file)
 *	firstFrame, lastFrame represent the first, last frames to be
 *	encoded
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
void
PrintStartStats(firstFrame, lastFrame)
    int firstFrame;
    int lastFrame;
{
    FILE *fpointer;
    register int i;
    char    inputFileName[1024];

    if ( statFileName[0] == '\0' ) {
	statFile = NULL;
    } else {
	statFile = fopen(statFileName, "a");	* open for appending *
	if ( statFile == NULL ) {
	    fprintf(stderr, "ERROR:  Could not open stat file:  %s\n", statFileName);
	    fprintf(stderr, "        Sending statistics to stdout only.\n");
	    fprintf(stderr, "\n\n");
	} else {
	    fprintf(stdout, "Appending statistics to file:  %s\n", statFileName);
	    fprintf(stdout, "\n\n");
	}
    }
	
    for ( i = 0; i < 2; i++ ) {
	if ( i == 0 ) {
	    fpointer = stdout;
	} else if ( statFile != NULL ) {
	    fpointer = statFile;
	} else {
	    continue;
	}

	fprintf(fpointer, "MPEG ENCODER STATS\n");
	fprintf(fpointer, "------------------\n");
	fprintf(fpointer, "TIME STARTED:  %s", ctime(&timeStart));
	if ( getenv("HOST") != NULL ) {
	    fprintf(fpointer, "MACHINE:  %s\n", getenv("HOST"));
	} else {
	    fprintf(fpointer, "MACHINE:  unknown\n");
	}
*
	if ( firstFrame == -1 ) {
	    fprintf(fpointer, "OUTPUT:  %s\n", outputFileName);
	} else {
	    GetNthInputFileName(inputFileName, firstFrame); 
	    fprintf(fpointer, "FIRST FILE:  %s/%s\n", currentPath, inputFileName);
	     GetNthInputFileName(inputFileName, lastFrame); 
	    fprintf(fpointer, "LAST FILE:  %s/%s\n", currentPath,
		    inputFileName);
	}
*
	fprintf(fpointer, "PATTERN:  %s\n", framePattern);
	fprintf(fpointer, "GOP_SIZE:  %d\n", gopSize);
	fprintf(fpointer, "SLICES PER FRAME:  %d\n", slicesPerFrame);
	fprintf(fpointer, "RANGE:  +/-%d\n", searchRange/2);
	fprintf(fpointer, "FULL SEARCH:  %d\n", pixelFullSearch);
	fprintf(fpointer, "PSEARCH:  %s\n", PSearchName());
	fprintf(fpointer, "BSEARCH:  %s\n", BSearchName());
	fprintf(fpointer, "QSCALE:  %d %d %d\n", qscaleI, 
		GetPQScale(), GetBQScale());
	if ( referenceFrame == DECODED_FRAME ) {
	    fprintf(fpointer, "REFERENCE FRAME:  DECODED\n");
	} else if ( referenceFrame == ORIGINAL_FRAME ) {
	    fprintf(fpointer, "REFERENCE FRAME:  ORIGINAL\n");
	} else {
	    fprintf(stderr, "ERROR:  Illegal referenceFrame!!!\n");
	    
	}
    }

    fprintf(stdout, "\n\n");
}
*/


/*===========================================================================*
 *
 * NonLocalRefFrame
 *
 *	decides if this frame can be referenced from a non-local process
 *
 * RETURNS:	TRUE or FALSE
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
boolean
NonLocalRefFrame(id)
    int id;
{
    int	    lastIPid;
    int	    nextIPid;
    FrameTable *entry = NULL;

    if ( ! childProcess ) {
	return FALSE;
    }

    if ( (id % framePatternLen) == 0 ) {
	entry = &frameTable[framePatternLen];
    } else {
	entry = &(frameTable[id % framePatternLen]);
    }

    if ( entry == NULL ) {
	mexErrMsgTxt("MPEG Decoding error.");
    }

    lastIPid = id - (entry->number - entry->prev->number);

    /* might be accessed by B-frame */
    if ( lastIPid+1 < realStart ) {
	return TRUE;
    }

    entry = &(frameTable[id % framePatternLen]);

    /* if B-frame is out of range, then current frame can be ref'd by it */
    nextIPid = id + (entry->next->number - entry->number);

    /* might be accessed by B-frame */
    if ( nextIPid-1 > realEnd ) {
	return TRUE;
    }

    /* might be accessed by P-frame */
    if ( (nextIPid > realEnd) && (FRAME_TYPE(nextIPid) == 'p') ) {
	return TRUE;
    }

    return FALSE;
}
    

/*=====================*
 * INTERNAL PROCEDURES *
 *=====================*/

/*===========================================================================*
 *
 * ComputeDHMSTime
 *
 *	turn some number of seconds (someTime) into a string which
 *	summarizes that time according to scale (days, hours, minutes, or
 *	seconds)
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
static void
ComputeDHMSTime(someTime, timeText)
    int32 someTime;
    char *timeText;
{
    int	    days, hours, mins, secs;

    days = someTime / (24*60*60);
    someTime -= days*24*60*60;
    hours = someTime / (60*60);
    someTime -= hours*60*60;
    mins = someTime / 60;
    secs = someTime - mins*60;

    if ( days > 0 ) {
        sprintf(timeText, "Total time:  %d days and %d hours", days, hours);
    } else if ( hours > 0 ) {
        sprintf(timeText, "Total time:  %d hours and %d minutes", hours, mins);
    } else if ( mins > 0 ) {
        sprintf(timeText, "Total time:  %d minutes and %d seconds", mins, secs);
    } else {
	 sprintf(timeText, "Total time:  %d seconds", secs);
    }
}


/*===========================================================================*
 *
 * ComputeGOPFrames
 *
 *	calculate the first, last frames of the numbered GOP
 *
 * RETURNS:	lastFrame, firstFrame changed
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
static void
ComputeGOPFrames(whichGOP, firstFrame, lastFrame, numFrames)
    int whichGOP;
    int *firstFrame;
    int *lastFrame;
    int numFrames;
{
    int	    passedB;
    int	    currGOP;
    int	    gopNum, frameNum;

    /* calculate first, last frames of whichGOP GOP */

    *firstFrame = -1;
    *lastFrame = -1;
    gopNum = 0;
    frameNum = 0;
    passedB = 0;
    currGOP = 0;
    while ( *lastFrame == -1 ) {
	if ( frameNum >= numFrames ) {
	    mexErrMsgTxt("Error in MPEG file.");
	}

fprintf(stdout, "GOP STARTS AT %d\n", frameNum-passedB);

	if ( gopNum == whichGOP ) {
	    *firstFrame = frameNum-passedB;
	}

	/* go past one gop */
	while ( (frameNum < numFrames) && 
		((FRAME_TYPE(frameNum) != 'i') || currGOP < gopSize) ) {
	    currGOP += (1 + passedB);

	    frameNum++;

	    passedB = 0;
	    while ( FRAME_TYPE(frameNum) == 'b' ) {
		frameNum++;
		passedB++;
	    }
	}

	currGOP -= gopSize;

	if ( gopNum == whichGOP ) {
	    *lastFrame = (frameNum-passedB-1);
	}

fprintf(stdout, "GOP ENDS at %d\n", frameNum-passedB-1);

	gopNum++;
    }
}


/*===========================================================================*
 *
 * PrintEndStats
 *
 *	print end statistics (summary, time information)
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
static void
PrintEndStats(inputFrameBits, totalBits)
    int inputFrameBits;
    int32 totalBits;
{
    FILE *fpointer;
    register int i;
    char    timeText[256];

    fprintf(stdout, "\n\n");

    ComputeDHMSTime(diffTime, timeText);

    for ( i = 0; i < 2; i++ ) {
	if ( i == 0 ) {
	    fpointer = stdout;
	} else if ( statFile != NULL ) {
	    fpointer = statFile;
	} else {
	    continue;
	}

	fprintf(fpointer, "TIME COMPLETED:  %s", ctime(&timeEnd));
	fprintf(fpointer, "%s\n\n", timeText);

	ShowIFrameSummary(inputFrameBits, totalBits, fpointer);
	ShowPFrameSummary(inputFrameBits, totalBits, fpointer);
	ShowBFrameSummary(inputFrameBits, totalBits, fpointer);
	fprintf(fpointer, "---------------------------------------------\n");
	fprintf(fpointer, "Total Compression:  %3d:1\n",
		framesOutput*inputFrameBits/totalBits);
	fprintf(fpointer, "Total Frames Per Second:  %f\n",
		(float)framesOutput/(float)diffTime);
	fprintf(fpointer, "Total Output Bit Rate (30 fps):  %d bits/sec\n",
		30*totalBits/framesOutput);
	fprintf(fpointer, "\n\n");
    }

    if ( statFile != NULL ) {
	fclose(statFile);
    }
}
*/


/*===========================================================================*
 *
 * ComputeFrameTable
 *
 *	compute a table of I, P, B frames to help in determining dependencies
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    frameTable
 *
 *===========================================================================*/
static void
ComputeFrameTable()
{
    register int index;
    FrameTable	*lastI, *lastIP, *firstB;
    FrameTable	*ptr;
    int	    numberP, numberN, numberNO;

    frameTable = (FrameTable *) mxCalloc(framePatternLen+1, sizeof(FrameTable));

    lastI = NULL;
    lastIP = NULL;
    firstB = NULL;
    for ( index = 0; index < framePatternLen; index++ ) {
	frameTable[index].number = index;
	frameTable[index].freeNow = TRUE;
	frameTable[index].frame = NULL;

	switch( framePattern[index] ) {
	    case 'i':
		ptr = firstB;
		while ( ptr != NULL ) {
		    ptr->next = &(frameTable[index]);
		    ptr = ptr->nextOutput;
		}
		frameTable[index].nextOutput = firstB;
		frameTable[index].prev = lastIP;	/* for freeing */
		if ( lastIP != NULL ) {
		    lastIP->next = &(frameTable[index]);
		}
		lastIP = &(frameTable[index]);
		firstB = NULL;
		break;
	    case 'p':
		ptr = firstB;
		while ( ptr != NULL ) {
		    ptr->next = &(frameTable[index]);
		    ptr = ptr->nextOutput;
		}
		frameTable[index].nextOutput = firstB;
		frameTable[index].prev = lastIP;
		if ( lastIP != NULL ) {
		    lastIP->next = &(frameTable[index]);
		}
		lastIP->freeNow = FALSE;
		lastIP = &(frameTable[index]);
		firstB = NULL;
		break;
	    case 'b':
		if ( (index+1 == framePatternLen) ||
		     (framePattern[index+1] != 'b') ) {
		    frameTable[index].nextOutput = NULL;
		} else {
		    frameTable[index].nextOutput = &(frameTable[index+1]);
		}
		frameTable[index].prev = lastIP;
		lastIP->freeNow = FALSE;
		if ( firstB == NULL ) {
		    firstB = &(frameTable[index]);
		}
		break;
	}
    }

    frameTable[framePatternLen].number = framePatternLen;
    frameTable[framePatternLen].frame = NULL;

    ptr = firstB;
    while ( ptr != NULL ) {
	ptr->next = &(frameTable[framePatternLen]);
	ptr = ptr->nextOutput;
    }
    frameTable[framePatternLen].nextOutput = firstB;
    frameTable[framePatternLen].prev = lastIP;
    frameTable[framePatternLen].freeNow = frameTable[0].freeNow;

    frameTable[0].prev = lastIP;
    if ( lastIP != NULL ) {
	lastIP->next = &(frameTable[framePatternLen]);
    }

    for ( index = 0; index < framePatternLen+1; index++ ) {
	if ( frameTable[index].prev == NULL ) {
	    numberP = -1;
	} else {
	    numberP = frameTable[index].prev->number;
	}

	if ( frameTable[index].next == NULL ) {
	    numberN = -1;
	} else {
	    numberN = frameTable[index].next->number;
	}

	if ( frameTable[index].nextOutput == NULL ) {
	    numberNO = -1;
	} else {
	    numberNO = frameTable[index].nextOutput->number;
	}
    }
}


/*===========================================================================*
 *
 * ProcessRefFrame
 *
 *	process an I or P frame -- encode it, and process any B frames that
 *	we can now
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    stuff appended to bb
 *
 *===========================================================================*/
static void
ProcessRefFrame(entry, bb, lastFrame, outputFileName)
    FrameTable *entry;
    BitBucket *bb;
    int lastFrame;
    char *outputFileName;
{
    FrameTable *ptr;
    char    fileName[1024];
    char    inputFileName[1024];
    FILE    *fpointer = NULL;
    boolean separateFiles;
    int	    id;
    time_t  tempTimeStart, tempTimeEnd;

    separateFiles = (bb == NULL);

    if ( separateFiles && (entry->frame->id >= realStart) &&
	 (entry->frame->id <= realEnd) ) {
	sprintf(fileName, "%s.frame.%d", outputFileName, entry->frame->id);
	if ( (fpointer = fopen(fileName, "w")) == NULL ) {
           mexErrMsgTxt("Could not open output file.");
       }

	bb = Bitio_New(fpointer);

    }

    /* nothing to do */
    if ( entry->frame->id < realStart ) {
	return;
    }

    /* first, output this frame */
    if ( entry->frame->type == TYPE_IFRAME ) {
	/* only start a new GOP with I */
	/* don't start GOP if only doing frames */
	if ( (! separateFiles) && (currentGOP >= gopSize) ) {
	    int closed;

	    /* first, check to see if closed GOP */
	    if ( totalFramesSent == entry->frame->id ) {
		closed = 1;
	    } else {
		closed = 0;
	    }

/*
	    fprintf(stdout, "Creating new GOP (closed = %d) before frame %d\n",
		    closed, entry->frame->id);
*/

	    /* new GOP */
	    Mhead_GenGOPHeader(bb, /* drop_frame_flag */ 0,
		       tc_hrs, tc_min, tc_sec, tc_pict,
		       closed, /* broken_link */ 0,
		       /* ext_data */ NULL, /* ext_data_size */ 0,
		       /* user_data */ NULL, /* user_data_size */ 0);
	    currentGOP -= gopSize;
	    SetGOPStartTime(entry->frame->id);
	}

	if ( (entry->frame->id >= realStart) && (entry->frame->id <= realEnd) ) {
	    GenIFrame(bb, entry->frame);
	    framesOutput++;

	    if ( separateFiles ) {
	        Bitio_Flush(bb);
		fclose(fpointer);
	    }
	}

	numI--;
	timeMask &= 0x6;

	currentGOP++;
	IncrementTCTime();
    } else {
	if ( (entry->frame->id >= realStart) && (entry->frame->id <= realEnd) ) {
	    GenPFrame(bb, entry->frame, entry->prev->frame);
	    framesOutput++;

	    if ( separateFiles ) {
		Bitio_Flush(bb);
		fclose(fpointer);
	    }
	}

	numP--;
	timeMask &= 0x5;
/*
	ShowRemainingTime();
*/
	currentGOP++;
	IncrementTCTime();
    }

    /* now, follow nextOutput and output B-frames */
    ptr = entry->nextOutput;
    while ( ptr != NULL ) {
	id = entry->frame->id - (entry->number - ptr->number);

	if ( (id >= realStart) && (id <= realEnd) ) {
	    ptr->frame = Frame_New(id, 'b');

	    time(&tempTimeStart);

	    /* read B frame, output it */
	    convert_frame(ptr->frame, id);

	    time(&tempTimeEnd);
	    IOtime += (tempTimeEnd-tempTimeStart);

	    if ( separateFiles ) {
		sprintf(fileName, "%s.frame.%d", outputFileName, ptr->frame->id);
		if ( (fpointer = fopen(fileName, "w")) == NULL ) {
		    mexErrMsgTxt("Could not open output file.");
		}
		bb = Bitio_New(fpointer);
	    }

	    GenBFrame(bb, ptr->frame, ptr->prev->frame, ptr->next->frame);
	    framesOutput++;

	    if ( separateFiles ) {
		Bitio_Flush(bb);
		fclose(fpointer);
	    }

	    /* free this B frame right away */
	    Frame_Free(ptr->frame);
	    ptr->frame = NULL;
	}

	numB--;
	timeMask &= 0x3;
/*
	ShowRemainingTime();
*/
	currentGOP++;
	IncrementTCTime();

	ptr = ptr->nextOutput;
    }

    /* now free previous frame, if there was one */
    if ( (entry->frame->type != TYPE_IFRAME) ||
	 (entry->nextOutput != NULL) ) {
	if ( entry->prev->frame != NULL ) {
	    Frame_Free(entry->prev->frame);
	    entry->prev->frame = NULL;
	}
    }

    /* check to see if we can free this frame now */
    if ( entry->freeNow || (entry->frame->id == lastFrame) ) {
	if ( entry->frame != NULL ) {
	    Frame_Free(entry->frame);
	    entry->frame = NULL;
	}
    }

    /* note, we may still not free last frame if lastFrame is incorrect
	(if the last frames are B frames, they aren't output!)
     */
}


/*===========================================================================*
 *
 * ShowRemainingTime
 *
 *	print out an estimate of the time left to encode
 *
 * RETURNS:	nothing
 *
 * SIDE EFFECTS:    none
 *
 *===========================================================================*/
/*
static void
ShowRemainingTime()
{
    static int	lastTime = 0;
    float   timeI, timeP, timeB;
    float   total;

    if ( childProcess ) {
	return * nothing *;
    }

    if ( numI + numP + numB == 0 ) {	* no time left *
	return * nothing * ;
    }

    if ( timeMask != 0 ) {	    * haven't encoded all types yet *
	return * nothing * ;
    }

    timeI = EstimateSecondsPerIFrame();
    timeP = EstimateSecondsPerPFrame();
    timeB = EstimateSecondsPerBFrame();

    total = (float)numI*timeI + (float)numP*timeP + (float)numB*timeB;

    if ( (quietTime >= 0) &&
	 (((lastTime-(int)total) >= quietTime) || (lastTime == 0)) ) {
	if ( total > 270.0 ) {
	    fprintf(stdout, "ESTIMATED TIME OF COMPLETION:  %d minutes\n",
		    ((int)total+30)/60);
	} else {
	    fprintf(stdout, "ESTIMATED TIME OF COMPLETION:  %d seconds\n",
		    (int)total);
	}

	lastTime = (int)total;
    }
}
*/


void
ReadDecodedRefFrame(frame, frameNumber)
    MpegFrame *frame;
    int frameNumber;
{
    FILE    *fpointer;
    char    fileName[256];
    int	width, height;
    register int y;

    width = Fsize_x;
    height = Fsize_y;

    sprintf(fileName, "%s.decoded.%d", outputFileName, frameNumber);
    fprintf(stdout, "reading %s\n", fileName);
    fflush(stdout);

    fpointer = fopen(fileName, "r");

	Frame_AllocDecoded(frame, TRUE);

	for ( y = 0; y < height; y++ ) {
	    fread(frame->decoded_y[y], 1, width, fpointer);
	}

	for (y = 0; y < height / 2; y++) {			/* U */
	    fread(frame->decoded_cb[y], 1, width / 2, fpointer);
	}

	for (y = 0; y < height / 2; y++) {			/* V */
	    fread(frame->decoded_cr[y], 1, width / 2, fpointer);
	}

    fclose(fpointer);
}
