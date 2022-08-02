/* $RCSfile: LF2407_Reg.h,v $
 * $Revision: 1.2 $ $Date: 2003/10/20 14:53:00 $
 * Copyright 2003 The MathWorks, Inc.
 */

/*-----------------------------------------------------------------
  Definitions of Programmable Registers on the TMS320x240x TI DSP
-----------------------------------------------------------------*/

//240x CPU core registers
                           
#define IMR 0x0004  /* Interrupt Mask Register */
#define IFR 0x0006  /* Interrupt Flag Register */

/* Interrupt and System configuration registers */
#define PIRQR0 0x7010 /* Peripheral Interrupt Request Register 0 */
#define PIRQR1 0x7011 /* Peripheral Interrupt Request Register 1 */
#define PIRQR2 0x7012 /* Peripheral Interrupt Request Register 2 */
#define PIACKR0 0x7014 /* Peripheral Interrupt Acknowledge Register 0 */
#define PIACKR1 0x7015 /* Peripheral Interrupt Acknowledge Register 1 */
#define PIACKR2 0x7016 /* Peripheral Interrupt Acknowledge Register 2 */
#define SCSR1 0x7018 /* System Control and Status Register 1 */
#define SCSR2 0x7019 /* System Control and Status Register 2 */
#define DINR 0x701C /* Device Identification Number Register */
#define PIVR 0x701E /* Peripheral Interrupt Vector Register */
/* Watchdog */
#define WDCNTR 0x7023 /* Watchdog Counter Register */
#define WDKEY 0x7025 /* Watchdog Reset Key Register */
#define WDCR 0x7029 /* Watchdog Timer Control Register */
/* Serial Peripheral Interface (SPI) */
#define SPICCR 0x7040 /* SPI Configuration Control Register */
#define SPICTL 0x7041 /* SPI Operation Control Register */
#define SPISTS 0x7042 /* SPI Status Register */
#define SPIBRR 0x7044 /* SPI Baud Rate Register */
#define SPIRXEMU 0x7046 /* SPI Emulation Buffer Register */
#define SPIRXBUF 0x7047 /* SPI Serial Receive Buffer Register */
#define SPITXBUF 0x7048 /* SPI Serial Transmit Buffer Register */
#define SPIDAT 0x7049 /* SPI Serial Data Register */
#define SPIPRI 0x704F /* SPI Priority Control Register */
/* Serial Communications Interface (SCI) */
#define SCICCR 0x7050 /* SCI Communication Control Register */
#define SCICTL1 0x7051 /* SCI Control Register 1 */
#define SCIHBAUD 0x7052 /* SCI Baud-Select Register, high bits */
#define SCILBAUD 0x7053 /* SCI Baud-Select Register, low bits */
#define SCICTL2 0x7054 /* SCI Control Register 2 */
#define SCIRXST 0x7055 /* SCI Receiver Status Register */
#define SCIRXEMU 0x7056 /* SCI Emulation Data Buffer Register */
#define SCIRXBUF 0x7057 /* SCI Receiver Data Buffer Register */
#define SCITXBUF 0x7059 /* SCI Transmit Data Buffer Register */
#define SCIPRI 0x705F /* SCI Priority Control Register */
/* External Interrupt */
#define XINT1CR 0x7070 /* External Interrupt 1 Control Register */
#define XINT2CR 0x7071 /* External Interrupt 2 Control Register */
/* Digital I/O */
#define MCRA 0x7090 /* I/O Mux Control Register A */
#define MCRB 0x7092 /* I/O Mux Control Register B */
#define MCRC 0x7094 /* I/O Mux Control Register C */
#define PADATDIR 0x7098 /* Port A Data and Direction Control Register */
#define PBDATDIR 0x709A /* Port B Data and Direction Control Register */
#define PCDATDIR 0x709C /* Port C Data and Direction Control Register */
#define PDDATDIR 0x709E /* Port D Data and Direction Control Register */
#define PEDATDIR 0x7095 /* Port E Data and Direction Control Register */
#define PFDATDIR 0x7096 /* Port F Data and Direction Control Register */
/* Analog-to-Digital Converter (ADC) (10-Bit) */
#define ADCTRL1 0x70A0 /* ADC Control Register 1 */
#define ADCTRL2 0x70A1 /* ADC Control Register 2 */
#define MAX_CONV 0x70A2 /* Maximum Conversion Channels Register */
#define CHSELSEQ1 0x70A3 /* Channel Select Sequencing Control Register 1 */
#define CHSELSEQ2 0x70A4 /* Channel Select Sequencing Control Register 2 */
#define CHSELSEQ3 0x70A5 /* Channel Select Sequencing Control Register 3 */
#define CHSELSEQ4 0x70A6 /* Channel Select Sequencing Control Register 4 */
#define AUTO_SEQ_SR 0x70A7 /* Autosequence Status Register */
#define RESULT0 0x70A8 /* Conversion Result Buffer Register 0 */
#define RESULT1 0x70A9 /* Conversion Result Buffer Register 1 */
#define RESULT2 0x70AA /* Conversion Result Buffer Register 2 */
#define RESULT3 0x70AB /* Conversion Result Buffer Register 3 */
#define RESULT4 0x70AC /* Conversion Result Buffer Register 4 */
#define RESULT5 0x70AD /* Conversion Result Buffer Register 5 */
#define RESULT6 0x70AE /* Conversion Result Buffer Register 6 */
#define RESULT7 0x70AF /* Conversion Result Buffer Register 0x7 */
#define RESULT8 0x70B0 /* Conversion Result Buffer Register 8 */
#define RESULT9 0x70B1 /* Conversion Result Buffer Register 9 */
#define RESULT10 0x70B2 /* Conversion Result Buffer Register 10 */
#define RESULT11 0x70B3 /* Conversion Result Buffer Register 11 */
#define RESULT12 0x70B4 /* Conversion Result Buffer Register 12 */
#define RESULT13 0x70B5 /* Conversion Result Buffer Register 13 */
#define RESULT14 0x70B6 /* Conversion Result Buffer Register 14 */
#define RESULT15 0x70B7 /* Conversion Result Buffer Register 15 */
#define CALIBRATION 0x70B8 /* Calibration result which is used to correct subsequent conversions */
/* Controller Area Network (CAN)*/
#define MDER 0x7100 /* Mailbox Direction/Enable Register */
#define TCR 0x7101 /* Transmission Control Register */
#define RCR 0x7102 /* Receive Control Register */
#define MCR 0x7103 /* Master Control Register */
#define BCR2 0x7104 /* Bit Configuration Register 2 */
#define BCR1 0x7105 /* Bit Configuration Register 1 */
#define ESR 0x7106 /* Error Status Register */
#define GSR 0x7107 /* Global Status Register */
#define CEC 0x7108 /* Transmit and Receive Error Counters */
#define CAN_IFR 0x7109 /* Interrupt Flag Register */
#define CAN_IMR 0x710A /* Interrupt Mask Register */
#define LAM0_H 0x710B /* Local Acceptance Mask (MBOX 0 and MBOX 1) */
#define LAM0_L 0x710C /* Local Acceptance Mask (MBOX 0 and MBOX 1) */
#define LAM1_H 0x710D /* Local Acceptance Mask (MBOX 2 and MBOX 3) */
#define LAM1_L 0x710E /* Local Acceptance Mask (MBOX 2 and MBOX 3) */
#define MSGID0L 0x7200 /* CAN Message ID for Mailbox 0 (lower 16 bits) */
#define MSGID0H 0x7201 /* CAN Message ID for Mailbox 0 (upper 16 bits) */
#define MSGCTRL0 0x7202 /* MBOX 0 RTR and DLC */
#define MBOX0A 0x7204 /* CAN 2 of 8 bytes of Mailbox 0 */
#define MBOX0B 0x7205 /* CAN 2 of 8 bytes of Mailbox 0 */
#define MBOX0C 0x7206 /* CAN 2 of 8 bytes of Mailbox 0 */
#define MBOX0D 0x7207 /* CAN 2 of 8 bytes of Mailbox 0 */
#define MSGID1L 0x7208 /* CAN Message ID for mailbox 1 (lower 16 bits) */
#define MSGID1H 0x7209 /* CAN Message ID for mailbox 1 (upper 16 bits) */
#define MSGCTRL1 0x720A /* MBOX 1 RTR and DLC */
#define MBOX1A 0x720C /* CAN 2 of 8 bytes of Mailbox 1 */
#define MBOX1B 0x720D /* CAN 2 of 8 bytes of Mailbox 1 */
#define MBOX1C 0x720E /* CAN 2 of 8 bytes of Mailbox 1 */
#define MBOX1D 0x720F /* CAN 2 of 8 bytes of Mailbox 1 */
#define MSGID2L 0x7210 /* CAN Message ID for mailbox 2 (lower 16 bits) */
#define MSGID2H 0x7211 /* CAN Message ID for mailbox 2 (upper 16 bits) */
#define MSGCTRL2 0x7212 /* MBOX 2 RTR and DLC */
#define MBOX2A 0x7214 /* CAN 2 of 8 bytes of Mailbox 2 */
#define MBOX2B 0x7215 /* CAN 2 of 8 bytes of Mailbox 2 */
#define MBOX2C 0x7216 /* CAN 2 of 8 bytes of Mailbox 2 */
#define MBOX2D 0x7217 /* CAN 2 of 8 bytes of Mailbox 2 */
#define MSGID3L 0x7218 /* CAN Message ID for Mailbox 3 (lower 16 bits) */
#define MSGID3H 0x7219 /* CAN Message ID for Mailbox 3 (upper 16 bits) */
#define MSGCTRL3 0x721A /* MBOX 3 RTR and DLC */
#define MBOX3A 0x721C /* CAN 2 of 8 bytes of Mailbox 3 */
#define MBOX3B 0x721D /* CAN 2 of 8 bytes of Mailbox 3 */
#define MBOX3C 0x721E /* CAN 2 of 8 bytes of Mailbox 3 */
#define MBOX3D 0x721F /* CAN 2 of 8 bytes of Mailbox 3 */
#define MSGID4L 0x7220 /* CAN Message ID for Mailbox 4 (lower 16 bits) */
#define MSGID4H 0x7221 /* CAN Message ID for Mailbox 4 (upper 16 bits) */
#define MSGCTRL4 0x7222 /* MBOX 4 RTR and DLC */
#define MBOX4A 0x7224 /* CAN 2 of 8 bytes of Mailbox 4 */
#define MBOX4B 0x7225 /* CAN 2 of 8 bytes of Mailbox 4 */
#define MBOX4C 0x7226 /* CAN 2 of 8 bytes of Mailbox 4 */
#define MBOX4D 0x7227 /* CAN 2 of 8 bytes of Mailbox 4 */
#define MSGID5L 0x7228 /* CAN Message ID for Mailbox 5 (lower 16 bits) */
#define MSGID5H 0x7229 /* CAN Message ID for Mailbox 5 (upper 16 bits) */
#define MSGCTRL5 0x722A /* MBOX 5 RTR and DLC */
#define MBOX5A 0x722C /* CAN 2 of 8 bytes of Mailbox 5 */
#define MBOX5B 0x722D /* CAN 2 of 8 bytes of Mailbox 5 */
#define MBOX5C 0x722E /* CAN 2 of 8 bytes of Mailbox 5 */
#define MBOX5D 0x722F /* CAN 2 of 8 bytes of Mailbox 5 */
/* Event Manager A (EVA) : GP Timer Control Register*/
#define GPTCONA 0x7400 /* GP Timer Control Register A */
#define T1CNT 0x7401 /* Timer 1 Counter Register */
#define T1CMPR 0x7402 /* Timer 1 Compare Register */
#define T1PR 0x7403 /* Timer 1 Period Register */
#define T1CON 0x7404 /* Timer 1 Control Register */
#define T2CNT 0x7405 /* Timer 2 Counter Register */
#define T2CMPR 0x7406 /* Timer 2 Compare Register */
#define T2PR 0x7407 /* Timer 2 Period Register */
#define T2CON 0x7408 /* Timer 2 Control Register */
/* Event Manager A (EVA) : Compare Control Register*/
#define COMCONA 0x7411 /* Compare Control Register A */
#define ACTRA 0x7413 /* Compare Action Control Register A */
#define DBTCONA 0x7415 /* Dead-Band Timer Control Register A */
#define CMPR1 0x7417 /* Compare Register 1 */
#define CMPR2 0x7418 /* Compare Register 2 */
#define CMPR3 0x7419 /* Compare Register 3 */
/* Event Manager A (EVA) : Capture Control Register*/
#define CAPCONA 0x7420 /* Capture Control Register A */
#define CAPFIFOA 0x7422 /* Capture FIFO Status Register A */
#define CAP1FIFO 0x7423 /* Two-Level-Deep Capture FIFO stack 1 */
#define CAP2FIFO 0x7424 /* Two-Level-Deep Capture FIFO stack 2 */
#define CAP3FIFO 0x7425 /* Two-Level-Deep Capture FIFO stack 3 */
#define CAP1FBOT 0x7427 /* Bottom Register of Capture FIFO stack 1 */
#define CAP2FBOT 0x7428 /* Bottom Register of Capture FIFO stack 2 */
#define CAP3FBOT 0x7429 /* Bottom Register of Capture FIFO stack 3 */
/* EVA Interrupt Mask Register A */
#define EVAIMRA 0x742C /* EVA Interrupt Mask Register A */
#define EVAIMRB 0x742D /* EVA Interrupt Mask Register B */
#define EVAIMRC 0x742E /* EVA Interrupt Mask Register C */
#define EVAIFRA 0x742F /* EVA Interrupt Flag Register A */
#define EVAIFRB 0x7430 /* EVA Interrupt Flag Register B */
#define EVAIFRC 0x7431 /* EVA Interrupt Flag Register C */
/* Event Manager B (EVB) : GP Timer Control Register*/
#define GPTCONB 0x7500 /* GP Timer Control Register B */
#define T3CNT 0x7501 /* Timer 3 Counter Register */
#define T3CMPR 0x7502 /* Timer 3 Compare Register */
#define T3PR 0x7503 /* Timer 3 Period Register */
#define T3CON 0x7504 /* Timer 3 Control Register */
#define T4CNT 0x7505 /* Timer 4 Counter Register */
#define T4CMPR 0x7506 /* Timer 4 Compare Register */
#define T4PR 0x7507 /* Timer 4 Period Register */
#define T4CON 0x7508 /* Timer 4 Control Register */
/* Event Manager B (EVB) : Compare Control Register*/
#define COMCONB 0x7511 /* Compare Control Register B */
#define ACTRB 0x7513 /* Compare Action Control Register B */
#define DBTCONB 0x7515 /* Dead-Band Timer Control Register B */
#define CMPR4 0x7517 /* Compare Register 4 */
#define CMPR5 0x7518 /* Compare Register 5 */
#define CMPR6 0x7519 /* Compare Register 6 */
/* Event Manager B (EVB) : Capture Control Register*/
#define CAPCONB 0x7520 /* Capture Control Register B */
#define CAPFIFOB 0x7522 /* Capture FIFO Status Register B */
#define CAP4FIFO 0x7523 /* Two-Level-Deep Capture FIFO stack 4 */
#define CAP5FIFO 0x7524 /* Two-Level-Deep Capture FIFO stack 5 */
#define CAP6FIFO 0x7525 /* Two-Level-Deep Capture FIFO stack 6 */
#define CAP4FBOT 0x7527 /* Bottom Register of Capture FIFO stack 4 */
#define CAP5FBOT 0x7528 /* Bottom Register of Capture FIFO stack 5 */
#define CAP6FBOT 0x7529 /* Bottom Register of Capture FIFO stack 6 */
/* EVB Interrupt Mask Register B */
#define EVBIMRA 0x752C /* EVB Interrupt Mask Register A */
#define EVBIMRB 0x752D /* EVB Interrupt Mask Register B */
#define EVBIMRC 0x752E /* EVB Interrupt Mask Register C */
#define EVBIFRA 0x752F /* EVB Interrupt Flag Register A */
#define EVBIFRB 0x7530 /* EVB Interrupt Flag Register B */
#define EVBIFRC 0x7531 /* EVB Interrupt Flag Register C */

#define FCMR 0xFF0F /* Flash Control Mode Register */
#define WSGR 0xFFFF /* Wait State Generator Register */

/* define constant value */
#define AllBitHi 0xFFFF
#define AllBitLo 0x0000
#define Bit0Hi 0x0001
#define Bit1Hi 0x0002
#define Bit2Hi 0x0004
#define Bit3Hi 0x0008
#define Bit4Hi 0x0010
#define Bit5Hi 0x0020
#define Bit6Hi 0x0040
#define Bit7Hi 0x0080
#define Bit8Hi 0x0100
#define Bit9Hi 0x0200          
#define Bit10Hi 0x0400
#define Bit11Hi 0x0800
#define Bit12Hi 0x1000
#define Bit13Hi 0x2000
#define Bit14Hi 0x4000
#define Bit15Hi 0x8000
#define Bit0Lo 0xFFFE        
#define Bit1Lo 0xFFFD 
#define Bit2Lo 0xFFFB 
#define Bit3Lo 0xFFF7 
#define Bit4Lo 0xFFEF 
#define Bit5Lo 0xFFDF 
#define Bit6Lo 0xFFBF 
#define Bit7Lo 0xFF7F 
#define Bit8Lo 0xFEFF 
#define Bit9Lo 0xFDFF 
#define Bit10Lo 0xFBFF 
#define Bit11Lo 0xF7FF 
#define Bit12Lo 0xEFFF 
#define Bit13Lo 0xDFFF 
#define Bit14Lo 0xBFFF 
#define Bit15Lo 0x7FFF 

/* #define SCSR 0xFFFF */
extern volatile unsigned int *MMREGS;