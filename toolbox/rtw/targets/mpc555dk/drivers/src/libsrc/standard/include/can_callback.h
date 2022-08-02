/*
 * File: can_callback.h
 *
 * Abstract:
 *    Handle execution of code from an interrupt triggered by CAN
 *
 *
 * $Revision: 1.10.6.3 $
 * $Date: 2004/04/19 01:25:31 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#ifndef _CAN_CALLBACKS_H
#define _CAN_CALLBACKS_H

#include "isr.h"
#include "can_common.h"

/*------------------------------------------------------------
 * Function
 *
 *  enableCanModuleCallback
 *  disableCanModuleCallback
 *
 * Purpose
 *
 *  To enable the interrupt for a particular TouCAN source
 *
 * Arugments
 *
 *  module  -   The TouCAN module
 *  source  -   The source of the interrupt
 *
 */
void enableCanModuleCallback(PCAN_MODULE module, TOUCAN_IRQ_SOURCE source );


/*--------------------------------------------------------------------
 * Function
 *
 *    setCanModuleIrqLevel       - Set the IRQ level on the UIMB
 *
 * Purpose
 *
 *  initialize the Toucan module interrupt processor to place
 *  the specified interrupt level on the UIMB when it 
 *  generates an interrupt.
 *
 *  To generate interrupts you must configure the handlers
 *  for the specific can interrupt source. See setCanCallback 
 *  and enableCanModuleCallback.
 *
 * Arguments
 *
 *  module  -   a pointer to the CAN module
 *  level       -   the level at which to set the interrupt priority.
 *
 * Return
 *
 *    true(1)  -  if the module was registered
 *    false(0) -  if the module was not registered. This
 *             is probably because another module has already
 *             been registered at this level.
 *
 *-----------------------------------------------------------------------------*/
int setCanModuleIrqLevel(PCAN_MODULE module, 
        MPC555_IRQ_LEVEL level);

int setOSEKCanModuleIrqLevel(PCAN_MODULE module, 
                             MPC555_IRQ_LEVEL level);



/*------------------------------------------------------------
 * Function
 *    
 *    CAN_IRQ_CALLBACK                        -  type for callback
 *    setCanModuleCallback                    -  set the callback
 *    setCanModuleFloatingPointCallback       -  set the callback and allow floating point
 *    removeCanModuleCallback                 -  remove and disable the callback
 *
 * Purpose
 *
 *    Allows the user to add a handler to any of the possible
 *    CAN interrupt sources. The same function can be added
 *    to more than one source as the source argument is
 *    passed to the handler and can be possibly used in
 *    a switch to differentiate the sources.
 *
 *    The interrupt is enabled automatically by this call so
 *    do not register this until the code is ready. As long as
 *    the main interrupt controller to the TOUCAN is disabled 
 *    registering the callback will not active the callback
 *
 * Arguments
 *
 *    module  -  a pointer to the CAN module
 *    source   -  the can interrupt source to attach the
 *                handler to
 *    fHND     -  a pointer the the function itself
 *
 **/


void setCanModuleCallback(PCAN_MODULE module,
                          TOUCAN_IRQ_SOURCE source,
                          CAN_IRQ_CALLBACK  fHND);

void setCanModuleFloatingPointCallback(PCAN_MODULE module,
        TOUCAN_IRQ_SOURCE source,
        CAN_IRQ_CALLBACK  fHND);

void removeCanModuleCallback(PCAN_MODULE module,
      TOUCAN_IRQ_SOURCE source);

/*------------------------------------------------------------*/

/*------------------------------------------------------------
 * Function
 *    ToucanSoftReset(PCAN_MODULE module)
 *    
 * Purpose
 *
 *    Resets the TOUCAN module. This may be usefull after the
 *    module has entered a fault confinement state and the user
 *    wishes to reset the module. The process followed is
      
      Stop the module
      Reset the module
      Wait for reset to finish
      Set the IRQ level of the module
      Set some options in the MCR
      Set the IMASK for all callbacks
      Re-enable to module

 * Arguments
 *
 *    module  -  a pointer to the CAN module
 *    source   -  the can interrupt source to attach the
 *                handler to
 *    fHND     -  a pointer the the function itself
 *
 **/



int ToucanSoftReset(PCAN_MODULE module);

/*------------------------------------------------------------*/




#endif
