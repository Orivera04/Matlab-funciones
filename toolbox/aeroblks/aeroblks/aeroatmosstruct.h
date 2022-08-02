/*
 * File: aeroatmosstruct.h
 *
 * Abstract:
 *
 *      Shared structure and enum defined for saeroatmcoesa.c,
 *      saeroatmos.c, aeroatmcoesa.c, aeroatmenvelope210c.c,
 *      aeroatmenvelop310.c, aeroatmprofile210c, and
 *      aeroatmprofile310.c
 *
 *  S. Gage, 6 AUG 2002
 *  Copyright 1990-2002 The MathWorks, Inc.
 *
 *  $Revision: 1.1.6.1 $ $Date: 2002/10/02 18:11:33 $
 */

typedef enum { COESA = 1, MILHDBK310, MILSTD210C } TypeIdx;

typedef enum { PROFILE = 1, ENVELOPE } ModelIdx;

typedef enum { HIGHTEMP = 1, LOWTEMP, HIGHDENSITY,
               LOWDENSITY, HIGHPRESSURE, LOWPRESSURE } VarIdx;

typedef enum { PP1 = 1, PP10 } PPercentIdx;

typedef enum { K5 = 1, K10, K20, K30, K40 } PAltIdx;

typedef enum { EXTREME = 1, P1, P5, P10, P20 } EPercentIdx;

typedef enum { NONE = 1, WARNING, ERROR } ActionIdx;

typedef struct SFcnCache_tag {
    int         below_min;  /* flag denoting if altitude went below zero */
    int         over_max;   /* flag denoting if altitude went above 84528 */
    TypeIdx     type;       /* specification type */
    ModelIdx    model;      /* profile or envelope */
    VarIdx      pvar;       /* extreme parameter (profile) */
    PPercentIdx ppercent;   /* frequency of occurence (profile) */    
    PAltIdx     palt;       /* altitude of extreme valueb (profile) */    
    VarIdx      evar;       /* extreme parameter (envelope) */
    EPercentIdx epercent;   /* frequency of occurence (envelope) */    
    int         numpts;     /* number of points in tables */
    double      lower_alt;  /* lower limit of altitude table */
    double      upper_alt;  /* upper limit of altitude table */
} SFcnCache;









