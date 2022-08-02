/*
 *  mmstruct2cell.c - Extract structure data and put it into a cell array.
 *
 *   MATLAB usage: [c,f]=mmstruct2cell(s)
 *
 *   If s is an m-by-n structure array with p fields, then c will be
 *   an m-by-n-by-p cell array. If output f is requested, f will be a 
 *   p-by-1 cell array of field names.
 *
 *   Mastering MATLAB MEX Example 4:
 *       single 2-D structure array input,
 *       2-D and 3-D cell array output,
 *       multiple output parameters,
 *       N-D cell and structure indexing,
 *       no extra memory allocation.
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   6/22/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include "mex.h"

#define CDIMS 3
#define SDIMS 2

void mexFunction( int nlhs,       mxArray *plhs[], 
		          int nrhs, const mxArray *prhs[] )
     
{ 
  int m, n, p, i, j, k, cellindex, strindex; 
  int sidx[SDIMS], cidx[CDIMS];
  
  /* Do some error checking */
  
  if (nrhs < 1) 
    mexErrMsgTxt("Missing input argument."); 
  else if (nrhs > 1) 
    mexErrMsgTxt("Too many input arguments."); 
  else if (!mxIsStruct(prhs[0]))
    mexErrMsgTxt("Input must be a structure.");
  else if (mxGetNumberOfDimensions(prhs[0]) != SDIMS)
    mexErrMsgTxt("N-dimensional arrays not supported.");
  else if (nlhs > 2) 
    mexErrMsgTxt("Too many output arguments."); 
   
  /* Determine the characteristics of the input structure array */ 

  m = cidx[0] = mxGetM(prhs[0]);
  n = cidx[1] = mxGetN(prhs[0]);
  p = cidx[2] = mxGetNumberOfFields(prhs[0]);

  /* Create the output cell array(s) and fill them up */

  plhs[0] = mxCreateCellArray(CDIMS, cidx);
  for (i = 0; i < m; i++) 
    for (j = 0; j < n; j++) 
      for (k = 0; k < p; k++) {
        cidx[0] = sidx[0] = i;
        cidx[1] = sidx[1] = j;
        cidx[2] = k;
        cellindex = mxCalcSingleSubscript(plhs[0],CDIMS,cidx); 
        strindex =  mxCalcSingleSubscript(prhs[0],SDIMS,sidx);
        mxSetCell(plhs[0], cellindex, 
          mxDuplicateArray(mxGetFieldByNumber(prhs[0],strindex,k)));
      }

  /* Create the cell array of field names if requested */

  if (nlhs == 2) {
    plhs[1] = mxCreateCellMatrix(p, 1);
    for (i = 0; i < p; i++) 
      mxSetCell(plhs[1],i,mxCreateString(mxGetFieldNameByNumber(prhs[0],i))); 
  }
    
}


