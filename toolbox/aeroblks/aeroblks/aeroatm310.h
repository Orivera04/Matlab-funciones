/* $Revision.1 $ */
/*
 * File: aeroatm310.h
 *
 * Abstract:
 *
 *   Function prototypes to calculate 
 *   Non-Standard Atmosphere from MIL-HDBK-310. 
 *     
 * Copyright 1990-2002 The MathWorks, Inc.
 *
 * Author: S. Gage      14-AUG-2002
 */

extern void InitCalcAtmosEnvelope310( SFcnCache *udata,
                                      double alt_table[],
                                      double temp_table[],
                                      double dens_table[],
                                      double pres_table[]);


extern void CalcAtmosEnvelope310(const double *altitude,
                                 double alt_table[],
                                 double temp_table[],
                                 double dens_table[],
                                 double pres_table[], 
		                 double *temp, 
		                 double *pressure, 
		                 double *density,
                                 double *speedofsound,
		                 int numPoints,
                                 const SFcnCache *udata);

extern void InitCalcAtmosProfile310( SFcnCache *udata,
                                     double temp_table[],
                                     double dens_table[]);


extern void CalcAtmosProfile310(const double *altitude, 
                                 double temp_table[],
                                 double dens_table[],
		                 double *temp, 
		                 double *pressure, 
		                 double *density,
                                 double *speedofsound,
		                 int numPoints,
                                 int numTablePts,
		                 double lower_alt,
		         	 double upper_alt);


