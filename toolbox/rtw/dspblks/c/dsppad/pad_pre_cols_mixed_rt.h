/*
 * @(#)pad_pre_cols_mixed_rt.h    generated by: makeheader 4.21  Tue Mar 30 16:43:30 2004
 *
 *		built from:	pad_pre_cols_mixed_rt.c
 */

#ifndef pad_pre_cols_mixed_rt_h
#define pad_pre_cols_mixed_rt_h

#ifdef __cplusplus
    extern "C" {
#endif

EXPORT_FCN void MWDSP_PadPreAlongColsMixed(
    const byte_T *u,         /* pointer to input array  (any data type, any complexity) */
    byte_T       *y,         /* pointer to output array (any data type, any complexity) */
    byte_T       *padValue,  /* pointer to value to pad output array
                              * (complexity must match complexity of y) */
    byte_T       *zero,      /* pointer to data-typed "real zero" representation */

    int_T numInpRows,         /* number of rows in the input array     */
    int_T numInpCols,         /* number of columns in the input array  */
    int_T numExtraRows,       /* number of extra rows to pad in output array */
    int_T bytesPerRealElement /* number of bytes per input sample */
    );

#ifdef __cplusplus
    }	/* extern "C" */
#endif

#endif /* pad_pre_cols_mixed_rt_h */