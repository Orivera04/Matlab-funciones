/*
 * @(#)bq6_df2t_1fpf_nsos_zd_rt.h    generated by: makeheader 4.21  Tue Mar 30 16:43:14 2004
 *
 *		built from:	bq6_df2t_1fpf_nsos_zd_rt.c
 */

#ifndef bq6_df2t_1fpf_nsos_zd_rt_h
#define bq6_df2t_1fpf_nsos_zd_rt_h

#ifdef __cplusplus
    extern "C" {
#endif

EXPORT_FCN void MWDSP_BQ6_DF2T_1fpf_Nsos_ZD (const creal_T *u,
                                  creal_T *y,
                                  creal_T *state,
                                  const real_T *coeffs,
                                  const real_T *a0invs,
                                  const int_T sampsPerChan,
                                  const int_T numChans,
                                  const int_T numSections);

#ifdef __cplusplus
    }	/* extern "C" */
#endif

#endif /* bq6_df2t_1fpf_nsos_zd_rt_h */