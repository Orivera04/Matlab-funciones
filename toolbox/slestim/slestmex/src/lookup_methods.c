/* -|---------|-----|----------------------------------------------------------
 *  Program   :     lookup_methods.c
 *  Author    :     Bora Eryilmaz
 *
 *  Time-stamp:     <2004-03-18 13:22:02 beryilma>
 *  Copyright :     1990-2001 The MathWorks, Inc.
 *  Licence   :     MathWorks License Agreement
 *  $Revision: 1.1.6.3 $
 *
 *  Purpose   :     Function Definitions for Adaptive Lookup Tables
 * ------------------------------------------------------------------------- */

#include "simstruc.h"
#include "lookup_methods.h"

/* ----------------------------------------------------------------------------
 * Purpose: Compute block outputs based on dialog selection.
 * ------------------------------------------------------------------------- */
void tbOutput(TbStruct* tbStruct, const real_T* u, const real_T* z,
	      EnableSignal enable, LockSignal lock, int_T numElements)
{
  BpStruct **bpStruct = tbStruct->bpStruct;
  MdStruct  *mdStruct = tbStruct->mdStruct;
  
  boolean_T inRange = true;
  int_T i;

  /* Update current indices, bpStruct(s) */
  if (lock == UNLOCK) {
    for (i = 0; i < (int_T) tbStruct->numDims; i++) {
      bpUpdate(bpStruct[i], u[i]);
      
      if ( !bpStruct[i]->range ) {
	inRange = inRange && false;
      }
    }
  } else {
    /* Will use previous bpStruct data */
  }

  switch (enable) {
  case ALT_ENABLE:  
  case ALT_DISABLE:
    break;
    
  case ALT_RESET:
    /* Initialize the table and the weights */
    memcpy(tbStruct->tabData, tbStruct->initData,
	   numElements * sizeof *tbStruct->tabData);
    for (i = 0; i < numElements; i++) {
      tbStruct->weights[i] = 0.0;
    }
    break;    
  }

  /* Adapt if in range*/
  if ( (mdStruct->rangeMode == ADAPT) || inRange ) {
    tbUpdate(tbStruct, z[0], enable);
  }
}

/* ----------------------------------------------------------------------------
 * Purpose: N-dimensional adaptive table update.
 * ------------------------------------------------------------------------- */
void tbUpdate(TbStruct* tbStruct, real_T z, EnableSignal enable)
{
  uint_T i, j;
  int_T k;
  
  /* Locate cell index for the current data */ 
  for (k = 0, j = 1, i = 0; i < tbStruct->numDims; i++) { 
    if (i != 0) { 
      j = j * (tbStruct->bpStruct[i-1]->length - 1); 
    } 
    k = k + j * tbStruct->bpStruct[i]->index; 
  } 
  tbStruct->index = k; 

  /* Update weight and table data (scalar recursive least-squares) */
  if (enable == ALT_ENABLE) {
    tbStruct->weights[k] = tbStruct->gain * tbStruct->weights[k] + 1;
    tbStruct->tabData[k] = tbStruct->tabData[k]
                         + (z - tbStruct->tabData[k]) / tbStruct->weights[k];
  }
  tbStruct->value = tbStruct->tabData[k];
}


/* ----------------------------------------------------------------------------
 * Purpose: One-dimensional breakpoint search and bpStruct update.
 * ------------------------------------------------------------------------- */
void bpUpdate(BpStruct* bpStruct, real_T x)
{
  int_T left  = 0;                     /* initial left index */
  int_T right = bpStruct->length - 1;  /* initial right index */
  int_T index = bpStruct->index;       /* index from previous search */
  const real_T *X = bpStruct->data;
  boolean_T bpFound = false;
  real_T  fraction;

  /* First, handle clipping or extrapolation */
  if (x < X[left]) {
    index    = left;
    fraction = 0.0;
    bpFound  = true;
  } else if (x >= X[right]) {
    index    = right - 1;
    fraction = 1.0;
    bpFound  = true;
  }
  
  /* Adjust fraction for input extrapolation (linear) */
  /*
    if (bpStruct->extrapMode != CLIP) {
    fraction = (x - X[index]) / (X[index+1] - X[index]);
    }
  */
  
  if (bpFound) {
    /* out-range parameters */
    bpStruct->range = false;
  } else {
    /* in-range parameters */
    while (bpFound == false) {
      if (x < X[index]) {
	right = index - 1;
	index = (left + right) / 2;
      } else if (x <= X[index+1]) {
	bpFound = true;
	if (x == X[index+1]) {
	  index++;
	}
      } else { 
	left = index + 1;
	index = (left + right) / 2;
      }
    }
    fraction = (x - X[index]) / (X[index+1] - X[index]);
    bpStruct->range    = true;
  }

  bpStruct->index    = index;
  bpStruct->fraction = fraction;
}

/* ----------------------------------------------------------------------------
 *  Purpose: In MATLAB, the number of dimensions of an mxArray is always
 *           2 or more.  Here, a 1-D table is possible, so it is necessary
 *           to detect tables that report two dimensions but are actually
 *           just a vector implying that the table lookup only needs one input.
 * ------------------------------------------------------------------------- */
int_T getNumTableDims(const int_T *tableDims, int_T numDims)
{
  if ((numDims == 2) && (tableDims[0] == 1 || tableDims[1] == 1)) {
    numDims = 1;
  }
  return numDims;
}
