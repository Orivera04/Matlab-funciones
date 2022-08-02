/* $Revision: 1.4.2.1 $ */
/*
 * File: aeroatmcoesa.c
 *
 * Abstract:
 *
 *   Functions to calculate 1976 COESA-extended U.S.
 *   Standard Atmosphere.  Given geopotential altitude 
 *   in meters, calculate temperature (K), 
 *   pressure (Pa), and density (kg/m^3) using standard
 *   interpolation formulae (linear in temperature and
 *   logarithmic in pressure).
 *
 *   Extrapolates temperature linearly and pressure 
 *   logarithmically beyond the range:
 *
 *        0 <= altitude <= 84852 m
 *
 *   Density is calculated using a perfect gas relationship.
 *
 *   Data used are from the 15-OCT-1976 COESA extensions to the
 *   U.S. Standard Atmosphere, 1976, published by the U.S.
 *   Government Printing Office, Washington, D.C.  The COESA
 *   extensions to the 1976 standard can be obtained from:
 *   
 *     National Geophysical Data Center
 *     National Oceanic and Atmospheric Administration
 *     325 Broadway
 *     Boulder, CO  80303
 *     voice: +1 (303) 497-6136
 *     
 * Copyright 1990-2002 The MathWorks, Inc.
 *
 * Author:  R. Aberg      27­May-2000
 * Modified: S. Gage      27-Nov-2001
 */

#include <math.h>
#include "aeroatm.h"

/* 1976 COESA atmosphere model */

#define NUM1976PTS 8

static double altitude76[NUM1976PTS] = {  /* in meters (m) */
    0.0, 11000.0, 20000.0, 32000.0, 47000.0, 51000.0, 71000.0, 84852.0 };
static double tempGradient76[NUM1976PTS] = {  /* in K/m  */
    (-0.0065), 0.0, 0.0010, 0.0028, 0.0, -0.0028, -0.0020, -0.0020 };

static double temperature76[NUM1976PTS];
static double pressureRatio76[NUM1976PTS];

/* Function: InitCalcAtmosCOESA ==============================================
 * Abstract:
 *   initialize pressure and temperature tables.
 *
 */
void InitCalcAtmosCOESA(void)
{
    int k;

    temperature76[0]   = TEMPERATURE0;
    pressureRatio76[0] = 1.0;

    /* set up the data at the 1976 altitude breakpoints */
 
    for (k=0; k<(NUM1976PTS-1); k++) {
        if (tempGradient76[k] != 0.0) {
            temperature76[k+1]   = temperature76[k] + 
                tempGradient76[k]*(altitude76[k+1] - altitude76[k]);
            pressureRatio76[k+1] = pressureRatio76[k] *
                exp( log(temperature76[k]/temperature76[k+1]) * 
                     GMR/tempGradient76[k] );
        } else {
            temperature76[k+1]   = temperature76[k];
            pressureRatio76[k+1] = pressureRatio76[k] *
              exp( (-GMR)*(altitude76[k+1] - altitude76[k])/temperature76[k] );
        }
    }
}

/* Function: CalcAtmosCOESA ==================================================
 * Abstract:
 *   Using cached pressure and temperature tables, find the 
 *   working interval and perform logarithmic interpolation.
 */

void CalcAtmosCOESA(const double *altitude, 
		    double *temp, 
		    double *pressure, 
		    double *density,
                    double *speedofsound,
		    int numPoints)
{
    int i;

    for (i=0; i<numPoints; i++) {
        int bottom = 0;
        int top    = NUM1976PTS-1;
        int idx;

        /* Find altitude interval using binary search
         *
         * Deal with the extreme cases first:
         *   if altitude <= altitude76[bottom] then return idx = bottom
         *   if altitude >= altitude76[top]    then return idx = top
         */
        if (altitude[i] <= altitude76[bottom]) {
            idx = bottom;
        } else if (altitude[i] >= altitude76[top]) {
            idx = NUM1976PTS-2;
        } else {
            for (;;) {
                idx = (bottom + top)/2;
                if (altitude[i] < altitude76[idx]) {
                    top = idx - 1;
                } else if (altitude[i] >= altitude76[idx+1]) {
                    bottom = idx + 1;
                } else {
                 /* we have altitude76[idx] <= altitude[i] < altitude76[idx+1],
                  * so break and just use idx 
                  */
                    break;
                }
            } 
        }

        /* Interval has been obtained, now do linear temperature
         * interpolation and log pressure interpolation.
         */
        if ( tempGradient76[idx] != 0.0 ) {
            temp[i] = temperature76[idx] + 
                tempGradient76[idx] * (altitude[i] - altitude76[idx]);
            pressure[i] = PRESSURE0 * pressureRatio76[idx] * 
                pow(temperature76[idx]/temp[i], GMR/tempGradient76[idx] );
        } else {
            temp[i] = temperature76[idx];
            pressure[i] = PRESSURE0 * pressureRatio76[idx] *
                exp( (-GMR)*(altitude[i] - altitude76[idx]) 
                     / temperature76[idx] );
        }
        density[i] = pressure[i] / ((R_HAT/MOL_WT)*temp[i]);
        speedofsound[i] = sqrt(GAMMA*temp[i]*(R_HAT/MOL_WT));
    }
}

/* Function: CalcPAltCOESA ==================================================
 * Abstract:
 *   Using cached pressure and Altitude tables, find the 
 *   working interval and perform logarithmic interpolation.
 */

void CalcPAltCOESA(const double *pressure, 
                   double *altitude,
                   int numPoints)
{
    int i;
    double ptemp;

    for (i=0; i<numPoints; i++) {
        int bottom = 0;
        int top    = NUM1976PTS-1;
        int idx;

        /* Find altitude interval using binary search
         *
         * Deal with the extreme cases first:
         *   if pressure >= pressureRatio76[bottom]*PRESSURE0 
         *   then return idx = bottom
         *
         *   if pressure <= pressureRatio76[top]*PRESSURE0    
         *   then return idx = top
         */
        if (pressure[i] >= pressureRatio76[bottom]*PRESSURE0) {
            idx = bottom;
        } else if (pressure[i] <= pressureRatio76[top]*PRESSURE0) {
            idx = NUM1976PTS-2;
        } else {
            for (;;) {
                idx = (bottom + top)/2;
                if (pressure[i] > pressureRatio76[idx]*PRESSURE0) {
                    top = idx - 1;
                } else if (pressure[i] <= pressureRatio76[idx+1]*PRESSURE0) {
                    bottom = idx + 1;
                } else {
                    /* we have pressureRatio76[idx]*PRESSURE0 >= pressure[i] > 
                     *                          pressureRatio76[idx+1]*PRESSURE0,
                     * so break and just use idx 
                     */
                    break;
                }
            } 
        }

        /* Interval has been obtained, now do log altitude interpolation.
         */
        if (pressure[i] == (PRESSURE0 * pressureRatio76[idx])){
            altitude[i] = altitude76[idx];
        }
        else{
            if ( tempGradient76[idx] != 0.0 ) {
                ptemp = pow(pressure[i]/(PRESSURE0 * pressureRatio76[idx]),
                                                      (tempGradient76[idx]/GMR));
                altitude[i] = altitude76[idx] + ((1.0 - ptemp)/
                               (tempGradient76[idx] * ptemp))*temperature76[idx];
            } else {
                altitude[i] = altitude76[idx]-((temperature76[idx]/GMR)*
                              log(pressure[i]/(PRESSURE0 * pressureRatio76[idx])));
            }
        }
    }
}
















