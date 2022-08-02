/*
 *  mmcellstr.c - Create a cell array of strings from a 2D character array.
 *
 *   MATLAB usage: c=mmcellstr(s)
 *
 *   If s is an m-by-n string array, then c will be
 *      an m-by-1 cell array of strings. 
 *   MEX file to implement the MATLAB function cellstr.
 *
 *   Mastering MATLAB MEX Example X:
 *       single 2-D character array input,
 *       single cell array of strings output,
 *       memory allocation for character arrays.
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   7/10/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include "mex.h"

void mexFunction( int nlhs,       mxArray *plhs[], 
		          int nrhs, const mxArray *prhs[] )
{ 
  int m, n, i, j; 
  char *buf;
  char **line;
  
  /* Do some error checking */
  if (nrhs < 1) 
    mexErrMsgTxt("Missing input argument."); 
  else if (nrhs > 1) 
    mexErrMsgTxt("Too many input arguments."); 
  else if (mxGetNumberOfDimensions(prhs[0]) != 2)
    mexErrMsgTxt("Input must be 2-D.");
  else if (nlhs > 1) 
    mexErrMsgTxt("Too many output arguments."); 

  /* If the input is already a cell array, duplicate it. */
  if (mxIsCell(prhs[0]))
    if (mxIsChar(mxGetCell(prhs[0],0))) {
      plhs[0]=mxCreateCellMatrix(mxGetM(prhs[0]),mxGetN(prhs[0]));
      plhs[0]=mxDuplicateArray(prhs[0]);
      return;
    }   
    
  /* Make sure the input is a character array. */
  if (!mxIsChar(prhs[0]))
    mexErrMsgTxt("Input must be a character array.");
   
  /* Handle the empty input case. */
  if (mxIsEmpty(prhs[0])) {
    plhs[0]=mxCreateCellMatrix(1, 1);
    mxSetCell(plhs[0],0,mxDuplicateArray(prhs[0]));
    return;
  } 

  /* Determine the dimensions of the input structure array */ 
  m=mxGetM(prhs[0]);
  n=mxGetN(prhs[0]);

  /* Stuff the input into a string buffer. */
  buf=mxCalloc(m*n,sizeof(char));
  buf=mxArrayToString(prhs[0]);

  /* Create line buffers for the individual strings. */
  for (i=0;i<m;i++)
    line[i]=mxCalloc(n+1,sizeof(char));

  /* Parse the buffer into individual lines. */
  for (j=0;j<n;j++) 
    for (i=0;i<m;i++) 
      line[i][j]=buf[i+m*j];

  /* Free the string buffer and create the output cell array. */
  mxFree(buf);
  plhs[0]=mxCreateCellMatrix(m, 1);

  for (i=0;i<m;i++) {
    /* For each line, remove trailing blanks... */
    j=n;
    while (--j >= 0)
      if (line[i][j] != ' ')
        break;
    line[i][j+1]='\0';

    /* insert the line into the output array... */
    mxSetCell(plhs[0],i,mxCreateString(line[i]));

    /* and free line buffer memory. */
    mxFree(line[i]);
  }
}


