/*
 * File: can_driver.c
 *
 * Abstract:
 *    CAN driver for use by boot code
 *
 *
 * $Revision: 1.1.6.2 $
 * $Date: 2004/04/19 01:25:09 $
 *
 * Copyright 2002-2003 The MathWorks, Inc.
 */

#include "simple_can_driver.h"

static UINT32 s_tx_id;

// Receive a frame of data
int receiveCanFrameBoot(unsigned char * data){

   struct TOUCAN_tag * can;

   int id,idx;
   can = &(CAN_MODULE);


   //if(can->MBUFF[RX_BUFFER].SCR.B.CODE == MPC555_TOUCAN_RX_CODE_FULL){
   if(can->IFLAG.R & ( 0x1 << RX_BUFFER)){

      const void * src;                 // Pointer to source RX_BUFFER
      void * dest;                      // Pointer to destination RX_BUFFER

      // If the TouCAN RX_BUFFER is busy then wait
      while(can->MBUFF[RX_BUFFER].SCR.B.CODE & MPC555_TOUCAN_RX_CODE_BUSY);

#if MESSAGE_TYPE == CAN_MESSAGE_STANDARD
      id = can->MBUFF[RX_BUFFER].ID_HIGH.B >> 5;
#elif MESSAGE_TYPE == CAN_MESSAGE_EXTENDED
      id = ( ( can->MBUFF[RX_BUFFER].ID_HIGH.B >> 5 ) << 18 ) |
         ( ( can->MBUFF[RX_BUFFER].ID_HIGH.B & 0x7 ) << 15) |
         ( can->MBUFF[RX_BUFFER].ID_LOW.B >> 1 );
#else
#error MESSAGE_TYPE should be CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED
#endif

      /* Block copy the data RX_BUFFER */

      for(idx=0;idx<8;idx++){
         data[idx] = can->MBUFF[RX_BUFFER].DATA[idx].R;
      }

      can->MBUFF[RX_BUFFER].SCR.B.CODE = MPC555_TOUCAN_RX_CODE_ACTIVE_EMPTY;

      // Clear the IFLAG
      can->IFLAG.R &= ~( 0x1 << RX_BUFFER);

      // Reading the timer unlocks the message TX_BUFFER
      idx = (volatile int ) (CAN_MODULE.TIMER.R);
      return 1; 

   }else{
      // Reading the timer unlocks the message TX_BUFFER
      idx = (volatile int ) (CAN_MODULE.TIMER.R);
      return 0;
   }
}


void initCanModuleRxTxBoot(UINT32 rx_id, UINT32 tx_id){
   int idx;

   s_tx_id = tx_id;

   CAN_MODULE.MBUFF[RX_BUFFER].SCR.B.CODE = MPC555_TOUCAN_RX_CODE_NOT_ACTIVE;

#if MESSAGE_TYPE == CAN_MESSAGE_STANDARD
   CAN_MODULE.MBUFF[RX_BUFFER].ID_HIGH.R = STD_ID_2_ID_HIGH(rx_id);    // IDE bit not set 
   CAN_MODULE.MBUFF[RX_BUFFER].ID_LOW.R = 0;
#elif MESSAGE_TYPE == CAN_MESSAGE_EXTENDED
   CAN_MODULE.MBUFF[RX_BUFFER].ID_HIGH.R = XTD_ID_2_ID_HIGH(rx_id);    // IDE bit set 
   CAN_MODULE.MBUFF[RX_BUFFER].ID_LOW.R = XTD_ID_2_ID_LOW(rx_id);
#else
#error MESSAGE_TYPE should be CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED
#endif

   CAN_MODULE.MBUFF[RX_BUFFER].SCR.B.CODE = MPC555_TOUCAN_RX_CODE_ACTIVE_EMPTY;
   // Reading the timer unlocks the message TX_BUFFER
   idx = (volatile int ) (CAN_MODULE.TIMER.R);



}



// Send the frame of data
void sendCanFrameBoot(unsigned char * data){
   int idx;

   // Disable the CAN Buffer
   CAN_MODULE.MBUFF[TX_BUFFER].SCR.B.CODE=MPC555_TOUCAN_TX_CODE_NOT_ACTIVE;

   // Load the ID into the TX_BUFFER
   CAN_MODULE.MBUFF[TX_BUFFER].SCR.B.LENGTH = 8;

#if MESSAGE_TYPE == CAN_MESSAGE_STANDARD
   CAN_MODULE.MBUFF[TX_BUFFER].ID_HIGH.B = STD_ID_2_ID_HIGH(s_tx_id); 
   CAN_MODULE.MBUFF[TX_BUFFER].ID_LOW.B = STD_ID_2_ID_HIGH(s_tx_id); 
#elif MESSAGE_TYPE == CAN_MESSAGE_EXTENDED
   CAN_MODULE.MBUFF[TX_BUFFER].ID_HIGH.B = XTD_ID_2_ID_HIGH(s_tx_id);
   CAN_MODULE.MBUFF[TX_BUFFER].ID_LOW.B = XTD_ID_2_ID_LOW(s_tx_id);
#else
#error MESSAGE_TYPE should be CAN_MESSAGE_STANDARD | CAN_MESSAGE_EXTENDED
#endif

   // Copy the message into the TX_BUFFER
   for (idx=0;idx<8;idx++){
      CAN_MODULE.MBUFF[TX_BUFFER].DATA[idx].R = data[idx];
   }

   // Marks the message TX_BUFFER as ready to transmit once only
   CAN_MODULE.MBUFF[TX_BUFFER].SCR.B.CODE = MPC555_TOUCAN_TX_CODE_ONCE;

   // Reading the timer unlocks the message TX_BUFFER
   idx = (volatile int ) (CAN_MODULE.TIMER.R);
}

void setupCanModuleBoot(UINT16 desiredNumQuanta,
                        FLOAT32 desiredSamplePoint,
                        FLOAT32 desiredBitRate){

   struct TOUCAN_tag * reg;

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
   CAN_MODULE.CANCTRL0.B.RXMODE = 0;
   CAN_MODULE.CANCTRL0.B.TXMODE = 0;


   /*****************************************************
   *    Configure CAN_MODULE TCNMCR
   *    TouCAN Module Configuration CAN_MODULEister.
    *
   *    Bits in this CAN_MODULEister controll things such as
   *    low power mode and wake up functions and
   *    reset functions. See section 16.7.1 in the
   *    MPC555 manual.
    *****************************************************/

   CAN_MODULE.TCNMCR.B.FRZ  = 1;            // Enable debugging of the CAN module
   CAN_MODULE.TCNMCR.B.SUPV = 1;            // Place the CAN_MODULEisters in user privilage mode. 

   /*****************************************************
   *    Configure CAN_MODULE CANICR
   *    TouCAN Interrupt Configuration Register

   *    Here we can configure the interrupt
   *    level of the TouCAN module.

   *    See section 16.7.3 in the MPC555 manual.
    *****************************************************/

   // We are   going to operate the TouCAN in polled mode.

   /*****************************************************
   *    Configure CAN_MODULE CANCTRL0
   *    TouCAN Control Register 0
    *
   *    See section 16.7.4 in the MPC555 manual.
    *****************************************************/

   CAN_MODULE.CANCTRL0.B.BOFFMSK = 0;       // No Bus off interrupt
   CAN_MODULE.CANCTRL0.B.ERRMSK = 0;        // No Error interrupt

   /* set the CAN Bit Timing registers appropriately */
   setBitTiming(desiredNumQuanta,
                desiredSamplePoint,
                desiredBitRate);

   /*****************************************************
   *    Configure CAN_MODULE  
   *    Configure the TouCAN Mask Registers
    *
   *    See section 16.7.4 and 16.7.9 and 16.7.10 
   *    in the MPC555 manual.
    *****************************************************/

   CAN_MODULE.RXGMSKHI.R = 0xFFFF;
   CAN_MODULE.RXGMSKHI.R = 0xFFFF;

   CAN_MODULE.RX14MSKHI.R = 0xFFFF; 
   CAN_MODULE.RX14MSKLO.R = 0xFFFF;

   CAN_MODULE.RX15MSKHI.R = 0xFFFF;
   CAN_MODULE.RX15MSKLO.R = 0xFFFF;


   // Enable the CAN module:w
   {
      UINT8 i;
      for (i=0; i<16; i++) {
         CAN_A.MBUFF[i].SCR.B.CODE=MPC555_TOUCAN_TX_CODE_NOT_ACTIVE;
      }
   }

   CAN_MODULE.TCNMCR.B.HALT=0;
}

/* setBitTiming is essentially a C implementation of the m-file
 * can_bit_timing.m, which calculates the register settings 
 * required to achieve arbitrary bit rates. 
 *
 * See can_bit_timing.m for more information on the implementation
 * of this utility */
static void setBitTiming(UINT16 desiredNumQuanta,
                  FLOAT32 desiredSamplePoint,
                  FLOAT32 desiredBitRate) {
   /*****************************************************
   *    BIT TIMING Configuration
   *
   *    Configure CAN_MODULE CANCTRL0 CANTRL1 PRESDIV CANTRL2
   *    TouCAN Control Register 0
   *    TouCAN Control Register 1
   *    Prescaler Divide
   *    TouCAN Control Register 2
   *
   *    These CAN_MODULE registers control the bit timing and
   *    and bit rate of the TouCAN     
   *    See section 16.7.5 -> 16.7.7 in the MPC555 manual.
   *   
   *    Clock Input                 = BOOTCODE_SYSTEM_FREQUENCY  (20Mhz)
   *    Number of segments          = desiredNumQuanta 
   *    Bit Rate                    = desiredBitRate
   *    Sampling point              = desiredSamplePoint
   *
   ********************************************************/

   /* variables to hold calculated values before writing to the CAN
    * Module */
   UINT8 presdiv, propseg, pseg1, pseg2;

   /* temporary variables to store best 
    * solution so far */
   FLOAT32 currSample;
   int currTseg1;
   int loopMax;
   
   /* out of range (0 <= x <= 1) initial sample */
   FLOAT32 bestSample = 1.5;
   UINT8 bestTseg1;
   
   /* One sample taken at end of PSEG1 for bit determinization */
   CAN_MODULE.CANCTRL1.B.SAMP = 0;

   /* No SYNC message. No Global time */
   CAN_MODULE.CANCTRL1.B.TSYNC = 0;

   /* Transmit buffer with lowest ID first */
   CAN_MODULE.CANCTRL1.B.LBUF = 0;
 
   /* default value for RJW */
   CAN_MODULE.CANCTRL2.B.RJW = 3;
   
   /* calculate presdiv from input arguments
    * NOTE: can_bit_timing.m threw an error condition
    * in the case where presdiv is not a whole number - 
    * FIXME: evaluate cases that could cause an error */
   presdiv = BOOTCODE_SYSTEM_FREQUENCY / (desiredNumQuanta * desiredBitRate);

   /* loopMax = min(desiredNumQuanta - 1, 16) */
   if ((desiredNumQuanta-1) < 16) {
      loopMax = desiredNumQuanta - 1;
   }
   else {
      loopMax = 16;
   }

   /* loop over candidate values for TSEG1, and calculate SAMPLE
    * Compare to desiredSamplePoint to find best values */
   for (currTseg1 = 2; currTseg1 <= loopMax; currTseg1++) {
      currSample = (1.0 + currTseg1) / desiredNumQuanta;
      if (fabs(currSample - desiredSamplePoint) < fabs(bestSample - desiredSamplePoint)) {
         bestSample = currSample;
         bestTseg1 = currTseg1;
      }
   }

   /* calculate remaining params */
   propseg = floor(bestTseg1 / 2);
   pseg1 = bestTseg1 - propseg;
   pseg2 = desiredNumQuanta - 1 - propseg - pseg1;

   CAN_MODULE.CANCTRL1.B.PROPSE = propseg - 1;
   CAN_MODULE.PRESDIV.R = presdiv - 1;
   CAN_MODULE.CANCTRL2.B.PSEG = pseg1 - 1;
   CAN_MODULE.CANCTRL2.B.PSEG2 = pseg2 - 1;
}
