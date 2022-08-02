/*
 * File: qspi_manage.c
 *
 * Abstract:
 *
 *
 * $Revision: 1.2.6.3 $
 * $Date: 2004/04/19 01:25:56 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include "mpc5xx.h"
#include <stdlib.h>
#include "isr.h"
#include "qspi_manage.h"

#ifndef MPC555_VARIANT
#define QSMCM QSMCM_A
#define MIOS1 MIOS14
#endif

#ifdef PROFILING_ENABLED
#include "profile_utils.h"
#endif  

///* Maximum number of entries in the queue */
#define LOWEST_PRIORITY 0xFE

/* Global variables */
extern QSPI_QUEUE       qspi_queue[];
volatile UINT16        QSPIST;                          /*  QSPI queue status byte */

/* Local function prototypes */
static void QspiComplete(MPC555_IRQ_LEVEL level_not_used);
static void send_next(void);

static UINT8 qspi_queue_len; 
static QSPI_QUEUE                       *qspi_curque;


/*********************************************************************************
 * QspiSetup - see documentation in header file
 *********************************************************************************/
void QspiSetup(MPC555_IRQ_LEVEL level, UINT8 qspi_queue_len_local) {
  QSPIST = 0;
  if (IRQ_HANDLER_REGISTERED != 
      registerIRQ_Handler( level, QspiComplete, 0, FLOAT_NOT_USED_IN_ISR ) ) {
    exit(0);
  }
  /* Save the available queue length in a static variable */
  qspi_queue_len = qspi_queue_len_local;

  /* Do setup that is common to all devices that will use the QSPI */
  qspi_common_setup(level);
}

/*********************************************************************************
 * QspiSubmit - see documentation in header file
 *********************************************************************************/
UINT8 QspiSubmit(UINT8 priority, QSPI_START_FCN startFcn,
               QSPI_COMPLETE_FCN completeFcn,
               void * user_data) {
  QSPI_QUEUE *ptr;

  EID(); /* enter critical section */
  ptr= &qspi_queue[0];
  do               /* Search for an empty queue entry */
    {
      if(ptr->status == 0)
        goto slot_found;
    } while(++ptr != qspi_queue+qspi_queue_len);

  EIE(); /* exit critical section */
  return(FAILED_QSPI_SUBMIT);                    /* Return Error, No empty slots */
  
 slot_found:
  ptr->qspi_job.priority = priority;
  ptr->qspi_job.startFcn = startFcn;
  ptr->qspi_job.completeFcn = completeFcn;
  ptr->qspi_job.user_data = user_data;
  ptr->status= JOB_PENDING;  

  if(!(QSPIST & (QSPI_FAULT | QSPI_QUEUE_OCCUPIED))) {
    /* Start the new job */
    (* (ptr->qspi_job.startFcn)) ( user_data );
    
    QSPIST |= QSPI_QUEUE_OCCUPIED;  /*  Set job running flag */
    qspi_curque =ptr;
  } else {
    /* If the current job is interruptible then stop it */
    if ( (qspi_curque->qspi_job.priority==LOWEST_PRIORITY) && (QSMCM.SPCR1.B.SPE==1) ) {
      /* Halt the job */
      QSMCM.SPCR3.B.HALT = 1; /* Request HALT */
    }
  }

  EIE(); /* exit critical section */

  return 0; // job submitted
}


/*********************************************************************************
 * QspiComplete
 *
 * Description: call the function that has been registered to be called
 *              when the QSPI operation is finshed or HALTed. Note that this
 *              function is called from within the ISR for the QSPI. It 
 *              must therefore be very short, additionally, it MUST NOT use 
 *              FLOATING POINT.
 * 
 * Inputs:
 *
 * None
 *
 * Returns:
 *
 * None
 * 
 ********************************************************************************/
void QspiComplete(MPC555_IRQ_LEVEL not_used) {
  UINT8 spif;

#ifdef PROFILING_ENABLED
        /* Task execution profiling */
        profile_section_start(PROFILING_ID_QSMCM_ISR);
#endif 


  /* In case being called as a result of HALT request, must
   * disable QSPI */
  QSMCM.SPCR1.B.SPE = 0U;

  /* Save value of SPIF */
  spif = QSMCM.SPSR.B.SPIF;

  /* Clear flags and control bits related to this interrupt */
  QSMCM.SPSR.B.SPIF = 0U;
  QSMCM.SPSR.B.HALTA = 0U;
  QSMCM.SPCR3.B.HALT = 0U;
  
  /* Only run the completeFcn if the job was finished 
   * and not HALTed */
  if (spif) {
    /* need to run the completeFcn for the last user */
    if ( qspi_curque->qspi_job.completeFcn != NULL ) {
      (qspi_curque->qspi_job.completeFcn) 
        ( qspi_curque->qspi_job.user_data );
    }
  }

  /* Only set JOB_INACTIVE if it was actually finished */
  if (spif) {
    qspi_curque->status = JOB_INACTIVE;
  }

  QSPIST &= ~QSPI_QUEUE_OCCUPIED; /* Clear the queue occupied flag */
  

  send_next(); //begin the next job if there is one waiting

#ifdef PROFILING_ENABLED
   /* Task execution profiling */
   profile_section_end(PROFILING_ID_QSMCM_ISR);
#endif 


}

void send_next(void) {
  QSPI_QUEUE *ptr;
  QSPI_JOB * qspi_job;
  UINT8 tmp_priority = 0xFF;

  
  /*  Check for Fault or already transmitting */
  if (QSPIST & (QSPI_FAULT | QSPI_QUEUE_OCCUPIED)) {
    return;
  }  
  ptr = &qspi_queue[0];
  do                                                                           
    {
      if( ptr->status & JOB_PENDING )       /* Search for an occupied entry */
        {
          qspi_job = &(ptr->qspi_job);
          if( qspi_job->priority < tmp_priority )
            {
              tmp_priority = qspi_job->priority;
              qspi_curque = ptr;
            }
        }
    } while( ++ptr != &qspi_queue[qspi_queue_len]);
  
  if( tmp_priority == 0xFF ) {
    return;
    }
  
  /* Start the new job */
  (* (qspi_curque->qspi_job.startFcn)) 
    ( qspi_curque->qspi_job.user_data );
  
  QSPIST |= QSPI_QUEUE_OCCUPIED;  /*  Set job running flag */
}
