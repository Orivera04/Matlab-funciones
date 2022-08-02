/* $Revision: 1.3.2.1 $ */
/*
 * File: aeroatmcoesa.h
 *
 * Abstract:
 *
 *   Function prototypes to calculate 1976 COESA-extended U.S.
 *   Standard Atmosphere. 
 *     
 * Copyright 1990-2002 The MathWorks, Inc.
 *
 * Author: S. Gage      5-DEC-2001
 */

extern void InitCalcAtmosCOESA(void);


extern void CalcAtmosCOESA(const double *altitude, 
		           double *temp, 
		           double *pressure, 
		           double *density,
                           double *speedofsound,
		           int numPoints);

extern void CalcPAltCOESA(const double *pressure, 
		           double *altitude,
                          int numPoints);

