
/************************************************************************

MPGWRITE

This file contains the mexFunction for mex file MPEG encoder which
translates Matlab movies into MPEG files.

This function also contains the following functions:
convert_frame:     converts a Matlab movie frame into a YUV frame.
run_encoder:       sets up parameters and runs the MPEG encoder.

*************************************************************************/

/*
Copyright (c) 1994-1997, The MathWorks, Inc.
All rights reserved.
Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer. 
* Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution. 
* Neither the name of the <ORGANIZATION> nor the names of its contributors may 
be used to endorse or promote products derived from this software without 
specific prior written permission. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/************************************************************************
                          R C S Information
*************************************************************************/
/* $Log: mpgwrite.c,v $
 * Revision Changed mexFunction and mxIsString to proper v5 standards *
 * October 1997

 * Revision 1.10  1994/01/14  14:53:24  daf
 * Fixed call to mxFree with wrong pointer.
 *
 * Revision 1.9  1994/01/12  18:58:02  daf
 * Cleaned up a few things.
 *
 * Revision 1.8  1994/01/12  18:34:10  daf
 * Added RCS header.
 * 

 * revision 1.7    locked by: daf;
 * date: 1994/01/11 21:53:14;  author: daf;  state: Exp;  lines: +3 -3
 * Changed < 31 to be <= 31 in quantization scale error checking.

 * revision 1.6
 * date: 1994/01/11 21:34:04;  author: daf;  state: Exp;  lines: +2 -2
 * *** empty log message ***

 * revision 1.5
 * date: 1994/01/11 20:53:32;  author: daf;  state: Exp;  lines: +6 -0
 * Modified for PC compatibility

 * revision 1.4
 * date: 1994/01/11 19:07:02;  author: daf;  state: Exp;  lines: +7 -1
 * Now adds .mpg if no extension given

 * revision 1.3
 * date: 1994/01/11 15:46:29;  author: daf;  state: Exp;  lines: +11 -10
 * Removed exit calls

 * revision 1.2
 * date: 1994/01/07 18:56:56;  author: daf;  state: Exp;  lines: +4 -0
 * Added search range error checking.

 * revision 1.1
 * date: 1994/01/07 17:16:26;  author: daf;  state: Exp;
 * Initial revision
*/


#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <stdio.h>
#ifndef WIN32
#include <memory.h>
#endif
#include "mex.h"

#define MAIN_FILE

/* MPEG ENCODER INCLUDE FILES */
#include "mtypes.h"
#include "mpeg.h"
#include "search.h"
#include "prototyp.h"
#include "param.h"
#include "parallel.h"
#include "readfram.h"
#include "combine.h"
#include "frames.h"
#include "fsize.h"


/* STATIC VARIABLES */
static double *m;         /* pointer to the movie matrix values */
static double *cm;        /* pointer to the colormap matrix values */
static int m_rows;        /* number of rows in movie */
static int m_cols;        /* number of columns in movie */
static int cm_rows;       /* number of rows in colormap */
static int n_options;     /* number of options given by user */
static double *options;   /* pointer to the options matrix values */

static int NewMovieFormat = 0;  /* Flag indicating 5.3 movie format */
static const mxArray *newMovie = NULL;  /* The Movie struct in 5.3 and later */

/* MPEG ENCODER STATIC VARIABLES */
static int	frameStart = -1;
static int	frameEnd;

/* MPEG ENCODER GLOBAL VARIABLES */
char outputFileName[MAXPATHLEN];
extern char currentPath[MAXPATHLEN];
/* extern time_t IOtime;*/
int	whichGOP = -1;
boolean	childProcess = FALSE;
boolean	ioServer = FALSE;
boolean	outputServer = FALSE;
boolean	decodeServer = FALSE;
int	quietTime = 0;
boolean	frameSummary = TRUE;
boolean debugSockets = FALSE;
boolean debugMachines = FALSE;
int numInputFiles = 0;         /* actually the number of frames */
char inputConversion[1024];

/* function prototypes */
void convert_frame(MpegFrame *frame, int n);
void run_encoder(void);
void mexFunction(
    int           nlhs,           /* number of expected outputs */
    mxArray       *plhs[],        /* array of pointers to output arguments */
    int           nrhs,           /* number of inputs */
#if !defined(V4_COMPAT)
    const mxArray *prhs[]         /* array of pointers to input arguments */
#else
    mxArray *prhs[]         /* array of pointers to input arguments */
#endif
);

/* Little Endian - Big Endian conversion */
typedef enum {ELITTLE_ENDIAN, EBIG_ENDIAN} ByteOrder;

ByteOrder MOVIE_GetClientByteOrder(void)
{
    const short one = 1;
    return((*((char *) &one) == 1) ? ELITTLE_ENDIAN : EBIG_ENDIAN );
}

#define FLIPBYTES(x)                                                     \
(                                                                         \
((x&0xff) << 24) | ((x & 0xff00) << 8) | ((x & 0xff0000) >> 8) | (x >> 24) \
)


/*
====================================================================
mexFunction

This routine is the Matlab external interface function which is
called by Matlab when the user executes the MOV2MPEG command.
It processes arguments and calls run_encoder to translate the 
passed movie into MPEG format.
=====================================================================
*/
void mexFunction(
    int           nlhs,           /* number of expected outputs */
    mxArray       *plhs[],        /* array of pointers to output arguments */
    int           nrhs,           /* number of inputs */
#if !defined(V4_COMPAT)
    const mxArray *prhs[]         /* array of pointers to input arguments */
#else
    mxArray *prhs[]         /* array of pointers to input arguments */
#endif
)
{
	double *aDoublePtr;

  /* check arguments */
  if (nlhs > 0)
    mexErrMsgTxt("MPGWRITE returns nothing.");
  if (nrhs > 4)
    mexErrMsgTxt("Too many arguments.");
  if (nrhs < 3)
    mexErrMsgTxt("Too few arguments.");
  if (!mxIsChar(prhs[2]))
    mexErrMsgTxt("Third argument (file name) must be a string.");
 
  mxGetString(prhs[2], outputFileName, MAXPATHLEN);
  if (strchr(outputFileName, '.') == NULL)
    strcat(outputFileName, ".mpg");
  
  /* store the data from the movie and colormap into global arrays */
  cm = mxGetPr(prhs[1]);

  /* store the size of the movie into global variables */
  if (mxIsDouble(prhs[0])) 
  {
    m = mxGetPr(prhs[0]);
    m_cols = mxGetN(prhs[0]);
    m_rows = mxGetM(prhs[0]);

    aDoublePtr = mxGetPr( prhs[0] );
    NewMovieFormat = 0;
    if ((*aDoublePtr < 8) || (*(aDoublePtr+1) < 8))
      mexErrMsgTxt("Movie is too small.");
  } else {
    newMovie = prhs[0];
    NewMovieFormat = 1;
    m_cols = mxGetM(prhs[0]) * mxGetN(prhs[0]);
    m_rows = 1;
  }

  /* store the size of the colormap */
  cm_rows = mxGetM(prhs[1]);

  /* check for and process the fourth argument which contains options */
  if (nrhs == 4)
  {
    if (mxGetN(prhs[3]) > 1)
    {
      n_options = mxGetN(prhs[3]);
      if (mxGetM(prhs[3]) > 1)
        mexErrMsgTxt("Fourth argument must be a vector");
    }
    else
      n_options = mxGetM(prhs[3]);
  
    options = mxGetPr(prhs[3]);
  }
  else
  {
    options = NULL;
    n_options = 0;
  }
 
  /* call rountine to run the MPEG encoder on the Matlab movie */  
  run_encoder();
}


/*
====================================================================
run_encoder

This function is called by mexFunction as an interface to the 
MPEG encoder by L.A. Rowe, K. Patel, and B. Smith of U. Cal. Berkeley.
This function replaces their main function and their functions used to
parse the parameters file which does not exist in this mex implementation.
====================================================================
*/
void run_encoder(void)
{
  int32    totalTime = -1;    /* store encoding time */                 
  char     psearch_alg[40];   /* store name of p-search method */
  char     bsearch_alg[40];   /* store name of b-search method */
  char     ref_frame[40];     /* store name of reference frame option */
  int      pix_range;         /* search radius in pixels */
  int      iqscale;           /* store the quantization values */
  int      pqscale;
  int      bqscale;
  int      num_repeats;       /* store the number of times to repeat movie */
  FILE     *ofp;              /* file pointer for output MPEG file */

  
  /* get width and height of first frame - assume they are the same for all
   * frames */
  if (!NewMovieFormat) {
    yuvWidth = *m;
    yuvHeight = *(m+1);
  } else {
    mxArray *frame1 = mxGetField(newMovie, 0, "cdata");
    const int *dims = mxGetDimensions(frame1);
    yuvWidth = dims[1];
    yuvHeight = dims[0];
    /* Error if all frames are not the same size */
    {
      int i;
      for (i = 0; i < m_cols; i++) {
	mxArray *f = mxGetField(newMovie, i, "cdata");
	dims = mxGetDimensions(f);
	if ((dims[1] != yuvWidth) || (dims[0] != yuvHeight)) {
	  mexErrMsgTxt("All movie frames must have the same size");
	}
      }
    }
  }
  realWidth = yuvWidth;
  realHeight = yuvHeight;
  
  /* define some globals for encoder */
  frameSummary = FALSE;
  decodeRefFrames = FALSE;
  frameStart = -1;
  whichGOP = -1;

  /* Establish parameters for encoding the MPEG movie */

  /* User-Definable Parameters are as follows: 
     Repeat: an integer number of times to repeat the Matlab movie sequence.
     P-search algorithm: 0* = logarithmic, 1 = subsample, 2 = exhaustive
     B-search algorithm: 0 = simple, 1* = cross2, 2 = exhaustive
     Reference Frame: 0* = original, 1 = decoded
     Range: number of pixels (default = 10)
     IQ scale: 1-31 (default = 8)
     PQ scale: 1-31 (default = 10)
     BQ scale: 1-31 (dfault = 25)
       In above three, use higher numbers for greater compression
  */

  /* set user-defined parameter values */
  
  if (n_options > 0)
  {
    if ((int)options[0] > 0)
      num_repeats = (int)options[0];
    else
      num_repeats = 1;
  }
  else
    num_repeats = 1;

  if (n_options > 1)
  {
    switch ((int)options[1])
    {
      case 0:
        sprintf(psearch_alg, "LOGARITHMIC");
        break;
      case 1:
        sprintf(psearch_alg, "SUBSAMPLE");
        break;
      case 2:
        sprintf(psearch_alg, "EXHAUSTIVE");
        break;
      default:
        sprintf(psearch_alg, "LOGARITHMIC");
    }
  }
  else
    sprintf(psearch_alg, "LOGARITHMIC");

  if (n_options > 2)
  {
    switch ((int)options[2])
    {
      case 0:
        sprintf(bsearch_alg, "SIMPLE");
        break;
      case 1:
        sprintf(bsearch_alg, "CROSS2");
        break;
      case 2:
        sprintf(bsearch_alg, "EXHAUSTIVE");
        break;
      default:
        sprintf(bsearch_alg, "CROSS2");
    }
  }
  else
    sprintf(bsearch_alg, "CROSS2");

  if (n_options > 3)
  {
    if ((int)options[3] == 1)
      sprintf(ref_frame, "DECODED");
    else
      sprintf(ref_frame, "ORIGINAL");
  }
  else
    sprintf(ref_frame, "ORIGINAL");
 
  if (n_options > 4)
  {
    pix_range = options[4];
    if (pix_range > (realWidth/2))
      pix_range = realWidth/2;
    if (pix_range > (realHeight/2))
      pix_range = realHeight/2;
  }
  else
    pix_range = 10;

  if (n_options > 5)
  {
    if ((options[5] > 0) && (options[5] <= 31))
      iqscale = (int)options[5];
    else
      iqscale = 8;
  }
  else
    iqscale = 8;

  if (n_options > 6)
  {
    if ((options[6] > 0) && (options[6] <= 31))
      pqscale = (int)options[6];
    else
      pqscale = 10;
  }
  else pqscale = 10;
 
  if (n_options > 7)
  {
    if ((options[7] > 0) && (options[7] <= 31))
      bqscale = (int)options[7];
    else
      bqscale = 25;
  }
  else
    bqscale = 25;

  /* set user-definable encoder parameters */
  numInputFiles = m_cols*num_repeats;
  sprintf(currentPath, ".");
  SetGOPSize(6);
  /* if there are the right number of frames, then the IBBP... pattern is
   * best.  Otherwise, will use less efficient patterns to insure that
   * all frames get encoded (trailing "B" frames will not be encoded because
   * they require a following "P" or "I" frame */
  if ((numInputFiles - 1)%3 == 0)
    SetFramePattern("IBBPBBPBBPBB");
  else if ((numInputFiles - 1)%2 == 0)
    SetFramePattern("IBPBPBPBPBPB");
  else
    SetFramePattern("IPPPPPPPPPPP");
  /* use mpeg_encode calls to set user-defined parameters */
  SetPixelSearch("HALF");
  SetPQScale(pqscale);
  SetIQScale(iqscale);
  SetBQScale(bqscale);
  SetPSearchAlg(psearch_alg);
  SetBSearchAlg(bsearch_alg);
  SetSearchRange(pix_range);
  SetReferenceFrameType(ref_frame);
  SetSlicesPerFrame(1);
  strcpy(inputConversion, "*");
  Fsize_Validate(&yuvWidth, &yuvHeight);
  SetFCode();
  if ( psearchAlg ==  PSEARCH_TWOLEVEL )
       SetPixelSearch("HALF");

  /* allocate space for frames being encoded */
  Frame_Init();

  /* open the output MPEG file */
  if (strchr(outputFileName, '.') == NULL)
    strcat(outputFileName, ".mpg");
#ifdef WIN32
  if ( (ofp = fopen(outputFileName, "wb")) == NULL ) {
#else
  if ( (ofp = fopen(outputFileName, "w")) == NULL ) {
#endif
    mexErrMsgTxt("Could not open output file.");
  }

  totalTime = GenMPEGStream(whichGOP, frameStart, frameEnd,
			    numInputFiles, ofp,
                            outputFileName);

  /* deallocate frame space */
  Frame_Exit();

  if (ofp != NULL) {
    fclose(ofp);
  }
}


/*
====================================================================
convert_frame

This function takes a frame number, converts the Matlab frame
into YUV format and places the result in the passed frame structure.
====================================================================
*/
void convert_frame_old(MpegFrame *frame, int n)
{
  unsigned char *m_ptr;	       	/* byte pointer into matrix */
  unsigned char *temp_matrix;   /* temporary copy of current matrix row */
  double width;                 /* width of frame */
  double height;                /* height of frame */
  double format;                /* format identifier - not used yet */
  int cmap_len;                 /* length of colormap used in frame capture */
  int num_fixed;                /* number of fixed colors in frame */
  int r[256];                   /* RGB color table */
  int g[256];
  int b[256];
  int j,k;                      /* loop counters */
  int y[256];                   /* YUV color table */
  int u[256];
  int v[256];
  double cm_ratio;              /* stores ratio between number of colors in */
                                /* colormap supplied by user and colormap */
                                /* used to capture the frame for the movie */
  unsigned int temp_int;        /* used to flip bytes if little endian */
  float temp_float;

  
  /* make a copy of the requested frame */
  temp_matrix = (unsigned char *)mxCalloc(m_rows * 8, sizeof(unsigned char));
  if (temp_matrix == NULL)
    mexErrMsgTxt("Out of memory.");
  memcpy(temp_matrix, ((unsigned char *)m) + 8*(n%m_cols)*m_rows, m_rows*8);
  m_ptr = temp_matrix;

  /* allocate space for frame */
  Fsize_Note(frame->id, realWidth, realHeight);
  Frame_AllocYCC(frame);
 
  /* get the information for the frame */
  width = *(double *)m_ptr; m_ptr += 8;
  height = *(double *)m_ptr; m_ptr += 8;

  format = *(double *)m_ptr; m_ptr += 8;

  if (MOVIE_GetClientByteOrder() == ELITTLE_ENDIAN)
  {
    num_fixed = *(int *)m_ptr; m_ptr += 4;
    cmap_len = *(int *)m_ptr; m_ptr += 4;
    if (cmap_len > 256)
      cmap_len = 256;
  }
  else
  {
    cmap_len = *(int *)m_ptr; m_ptr += 4;
    if (cmap_len > 256)
      cmap_len = 256;
    num_fixed = *(int *)m_ptr; m_ptr += 4;
  }

  /* create a standard rgb colormap */
  cm_ratio =  (double)cm_rows / (double)cmap_len;

  for (j = 0; j < cmap_len; j++)
  {
    r[j] = (int)(255 * cm[(int)(j*cm_ratio)]);
    g[j] = (int)(255 * cm[(int)(j*cm_ratio) + cm_rows]);
    b[j] = (int)(255 * cm[(int)(j*cm_ratio) + 2*cm_rows]);
  }

  /* flip floats on little endian machines */
  if (MOVIE_GetClientByteOrder() == ELITTLE_ENDIAN)
  {
    for (j = 0; j < num_fixed*12; j+= 8)
    {
      temp_float = *(float *)(m_ptr + j);
      *(float *)(m_ptr + j) = *((float *)(m_ptr + j) + 1);
      *((float *)(m_ptr + j) + 1) = temp_float;
    }
  }

  /* place the fixed color rgb values into the colormap */ 
  for (j = cmap_len; j < cmap_len + num_fixed; j++)
  { 
    r[j] = (int)(*(float *)m_ptr * 255); m_ptr += 4;
    g[j] = (int)(*(float *)m_ptr * 255); m_ptr += 4;
    b[j] = (int)(*(float *)m_ptr * 255); m_ptr += 4;
  }
    
  /* advance m_ptr past the invalid fixed color information */
  m_ptr += 12*(256-num_fixed);

  /* make correction for little endian machines */
  if (MOVIE_GetClientByteOrder() == ELITTLE_ENDIAN)
  {
    for (k = 0; k < (m_rows - 388); k++)
    {
      temp_int = FLIPBYTES(*((unsigned int *)m_ptr));
      *((unsigned int *)m_ptr) = 
        FLIPBYTES(*((unsigned int *)m_ptr + 1));
      *((unsigned int *)m_ptr + 1) = temp_int;
      m_ptr += sizeof(double);
    }
    m_ptr -= (m_rows -388)*8; /* rewind m_ptr */
  }

  /* translate color table from RGB to YUV */
  for (j = 0; j < cmap_len + num_fixed; j++)
  {
    y[j] = (0.299 * r[j] + 0.587 * g[j] + 0.114 * b[j]) * 219/255 + 16 ;
    u[j] = (-0.1687 * r[j] - 0.3313 * g[j] + 0.5 * b[j]) * 224/255 + 128;
    v[j] = (0.5 * r[j] - 0.4187 * g[j] - 0.0813 * b[j]) * 224/255 + 128;
  }

  /* initialize U and V frames */
  for (j = 0; j < (int)(Fsize_y/2); j++)
  {
    for (k = 0; k < (int)(Fsize_x/2); k++)
    {
      *(frame->orig_cb[j] + k) = 0;
      *(frame->orig_cr[j] + k) = 0;
    }
  }

  /* convert colormap indices into YUV frame */
  for (j = 0; j < Fsize_y; j++)
  {
    for (k = 0; k < Fsize_x; k++)
    {
      *(frame->orig_y[j] + k) = y[(*m_ptr)];
      /* U and V frames are 4:1 subsamples for MPEG */
      /* Using average color value for now */
      *(frame->orig_cb[(int)(j/2)] + (int)(k/2)) += 0.25*u[(*m_ptr)];
      *(frame->orig_cr[(int)(j/2)] + (int)(k/2)) += 0.25*v[(*m_ptr)];
      m_ptr++; 
    }
    /* advance past excess pixels */
    for (k = Fsize_x; k < realWidth; k++)
      m_ptr++;
  }

  mxFree(temp_matrix);
}

void convertRGBtoYUV(int r, int g, int b, int *y, int *u, int *v)
{
  *y = (0.299 * r + 0.587 * g + 0.114 * b) * 219.0/255.0 + 16 ;
  *u = (-0.1687 * r - 0.3313 * g + 0.5 * b) * 224.0/255.0 + 128;
  *v = (0.5 * r - 0.4187 * g - 0.0813 * b) * 224.0/255.0 + 128;
}

void convert_frame(MpegFrame *frame, int n)
{
  if (!NewMovieFormat) {
    convert_frame_old(frame, n);
  } else {
    mxArray *cdata = mxGetField(newMovie, n, "cdata");
    mxArray *colormap = mxGetField(newMovie, n, "colormap");
    unsigned char *pr = (unsigned char *)mxGetData(cdata);
    int j,k;                      /* loop counters */

    /* allocate space for frame */
    Fsize_Note(frame->id, realWidth, realHeight);
    Frame_AllocYCC(frame);
    
    if (mxGetNumberOfDimensions(cdata) == 2) {
      /* Indexed color movie frame */
      int r[256];                   /* RGB color table */
      int g[256];
      int b[256];
      int y[256];                   /* YUV color table */
      int u[256];
      int v[256];
      int cmap_len = mxGetM(colormap);
      double *cmPr = (double *)mxGetPr(colormap);
      double *cmPg = cmPr + cmap_len;
      double *cmPb = cmPg + cmap_len;

      for (j = 0; j < cmap_len; j++)
	{
	  r[j] = (int)(255 * cmPr[j]);
	  g[j] = (int)(255 * cmPg[j]);
	  b[j] = (int)(255 * cmPb[j]);
	}

      for (j = 0; j < cmap_len; j++)
	{
	  convertRGBtoYUV(r[j], g[j], b[j], y+j, u+j, v+j);
	}

      /* Truecolor movie frame */
      /* initialize U and V frames */
      for (j = 0; j < (int)(Fsize_y/2); j++)
	{
	  for (k = 0; k < (int)(Fsize_x/2); k++)
	    {
	      *(frame->orig_cb[j] + k) = 0;
	      *(frame->orig_cr[j] + k) = 0;
	    }
	}
      
      /* convert colormap indices into YUV frame */
      for (k = 0; k < Fsize_x; k++)
	{
	  for (j = 0; j < Fsize_y; j++)
	    {
	      *(frame->orig_y[j] + k) = y[*pr];
	      /* U and V frames are 4:1 subsamples for MPEG */
	      /* Using average color value for now */
	      *(frame->orig_cb[(int)(j/2)] + (int)(k/2)) += 0.25*u[*pr];
	      *(frame->orig_cr[(int)(j/2)] + (int)(k/2)) += 0.25*v[*pr];
	      pr++; 
	    }
	  for (j = Fsize_y; j < realHeight; j++) 
	    {
	      pr++;
	    }
	}
    } else {
      unsigned char *pg = pr + realHeight*realWidth;
      unsigned char *pb = pg + realHeight*realWidth;

      /* Truecolor movie frame */
      /* initialize U and V frames */
      for (j = 0; j < (int)(Fsize_y/2); j++)
	{
	  for (k = 0; k < (int)(Fsize_x/2); k++)
	    {
	      *(frame->orig_cb[j] + k) = 0;
	      *(frame->orig_cr[j] + k) = 0;
	    }
	}
      
      /* convert RGB values into YUV frame */
      for (k = 0; k < Fsize_x; k++)
	{
	  for (j = 0; j < Fsize_y; j++)
	    {
	      int y, u, v;
	      convertRGBtoYUV(*pr, *pg, *pb, &y, &u, &v);
	      *(frame->orig_y[j] + k) = y;
	      /* U and V frames are 4:1 subsamples for MPEG */
	      /* Using average color value for now */
	      *(frame->orig_cb[(int)(j/2)] + (int)(k/2)) += 0.25*u;
	      *(frame->orig_cr[(int)(j/2)] + (int)(k/2)) += 0.25*v;
	      pr++;
	      pb++;
	      pg++;
	    }
	  for (j = Fsize_y; j < realHeight; j++) 
	    {
	      pr++;
	      pg++;
	      pb++;
	    }
	}
    }
  }
}

  
















