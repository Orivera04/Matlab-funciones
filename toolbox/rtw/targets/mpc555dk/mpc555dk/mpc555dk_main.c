/*
 * File: mpc555dk_main.c
 *
 * Abstract:
 *
 *   An embedded real-time main that runs the generated Real-Time Workshop code
 *   and is tailored for Motorola MPC555. Based on the value of NUMST and
 *   definition of MULTITASKING a single rate/single task, multirate/single task
 *   or multirate/multitask step function is employed.
 *
 *
 * Required Defines:
 *
 *   MODEL - Model name
 *   NUMST - Number of sample times
 *
 * Release Notes:
 *
 *   Version 3.0
 *   -----------
 *
 *   (1) The multirate scheduling code inside rt_OneStep() is now generated
 *   with the model (significantly simplifying the interface).  If you
 *   have a modified version of ert_main.c, remove the approprite sections
 *   of function rt_OneStep().  Search for "REMOVE" to locate the appropriate
 *   sections to be removed from any modified versions of ert_main.c.
 *
 *   (2) Interface code should not access the Real-Time Object directly.
 *   If you have any modified versions of ert_main.c, it's recommended that
 *   you change the following code segment
 *   
 *   for (i = 1; i < NUMST; i++) {
 *     eventFlags[i] = (!RT_OBJ.cTaskTicks[i]) ? 1 : 0;
 *   }
 *
 *   to use the appropriate method that's now generated with the code
 *
 *   MODEL_SETEVENTS(eventFlags);
 *
 *   Search for "REPLACE" to locate the appropriate sections to be modified.
 *
 *   $Revision: 1.11.4.9 $
 *   $Date: 2004/04/29 03:40:08 $
 *
 *   Copyright 2001-2004 The MathWorks, Inc. */

/*==================*
 * Required defines *
 *==================*/

#ifndef MODEL
# error Must specify a model name.  Define MODEL=name.
#else
/* create generic marcros that work with any model */
# define EXPAND_CONCAT(name1,name2) name1 ## name2
# define CONCAT(name1,name2) EXPAND_CONCAT(name1,name2)
# define MODEL_INITIALIZE CONCAT(MODEL,_initialize)
# define MODEL_STEP       CONCAT(MODEL,_step)
# define MODEL_TERMINATE  CONCAT(MODEL,_terminate)
# define MODEL_SETEVENTS  CONCAT(MODEL,_SetEventsForThisBaseStep)
# define RT_MDL           CONCAT(MODEL,_M)
# define RT_OBJ           RT_MDL
#endif

#ifndef NUMST
# error Must specify the number of sample times.  Define NUMST=number.
#endif

#ifndef NCSTATES
#error NCSTATES must be defined
#endif

#if defined(TID01EQ) && (TID01EQ == 1) && (NCSTATES == 0)
#define DISC_NUMST (NUMST - 1)
#else
#define DISC_NUMST NUMST
#endif

#if ONESTEPFCN==0
#error Separate output and update functions are not supported by ert_main.c. \
You must update ert_main.c to suit your application needs, or select \
the 'Single output/update function' option.
#endif

#if MULTI_INSTANCE_CODE==1
#error The static version of ert_main.c does not support multi-instance \
code generation.  Either deselect option 'Generate multi-instance code', \
select option 'Generate an example main program', or modify ert_main.c for \
your application needs.
#endif

/* Edit these values to tune the behaviour of the model when overruns occur */
#define BASE_RATE_MAX_OVERRUNS 5
#define SUB_RATE_MAX_OVERRUNS 2

/*==========*
 * Includes *
 *==========*/

#include <string.h>    /* optional for strcmp */
#include "mpc5xx.h"

#include "rtwtypes.h"                                                    

/*                                                                       
 * Let MT be synonym for MULTITASKING (to shorten command line for DOS)  
 */                                                                      
#if defined(MT)                                                          
# if MT == 0                                                             
# undef MT                                                               
# else                                                                   
# define MULTITASKING 1                                                  
# endif                                                                  
#endif        
/* indicate that MT preprocessor define has been processed */
#define CCP_MT_PROCESSED   

/* include the model header file */
#include "autobuild.h" /* optional for automated builds */
/* indicate that Model Header file has been included */
#define CCP_AUTOBUILD_PROCESSED 

#include "ext_work.h"  /* optional for external mode */
#include "pit.h"       /* MPC555 Programmable Interrupt Timer Header */ 
#include "realtime_vars.h" /*Some auto-generated defines for the scheduler */
#include "profile.h"

/*====================*
 * External functions *
 *====================*/

extern void MODEL_INITIALIZE(boolean_T firstTime);
#if TERMFCN==1
   extern void MODEL_TERMINATE(void);
#endif
extern void MODEL_SETEVENTS(boolean_T *eventFlags);

#if DISC_NUMST == 1
 extern void MODEL_STEP(void);       /* single rate step function */
#else
 extern void MODEL_STEP(int_T tid);  /* multirate step function */
#endif

/* defined in ccp_utils - call to fire the DAQ lists */
#ifdef CCP_DAQ_LIST_ENABLED
   extern void c_fire_DAQs(uint8_T); 
#endif
 

/*==================================*
 * Macros used by this module 
 *==================================*/
#define SERVICE_WATCHDOG_TIMER \
   USIU.SWSR.R = 0x556C; \
   USIU.SWSR.R = 0xAA39; 

/*==================================*
 * Global data local to this module *
 *==================================*/
#ifndef MULTITASKING
static uint_T OverrunFlags[1];    /* ISR overrun flags */
#else
static uint_T OverrunFlags[DISC_NUMST];
static uint_T TaskRunningFlags[DISC_NUMST];
#endif

/*===================*
 * Visible functions *
 *===================*/

#if DISC_NUMST == 1 && !defined(MULTITASKING) /* single rate - single task */

/* Function: rtOneStep ========================================================
 *
 * Abstract: Perform one step of the model.  This function is modeled is called
 *   from an interrupt service routine (ISR).  
 */
void  rt_OneStep(MPC555_IRQ_LEVEL level)
{
    /* Clear the interrupt that triggered this function */
    ClearPitIRQ;
    
    /***********************************************
     * Check if too many overruns occurred
     ***********************************************/
    if (OverrunFlags[0] > BASE_RATE_MAX_OVERRUNS) {
        rtmSetErrorStatus(RT_OBJ, "Overrun");
    }
    
    /*************************************************
     * Check if an error status has been set *
     * by an overrun or by the generated code.       *
     *************************************************/
    if (rtmGetErrorStatus(RT_OBJ) != NULL) {
        return;
    }

    /***********************************************
     * Increment the overruns flag
     ***********************************************/
    if (OverrunFlags[0]++) {
#ifdef PROFILING_ENABLED
        overrun_max_log(OverrunFlags[0], 0);
#endif
        return;
    }
    
    while (OverrunFlags[0] > 0 ) {
#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_task_start(0);
#endif 
        
        /* Re-enable interrupts here */
        EIE();

        /* Set model inputs here */
        
        /**************
         * Step model *
         **************/
        MODEL_STEP();
#ifdef CCP_DAQ_LIST_ENABLED
        /* single rate, single tasking only rate in the model will be TID 0 */
        c_fire_DAQs(0);
#endif
        
        /* Get model outputs here */
        
        /************************
         * Service Watchdog Timer
         ************************/
        SERVICE_WATCHDOG_TIMER;
        
        /* Disable interrupts */
        EID();

        /**************************
         * Decrement overrun flag *
         **************************/
        OverrunFlags[0]--;

#ifdef EXT_MODE
        rtExtModeCheckEndTrigger();
#endif
        
#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_task_end(0);
#endif 
        
    }
    return;
} /* rtOneStep */


#elif DISC_NUMST > 1 && !defined(MULTITASKING) /* multirate - single task */
/* Function: rtOneStep ========================================================
 *
 *
 * Abstract: Perform one step of the model.  This function is called from an
 *   interrupt service routine (ISR).
 *
 *   This routine is designed for a single tasking real-time environment.
 *
 */
void rt_OneStep(MPC555_IRQ_LEVEL level)
{
    int_T i;

#ifdef CCP_DAQ_LIST_ENABLED
    /* Local variable to store which tids need to be fired 
     * we always fire the base-rate so we don't need to store any 
     * information about it */
    uint8_T tids_to_fire[TOTAL_NUM_TIDS - 1];
#endif

    /* Clear the interrupt that triggered this function */
    ClearPitIRQ;

    /***********************************************
     * Check if base step time is too fast *
     ***********************************************/
    if (OverrunFlags[0] > BASE_RATE_MAX_OVERRUNS) {
        rtmSetErrorStatus(RT_OBJ, "Overrun");
    }

    /*************************************************
     * Check if an error status has been set *
     * by an overrun or by the generated code.       *
     *************************************************/
    if (rtmGetErrorStatus(RT_OBJ) != NULL) {
        return;
    }

    /***********************************************
     * Increment the overruns flag
     ***********************************************/
    if (OverrunFlags[0]++) {
#ifdef PROFILING_ENABLED
        overrun_max_log(OverrunFlags[0], 0);
#endif
        return;
    }

    while (OverrunFlags[0] > 0) {
#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_task_start(0);
#endif 

        /* Re-enable interrupts here */
        EIE();

        /* Set model inputs here */

#ifdef CCP_DAQ_LIST_ENABLED
        /* Need to work out which TIDs need firing after the 
         * MODEL_STEP.  Note: this must be done before the 
         * MODEL_STEP as the MODEL_STEP updates the timing information */
        for (i=1; i<TOTAL_NUM_TIDS; i++) {
            /* Use macro to determine which rates will need their TID's 
             * processing.
             * This macro is defined in realtime_vars.h */
            if (MPC555_IS_SINGLE_TASKING_SAMPLE_HIT(i)) {
                /* fire this TID i after the model step */
                tids_to_fire[i-1] = 1;
            }
            else {
                /* do not fire TID i after the model step */
                tids_to_fire[i-1] = 0;
            }
        }
#endif
        
        /******************/
        /* Step the model */
        /******************/
        MODEL_STEP(0); /* tid index is always zero for singletasking */


#ifdef CCP_DAQ_LIST_ENABLED
        /* multi rate, single tasking */
    
        /* always fire the base-rate */
        c_fire_DAQs(0);

        /* now fire any other tids that are required */
        for (i=1; i<TOTAL_NUM_TIDS; i++) {
            if (tids_to_fire[i-1] == 1) {
                c_fire_DAQs(i);
            }
        }
#endif

        /* Get model outputs here */

        /************************
         * Service Watchdog Timer
         ************************/
        SERVICE_WATCHDOG_TIMER;

        /* Disable interrupts */
        EID();

        /**************************
         * Decrement overrun flag *
         **************************/
        OverrunFlags[0]--;

#ifdef EXT_MODE
        rtExtModeCheckEndTrigger();
#endif

#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_task_end(0);
#endif 

    }
    return;
} /* rtOneStep */

#elif DISC_NUMST > 1 && defined(MULTITASKING) /* multirate - multitask */

/* Function: rtOneStep ========================================================
 *
 * Abstract:
 *   Perform one step of the model.  This function is called from a timer
 *   interrupt service routine (ISR).
 *
 *   This routine is designed for a multitasking real-time environment, and
 *   therefore needs to be fully re-entrant when it is called from an ISR.
 *   The eventFlags array is a stack array variable which guarantees
 *   that each subrate in the model is executed for each (preemptable) base
 *   rate interrupt.
 *
 */
void rt_OneStep(MPC555_IRQ_LEVEL level)
{
    int_T i;

    /* Clear the interrupt that triggered this function */
    ClearPitIRQ;

    /***********************************************
     * Check if too many overruns occurred
     ***********************************************/
    if (OverrunFlags[0] > BASE_RATE_MAX_OVERRUNS) {
        rtmSetErrorStatus(RT_OBJ, "Overrun");
    }

    /*************************************************
     * Check if an error status has been set         
     * by an overrun or by the generated code.       
     *************************************************/
    if (rtmGetErrorStatus(RT_OBJ) != NULL) {
        return;
    }

    /***********************************************
     * Increment the overruns flag
     ***********************************************/
    if (OverrunFlags[0]++) {
#ifdef PROFILING_ENABLED
        overrun_max_log(OverrunFlags[0], 0);
#endif
        return;
    }
    
    while (OverrunFlags[0] > 0) {
        
        boolean_T eventFlags[DISC_NUMST]; /* necessary for overlapping preemption */

#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_task_start(0);
#endif 
        
        /* Re-enable interrupts here */
        EIE();

        /*****************************************************************
         * Buffer event flags locally so that the function is re-entrant *
         *****************************************************************/
        MODEL_SETEVENTS(eventFlags);

        /* Set model inputs associated with base-rate here */

        /*******************************************
         * Step the model for the base sample time *
         *******************************************/
        MODEL_STEP(0);
#ifdef CCP_DAQ_LIST_ENABLED
        /* multi rate, multi tasking
         * fire DAQ list for TID 0 */
        c_fire_DAQs(0);
#endif

        /* Get model outputs associated with base-rate here */

        /************************
         * Service Watchdog Timer
         ************************/
        SERVICE_WATCHDOG_TIMER;

        /* Disable interrupts */
        EID();

        /**************************
         * Decrement overrun flag *
         **************************/
        OverrunFlags[0]--;

#ifdef EXT_MODE
        rtExtModeCheckEndTrigger();
#endif

#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_task_end(0);
#endif 
        /*********************************************************
         * Update event flags for any other sample times (sub-rates)
         *********************************************************/
        for (i = 1; i < DISC_NUMST; i++) {
            if (eventFlags[i]) {
                if (OverrunFlags[i]++ > SUB_RATE_MAX_OVERRUNS) {
                    /* Sampling too fast */
                    rtmSetErrorStatus(RT_OBJ, "Overrun");
                }
#ifdef PROFILING_ENABLED
                overrun_max_log(OverrunFlags[i], i);
#endif
            }
        }
    }

    /*********************************************************
     * Step the model for any other sample times (sub-rates)
     *********************************************************/
    for (i = 1; i < DISC_NUMST; i++) {
        /* Check if this task is already running */
        if (TaskRunningFlags[i]) {
            /* Defer execution until instance of this task already running is
               complete */
            break;
        }

        while (OverrunFlags[i] > 0) {
#ifdef PROFILING_ENABLED
            /* Task execution profiling */
            profile_task_start(i);
#endif 
                
            /* Set the task running flag */
            TaskRunningFlags[i] = 1;
            
            /* Re-enable interrupts here */
            EIE();
                
            /* Set model inputs associated with subrate here */

            MODEL_STEP(i);
#ifdef CCP_DAQ_LIST_ENABLED
            /* multi rate, multi tasking 
             * must fire DAQ lists for the subrate after the 
             * MODEL_STEP(i) */
            c_fire_DAQs(i);
#endif
            /* Get model outputs associated with subrate here */
                
            /* Disable interrupts */
            EID();
                    
            /* Clear the task running flag */
            TaskRunningFlags[i] = 0;
            
            /**************************
             * Decrement overrun flag *
             **************************/
            OverrunFlags[i]--;
#ifdef PROFILING_ENABLED
            /* Task execution profiling */
            profile_task_end(i);
#endif 
        }
    }
    return;
} /* rtOneStep */

#else /* illegal state : single rate - multitask */
# error "A single rate model can't have multiple tasks" 
#endif 

/* Function: rt_InitModel ====================================================
 * 
 * Abstract: 
 *   Initialized the model and the overrun-flags
 *
 */
void rt_InitModel(void)
{
    /****************************
     * Initialize global memory *
     ****************************/
#if defined(MULTITASKING)
    int i;
    for(i=0; i < DISC_NUMST; i++) {
        OverrunFlags[i] = 0;
        TaskRunningFlags[i] = 0;
    }
#else
    OverrunFlags[0] = 0;
#endif

    /************************
     * Initialize the model *
     ************************/
    MODEL_INITIALIZE(1);
}

/* Function: rt_TermModel ====================================================
 * 
 * Abstract:
 *   Terminates the model.
 *
 */
#if TERMFCN==1
int_T rt_TermModel(void)
{
    MODEL_TERMINATE();
    return(0);
}
#endif

/* Function: main =============================================================
 *
 * Abstract:
 *   Execute model on Motorola MPC555.
 */
int_T main(int_T argc, const char_T *argv[])
{
   /*******************
    * Parse arguments *
    *******************/
#ifdef EXT_MODE
    rtERTExtModeParseArgs(argc, argv);
#endif

   /************************
    * initialize the model *
    ************************/
	initIrqModule(3);
   rt_InitModel();
	{
		float period ;

		/* Set the timeout period of the Programmable Interrupt Timer 
		 * which will driver rtOneStep */
		setPitModuleIrqLevel(RT_ONE_STEP_IRQ);
		period = setPitPeriod(TIMER_TICK_PERIOD, OSCILLATOR_FREQ);
		if(period < 0){
			// Unable to achive this period
			exit(1);
		}


#if INTEGER_CODE==0
        registerIRQ_Handler( RT_ONE_STEP_IRQ, rt_OneStep , NULL , FLOAT_USED_IN_ISR);
#else
        registerIRQ_Handler( RT_ONE_STEP_IRQ, rt_OneStep , NULL , FLOAT_NOT_USED_IN_ISR);
#endif
        EnablePitFreeze;	     /* Make sure we can stop the ISR during debug */
        EnablePitInterrupt;	     /* Enable the timer interrupt */
        EnablePit;		     /* Start the timer counting */

#ifdef PROFILING_ENABLED
        /* MPC555-specific initialization for execution profiling */
        profile_timer_enable();
        
        /* General initialization for execution profiling */
        profile_init();
#endif

        /* Enable External Interrupts */
        EIE();

        while(1) {
            boolean_T rtmStopReq = false;
#ifdef PROFILING_ENABLED
            profile_state_update();
#endif
#ifdef EXT_MODE
            rt_PktServerWork(RT_MDL->extModeInfo,
                             DISC_NUMST,
                             &rtmStopReq);
            rt_UploadServerWork(DISC_NUMST);
#endif
        };
    }
}
