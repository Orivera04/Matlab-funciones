/*
 * @(#)bq6_df2t_1fpf_nsos_rc_rt.h    generated by: makeheader 4.21  Tue Mar 30 16:43:14 2004
 *
 *		built from:	bq6_df2t_1fpf_nsos_rc_rt.c
 */

#ifndef bq6_df2t_1fpf_nsos_rc_rt_h
#define bq6_df2t_1fpf_nsos_rc_rt_h

#ifdef __cplusplus
    extern "C" {
#endif

EXPORT_FCN void MWDSP_BQ6_DF2T_1fpf_Nsos_RC (const real32_T *u,
                                  creal32_T *y,
                                  creal32_T *state,
                                  const creal32_T *coeffs,
                                  const creal32_T *a0invs,
                                  const int_T sampsPerChan,
                                  const int_T numChans,
                                  const int_T numSections);

#ifdef __cplusplus
    }	/* extern "C" */
#endif

#endif /* bq6_df2t_1fpf_nsos_rc_rt_h */