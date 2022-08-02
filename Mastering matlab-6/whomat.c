/*
 *  whomat.c - Examine a binary MAT file and print a list
 *             of the contents (like "who" or "whos").
 *
 *  Mastering MATLAB MAT-file Example
 *
 */

/*   B.R. Littlefield, University of Maine, Orono, ME 04469
 *   7/21/00
 *   Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
 */

#include "mat.h"
#include <string.h>

int whomat(const char *filename) 
{
  MATFile *mfile;
  mxArray *marray;
  char **dir;
  char siz[25], buf[10];
  int i, j, k, num, nel, elsize, ndim, eltot, btot;
  const int *dims;
  
  /* Open the MAT file for reading. */
  mfile = matOpen(filename, "r");
  if (mfile == NULL) {
    printf("Cannot open %s for reading.\n", filename);
    return(EXIT_FAILURE);
  }

   /* Get the directory list and print in "who" format. */
  dir = matGetDir(mfile, &num);
  if (dir == NULL) {
    printf("Error reading the directory of %s.\n", filename);
    return(EXIT_FAILURE);
  } else {
    printf("\n");
    printf("Variables in %s are:\n\n", filename);
    for (i=0; i<num; i++) {
      printf("%-10s",dir[i]);
      if (i>0 && i%4==0) printf("\n");
    }
  }

  /* Examine each variable and print a "whos" list. */
  eltot=btot=0;
  printf("\n\n  Name         Size         Bytes  Class\n\n");
  for (i=0; i<num; i++) {
    marray=matGetArray(mfile, dir[i]);
    if (marray == NULL) {
      printf("Cannot read file %s.\n\n", filename);
      return(EXIT_FAILURE);
    }

    /* If marray is a cell array or structure array, then  */
    /* mxGetElementSize returns the size of a pointer; not */
    /* the size of all the elements in each cell or field. */
    /* To get the correct number of bytes would require    */
    /* traversing the array and summing leaf element sizes.*/
    /* Java arrays return 0x0 array dimensions and 0 size. */

    elsize=mxGetElementSize(marray);
    btot=btot+(nel*elsize);
    nel=mxGetNumberOfElements(marray);
    eltot=eltot+nel;
    ndim=mxGetNumberOfDimensions(marray);
    dims=mxGetDimensions(marray);
    siz[0]='\0';
    for (j=0; j<ndim; j++) {
      sprintf(buf,"%d",dims[j]);
      strcat(siz,buf);
      if (j<(ndim-1))
        strcat(siz,"x");
    }
    printf("  %-12s %-12s %5d  %s array\n", mxGetName(marray),
              siz,nel*elsize,mxGetClassName(marray));
    mxDestroyArray(marray);
  }
  printf("\nGrand total is %d elements using %d bytes\n\n",
            eltot,btot);

  /* Release the memory allocated for the directory. */
   mxFree(dir);

  /* Close the MAT file. */
  if (matClose(mfile) != 0) {
      printf("Cannot close %s.\n",filename);
      return(EXIT_FAILURE);
  }
  return(EXIT_SUCCESS);
}

int main(int argc, char **argv)
{
  int status;

  if (argc > 1)
    status = whomat(argv[1]);
  else{
    status = EXIT_FAILURE;
    printf("Usage: whomat <matfile>");
  }
  return(status);
}
