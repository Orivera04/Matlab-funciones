/*
 * File: aerogravitywgs84.h
 *
 * Abstract:
 *
 *      Function prototypes to calculate World Geodetic System 
 *      (WGS 84) Earth gravity.
 *
 *  S. Gage, 16 JUL 2001
 *  Copyright 1990-2002 The MathWorks, Inc.
 *
 *  $Revision: 1.2 $ $Date: 2002/01/16 19:31:32 $
 */

extern double wgs84_taylor_series(double      h,
                                  double      phi,
                                  WGS_params *WGS,
                                  double      opt_m2ft);

extern double wgs84_approx(double h,
                           double phi, 
                           double lambda,
                           const SFcnCache *udata,
                           double E2,
                           double GM,
                           double opt_m2ft );

extern double wgs84_exact( double h,
                           double phi,
                           double lambda,
                           const SFcnCache *udata,
                           double E2,
                           double GM,
                           double opt_m2ft );
