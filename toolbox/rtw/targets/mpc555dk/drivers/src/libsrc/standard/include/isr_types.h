/*
 * File: isr.h
 *
 * Abstract:
 *    Header file for interrupt service routine code
 *
 * $Revision: 1.1 $
 * $Date: 2002/09/13 09:05:29 $
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#ifndef _ISR_TYPES_H
#define _ISR_TYPES_H
/*------------------------------------------------------------
 * ENUM
 * 
 *    MPC555_IRQ_LEVEL
 *
 * Purpose
 *
 *    Identifies all IRQ levels available to the MPC555
 *
 *-----------------------------------------------------------*/
typedef enum {
   EXT_IRQ0       ,  
   INT_LEVEL0     ,  
   EXT_IRQ1       ,  
   INT_LEVEL1     ,  
   EXT_IRQ2       ,   
   INT_LEVEL2     ,  
   EXT_IRQ3       ,  
   INT_LEVEL3     ,
   EXT_IRQ4       ,
   INT_LEVEL4     ,
   EXT_IRQ5       ,
   INT_LEVEL5     ,
   EXT_IRQ6       ,
   INT_LEVEL6     ,    
   EXT_IRQ7       ,   
   INT_LEVEL7     , 
   INT_LEVEL8     , 
   INT_LEVEL9     ,
   INT_LEVEL10    ,
   INT_LEVEL11    ,
   INT_LEVEL12    ,
   INT_LEVEL13    ,
   INT_LEVEL14    ,
   INT_LEVEL15    ,
   INT_LEVEL16    ,
   INT_LEVEL17    ,
   INT_LEVEL18    ,
   INT_LEVEL19    ,
   INT_LEVEL20    ,
   INT_LEVEL21    ,
   INT_LEVEL22    ,
   INT_LEVEL23    ,
   INT_LEVEL24    ,
   INT_LEVEL25    ,
   INT_LEVEL26    ,
   INT_LEVEL27    ,
   INT_LEVEL28    ,
   INT_LEVEL29    ,
   INT_LEVEL30    ,
   INT_LEVEL31 } MPC555_IRQ_LEVEL ;

/*------------------------------------------------------------
 * Declare a function prototype for interrupt
 * service routines.
 */

typedef void ( * ISR_HANDLER ) ( MPC555_IRQ_LEVEL level ) ; 

/*------------------------------------------------------------*/



/*------------------------------------------------------------
 * Function
 *
 *    registerHandler
 *
 * PurposIRQ_ENABLE_COUNT_SEMAPHOREe
 *
 *    To register an interrupt handler at the appropriate
 *    level for the MPC555. 
 *
 *    At the moment chaining is not supported so if you register
 *    one handler then another at the same level then the first
 *    handler will be removed.
 *
 *    By installing a handler at this level you are also 
 *    implicitly enabling the level in SIVEC. 
 * 
 * Arguments
 *
 *    lvl        -  One of the levels specified by MPC555_IRQ_LEVEL
 *    fHND       -  handle to a c function matching ISR_HANDLER prototype
 *    objet      -  An optional object you can store for a particular level.
 *                  You can retrieve this object with the macro. GET_IRQ_OBJECT
 *
 * Returns       -  IRQ_HANDLER_REGISTERED if the registration was successfull
 *               -  IRQ_HANDLER_NOT_REGISTERED if the registration was unsucessfull due
 *                  to another handler being registered at the same level. If this
 *                  is the case there is either a bug in your code or you need to
 *                  explicitly  unregister the handler at that level.
 */
 // ENUMERAIONS
typedef enum { IRQ_HANDLER_REGISTERED,IRQ_HANDLER_NOT_REGISTERED } IRQ_REGISTRATION_STATUS; 
typedef enum { FLOAT_USED_IN_ISR , FLOAT_NOT_USED_IN_ISR } FLOATING_POINT_FOR_ISR;

#endif
