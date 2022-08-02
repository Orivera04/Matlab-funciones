/* $Revision: 1.3 $ */
/*
 * File: aeroatm.h
 *
 * Abstract:
 *
 *   Constants to calculate 1976 COESA-extended U.S.
 *   Standard Atmosphere.
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

/* Atmospheric Constants */

#define PRESSURE0   101325.0     /*  N/m^2                  */
#define TEMPERATURE0   288.15    /*  K                      */
#define GRAV_CONST       9.80665 /*  m/s^2                  */
#define MOL_WT          28.9644  /*  kg/kgmol (air)         */
#define R_HAT         8314.32    /*  J/kgmol.K (gas const.) */
#define GAMMA            1.4     /*  (specific heat ratio) */

#define GMR       ( GRAV_CONST * MOL_WT / R_HAT )      


