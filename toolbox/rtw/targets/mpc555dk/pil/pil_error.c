/*
 * File: pil_error.c
 *
 * Abstract:
 *   Utitlity functions for error handling
 *
 * $Revision: 1.7.4.1 $
 * $Date: 2004/04/19 01:28:13 $
 *
 * Copyright 2001-2002 The MathWorks, Inc.
 */

#include <string.h>

/* - ERT is a prerequisit for PIL, but when left defined, including simstruct
 * results in references to undefined data types LogSignalPtrsType and
 * LogYSignalPtrs, so we check for it and then undefine it.
 */
#ifndef ERT
#error ERT is a prerequisit
#else
#undef ERT /* When ERT is left defined, including simstruct results in
            * references to undefined data types LogSignalPtrsType and
            * LogYSignalPtrs. 
            * Although ERT is prerequisit for PIL our PIL S-Function does
            * execute a full simstruct environment.
            */
#endif

/*
 * "simstruct.h" requires one, but does not allow more than one, of
 * MATLAB_MEX_FILE, RT and NRT to be defined. We expect that the PIL build
 * environment defines ERT and NRT and that MATLAB_MEX_FILE is defined when
 * building with the mex command. For this reason we will guarentee that only
 * the most germain of these is left defined before including that file.
 */

/*
 * - RT is not a relevent aspect of our environment for pil_error.
 * - MULTITASKING is not a relevent aspect of our environment for pil_error.
 * - MT is not a relevent aspect of our environment for pil_error.
 * - NRT is provided by the build process.  
 * - MATLAB_MEX_FILE is not a relevent aspect of our environment for
 * pil_error.
 */ 

#ifdef MT /* MT is not relevent to marshaling */
#undef MT
#endif

#ifdef MULTITASKING /* MT is not relevent to marshaling */
#undef MULTITASKING
#endif

#undef MATLAB_MEX_FILE /* Because we only need one of the requisit defines and
                        * this one isn't really relevent */

#ifndef NRT
#error NRT is expected for an S-Function
#endif

#ifdef RT /* While the ERT generated code is RT compatible, when used for PIL,
           * it is not real-time. 
           */
#undef RT
#endif 

#include "simstruc.h"

typedef int DTypeId;

void pil_error(
    SimStruct *S,
    const char_T *ErrorString
    ) 
{
    /* Set the given error string to be detected by Simulink. */
    ssSetErrorStatus(S, ErrorString);
}

/* [EOF] pil_error.c */
