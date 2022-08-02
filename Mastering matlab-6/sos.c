/*
 *  sos.c - Calculate the sum of the squares of the elements of a vector.
 *
 *  Mastering MATLAB Engine Example
 *
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   7/17/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include <stdio.h>
#include <string.h>
#include "engine.h"
#define  BUFSIZE 256

int main()
{
    Engine *mat;
    mxArray *mydata = NULL, *sqdata = NULL;
    int i, j;
    double x, *myptr, *sptr;
    char buf[BUFSIZE];
    double dataset[10] = { 0.0, 1.0, 2.0, 3.0, 4.0, 
                           5.0, 6.0, 7.0, 8.0, 9.0 };

    /* Start the MATLAB engine on the local computer.  */

    if (!(mat = engOpen("\0"))) {
        fprintf(stderr, "\nCannot open connection to MATLAB!\n");
        return EXIT_FAILURE;
    }

    /* Create an mxArray and get a C pointer to the mxArray. */

    mydata = mxCreateDoubleMatrix(1, 10, mxREAL);
    myptr = mxGetPr(mydata);

    /* Associate a MATLAB variable name with the mxArray. */

    mxSetName(mydata, "newdata");

    /* Copy the dataset array to the new mxArray. */

    memcpy((void *)myptr, (void *)dataset, sizeof(dataset));

    /* Pass the mxArray to the engine and square the elements. */

    engPutArray(mat, mydata);
    engEvalString(mat, "sqdata = newdata.^2");

    /* Create an output buffer to capture MATLAB text output. */

    engOutputBuffer(mat, buf, BUFSIZE);

    /* Calculate the sum of the squares and save the result in x. */

    engEvalString(mat,"disp(sum(sqdata))");
    x=atof(buf+2);

    /* Retrieve the array of squares from the emgine, */

    if ((sqdata = engGetArray(mat,"sqdata")) == NULL) {
        fprintf(stderr, "Cannot retrieve sqdata!\n\n");
        return EXIT_FAILURE;
    }
    
    /* and get a C pointer to the mxArray. */

    sptr = mxGetPr(sqdata);

    /* Print the results to stdout. */

    printf("\nThe inputs are:\n");
    for (i=0;i<10;i++)
      printf("%6.1f ",myptr[i]);
    printf("\n\nThe squares are:\n");
    for (i=0;i<10;i++)
      printf("%6.1f ",sptr[i]);
    printf("\n\nThe sum of the squares is %6.1f \n\n",x);

    /* Free the mxArray memory and quit MATLAB. */

    mxDestroyArray(mydata);
    mxDestroyArray(sqdata);
    engClose(mat);
    
    return EXIT_SUCCESS;
}
