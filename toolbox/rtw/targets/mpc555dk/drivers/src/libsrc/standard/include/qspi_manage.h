/*
 * File: qspi_manage.h
 *
 * Abstract:
 *
 *
 * $Revision: 1.2.4.2 $
 * $Date: 2004/04/19 01:25:42 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _QSPI_MANAGE_H 
#define _QSPI_MANAGE_H 
/*--------------------------------------------------------------------------
;
; File:         qspi_manage.h
;
; 
;   
; --------------------------------------------------------------------------*/

#include "mpc5xx.h"
#include "isr.h"
/*------------------------------------------------------------
 * Declare a prototype for the function that gets executed
 * on completion of a QSPI job. 
 */
typedef void ( * QSPI_COMPLETE_FCN ) ( void * UserData ) ; 

/*------------------------------------------------------------
 * Declare a prototype for the function that gets executed
 * at the start of a QSPI job
 */
typedef void ( * QSPI_START_FCN ) ( void * UserData ) ; 

/* Data structure to define a QSPI job */
typedef struct QSPI_JOB {
  UINT8 priority;
  QSPI_START_FCN startFcn;
  QSPI_COMPLETE_FCN completeFcn;
  void * user_data;
} QSPI_JOB;

/* Data structure for the QSPI queue */
typedef struct QSPI_QUEUE {
   UINT8 status;
   QSPI_JOB qspi_job;
}  QSPI_QUEUE;


/*********************************************************************************
 * QspiSubmit
 * 
 * Inputs:
 * 
 * Priority: Must be in the range 0 to 0xFE. The lower the value the higher the
 *           priority, when the QSPI is ready to start the next job it will 
 *           select jobs from the queue in order of priority. Do not set a task
 *           with priority 0xFF as this will fail.
 *
 * StartFcn: each job on the queue must specify a function to be called when the
 *           job is started. This user defined function is responsible for 
 *           configuring the QSPI and initiating the transfer. The StartFcn 
 *           must be as short as possible, i.e. set QSPI configuration, copy data to 
 *           TRANRAM and COMDRAM, enable QSPI then return.  If StartFcn makes
 *           any changes to QSMCM.SPCR2, care must be take to ensure that 
 *           SPIFIE [SPI finished interrupt enable] is always set regardless of
 *           whether a CompleteFcn is used. The StartFcn may be called with 
 *           interrupts disabled; if it is required that interrupts must always
 *           be disabled when the StartFcn is called, this can be assured by
 *           ensuring that the call to QspiSubmit is wrapped within a EID(), EIE() 
 *           pair.
 *
 * CompleteFcn: jobs on the queue may optionally specify a CompleteFcn. When the
 *           transfer is complete, an interrupt is generated. The CompleteFcn,
 *           if specified, is called from the SPI finished interrupt service routine.
 *           If several QSPI jobs must be chained together, it is possible to
 *           call QspiSubmit from inside the CompleteFcn. The CompleteFcn is
 *           always called with interrupts enabled.
 * 
 * User_Data: a pointer to data that is passed as an argument both to the 
 *            StartFcn and the CompleteFcn.
 * 
 * Returns: 0 if successful, 1 otherwise
 *
 * 
 ********************************************************************************/
UINT8 QspiSubmit(UINT8 priority, QSPI_START_FCN start_fcn, 
               QSPI_COMPLETE_FCN completeFcn, void * user_data);

#define   FAILED_QSPI_SUBMIT  ((UINT8) 0xFFFF)


/*********************************************************************************
 * QspiSetup
 * 
 * Inputs: level - interrupt level assigned to this device
 *         qlen  - maximum number of entries in the qspi queue
 *
 * None
 *
 * Returns:
 *
 * None
 * 
 * Note: this function should be called once only during setup. If using
 * Simulink, this is achieved by including a QSPI configuration block
 * in the model.
 * 
 ********************************************************************************/
void QspiSetup(MPC555_IRQ_LEVEL level, UINT8 qlen);

/*     QSPI Queue Entry Status Values  */
#define JOB_INACTIVE            0
#define JOB_PENDING             0x80

/********************************************************************************
 * User defined QSPI setup function to set behaviour that is common to
 * all devices on the QSPI
 *******************************************************************************/
void qspi_common_setup(MPC555_IRQ_LEVEL level);


extern volatile UINT16 COMST; 

/* QSPI Queue overall status values */
#define QSPI_QUEUE_OVERRUN       0x0008          /* Job missed           */
#define QSPI_FAULT               0x0004          /* Fatal                */
#define QSPI_QUEUE_OCCUPIED      0x0002          /* Informational        */



#endif  /* _QSPI_MANAGE_H  */


