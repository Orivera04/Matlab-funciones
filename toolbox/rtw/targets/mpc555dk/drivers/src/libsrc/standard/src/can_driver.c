/*
 * File: can_driver.c
 *
 * Abstract:
 *    Code for CAN messaging
 *
 *
 * $Revision: 1.11.8.2 $
 * $Date: 2004/04/19 01:25:47 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#include <string.h>
#include "can_driver.h"
#include "can_callback.h"


PCAN_MODULE constructCanModule(const PCAN_MODULE module,struct TOUCAN_tag * pReg){
   int idx;
   for (idx=0;idx<NTOUCANCALLBACKS;idx++){
      module->callbacks[idx]=NULL;
      module->irqObjects[idx]=NULL;
      module->floatFlags[idx]=FLOAT_NOT_USED_IN_ISR;
   }
   module->reg=pReg;
   for ( idx=0;idx<16;idx++){
      disableCanModuleBuffer(module, idx);
   }
   return module;
}

void disableCanModuleBuffer(const PCAN_MODULE module,const UINT8 buffer){
   module->reg->MBUFF[buffer].SCR.B.CODE=MPC555_TOUCAN_RX_CODE_NOT_ACTIVE;
}

// Programmers Note - 
//
//    Do not store msg in any persistent data structures as
//    it may be a reference to local structures in the calling
//    function.
void loadCanMessage(const CAN_FRAME * msg, P_TOUCAN_MBUFF p_mbuff) {

   UINT32 id = msg->ID;
   unsigned int length = msg->LENGTH;
   

   // Load the ID into the buffer
   p_mbuff->SCR.B.CODE = MPC555_TOUCAN_TX_CODE_NOT_ACTIVE;
   switch(msg->type){
      case CAN_MESSAGE_STANDARD:
         p_mbuff->ID_HIGH.B = STD_ID_2_ID_HIGH(id); 
         p_mbuff->ID_LOW.B = STD_ID_2_ID_HIGH(id); 
         break;
      case CAN_MESSAGE_EXTENDED:
         p_mbuff->ID_HIGH.B = XTD_ID_2_ID_HIGH(id);
         p_mbuff->ID_LOW.B = XTD_ID_2_ID_LOW(id);
         break;
   }

   // Copy the message into the buffer
   memcpy((void *)p_mbuff->DATA,(void *)(msg->DATA),length);

   // Write control/status word 
   p_mbuff->SCR.B.LENGTH = length;
   p_mbuff->SCR.B.CODE = MPC555_TOUCAN_TX_CODE_ONCE;
}

void setCanModuleMasks(
      const PCAN_MODULE module,
      const CanFrameType globalMaskType,
      const int globalMask,
      const CanFrameType rx14MaskType,
      const int rx14Mask,
      const CanFrameType rx15MaskType,
      const int rx15Mask){

   struct TOUCAN_tag * reg;

   reg = module->reg;

    /*****************************************************
     *    Configure the TouCAN Mask Registers
     *
     *    See section 16.7.4 and 16.7.9 and 16.7.10 
     *    in the MPC555 manual.
     *****************************************************/

    switch(globalMaskType){
       case CAN_MESSAGE_STANDARD:
          // Set the global mask to be 0U 
          reg->RXGMSKHI.R = STD_ID_2_ID_HIGH(globalMask); 
          reg->RXGMSKLO.R = STD_ID_2_ID_LOW(globalMask);
          break;
       case CAN_MESSAGE_EXTENDED:
          // Set the global mask 
          reg->RXGMSKHI.R = XTD_ID_2_ID_HIGH(globalMask);
          reg->RXGMSKLO.R = XTD_ID_2_ID_LOW(globalMask);
          break;
    }

    switch(rx14MaskType){
       case CAN_MESSAGE_STANDARD:
          // Set the mask for rx14 to be 0U
          reg->RX14MSKHI.R = STD_ID_2_ID_HIGH(rx14Mask); 
          reg->RX14MSKLO.R = STD_ID_2_ID_LOW(rx14Mask);
          break;
       case CAN_MESSAGE_EXTENDED:
          // Set the mask for rx14 
          reg->RX14MSKHI.R = XTD_ID_2_ID_HIGH(rx14Mask);
          reg->RX14MSKLO.R = XTD_ID_2_ID_LOW(rx14Mask);
          break;
    }

    switch(rx15MaskType){
       case CAN_MESSAGE_STANDARD:
          // Set the mask for rx15 
          reg->RX15MSKHI.R = STD_ID_2_ID_HIGH(rx15Mask); 
          reg->RX15MSKLO.R = STD_ID_2_ID_LOW(rx15Mask);
          break;
       case CAN_MESSAGE_EXTENDED:
          // Set the mask for rx15 
          reg->RX15MSKHI.R = XTD_ID_2_ID_HIGH(rx15Mask);
          reg->RX15MSKLO.R = XTD_ID_2_ID_LOW(rx15Mask);
          break;
    }
}

void setCanModuleDefaults(const PCAN_MODULE module){

   struct TOUCAN_tag * reg;

   reg = module->reg;

   /******************************************************
    *  Configure the polarity of the transmit pins
    *
    *  The below configuration is for a dominant signal to
    *  drive B_CNTX0 low and a recesive signal to drive
    *  B_CNTX0 high. 
    *
    *  Equivalently for receiving the polarity is the 
    *  same for transmitting.
    *
    * ***************************************************/
   reg->CANCTRL0.B.RXMODE = 0;
   reg->CANCTRL0.B.TXMODE = 0;


   /*****************************************************
    *    Configure CAN_A TCNMCR
    *    TouCAN Module Configuration register.
    *
    *    Bits in this register controll things such as
    *    low power mode and wake up functions and
    *    reset functions. See section 16.7.1 in the
    *    MPC555 manual.
    *****************************************************/

   reg->TCNMCR.B.FRZ  = 1;            // Enable debugging of the CAN module
   reg->TCNMCR.B.SUPV = 1;            // Place the registers in user privilage mode. 

   /*****************************************************
    *    Configure CAN_A CANCTRL0
    *    TouCAN Control Register 0
    *
    *    See section 16.7.4 in the MPC555 manual.
    *****************************************************/

   reg->CANCTRL0.B.BOFFMSK = 0;       // No Bus off interrupt by default
   reg->CANCTRL0.B.ERRMSK = 0;        // No Error interrupt by default

   // No SYNC message. No Global time
   reg->CANCTRL1.B.TSYNC = 0;

   // Transmit buffer with lowest ID first
   reg->CANCTRL1.B.LBUF = 0;
}

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
      ){   

   struct TOUCAN_tag * reg;

   /* store desired settings */
   module->desiredNumQuanta = desiredNumQuanta;
   module->desiredSamplePoint = desiredSamplePoint;
   module->desiredBitRate = desiredBitRate;
   
   reg = module->reg;

   reg->CANCTRL1.B.SAMP = 0;

   reg->CANCTRL1.B.PROPSE = propseg-1;

   reg->PRESDIV.R = presdiv-1;

   reg->CANCTRL2.B.RJW = rjw-1;

   reg->CANCTRL2.B.PSEG = pseg1-1;

   reg->CANCTRL2.B.PSEG2 = pseg2-1;
}
