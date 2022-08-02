/*
 *  writemat.c - Create a binary MAT file.
 *
 *  Mastering MATLAB MAT-file Example
 *
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   7/20/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include "mat.h"

int makemat(const char *filename, 
            double *data, int m, int n, 
            char *mmstr) 
{
  MATFile *mfile;
  mxArray *mdata, *mstr;
  
  /* Open the MAT file for writing. */
  mfile = matOpen(filename, "w");
  if (mfile == NULL) {
    printf("Cannot open %s for writing.\n", filename);
    return(EXIT_FAILURE);
  }

  /* Create the mxArray to hold the numeric data.     */
  /* Note that the array dimensions are reversed.     */
  /* C uses row order while MATLAB uses column order. */
  /* The data array will be transposed in MATLAB.     */
  mdata = mxCreateDoubleMatrix(n,m,mxREAL);
  mxSetName(mdata, "mydata");

  /* Copy the data to the mxArray. Note that mxGetData is */
  /* similar to mxGetPr in that it returns a void pointer */
  /* while mxGetPr returns a pointer to a double.         */
  memcpy((void *)(mxGetData(mdata)), (void *)data, 
                  m*n*sizeof(double));
  
  /* Create the string array and set the variable name. */
  mstr = mxCreateString(mmstr);
  mxSetName(mstr, "mystr");

  /* Write the mxArrays to the MAT file. */
  matPutArray(mfile, mdata);
  matPutArray(mfile, mstr);

  /* Free the mxArray memory. */
  mxDestroyArray(mdata);
  mxDestroyArray(mstr);

  /* Close the MAT file. */
  if (matClose(mfile) != 0) {
    printf("Cannot close %s.\n",filename);
    return(EXIT_FAILURE);
  }

    return(EXIT_SUCCESS);
}

int main()
{ 
  int status;
  char *mmstr = "Mastering MATLAB Rocks!";
  double data[3][4] = {{  1.0,  2.0,  3.0,  4.0 },
                       {  5.5,  6.6,  7.7,  8.8 },
                       { -4.0, -3.0, -2.0, -1.0 }};
 
  status = makemat("mmtest.mat", *data, 3, 4, mmstr);
  return(status);
}
