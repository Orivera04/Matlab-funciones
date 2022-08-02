/*
 * File: aerogravitystruct.h
 *
 * Abstract:
 *
 *      Shared structure and enum defined for continuous World 
 *      Geodetic System (WGS 84) Earth gravity for saerogravity.c and
 *      aerogravitywgs84.c.
 *
 *  S. Gage, 16 JUL 2001
 *  Copyright 1990-2002 The MathWorks, Inc.
 *
 *  $Revision: 1.2.2.1 $ $Date: 2003/05/14 05:06:10 $
 */

typedef enum { WGS84TAYLORSERIES = 1, WGS84CLOSEAPPROX,
               WGS84EXACT } TypeIdx;

typedef enum { METRIC = 1, ENGLISH } UnitIdx;

typedef enum { JANUARY = 1, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY,
               AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER } MonthIdx;

typedef enum { NONE = 1, WARNING, ERROR } ActionIdx;

typedef struct WGS_params_tag {            
    double     a;             /* Semi-major Axis (m) */ 
    double     inv_f;         /* Reciprocal of Flattening */    
    double     omega_default; /* WGS 84 Angular Velocity of Earth (rad/sec) */ 
    double     GM_default;    /* Earth's Gravitational Const. (m^3/sec^2) */ 
    double     GM_prime;      /* Earth's Grav. Const. (m^3/sec^2) [no atmos]*/
    double     omega_prime;   /* IAU Angular Velocity of Earth (rad/sec) */
    double     gamma_e;       /* Theoretical (Normal) Gravity at the Equator 
                                 (on the Ellipsoid) (m/s^2) */
    double     k;             /* Theoretical (Normal) Gravity Formula Const. */
    double     e2;            /* First Eccentricity Squared */
    double     E;             /* Linear Eccentricity */
    double     b;             /* Semi-minor Axis (m) */
    double     b_over_a;      /* Axis Ratio */
} WGS_params;

typedef struct SFcnCache_tag {
    TypeIdx    type;        /* calculation method */
    UnitIdx    units;       /* use English or Metric */
    int        noatmos;     /* flag denoting use of atmosphere or not */
    int        precessing;  /* flag denoting use of precessing ref frame */
    MonthIdx   month;       
    double     day;         
    double     year;        
    int        centrifugal; /*flag denoting use of centrifugal force or not */
    WGS_params *WGS;
    int        phi_wrap;
    int        lambda_warn;
    int        lambda_wrap;
    int        below_min;
    int        above_20000;
} SFcnCache;
