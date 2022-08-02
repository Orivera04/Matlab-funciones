/* $Revision.1 $ */
/*
 * File: aeroatm210.h
 *
 * Abstract:
 *
 *   Function prototypes to calculate 
 *   Non-Standard Atmosphere from MIL-STD-210C. 
 *     
 * Copyright 1990-2002 The MathWorks, Inc.
 *
 * Author: S. Gage      14-AUG-2002
 */

extern void InitCalcAtmosEnvelope210c( SFcnCache *udata,
                                       double alt_table[],
                                       double temp_table[],
                                       double dens_table[],
                                       double pres_table[]);


extern void CalcAtmosEnvelope210c(const double *altitude,
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

extern void InitCalcAtmosProfile210c( SFcnCache *udata,
                                      double temp_table[],
                                      double dens_table[]);


extern void CalcAtmosProfile210c(const double *altitude,
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











