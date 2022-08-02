/* $Revision.2 $ */
/*
 * File: aeroatmenvelope210c.c
 *
 * Abstract:
 *
 *   Functions to calculate Non-Standard atmospheric 
 *   condition implemented from MIL-STD-210C.  Given 
 *   geometric altitude in meters, calculate temperature (K), 
 *   pressure (Pa), and density (kg/m^3) using standard
 *   interpolation formulae (linear in temperature and
 *   logarithmic in pressure and density).
 *
 *   No extrapolation of values beyond the table range:
 *
 *       ie:  0 <= altitude <= 80000 m
 *
 *   Density/Pressure are calculated using a perfect gas 
 *   relationship depending on lookup table outputs.
 *
 *   Data used are from the 9-JAN-1987 MIL-STD-210C
 *   Global Climatic Data for Developing Military Products 
 *   published by the U.S. Department of Defense, Washington, 
 *   D.C.  The MIL-STD-210C can be obtained from:
 *   
 *     ASSIST Online
 *     http://astimage.daps.dla.mil/online
 *
 *     
 * Copyright 1990-2002 The MathWorks, Inc.
 *
 * Author:  S. Gage      14-AUG-2002
 */

#include <math.h>
#include "aeroatm.h"
#include "aeroatmosstruct.h"

#define NUMENVELOPE1PTS 17
#define NUMENVELOPE2PTS 27
#define NUMENVELOPE3PTS 16
#define NUMENVELOPE4PTS 26

static double altitude1[NUMENVELOPE1PTS] = { /* in m */
    0.0,  1000.0,  2000.0,  4000.0,  6000.0,  8000.0,  10000.0,  
    12000.0, 14000.0, 16000.0, 18000.0, 20000.0, 22000.0,  24000.0, 
    26000.0, 28000.0, 30000.0 };

static double altitude2[NUMENVELOPE2PTS] = { /* in m */ 
    0.0,  1000.0,  2000.0,  4000.0,  6000.0,  8000.0,  10000.0,  
    12000.0, 14000.0, 16000.0, 18000.0, 20000.0, 22000.0,  24000.0, 
    26000.0, 28000.0, 30000.0, 35000.0, 40000.0, 45000.0,  50000.0, 
    55000.0, 60000.0, 65000.0, 70000.0, 75000.0, 80000.0 };

static double altitude3[NUMENVELOPE3PTS] = { /* in m */
    1000.0,  2000.0,  4000.0,  6000.0,  8000.0,  10000.0,  
    12000.0, 14000.0, 16000.0, 18000.0, 20000.0, 22000.0,  24000.0, 
    26000.0, 28000.0, 30000.0 };

static double altitude4[NUMENVELOPE4PTS] = { /* in m */
    1000.0,  2000.0,  4000.0,  6000.0,  8000.0,  10000.0,  
    12000.0, 14000.0, 16000.0, 18000.0, 20000.0, 22000.0,  24000.0, 
    26000.0, 28000.0, 30000.0, 35000.0, 40000.0, 45000.0,  50000.0, 
    55000.0, 60000.0, 65000.0, 70000.0, 75000.0, 80000.0 };

/* Function: InitCalcAtmosEnvelope210c ======================================
 * Abstract:
 *   initialize tables for selected non-standard day envelope
 *
 */
void InitCalcAtmosEnvelope210c( SFcnCache *udata,
                                double altitude210C[],
                                double temperature210C[],
                                double density210C[],
                                double pressure210C[] )
{

    int i;

    switch (udata->evar) {
      case HIGHTEMP:
        switch (udata->epercent) {
          case EXTREME:
              {
            static double hte[NUMENVELOPE1PTS] = {  /* in K */ 
                331.150000,	314.150000,	305.150000,	292.150000,   
                281.150000,
                269.150000,	260.150000,	251.150000,	243.150000,  
                238.150000,
                238.150000,	242.150000,	244.150000,	240.150000, 
                246.150000,
                251.150000,	256.150000 }; 

            static double htde[NUMENVELOPE1PTS] = {  /* in kg/m^3 */ 
                1.052000e+000,	1.018000e+000,	9.160000e-001,	7.620000e-001, 
                6.110000e-001,
                4.990000e-001,	3.930000e-001,	3.160000e-001,	2.080000e-001, 
                1.560000e-001,
                1.180000e-001,	8.600000e-002,	6.400000e-002,	4.800000e-002, 
                3.600000e-002,
                2.700000e-002,	2.000000e-002 }; 
            
            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    temperature210C[i] = hte[i];
                    density210C[i] = htde[i];
                    altitude210C[i]=altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
               } 
              }
            break;
          case P1:
              {
            static double ht1p[NUMENVELOPE2PTS] = {  /* in K */ 
                322.150000,	313.150000,	303.150000,	290.150000,   
                279.150000,
                268.150000,	260.150000,	251.150000,	243.150000,   
                236.150000,
                236.150000,	241.150000,	243.150000,	240.150000,   
                245.150000,
                250.150000,	255.150000,	276.150000,	298.150000,   
                303.150000,
                310.150000,	292.150000,	302.150000,	310.150000,   
                297.150000,
                289.150000,	278.150000 }; 

            static double htd1p[NUMENVELOPE2PTS] = {  /* in kg/m^3 */ 
                1.081000e+000,	1.007000e+000,	9.190000e-001,	7.570000e-001, 
                6.130000e-001,
                4.970000e-001,	3.970000e-001,	3.170000e-001,	2.100000e-001, 
                1.590000e-001,
                1.190000e-001,	8.700000e-002,	6.700000e-002,	4.900000e-002, 
                3.600000e-002,
                2.700000e-002,	2.000000e-002,	6.150000e-003,	3.120000e-003, 
                1.400000e-003,
                9.970000e-004,	9.920000e-004,	1.760000e-004,	1.010000e-004, 
                5.500000e-005,
                1.500000e-005,	7.000000e-006 }; 

            for ( i = 0; i < NUMENVELOPE2PTS; i++ )
                {
                    temperature210C[i] = ht1p[i];
                    density210C[i] = htd1p[i];
                    altitude210C[i]=altitude2[i];
		    udata->numpts = NUMENVELOPE2PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE2PTS - 1];
                }
              }
            break;
          case P5:
              {
            static double ht5p[NUMENVELOPE1PTS] = {  /* in K */ 
                319.150000,	312.150000,	302.150000,	287.150000,   
                277.150000,
                267.150000,	256.150000,	249.150000,	238.150000,   
                234.150000,
                235.150000,	235.150000,	235.150000,	235.150000,   
                236.150000,
                245.150000,	250.150000 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    temperature210C[i] = ht5p[i];
                    altitude210C[i]=altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
              }
            break;
          case P10:
              {
            static double ht10p[NUMENVELOPE2PTS] = {  /* in K */ 
                318.150000,	311.150000,	301.150000,	286.150000,   
                276.150000,
                264.150000,	254.150000,	243.150000,	237.150000,   
                234.150000,
                234.150000,	234.150000,	235.150000,	234.150000,   
                236.150000,
                240.150000,	245.150000,	260.150000,	278.150000,   
                288.150000,
                293.150000,	281.150000,	270.150000,	276.150000,   
                277.150000,
                259.150000,	254.150000 }; 

            for ( i = 0; i < NUMENVELOPE2PTS; i++ )
                {
                    temperature210C[i] = ht10p[i];
                    altitude210C[i]=altitude2[i];
		    udata->numpts = NUMENVELOPE2PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE2PTS - 1];
                }
              }
            break;
          case P20:
              {
            static double ht20p[NUMENVELOPE3PTS] = {  /* in K */ 
                307.150000,	300.150000,	285.150000,	273.150000,    
                262.150000,
                253.150000,	242.150000,	233.150000,	233.150000,    
                233.150000,
                233.150000,	234.150000,	234.150000,	235.150000,    
                237.150000,
                240.150000 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    temperature210C[i] = ht20p[i];
                    altitude210C[i]=altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
        } break;
      case LOWTEMP:
        switch (udata->epercent) {
          case EXTREME:
              {
            static double lte[NUMENVELOPE1PTS] = {  /* in K */ 
                205.150000,	219.150000,	226.150000,	220.150000,    
                212.150000,
                205.150000,	198.150000,	193.150000,	196.150000,    
                186.150000,
                185.150000,	186.150000,	188.150000,	187.150000,    
                189.150000,
                189.150000,	188.150000 }; 

            static double ltde[NUMENVELOPE1PTS] = {  /* in kg/m^3 */ 
                1.780000e+000,	1.419000e+000,	1.147000e+000,	8.990000e-001, 
                6.810000e-001,
                5.100000e-001,	4.090000e-001,	3.140000e-001,	2.180000e-001, 
                2.080000e-001,
                1.430000e-001,	7.800000e-002,	5.400000e-002,	3.800000e-002, 
                2.900000e-002,
                2.000000e-002,	1.100000e-002 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    temperature210C[i] = lte[i];
                    density210C[i] = ltde[i];
                    altitude210C[i]=altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
              }
            break;
          case P1:
              {
            static double lt1p[NUMENVELOPE2PTS] = {  /* in K */ 
                212.150000,	220.150000,	232.150000,	225.150000,    
                216.150000,
                207.150000,	199.150000,	200.150000,	198.150000,    
                187.150000,
                187.150000,	187.150000,	189.150000,	188.150000,    
                189.150000,
                190.150000,	190.150000,	192.150000,	202.150000,    
                203.150000,
                203.150000,	199.150000,	199.150000,	186.150000,    
                166.150000,
                153.150000,	128.150000 }; 

            static double ltd1p[NUMENVELOPE2PTS] = {  /* in kg/m^3 */ 
                1.610000e+000,	1.408000e+000,	1.132000e+000,	8.680000e-001, 
                6.750000e-001,
                5.230000e-001,	4.150000e-001,	2.970000e-001,	2.140000e-001, 
                2.060000e-001,
                1.430000e-001,	7.800000e-002,	5.400000e-002,	3.800000e-002, 
                2.900000e-002,
                2.000000e-002,	1.600000e-002,	7.220000e-003,	2.850000e-003, 
                1.660000e-003,
                7.230000e-004,	6.810000e-004,	2.820000e-004,	1.260000e-004, 
                4.600000e-005,
                2.000000e-005,	6.000000e-006 }; 

            for ( i = 0; i < NUMENVELOPE2PTS; i++ )
                {
                    temperature210C[i] = lt1p[i];
                    density210C[i] = ltd1p[i];
                    altitude210C[i]=altitude2[i];
		    udata->numpts = NUMENVELOPE2PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE2PTS - 1];
                }
              }
            break;
          case P5:
              {
            static double lt5p[NUMENVELOPE1PTS] = {  /* in K */ 
                216.150000,	222.150000,	237.150000,	227.150000,    
                217.150000,
                208.150000,	201.150000,	201.150000,	199.150000,    
                189.150000,
                189.150000,	190.150000,	190.150000,	190.150000,    
                190.150000,
                192.150000,	192.150000 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    temperature210C[i] = lt5p[i];
                    altitude210C[i]=altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
              }
            break;
          case P10:
              {
            static double lt10p[NUMENVELOPE2PTS] = {  /* in K */ 
                219.150000,	223.150000,	239.150000,	229.150000,    
                219.150000,
                209.150000,	203.150000,	203.150000,	200.150000,    
                190.150000,
                191.150000,	192.150000,	191.150000,	191.150000,    
                192.150000,
                194.150000,	194.150000,	200.150000,	211.150000,    
                219.150000,
                224.150000,	221.150000,	221.150000,	198.150000,    
                183.150000,
                163.150000,	140.150000 }; 

            for ( i = 0; i < NUMENVELOPE2PTS; i++ )
                {
                    temperature210C[i] = lt10p[i];
                    altitude210C[i]=altitude2[i];
		    udata->numpts = NUMENVELOPE2PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE2PTS - 1];
                }
            break;
              }
          case P20:
              {
            static double lt20p[NUMENVELOPE1PTS] = {  /* in K */ 
                222.150000,	224.150000,	242.150000,	233.150000,    
                222.150000,
                212.150000,	208.150000,	206.150000,	203.150000,    
                191.150000,
                192.150000,	202.150000,	191.150000,	192.150000,    
                193.150000,
                195.150000,	197.150000 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    temperature210C[i] = lt20p[i];
                    altitude210C[i]=altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
              }
            break;
        } break;
      case HIGHPRESSURE:
        switch (udata->epercent) {
          case EXTREME:
              {
            static double hpe[NUMENVELOPE1PTS] = {  /* in kPa */ 
                108.400000,	93.000000,	82.100000,	64.300000,     
                50.100000,
                38.500000,	29.400000,	22.600000,	16.800000,     
                12.300000,
                8.800000,	6.500000,	4.500000,	3.500000,      
                2.600000,
                2.000000,	1.500000 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    pressure210C[i] = hpe[i]*1000.0;
                    altitude210C[i] = altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
            break;
              }
          case P1:
              {
            static double hp1p[NUMENVELOPE4PTS] = {  /* in kPa */ 
                92.000000,	81.700000,	64.200000,	49.900000,     
                38.400000,
                29.300000,	22.600000,	16.700000,	12.300000,     
                8.800000,
                6.500000,	4.500000,	3.400000,	2.500000,      
                1.900000,
                1.500000,	0.760000,	0.410000,	0.220000,      
                0.120000,
                0.071000,	0.039000,	0.019000,	0.008600,      
                0.003700,
                0.001500 }; 

            for ( i = 0; i < NUMENVELOPE4PTS; i++ )
                {
                    pressure210C[i] = hp1p[i]*1000.0;
                    altitude210C[i] = altitude4[i];
		    udata->numpts = NUMENVELOPE4PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE4PTS - 1];

                }
              }
            break;
          case P5:
              {
            static double hp5p[NUMENVELOPE3PTS] = {  /* in kPa */ 
                91.800000,	81.600000,	64.100000,	49.700000,     
                38.300000,
                29.200000,	22.400000,	16.600000,	12.200000,     
                8.700000,
                6.400000,	4.400000,	3.300000,	2.500000,      
                1.900000,
                1.400000 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    pressure210C[i] = hp5p[i]*1000.0;
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
          case P10:
              {
            static double hp10p[NUMENVELOPE4PTS] = {  /* in kPa */ 
                91.700000,	81.500000,	64.000000,	49.600000,     
                38.200000,
                29.100000,	22.300000,	16.500000,	12.100000,     
                8.600000,
                6.300000,	4.400000,	3.200000,	2.400000,      
                1.800000,
                1.400000,	0.740000,	0.390000,	0.220000,      
                0.120000,
                0.066000,	0.035000,	0.018000,	0.008100,      
                0.003400,
                0.001400 }; 

            for ( i = 0; i < NUMENVELOPE4PTS; i++ )
                {
                    pressure210C[i] = hp10p[i]*1000.0;
                    altitude210C[i] = altitude4[i];
		    udata->numpts = NUMENVELOPE4PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE4PTS - 1];

                }
            break;
              }
          case P20:
              {
            static double hp20p[NUMENVELOPE3PTS] = {  /* in kPa */ 
                91.600000,	81.400000,	63.900000,	49.500000,     
                38.100000,
                29.000000,	22.200000,	16.400000,	12.000000,     
                8.500000,
                6.200000,	4.300000,	3.200000,	2.400000,      
                1.800000,
                1.300000 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    pressure210C[i] = hp20p[i]*1000.0;
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
        } break;
      case LOWPRESSURE:
        switch (udata->epercent) {
          case EXTREME:
              {
            static double lpe[NUMENVELOPE1PTS] = {  /* in kPa */ 
                87.000000,	84.200000,	73.600000,	54.800000,     
                40.600000,
                29.600000,	21.500000,	15.400000,	11.100000,     
                7.900000,
                5.600000,	4.000000,	2.800000,	2.000000,      
                1.400000,
                1.000000,	0.700000 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    pressure210C[i] = lpe[i]*1000.0;
                    altitude210C[i] = altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
              }
            break;
          case P1:
              {
            static double lp1p[NUMENVELOPE4PTS] = {  /* in kPa */ 
                84.700000,	74.200000,	55.000000,	40.800000,     
                29.900000,
                21.800000,	15.700000,	11.100000,	7.900000,      
                5.600000,
                4.100000,	2.900000,	2.100000,	1.500000,      
                1.100000,
                0.900000,	0.310000,	0.150000,	0.067000,      
                0.031000,
                0.015000,	0.007400,	0.003500,	0.001700,      
                0.000800,
                0.000350 }; 

            for ( i = 0; i < NUMENVELOPE4PTS; i++ )
                {
                    pressure210C[i] = lp1p[i]*1000.0;
                    altitude210C[i] = altitude4[i];
                    udata->numpts = NUMENVELOPE4PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE4PTS - 1];

                }
              }
            break;
          case P5:
              {
            static double lp5p[NUMENVELOPE3PTS] = {  /* in kPa */ 
                85.600000,	74.800000,	55.800000,	41.300000,     
                30.300000,
                22.100000,	15.800000,	11.300000,	8.000000,      
                5.700000,
                4.200000,	3.000000,	2.400000,	1.800000,      
                1.300000,
                1.000000 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    pressure210C[i] = lp5p[i]*1000.0;
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
          case P10:
              {
            static double lp10p[NUMENVELOPE4PTS] = {  /* in kPa */ 
                86.100000,	75.200000,	56.500000,	41.800000,     
                30.600000,
                22.300000,	16.000000,	11.500000,	8.200000,      
                5.800000,
                4.300000,	3.100000,	2.700000,	2.000000,      
                1.500000,
                1.100000,	0.340000,	0.170000,	0.079000,      
                0.039000,
                0.018000,	0.009000,	0.004200,	0.002000,      
                0.001100,
                0.000470 }; 

            for ( i = 0; i < NUMENVELOPE4PTS; i++ )
                {
                    pressure210C[i] = lp10p[i]*1000.0;
                    altitude210C[i] = altitude4[i];
		    udata->numpts = NUMENVELOPE4PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE4PTS - 1];

                }
              }
            break;
          case P20:
              {
            static double lp20p[NUMENVELOPE3PTS] = {  /* in kPa */ 
                86.800000,	75.700000,	56.900000,	42.200000,     
                30.900000,
                22.500000,	16.200000,	11.700000,	8.400000,      
                5.900000,
                4.500000,	3.200000,	2.800000,	2.100000,      
                1.600000,
                1.200000 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    pressure210C[i] = lp20p[i]*1000.0;
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
        } break;
      case HIGHDENSITY:
        switch (udata->epercent) {
          case EXTREME:
              {
            static double hde[NUMENVELOPE1PTS] = {  /* in kg/m^3 */ 
                1.780000e+000,	1.350000e+000,	1.170000e+000,	8.990000e-001, 
                7.010000e-001,
                5.520000e-001,	4.350000e-001,	3.450000e-001,	2.670000e-001, 
                2.060000e-001,
                1.500000e-001,	1.080000e-001,	7.300000e-002,	5.700000e-002, 
                4.300000e-002,
                2.800000e-002,	2.100000e-002 }; 

            static double hdte[NUMENVELOPE1PTS] = {  /* in K */ 
                205.150000,	230.150000,	228.150000,	220.150000,    
                224.150000,
                230.150000,	224.150000,	212.150000,	204.150000,    
                197.150000,
                193.150000,	203.150000,	207.150000,	214.150000,    
                233.150000,
                235.150000,	238.150000 }; 

            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    density210C[i] = hde[i];
                    temperature210C[i] = hdte[i];
                    altitude210C[i] = altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];

                }
              }
            break;
          case P1:
              {
            static double hd1p[NUMENVELOPE2PTS] = {  /* in kg/m^3 */ 
                1.720000e+000,	1.320000e+000,	1.160000e+000,	8.920000e-001, 
                6.950000e-001,
                5.500000e-001,	4.340000e-001,	3.410000e-001,	2.670000e-001, 
                2.050000e-001,
                1.490000e-001,	1.050000e-001,	7.300000e-002,	5.700000e-002, 
                4.300000e-002,
                2.800000e-002,	2.100000e-002,	1.090000e-002,	5.270000e-003, 
                2.790000e-003,
                1.480000e-003,	8.640000e-004,	4.860000e-004,	2.750000e-004, 
                1.500000e-004,
                7.200000e-005,	3.320000e-005 }; 

            static double hdt1p[NUMENVELOPE2PTS] = {  /* in K */ 
                212.150000,	236.150000,	234.150000,	226.150000,    
                229.150000,
                226.150000,	224.150000,	207.150000,	204.150000,    
                199.150000,
                190.150000,	197.150000,	202.150000,	214.150000,    
                233.150000,
                235.150000,	238.150000,	256.150000,	268.150000,    
                280.150000,
                285.150000,	278.150000,	257.150000,	225.150000,    
                195.150000,
                179.150000,	171.150000 }; 

            for ( i = 0; i < NUMENVELOPE2PTS; i++ )
                {
                    density210C[i] = hd1p[i];
                    temperature210C[i] = hdt1p[i];
                    altitude210C[i] = altitude2[i];
		    udata->numpts = NUMENVELOPE2PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE2PTS - 1];
                }
              }
            break;
          case P5:
              {
            static double hd5p[NUMENVELOPE3PTS] = {  /* in kg/m^3 */ 
                1.300000e+000,	1.140000e+000,	8.820000e-001,	6.880000e-001, 
                5.480000e-001,
                4.320000e-001,	3.400000e-001,	2.660000e-001,	2.030000e-001, 
                1.470000e-001,
                1.050000e-001,	7.300000e-002,	5.700000e-002,	4.300000e-002, 
                2.800000e-002,
                2.100000e-002 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    density210C[i] = hd5p[i];
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
          case P10:
              {
            static double hd10p[NUMENVELOPE4PTS] = {  /* in kg/m^3 */ 
                1.290000e+000,	1.130000e+000,	8.760000e-001,	6.860000e-001, 
                5.460000e-001,
                4.300000e-001,	3.390000e-001,	2.660000e-001,	2.020000e-001, 
                1.450000e-001,
                1.010000e-001,	7.200000e-002,	5.600000e-002,	4.200000e-002, 
                2.800000e-002,
                2.100000e-002,	1.020000e-002,	5.030000e-003,	2.670000e-003, 
                1.460000e-003,
                8.470000e-004,	4.770000e-004,	2.670000e-004,	1.420000e-004, 
                6.680000e-005,
                3.040000e-005 }; 

            for ( i = 0; i < NUMENVELOPE4PTS; i++ )
                {
                    density210C[i] = hd10p[i];
                    altitude210C[i] = altitude4[i];
		    udata->numpts = NUMENVELOPE4PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE4PTS - 1];

                }
              }
            break;
          case P20:
              {
            static double hd20p[NUMENVELOPE3PTS] = {  /* in kg/m^3 */ 
                1.280000e+000,	1.120000e+000,	8.690000e-001,	6.810000e-001, 
                5.420000e-001,
                4.260000e-001,	3.380000e-001,	2.650000e-001,	2.010000e-001, 
                1.440000e-001,
                9.700000e-002,	7.000000e-002,	5.600000e-002,	4.200000e-002, 
                2.700000e-002,
                2.000000e-002 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    density210C[i] = hd20p[i];
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
        } break;
      case LOWDENSITY:
        switch (udata->epercent) {
          case EXTREME:
              {
            static double lde[NUMENVELOPE1PTS] = {  /* in kg/m^3 */ 
                1.010000e+000,	1.040000e+000,	9.110000e-001,	7.610000e-001, 
                6.190000e-001,
                4.590000e-001,	3.400000e-001,	2.540000e-001,	1.890000e-001, 
                1.350000e-001,
                9.600000e-002,	6.600000e-002,	4.900000e-002,	3.500000e-002, 
                2.200000e-002,
                1.400000e-002,	1.000000e-002 }; 

            static double ldte[NUMENVELOPE1PTS] = {  /* in K */ 
                302.150000,	298.150000,	303.150000,	285.150000,    
                256.150000,
                222.150000,	218.150000,	225.150000,	225.150000,    
                230.150000,
                232.150000,	246.150000,	241.150000,	234.150000,    
                228.150000,
                229.150000,	231.150000 };
 
            for ( i = 0; i < NUMENVELOPE1PTS; i++ )
                {
                    density210C[i] = lde[i];
                    temperature210C[i] = ldte[i];
                    altitude210C[i] = altitude1[i];
		    udata->numpts = NUMENVELOPE1PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE1PTS - 1];
                }
              }
            break;
          case P1:
              {
            static double ld1p[NUMENVELOPE2PTS] = {  /* in kg/m^3 */ 
                1.090000e+000,	1.040000e+000,	9.150000e-001,	7.620000e-001, 
                6.200000e-001,
                4.600000e-001,	3.410000e-001,	2.550000e-001,	1.900000e-001, 
                1.360000e-001,
                9.700000e-002,	6.700000e-002,	4.900000e-002,	3.600000e-002, 
                2.300000e-002,
                1.400000e-002,	1.100000e-002,	4.740000e-003,	2.000000e-003, 
                9.630000e-004,
                4.620000e-004,	2.300000e-004,	1.010000e-004,	5.160000e-005, 
                2.540000e-005,
                1.130000e-005,	4.000000e-006 }; 

            static double ldt1p[NUMENVELOPE2PTS] = {  /* in K */ 
                321.150000,	297.150000,	303.150000,	284.150000,    
                271.150000,
                228.150000,	229.150000,	224.150000,	225.150000,    
                230.150000,
                230.150000,	246.150000,	236.150000,	234.150000,    
                228.150000,
                229.150000,	231.150000,	215.150000,	230.150000,    
                253.150000,
                256.150000,	253.150000,	249.150000,	226.150000,    
                210.150000,
                205.150000,	211.150000 }; 

            for ( i = 0; i < NUMENVELOPE2PTS; i++ )
                {
                    density210C[i] = ld1p[i];
                    temperature210C[i] = ldt1p[i];
                    altitude210C[i] = altitude2[i];
		    udata->numpts = NUMENVELOPE2PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE2PTS - 1];
                }
              }
            break;
          case P5:
              {
            static double ld5p[NUMENVELOPE3PTS] = {  /* in kg/m^3 */ 
                1.050000e+000,	9.200000e-001,	7.880000e-001,	6.320000e-001, 
                4.800000e-001,
                3.500000e-001,	2.590000e-001,	1.920000e-001,	1.390000e-001, 
                9.850000e-001,
                7.000000e-002,	4.950000e-002,	3.600000e-002,	2.400000e-002, 
                1.500000e-002,
                1.210000e-002 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    density210C[i] = ld5p[i];
                    altitude210C[i] = altitude3[i];
                    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
          case P10:
              {
            static double ld10p[NUMENVELOPE4PTS] = {  /* in kg/m^3 */ 
                1.050000e+000,	9.240000e-001,	7.800000e-001,	6.340000e-001, 
                4.840000e-001,
                3.540000e-001,	2.610000e-001,	1.930000e-001,	1.400000e-001, 
                9.980000e-001,
                7.120000e-002,	5.000000e-002,	3.700000e-002,	2.400000e-002, 
                1.500000e-002,
                1.240000e-002,	5.500000e-003,	2.230000e-003,	1.080000e-003, 
                5.440000e-004,
                2.580000e-004,	1.250000e-004,	5.830000e-005,	3.060000e-005, 
                1.430000e-006,
                6.000000e-006 }; 

            for ( i = 0; i < NUMENVELOPE4PTS; i++ )
                {
                    density210C[i] = ld10p[i];
                    altitude210C[i] = altitude4[i];
		    udata->numpts = NUMENVELOPE4PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE4PTS - 1];

                }
              }     
            break;
          case P20:
              {
            static double ld20p[NUMENVELOPE3PTS] = {  /* in kg/m^3 */ 
                1.050000e+000,	9.280000e-001,	7.820000e-001,	6.350000e-001, 
                4.990000e-001,
                3.620000e-001,	2.660000e-001,	1.970000e-001,	1.450000e-001, 
                1.050000e-001,
                7.600000e-002,	5.300000e-002,	3.700000e-002,	2.500000e-002, 
                1.600000e-002,
                1.300000e-002 }; 

            for ( i = 0; i < NUMENVELOPE3PTS; i++ )
                {
                    density210C[i] = ld20p[i];
                    altitude210C[i] = altitude3[i];
		    udata->numpts = NUMENVELOPE3PTS - 1;
		    udata->lower_alt = altitude210C[0];
		    udata->upper_alt = altitude210C[NUMENVELOPE3PTS - 1];

                }
              }
            break;
        } break;
    }
}

/* Function: CalcAtmosEnvelope210c ============================================
 * Abstract:
 *   Using cached tables, find the working interval and 
 *   perform logarithmic interpolation.
 */

void CalcAtmosEnvelope210c(const double *altitude,
                          double altitude210C[],
                          double temperature210C[],
                          double density210C[], 
                          double pressure210C[], 
                          double *temp, 
                          double *pressure, 
                          double *density,
                          double *speedofsound,
                          int numPoints,
                          const SFcnCache *udata)
{
    int i;

    for (i=0; i<numPoints; i++) {
        int bottom = 0;
        int idx;
        int top = udata->numpts - 1 ;

        /* Find altitude interval using binary search
         *
         * Deal with the extreme cases first:
         *  if altitude <= altitude210C[bottom] then return idx = bottom
         *  if altitude >= altitude210C[top]    then return idx = top
         */
        if (altitude[i] <= altitude210C[bottom]) {
            idx = bottom;
        } else if (altitude[i] >= altitude210C[top]) {
            idx = top;
        } else {
            for (;;) {
                idx = (bottom + top)/2;
                if (altitude[i] < altitude210C[idx]) {
                    top = idx - 1;
                } else if (altitude[i] >= altitude210C[idx+1]) {
                    bottom = idx + 1;
                } else {
                    /* we have altitude210C[idx] <= altitude[i] 
                     *                          < altitude210C[idx+1],
                     * so break and just use idx 
                     */
                    break;
                }
            } 
        }


        /* Interval has been obtained, now do interpolation */

        switch (udata->epercent) {
          case EXTREME:
          case P1:
            switch (udata->evar) {
              case HIGHTEMP:
              case LOWTEMP:
              case HIGHDENSITY:
              case LOWDENSITY:
                  {
                /* linear interpolation for temperature and 
                 * log interpolation for density 
                 */

                double tempGrad = (temperature210C[idx+1]-temperature210C[idx])/
                    (altitude210C[idx+1] - altitude210C[idx]);

                if ((tempGrad != 0.0)&&((altitude[i]>udata->lower_alt)||
                                       (altitude[i]<udata->upper_alt)))
                {
                    temp[i] = temperature210C[idx] + 
                        tempGrad * (altitude[i] - altitude210C[idx]);
                    density[i] = density210C[idx]*
                        pow(temperature210C[idx]/temp[i], 
                            (GMR/tempGrad)+1.0 );
                } else {
                    temp[i] = temperature210C[idx];
                    if ((altitude[i]>udata->lower_alt)||
                        (altitude[i]<udata->upper_alt)){
                    density[i] = density210C[idx]*
                        exp( (-GMR)*(altitude[i] - altitude210C[idx]) 
                             / temperature210C[idx] );
                    }
                    else{
                    density[i]=density210C[idx];
                    }
                }
                pressure[i] = density[i]*((R_HAT/MOL_WT)*temp[i]);
                speedofsound[i] = sqrt(GAMMA*temp[i]*(R_HAT/MOL_WT));
                  }
                break;
              case HIGHPRESSURE:
              case LOWPRESSURE:
                  {
                /* not enough information for logrithmic interpolation
                 * using linear.  Data should only be used in small 
                 * region about altitude 
                 */

                double presGrad = (pressure210C[idx+1]-pressure210C[idx])/
                     (altitude210C[idx+1] - altitude210C[idx]);

                if ((presGrad != 0.0)||(altitude[i]>udata->lower_alt)||
                                       (altitude[i]<udata->upper_alt))
                {
                    pressure[i] = pressure210C[idx] + 
                        presGrad * (altitude[i] - altitude210C[idx]);
                }
                else
                    { pressure[i] = pressure210C[idx];
                    }
                /* not enough information to calculate remaining data*/
                temp[i] = 0.0;
                density[i] = 0.0;
                speedofsound[i] = 0.0;
                  }
                break;
            }
            break;
          case P5:
          case P10:
          case P20:
            switch (udata->evar) {
              case HIGHTEMP:
              case LOWTEMP:
                  {
                double tempGrad=(temperature210C[idx+1]-temperature210C[idx])/
                    (altitude210C[idx+1] - altitude210C[idx]);

                if ((tempGrad != 0.0 )&&((altitude[i]>udata->lower_alt)||
                                       (altitude[i]<udata->upper_alt)))
                {
                    temp[i] = temperature210C[idx] + 
                        tempGrad * (altitude[i] - altitude210C[idx]);
                } else {
                    temp[i] = temperature210C[idx];
                }
                density[i] = 0.0;
                pressure[i] = 0.0;
                speedofsound[i] = sqrt(GAMMA*temp[i]*(R_HAT/MOL_WT));
                  }
                break;
              case HIGHDENSITY:
              case LOWDENSITY:
                  {
                /* not enough information for logrithmic interpolation
                 * using linear.  Data should only be used in small region
                 * about altitude */

                double densGrad = (density210C[idx+1] - density210C[idx])/
                    (altitude210C[idx+1] - altitude210C[idx]);

                if ((densGrad != 0.0)||(altitude[i]>udata->lower_alt)||
                                       (altitude[i]<udata->upper_alt))
                    {
                        density[i] = density210C[idx] + 
                            densGrad * (altitude[i] - altitude210C[idx]);
                    }
                else
                    { 
                        density[i] = density210C[idx];
                    }
                /* not enough information to calculate remaining data */
                temp[i] = 0.0;
                pressure[i] = 0.0;
                speedofsound[i] = 0.0;
                  }
                break;

              case HIGHPRESSURE:
              case LOWPRESSURE:
                  {
                /* not enough information for logrithmic interpolation
                 * using linear.  Data should only be used in small region
                 * about altitude */

                double presGrad = (pressure210C[idx+1] - pressure210C[idx])/
                    (altitude210C[idx+1] - altitude210C[idx]);

                if ((presGrad != 0.0)||(altitude[i]>udata->lower_alt)||
                                       (altitude[i]<udata->upper_alt)){
                    pressure[i] = pressure210C[idx] + 
                        presGrad * (altitude[i] - altitude210C[idx]);
                }
                else
                    { pressure[i] = pressure210C[idx];
                    }
                /* not enough information to calculate remaining data */
                temp[i] = 0.0;
                density[i] = 0.0;
                speedofsound[i] = 0.0;
                  }
                break;
            }
            break;
        }
    }
}



