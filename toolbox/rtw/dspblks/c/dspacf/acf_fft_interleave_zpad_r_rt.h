/*
 * @(#)acf_fft_interleave_zpad_r_rt.h    generated by: makeheader 4.21  Tue Mar 30 16:43:10 2004
 *
 *		built from:	acf_fft_interleave_zpad_r_rt.c
 */

#ifndef acf_fft_interleave_zpad_r_rt_h
#define acf_fft_interleave_zpad_r_rt_h

#ifdef __cplusplus
    extern "C" {
#endif

EXPORT_FCN void MWDSP_ACF_FFTInterleave_ZPad_R(
    const real32_T *inPtr,
    int_T         inRows,
    creal32_T       *buff,
    int_T         N,
    int_T         nChans
    );

#ifdef __cplusplus
    }	/* extern "C" */
#endif

#endif /* acf_fft_interleave_zpad_r_rt_h */
