/*
 * File: can_driver.c
 *
 * Abstract:
 *    Code for receipt of CAN messages
 *
 *
 * $Revision: 1.11.8.3 $
 * $Date: 2004/04/19 01:25:33 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifndef _CAN_TX_H
#define _CAN_TX_H

#include "can_msg.h"
#include "can_common.h"
#include "mpc5xx.h"


/*------------------------------------------------------------
 * Function
 *
 *    constructCanModule
 *
 * Purpose
 *
 *    creates a CAN_MODULE that can be used by the can driver
 *    routines. All that is required is the base address
 *    of the memory mapped toucan registers.
 *
 *    Initializes all arrays of pointers to NULL
 *
 * Arguments
 *
 *    PCAN_MODULE -  pointer to an uninitialized CAN Module
 *    pReg        -  base adress of the TOUCAN module registers
 *
 * Returns
 *
 *    A pointer to a new PCAN_MODULE or NULL if 
 *    if the operation failed.
 *
 *------------------------------------------------------------*/
  PCAN_MODULE constructCanModule(const PCAN_MODULE module,struct TOUCAN_tag * pReg);

/*------------------------------------------------------------
 * Function
 *
 *    initTouCAN_Module
 *
 * Purpose
 *
 *    Setup the toucan module so that it's bit timing
 *    is correct and the mask registers are all 
 *    initialized.
 *
 * Arguments
 *
 *    module           -  pointer to a CAN module
 *    globalMaskType    -  CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED  
 *    globalMask        -  the mask value
 *    rx14MaskType      -  CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED  
 *    rx14Mask          -  the mask value
 *    rx15MaskType      -  CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED  
 *    rx15Mask          -  the mask value
 */
void setCanModuleMasks(
      const PCAN_MODULE module,
      const CanFrameType globalMaskType,
      const int globalMask,
      const CanFrameType rx14MaskType,
      const int rx14Mask,
      const CanFrameType rx15MaskType,
      const int rx15Mask);

/*-----------------------------------------------------------*/


/*------------------------------------------------------------
 * Function
 *
 *    loadCanMessage
 *
 * Purpose
 *
 *    Load a CAN frame immediately into a TOUCAN buffer
 *
 * Arguments
 *    
 *    msg      -     The CAN Frame to load
 *    p_mbuff  -     Pointer to the MBUFF structure of the buffer to be loaded.
 */
void loadCanMessage(const CAN_FRAME * msg, P_TOUCAN_MBUFF p_mbuff);








/*--------------------------------------------------
 * Function
 *
 *    disableCanBuffer
 *
 * Purpose
 *
 *    disable the CAN buffer from participating in
 *    bus activity
 *
 * Arguments
 *
 *    pModule   - pointer to a CAN module 
 *    buffer   -  0-15
 */
void disableCanModuleBuffer(const PCAN_MODULE module,const UINT8 buffer);

/*------------------------------------------------------------ */



/*--------------------------------------------------------------
 * Function 
 *
 *    setCanBitTiming
 *
 * Purpose
 *
 *    Configure the baud rate and bit timing of the can signal
 *    
 * Parameters
 *
 *    module      -     The CAN module to configure
 *    propseg     -     The propogation segment       1 <= propseg <= 8
 *    pseg1       -     Phase segment 1               1 <= pseg1 <= 8
 *    pseg2       -     Phase segment 2               1 <= pseg2 <= 8
 *    presdiv     -     Prescaler divide              1 <= presdiv <= 256
 *    rjw         -     Resyncronization jump width   1 <= rjw <= 4
 *
 * Notes
 *
 *    In the mfiles directory there is a script can_bit_timing.m which will
 *    calculate the above parameters for required baud rates and sample
 *    points.
 *
 *    Using this function the module is configured to take one sample
 *    at the end of pseg1
 */ 
void setCanBitTiming(
      const PCAN_MODULE module,  // The CAN module
      const unsigned int propseg,         // The propogation segment
      const unsigned int pseg1,           // Phase segment 1
      const unsigned int pseg2,           // Phase segment 2
      const unsigned int presdiv,         // Prescaler divide
      const unsigned int rjw,             // Resyncronization jump width
      const UINT16 desiredNumQuanta,   /* desired num quanta */
      const FLOAT32 desiredSamplePoint, /* desired sample point */
      const FLOAT32 desiredBitRate      /* desired bit rate */
      );

    /*****************************************************
     *    BIT TIMING Configuration
     *
     *    Clock Input                 =   20Mhz 
     *
     *    Prescaler Divide            = 2
     *                PRESDIV + 1     = 1
     *                1       + 1     = 1 
     *                       
     *
     *    Number of segments          =   20
     *
     *    TSEG1 = PROPSEG + PSEG1 + 2 =   15
     *            7       + 6     + 2 =   15
     *                         
     *    TSEG2 = PSEG2   + 1         =   4
     *            3       + 1         =   4
     *
     *    Bit Rate = 20  mhz / ( 2 * 20)
     *             = 500 kbps
     *
     *    Sampling point = 16 / 20 = 0.8
     *
     ********************************************************/

/*-----------------------------------------------------------------------*/

/*----------------------------------------------------------------------
 * Function
 *
 *    setCanModuleDefaults
 *
 * Purpose
 *
 *    To setup some of the default options of the CAN Module
 *
 * Details
 *
 *    Configures polarity of the transciever 
 *    Enables debugging
 *    Places the registers in user privelege mode
 *    Buffer with lowest id is transmitted first
 *    No SYNC message and NO Global Time
 */
void setCanModuleDefaults(const PCAN_MODULE module);
/*----------------------------------------------------------------------*/
#endif
