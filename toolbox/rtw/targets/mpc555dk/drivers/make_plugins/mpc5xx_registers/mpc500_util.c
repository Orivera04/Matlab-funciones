/**************************************************************************/
/* FILE NAME: mpc5xx_util.c                   COPYRIGHT (c) MOTOROLA 2002 */
/* VERSION: 1.0                                   All Rights Reserved     */
/*                                                                        */
/* DESCRIPTION: This file contains useful routines when using MPC5xx      */
/* based devices.                                                         */
/*                                                                        */
/*========================================================================*/
/* HISTORY           ORIGINAL AUTHOR: Jeff Loeliger                       */
/* REV      AUTHOR      DATE       DESCRIPTION OF CHANGE                  */
/* ---   -----------  ---------    ---------------------                  */
/* 1.0   J. Loeliger  03/Aug/02    Initial version of function.           */
/**************************************************************************/
#include "mpc500_util.h"

/*******************************************************************************
FUNCTION      : tpu_func
PURPOSE       : To assign a function to a given channel
INPUTS NOTES  : This function has 3 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
                 function_number - Function number to be assigned
*******************************************************************************/
void tpu_func(struct TPU3_tag *tpu, UINT8 channel, UINT8 function_number)
{
    UINT16 reg;
    
    if (channel < 4) {
        reg = tpu->CFSR3.R;
        reg &= ~(TPU_CHANNEL_MASK << (channel * 4));
        reg |= (function_number << (channel * 4));
        tpu->CFSR3.R = reg;
    }
    else if (channel < 8) {
        reg = tpu->CFSR2.R;
        reg &= ~(TPU_CHANNEL_MASK << ((channel-4) * 4));
        reg |= (function_number << ((channel-4) * 4));
        tpu->CFSR2.R = reg;
    }
    else if (channel < 12) {
        reg = tpu->CFSR1.R;
        reg &= ~(TPU_CHANNEL_MASK << ((channel-8) * 4));
        reg |= (function_number << ((channel-8) * 4));
        tpu->CFSR1.R = reg;
    }
    else {
        reg = tpu->CFSR0.R;
        reg &= ~(TPU_CHANNEL_MASK << ((channel-12) * 4));
        reg |= (function_number << ((channel-12) * 4));
        tpu->CFSR0.R = reg;
    }
}

/*******************************************************************************
FUNCTION      : tpu_get_func
PURPOSE       : To get the function number running on a given channel
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
RETURNS NOTES : This function will return the function number running on the
                channel.
*******************************************************************************/
UINT8 tpu_get_func(struct TPU3_tag *tpu, UINT8 channel)
{
    UINT16 function;

    if (channel < 4) {
        function = tpu->CFSR3.R;
    }
    else if (channel < 8) {
        channel -= 4;
        function = tpu->CFSR2.R;
    }
    else if (channel < 12) {
        channel -= 8;
        function = tpu->CFSR1.R;
    }
    else {
        channel -= 12;
        function = tpu->CFSR0.R;
    }

    function=(function & (TPU_CHANNEL_MASK << (channel * 4)) >> (channel * 4));

    return ((UINT8)function);
}

/*******************************************************************************
FUNCTION      : tpu_hsr
PURPOSE       : To issue a host service request (HSR) to a channel
INPUTS NOTES  : This function has 3 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
                 hsr - service request value
GENERAL NOTES : WARNING the HSR bits for a channel should be cleared before
                writing another HSR otherwise the requests will be ORed
                together. The host CPU can only set bits in the HSR registers 
                so the values can be written directly with masks.
*******************************************************************************/
void  tpu_hsr(struct TPU3_tag *tpu, UINT8 channel, UINT8 hsr)
{
    if (channel < 8) {
        tpu->HSRR1.R = (hsr << (channel * 2));
    }
    else {
        tpu->HSRR0.R = (hsr << ((channel - 8) * 2));
    }
}

/*******************************************************************************
FUNCTION      : tpu_get_hsr
PURPOSE       : To get the current state of the HSR field
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
RETURNS NOTES : This function will return the pending HSR or zero
*******************************************************************************/
UINT8 tpu_get_hsr(struct TPU3_tag *tpu, UINT8 channel)
{
    UINT16 hsr;
    
    if (channel < 8) {
        hsr = tpu->HSRR1.R;
    }
    else {
        channel -= 8;
        hsr = tpu->HSRR0.R;
    }

    hsr = ((hsr & (TPU_HSR_MASK << (channel * 2))) >> (channel * 2));

    return ((UINT8)hsr);
}

/*******************************************************************************
FUNCTION      : tpu_hsq
PURPOSE       : To set the host squence bits (HSQ)
INPUTS NOTES  : This function has 3 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
                 hsq - host sequence value value
*******************************************************************************/
void  tpu_hsq(struct TPU3_tag *tpu, UINT8 channel, UINT8 hsq)
{
    UINT16 reg;

    if (channel < 8) {
        reg = tpu->HSQR1.R;
        reg &= ~(TPU_HSQ_MASK << ((channel) * 2));
        reg |= (hsq << ((channel) * 2));
        tpu->HSQR1.R = reg;
    }
    else {
        channel -= 8;
        reg = tpu->HSQR0.R;
        reg &= ~(TPU_HSQ_MASK << ((channel) * 2));
        reg |= (hsq << ((channel) * 2));
        tpu->HSQR0.R = reg;
    }
}

/*******************************************************************************
FUNCTION      : tpu_get_hsq
PURPOSE       : To get the current state of the HSQ ield
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
RETURNS NOTES : This function will return the curent HSQ field
*******************************************************************************/
UINT8 tpu_get_hsq(struct TPU3_tag *tpu, UINT8 channel)
{
    UINT16 hsq;
    
    if (channel < 8) {
        hsq = tpu->HSQR1.R;
    }
    else {
        channel -= 8;
        hsq = tpu->HSQR0.R;
    }

    hsq = (hsq & (TPU_HSQ_MASK << (channel * 2))) >> (channel * 2);

    return ((UINT8)hsq);
}

/*******************************************************************************
FUNCTION      : tpu_enable
PURPOSE       : To enable a TPU channel by assigning a priority to the channel
INPUTS NOTES  : This function has 3 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
                 priority - This is the priority to assign to the channel.
                            This parameter should be assigned a value of:
                            TPU_PRIORITY_HIGH, TPU_PRIORITY_MIDDLE or
                            TPU_PRIORITY_LOW.
*******************************************************************************/
void  tpu_enable(struct TPU3_tag *tpu, UINT8 channel, UINT8 priority)
{
    UINT16 reg;

    if (channel < 8) {
        reg = tpu->CPR1.R;
        reg &= ~(TPU_PRIORITY_MASK << ((channel) * 2));
        reg |= (priority << ((channel) * 2));
        tpu->CPR1.R = reg;
    }
    else {
        reg = tpu->CPR0.R;
        reg &= ~(TPU_PRIORITY_MASK << ((channel-8) * 2));
        reg |= (priority << ((channel-8) * 2));
        tpu->CPR0.R = reg;
    }
}

/*******************************************************************************
FUNCTION      : tpu_disable
PURPOSE       : To disable a TPU channel by setting the priority bits to 0b00
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
GENERAL NOTES : Disabling a channel will not stop a channel that is currently
                being executed by the TPU.
*******************************************************************************/
void  tpu_disable(struct TPU3_tag *tpu, UINT8 channel)
{
    UINT16 reg;

    if (channel < 8) {
        tpu->CPR1.R &= ~(TPU_PRIORITY_MASK << ((channel) * 2));
    }
    else {
        tpu->CPR0.R &= ~(TPU_PRIORITY_MASK << ((channel-8) * 2));
    }
}

/*******************************************************************************
FUNCTION      : tpu_interrupt_enable
PURPOSE       : To enable inerrupts on a channel
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
*******************************************************************************/
void  tpu_interrupt_enable(struct TPU3_tag *tpu, UINT8 channel)
{

    tpu->CIER.R |= (1 << channel);

}

/*******************************************************************************
FUNCTION      : tpu_interrupt_enable
PURPOSE       : To enable interrupts on a channel
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
GENERAL NOTES : Disabling interrupts does not stop the interruput flag from
                being set.
*******************************************************************************/
void  tpu_interrupt_disable(struct TPU3_tag *tpu, UINT8 channel)
{

    tpu->CIER.R &= ~(1 << channel);

}

/*******************************************************************************
FUNCTION      : tpu_clear_interrupt
PURPOSE       : To clear an interrupts on a channel
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
GENERAL NOTES : 
*******************************************************************************/
void  tpu_clear_interrupt(struct TPU3_tag *tpu, UINT8 channel)
{
    UINT16 dummy;
    
    dummy = tpu->CISR.R;
    
    tpu->CISR.R = ~(1 << channel);

}


/*******************************************************************************
FUNCTION      : tpu_check_interrupt
PURPOSE       : To check inerrupts on a channel
INPUTS NOTES  : This function has 2 parameters:
                 *tpu - This is a pointer to the TPU3 module to use. It is of
                         type TPU3_tag which is defined in m_tpu3.h
                 channel - This is the number of the channel
GENERAL NOTES : 
*******************************************************************************/
UINT8 tpu_check_interrupt(struct TPU3_tag *tpu, UINT8 channel)
{
    UINT16 tint;
    
    tint = ((tpu->CISR.R) >> channel ) & 1;
    
    return ((UINT8) tint);
}


/*********************************************************************
 *
 * Copyright:
 *	MOTOROLA, INC. All Rights Reserved.  
 *  You are hereby granted a copyright license to use, modify, and
 *  distribute the SOFTWARE so long as this entire notice is
 *  retained without alteration in any modified and/or redistributed
 *  versions, and that such modified versions are clearly identified
 *  as such. No licenses are granted by implication, estoppel or
 *  otherwise under any patents or trademarks of Motorola, Inc. This 
 *  software is provided on an "AS IS" basis and without warranty.
 *
 *  To the maximum extent permitted by applicable law, MOTOROLA 
 *  DISCLAIMS ALL WARRANTIES WHETHER EXPRESS OR IMPLIED, INCLUDING 
 *  IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
 *  PURPOSE AND ANY WARRANTY AGAINST INFRINGEMENT WITH REGARD TO THE 
 *  SOFTWARE (INCLUDING ANY MODIFIED VERSIONS THEREOF) AND ANY 
 *  ACCOMPANYING WRITTEN MATERIALS.
 * 
 *  To the maximum extent permitted by applicable law, IN NO EVENT
 *  SHALL MOTOROLA BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING 
 *  WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS 
 *  INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY
 *  LOSS) ARISING OF THE USE OR INABILITY TO USE THE SOFTWARE.   
 * 
 *  Motorola assumes no responsibility for the maintenance and support
 *  of this software
 ********************************************************************/

