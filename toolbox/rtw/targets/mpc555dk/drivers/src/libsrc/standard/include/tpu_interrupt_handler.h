/*
 * File: tpu_interrupt_handler.h
 *
 * Abstract:
 *    Handle execution of code from interrupts triggered by TPU channels
 *
 *
 * $Revision: 1.1.4.2 $
 * $Date: 2004/04/19 01:25:45 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#ifndef _TPU_INTERRUPT_HANDLER_H
#define _TPU_INTERRUPT_HANDLER_H

#include "tpu_common.h"
#include "mpc5xx.h"

/*------------------------------------------------------------
 * Function
 *    
 *    TPU_IRQ_CALLBACK                        -  type for handler
 *    setTPUModuleHandler                     -  set the handler
 *    setTPUModuleFloatingPointHandler        -  set the handler and allow floating point
 *    removeTPUModuleHandler                  -  remove and disable the handler
 *
 * Purpose
 *
 *    Allows the user to add a handler to any of the possible
 *    TPU interrupt sources (one for each channel). 
 *    The same function can be added
 *    to more than one source as the source argument is
 *    passed to the handler and can be possibly used in
 *    a switch to differentiate the sources.
 *
 *    The interrupt is enabled automatically by this call so
 *    do not register this until the code is ready. 
 *
 * Arguments
 *
 *    module  -  a pointer to the TPU module
 *    source   -  the TPU interrupt source to attach the
 *                handler to
 *    fHND     -  a pointer the the function itself
 *
 **/
void setTPUModuleHandler(TPU_ISR_MODULE_PTR module,
        TPU_IRQ_SOURCE source,
        TPU_IRQ_HANDLER  fHND);

void setTPUModuleFloatingPointHandler(TPU_ISR_MODULE_PTR module,
        TPU_IRQ_SOURCE source,
        TPU_IRQ_HANDLER  fHND);

void removeTPUModuleHandler(TPU_ISR_MODULE_PTR module,
      TPU_IRQ_SOURCE source);


/*--------------------------------------------------------------------
 * Function
 *
 *    setTPUModuleIrqLevel       - Set the IRQ level on the UIMB
 *
 * Purpose
 *
 *  initialize the TPU module interrupt processor to place
 *  the specified interrupt level on the UIMB when it 
 *  generates an interrupt.
 *
 *  To generate interrupts you must configure the handlers
 *  for the specific TPU channel. See setTPUCallback 
 *  and enableTPUModuleCallback.
 *
 * Arguments
 *
 *  module  -   a pointer to the TPU module
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
int setTPUModuleIrqLevel(TPU_ISR_MODULE_PTR module, MPC555_IRQ_LEVEL level);


/*---------------------------------------------
 * Function 
 *    
 *    mainTPUHandler
 *
 * Purpose
 *
 *    To handle interrupts for the TPU modules.
 *
 *    It is designed to be the handler for as many 
 *    TPU mdoules as there are on board the
 *    system. The handler is passed the interrupt
 *    level upon which it has been triggered and
 *    then retrieves the pointer to the TPU
 *    module corresponding to this level.
 *
 * Arguments
 *
 *    level -  The interrupt level which triggered
 *             this interrupt.
 *
 * ------------------------------------------------*/
void mainTPUHandler( MPC555_IRQ_LEVEL level );

#endif
