/*
 *  v2struct.c - Pack/Unpack Variables to/from a Scalar Structure. (MM)
 *
 *   MATLAB usage: s=mv2struct(x,y,z,...) s.x=x, s.y=y, etc.
 *   MATLAB usage: mv2struct(s) a=s.a, b=s.b, etc.
 *   MATLAB usage: [x,y,z,...]=mv2struct(s) x=s.a, y=s.b, etc.
 *
 *   MEX file to implement the MMToolbox function mmv2struct.m.
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
#include <string.h>
#define BUFLEN 100

void mexFunction( int nlhs,       mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )

{
  int i, j, nfields;
  char cmd[BUFLEN], tmp[10];
  const char *ans = "ans";
  const char **fnames; 
  char **name;

  /* Do some error checking */

  if (nrhs == 0) 
    mexErrMsgTxt("Input Arguments Required.");
  
  else if (nrhs == 1) {   /* Unpack */

    if (!mxIsStruct(prhs[0])) 
      mexErrMsgTxt("Single Input Must be a Scalar Structure.");
    else if (mxGetNumberOfElements(prhs[0]) != 1) 
      mexErrMsgTxt("Single Input Must be a Scalar Structure.");
    
    nfields = mxGetNumberOfFields(prhs[0]);
    
    if (nlhs == 0)    /* Assign fields in caller workspace */
      for (i=0; i<nfields; i++) {
        strcpy(cmd, mxGetFieldNameByNumber(prhs[0],i));
        strcat(cmd,"=");
        strcat(cmd, mxGetName(prhs[0]));
        strcat(cmd,".");
        strcat(cmd, mxGetFieldNameByNumber(prhs[0],i));
        mexEvalString(cmd);
      }

    else {            /* Assign fields to output variables */
      j = (nlhs < nfields) ? nlhs : nfields;
      for (i = 0; i < j; i++) 
        plhs[i] = mxDuplicateArray(mxGetFieldByNumber(prhs[0], 0, i));
    }
  }

  else {              /* Pack */

    /* Create a list of fieldnames. */

    fnames = mxCalloc(nrhs, sizeof(*fnames));

    for (i = 0; i < nrhs; i++)  {
      name[i] = mxCalloc(BUFLEN, sizeof(char));

      if (*mxGetName(prhs[i]) != '\0') 
        strcpy(name[i], mxGetName(prhs[i]));
      else {
        strcpy(name[i], ans);
        sprintf(tmp, "%d", i);
        strcat(name[i], tmp);
      }

      fnames[i] = name[i];
    }

    /* Create the output structure and free the allocated memory. */

    plhs[0] = mxCreateStructMatrix(1, 1, nrhs, fnames);
    mxFree(fnames);
    for (i = 0; i < nrhs; i++)  
      mxFree(name[i]);

    /* Stuff the inputs into the structure fields. */

    for (i = 0; i < nrhs; i++) 
     mxSetFieldByNumber(plhs[0],0,i,mxDuplicateArray(prhs[i])); 
  }
}

