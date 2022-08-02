/*
 * File: xc164cs_can.h
 *
 * Abstract:
 *    TwinCAN header definitions (provided on Infineon XC167CI Starter Kit CD)
 *
 * $Revision: 1.1.6.1 $
 * $Date: 2003/07/31 18:03:08 $
 */

#ifndef _XC164_CAN
#define _XC164_CAN

#define CAN_ABTRH              (*((uword volatile far *) 0x20020E))
#define CAN_ABTRH_LBM                      ((T_Reg16 *) 0x20020E)->bit0

#define CAN_ABTRL              (*((uword volatile far *) 0x20020C))
#define CAN_ABTRL_DIV8X                    ((T_Reg16 *) 0x20020C)->bit15

#define CAN_ACR                (*((uword volatile far *) 0x200200))
#define CAN_ACR_CALM                     ((T_Reg16 *) 0x200200)->bit7
#define CAN_ACR_CCE                      ((T_Reg16 *) 0x200200)->bit6
#define CAN_ACR_EIE                      ((T_Reg16 *) 0x200200)->bit3
#define CAN_ACR_INIT                     ((T_Reg16 *) 0x200200)->bit0
#define CAN_ACR_LECIE                    ((T_Reg16 *) 0x200200)->bit4
#define CAN_ACR_SIE                      ((T_Reg16 *) 0x200200)->bit2

#define CAN_AECNTH             (*((uword volatile far *) 0x200222))
#define CAN_AECNTH_LEINC                    ((T_Reg16 *) 0x200222)->bit9
#define CAN_AECNTH_LETD                     ((T_Reg16 *) 0x200222)->bit8

#define CAN_AECNTL             (*((uword volatile far *) 0x200220))

#define CAN_AFCRH              (*((uword volatile far *) 0x200216))
#define CAN_AFCRH_CFCIE                    ((T_Reg16 *) 0x200216)->bit6
#define CAN_AFCRH_CFCOV                    ((T_Reg16 *) 0x200216)->bit7

#define CAN_AFCRL              (*((uword volatile far *) 0x200214))

#define CAN_AGINP              (*((uword volatile far *) 0x200210))

#define CAN_AIMR4              (*((uword volatile far *) 0x20021C))
#define CAN_AIMR4_IMC32                    ((T_Reg16 *) 0x20021C)->bit0
#define CAN_AIMR4_IMC33                    ((T_Reg16 *) 0x20021C)->bit1
#define CAN_AIMR4_IMC34                    ((T_Reg16 *) 0x20021C)->bit2

#define CAN_AIMRH0             (*((uword volatile far *) 0x20021A))
#define CAN_AIMRH0_IMC16                    ((T_Reg16 *) 0x20021A)->bit0
#define CAN_AIMRH0_IMC17                    ((T_Reg16 *) 0x20021A)->bit1
#define CAN_AIMRH0_IMC18                    ((T_Reg16 *) 0x20021A)->bit2
#define CAN_AIMRH0_IMC19                    ((T_Reg16 *) 0x20021A)->bit3
#define CAN_AIMRH0_IMC20                    ((T_Reg16 *) 0x20021A)->bit4
#define CAN_AIMRH0_IMC21                    ((T_Reg16 *) 0x20021A)->bit5
#define CAN_AIMRH0_IMC22                    ((T_Reg16 *) 0x20021A)->bit6
#define CAN_AIMRH0_IMC23                    ((T_Reg16 *) 0x20021A)->bit7
#define CAN_AIMRH0_IMC24                    ((T_Reg16 *) 0x20021A)->bit8
#define CAN_AIMRH0_IMC25                    ((T_Reg16 *) 0x20021A)->bit9
#define CAN_AIMRH0_IMC26                    ((T_Reg16 *) 0x20021A)->bit10
#define CAN_AIMRH0_IMC27                    ((T_Reg16 *) 0x20021A)->bit11
#define CAN_AIMRH0_IMC28                    ((T_Reg16 *) 0x20021A)->bit12
#define CAN_AIMRH0_IMC29                    ((T_Reg16 *) 0x20021A)->bit13
#define CAN_AIMRH0_IMC30                    ((T_Reg16 *) 0x20021A)->bit14
#define CAN_AIMRH0_IMC31                    ((T_Reg16 *) 0x20021A)->bit15

#define CAN_AIMRL0             (*((uword volatile far *) 0x200218))
#define CAN_AIMRL0_IMC0                     ((T_Reg16 *) 0x200218)->bit0
#define CAN_AIMRL0_IMC1                     ((T_Reg16 *) 0x200218)->bit1
#define CAN_AIMRL0_IMC10                    ((T_Reg16 *) 0x200218)->bit10
#define CAN_AIMRL0_IMC11                    ((T_Reg16 *) 0x200218)->bit11
#define CAN_AIMRL0_IMC12                    ((T_Reg16 *) 0x200218)->bit12
#define CAN_AIMRL0_IMC13                    ((T_Reg16 *) 0x200218)->bit13
#define CAN_AIMRL0_IMC14                    ((T_Reg16 *) 0x200218)->bit14
#define CAN_AIMRL0_IMC15                    ((T_Reg16 *) 0x200218)->bit15
#define CAN_AIMRL0_IMC2                     ((T_Reg16 *) 0x200218)->bit2
#define CAN_AIMRL0_IMC3                     ((T_Reg16 *) 0x200218)->bit3
#define CAN_AIMRL0_IMC4                     ((T_Reg16 *) 0x200218)->bit4
#define CAN_AIMRL0_IMC5                     ((T_Reg16 *) 0x200218)->bit5
#define CAN_AIMRL0_IMC6                     ((T_Reg16 *) 0x200218)->bit6
#define CAN_AIMRL0_IMC7                     ((T_Reg16 *) 0x200218)->bit7
#define CAN_AIMRL0_IMC8                     ((T_Reg16 *) 0x200218)->bit8
#define CAN_AIMRL0_IMC9                     ((T_Reg16 *) 0x200218)->bit9

#define CAN_AIR                (*((uword volatile far *) 0x200208))

#define CAN_ASR                (*((uword volatile far *) 0x200204))
#define CAN_ASR_BOFF                     ((T_Reg16 *) 0x200204)->bit7
#define CAN_ASR_EWRN                     ((T_Reg16 *) 0x200204)->bit6
#define CAN_ASR_RXOK                     ((T_Reg16 *) 0x200204)->bit4
#define CAN_ASR_TXOK                     ((T_Reg16 *) 0x200204)->bit3

#define CAN_BBTRH              (*((uword volatile far *) 0x20024E))
#define CAN_BBTRH_LBM                      ((T_Reg16 *) 0x20024E)->bit0

#define CAN_BBTRL              (*((uword volatile far *) 0x20024C))
#define CAN_BBTRL_DIV8X                    ((T_Reg16 *) 0x20024C)->bit15

#define CAN_BCR                (*((uword volatile far *) 0x200240))
#define CAN_BCR_CALM                     ((T_Reg16 *) 0x200240)->bit7
#define CAN_BCR_CCE                      ((T_Reg16 *) 0x200240)->bit6
#define CAN_BCR_EIE                      ((T_Reg16 *) 0x200240)->bit3
#define CAN_BCR_INIT                     ((T_Reg16 *) 0x200240)->bit0
#define CAN_BCR_LECIE                    ((T_Reg16 *) 0x200240)->bit4
#define CAN_BCR_SIE                      ((T_Reg16 *) 0x200240)->bit2

#define CAN_BECNTH             (*((uword volatile far *) 0x200262))
#define CAN_BECNTH_LEINC                    ((T_Reg16 *) 0x200262)->bit9
#define CAN_BECNTH_LETD                     ((T_Reg16 *) 0x200262)->bit8

#define CAN_BECNTL             (*((uword volatile far *) 0x200260))

#define CAN_BFCRH              (*((uword volatile far *) 0x200256))
#define CAN_BFCRH_CFCIE                    ((T_Reg16 *) 0x200256)->bit6
#define CAN_BFCRH_CFCOV                    ((T_Reg16 *) 0x200256)->bit7

#define CAN_BFCRL              (*((uword volatile far *) 0x200254))

#define CAN_BGINP              (*((uword volatile far *) 0x200250))

#define CAN_BIMR4              (*((uword volatile far *) 0x20025C))
#define CAN_BIMR4_IMC32                    ((T_Reg16 *) 0x20025C)->bit0
#define CAN_BIMR4_IMC33                    ((T_Reg16 *) 0x20025C)->bit1
#define CAN_BIMR4_IMC34                    ((T_Reg16 *) 0x20025C)->bit2

#define CAN_BIMRH0             (*((uword volatile far *) 0x20025A))
#define CAN_BIMRH0_IMC16                    ((T_Reg16 *) 0x20025A)->bit0
#define CAN_BIMRH0_IMC17                    ((T_Reg16 *) 0x20025A)->bit1
#define CAN_BIMRH0_IMC18                    ((T_Reg16 *) 0x20025A)->bit2
#define CAN_BIMRH0_IMC19                    ((T_Reg16 *) 0x20025A)->bit3
#define CAN_BIMRH0_IMC20                    ((T_Reg16 *) 0x20025A)->bit4
#define CAN_BIMRH0_IMC21                    ((T_Reg16 *) 0x20025A)->bit5
#define CAN_BIMRH0_IMC22                    ((T_Reg16 *) 0x20025A)->bit6
#define CAN_BIMRH0_IMC23                    ((T_Reg16 *) 0x20025A)->bit7
#define CAN_BIMRH0_IMC24                    ((T_Reg16 *) 0x20025A)->bit8
#define CAN_BIMRH0_IMC25                    ((T_Reg16 *) 0x20025A)->bit9
#define CAN_BIMRH0_IMC26                    ((T_Reg16 *) 0x20025A)->bit10
#define CAN_BIMRH0_IMC27                    ((T_Reg16 *) 0x20025A)->bit11
#define CAN_BIMRH0_IMC28                    ((T_Reg16 *) 0x20025A)->bit12
#define CAN_BIMRH0_IMC29                    ((T_Reg16 *) 0x20025A)->bit13
#define CAN_BIMRH0_IMC30                    ((T_Reg16 *) 0x20025A)->bit14
#define CAN_BIMRH0_IMC31                    ((T_Reg16 *) 0x20025A)->bit15

#define CAN_BIMRL0             (*((uword volatile far *) 0x200258))
#define CAN_BIMRL0_IMC0                     ((T_Reg16 *) 0x200258)->bit0
#define CAN_BIMRL0_IMC1                     ((T_Reg16 *) 0x200258)->bit1
#define CAN_BIMRL0_IMC10                    ((T_Reg16 *) 0x200258)->bit10
#define CAN_BIMRL0_IMC11                    ((T_Reg16 *) 0x200258)->bit11
#define CAN_BIMRL0_IMC12                    ((T_Reg16 *) 0x200258)->bit12
#define CAN_BIMRL0_IMC13                    ((T_Reg16 *) 0x200258)->bit13
#define CAN_BIMRL0_IMC14                    ((T_Reg16 *) 0x200258)->bit14
#define CAN_BIMRL0_IMC15                    ((T_Reg16 *) 0x200258)->bit15
#define CAN_BIMRL0_IMC2                     ((T_Reg16 *) 0x200258)->bit2
#define CAN_BIMRL0_IMC3                     ((T_Reg16 *) 0x200258)->bit3
#define CAN_BIMRL0_IMC4                     ((T_Reg16 *) 0x200258)->bit4
#define CAN_BIMRL0_IMC5                     ((T_Reg16 *) 0x200258)->bit5
#define CAN_BIMRL0_IMC6                     ((T_Reg16 *) 0x200258)->bit6
#define CAN_BIMRL0_IMC7                     ((T_Reg16 *) 0x200258)->bit7
#define CAN_BIMRL0_IMC8                     ((T_Reg16 *) 0x200258)->bit8
#define CAN_BIMRL0_IMC9                     ((T_Reg16 *) 0x200258)->bit9

#define CAN_BIR                (*((uword volatile far *) 0x200248))

#define CAN_BSR                (*((uword volatile far *) 0x200244))
#define CAN_BSR_BOFF                     ((T_Reg16 *) 0x200244)->bit7
#define CAN_BSR_EWRN                     ((T_Reg16 *) 0x200244)->bit6
#define CAN_BSR_RXOK                     ((T_Reg16 *) 0x200244)->bit4
#define CAN_BSR_TXOK                     ((T_Reg16 *) 0x200244)->bit3

#define CAN_MSGAMRH0           (*((uword volatile far *) 0x20030E))

#define CAN_MSGAMRH1           (*((uword volatile far *) 0x20032E))

#define CAN_MSGAMRH10          (*((uword volatile far *) 0x20044E))

#define CAN_MSGAMRH11          (*((uword volatile far *) 0x20046E))

#define CAN_MSGAMRH12          (*((uword volatile far *) 0x20048E))

#define CAN_MSGAMRH13          (*((uword volatile far *) 0x2004AE))

#define CAN_MSGAMRH14          (*((uword volatile far *) 0x2004CE))

#define CAN_MSGAMRH15          (*((uword volatile far *) 0x2004EE))

#define CAN_MSGAMRH16          (*((uword volatile far *) 0x20050E))

#define CAN_MSGAMRH17          (*((uword volatile far *) 0x20052E))

#define CAN_MSGAMRH18          (*((uword volatile far *) 0x20054E))

#define CAN_MSGAMRH19          (*((uword volatile far *) 0x20056E))

#define CAN_MSGAMRH2           (*((uword volatile far *) 0x20034E))

#define CAN_MSGAMRH20          (*((uword volatile far *) 0x20058E))

#define CAN_MSGAMRH21          (*((uword volatile far *) 0x2005AE))

#define CAN_MSGAMRH22          (*((uword volatile far *) 0x2005CE))

#define CAN_MSGAMRH23          (*((uword volatile far *) 0x2005EE))

#define CAN_MSGAMRH24          (*((uword volatile far *) 0x20060E))

#define CAN_MSGAMRH25          (*((uword volatile far *) 0x20062E))

#define CAN_MSGAMRH26          (*((uword volatile far *) 0x20064E))

#define CAN_MSGAMRH27          (*((uword volatile far *) 0x20066E))

#define CAN_MSGAMRH28          (*((uword volatile far *) 0x20068E))

#define CAN_MSGAMRH29          (*((uword volatile far *) 0x2006AE))

#define CAN_MSGAMRH3           (*((uword volatile far *) 0x20036E))

#define CAN_MSGAMRH30          (*((uword volatile far *) 0x2006CE))

#define CAN_MSGAMRH31          (*((uword volatile far *) 0x2006EE))

#define CAN_MSGAMRH4           (*((uword volatile far *) 0x20038E))

#define CAN_MSGAMRH5           (*((uword volatile far *) 0x2003AE))

#define CAN_MSGAMRH6           (*((uword volatile far *) 0x2003CE))

#define CAN_MSGAMRH7           (*((uword volatile far *) 0x2003EE))

#define CAN_MSGAMRH8           (*((uword volatile far *) 0x20040E))

#define CAN_MSGAMRH9           (*((uword volatile far *) 0x20042E))

#define CAN_MSGAMRL0           (*((uword volatile far *) 0x20030C))

#define CAN_MSGAMRL1           (*((uword volatile far *) 0x20032C))

#define CAN_MSGAMRL10          (*((uword volatile far *) 0x20044C))

#define CAN_MSGAMRL11          (*((uword volatile far *) 0x20046C))

#define CAN_MSGAMRL12          (*((uword volatile far *) 0x20048C))

#define CAN_MSGAMRL13          (*((uword volatile far *) 0x2004AC))

#define CAN_MSGAMRL14          (*((uword volatile far *) 0x2004CC))

#define CAN_MSGAMRL15          (*((uword volatile far *) 0x2004EC))

#define CAN_MSGAMRL16          (*((uword volatile far *) 0x20050C))

#define CAN_MSGAMRL17          (*((uword volatile far *) 0x20052C))

#define CAN_MSGAMRL18          (*((uword volatile far *) 0x20054C))

#define CAN_MSGAMRL19          (*((uword volatile far *) 0x20056C))

#define CAN_MSGAMRL2           (*((uword volatile far *) 0x20034C))

#define CAN_MSGAMRL20          (*((uword volatile far *) 0x20058C))

#define CAN_MSGAMRL21          (*((uword volatile far *) 0x2005AC))

#define CAN_MSGAMRL22          (*((uword volatile far *) 0x2005CC))

#define CAN_MSGAMRL23          (*((uword volatile far *) 0x2005EC))

#define CAN_MSGAMRL24          (*((uword volatile far *) 0x20060C))

#define CAN_MSGAMRL25          (*((uword volatile far *) 0x20062C))

#define CAN_MSGAMRL26          (*((uword volatile far *) 0x20064C))

#define CAN_MSGAMRL27          (*((uword volatile far *) 0x20066C))

#define CAN_MSGAMRL28          (*((uword volatile far *) 0x20068C))

#define CAN_MSGAMRL29          (*((uword volatile far *) 0x2006AC))

#define CAN_MSGAMRL3           (*((uword volatile far *) 0x20036C))

#define CAN_MSGAMRL30          (*((uword volatile far *) 0x2006CC))

#define CAN_MSGAMRL31          (*((uword volatile far *) 0x2006EC))

#define CAN_MSGAMRL4           (*((uword volatile far *) 0x20038C))

#define CAN_MSGAMRL5           (*((uword volatile far *) 0x2003AC))

#define CAN_MSGAMRL6           (*((uword volatile far *) 0x2003CC))

#define CAN_MSGAMRL7           (*((uword volatile far *) 0x2003EC))

#define CAN_MSGAMRL8           (*((uword volatile far *) 0x20040C))

#define CAN_MSGAMRL9           (*((uword volatile far *) 0x20042C))

#define CAN_MSGARH0            (*((uword volatile far *) 0x20030A))

#define CAN_MSGARH1            (*((uword volatile far *) 0x20032A))

#define CAN_MSGARH10           (*((uword volatile far *) 0x20044A))

#define CAN_MSGARH11           (*((uword volatile far *) 0x20046A))

#define CAN_MSGARH12           (*((uword volatile far *) 0x20048A))

#define CAN_MSGARH13           (*((uword volatile far *) 0x2004AA))

#define CAN_MSGARH14           (*((uword volatile far *) 0x2004CA))

#define CAN_MSGARH15           (*((uword volatile far *) 0x2004EA))

#define CAN_MSGARH16           (*((uword volatile far *) 0x20050A))

#define CAN_MSGARH17           (*((uword volatile far *) 0x20052A))

#define CAN_MSGARH18           (*((uword volatile far *) 0x20054A))

#define CAN_MSGARH19           (*((uword volatile far *) 0x20056A))

#define CAN_MSGARH2            (*((uword volatile far *) 0x20034A))

#define CAN_MSGARH20           (*((uword volatile far *) 0x20058A))

#define CAN_MSGARH21           (*((uword volatile far *) 0x2005AA))

#define CAN_MSGARH22           (*((uword volatile far *) 0x2005CA))

#define CAN_MSGARH23           (*((uword volatile far *) 0x2005EA))

#define CAN_MSGARH24           (*((uword volatile far *) 0x20060A))

#define CAN_MSGARH25           (*((uword volatile far *) 0x20062A))

#define CAN_MSGARH26           (*((uword volatile far *) 0x20064A))

#define CAN_MSGARH27           (*((uword volatile far *) 0x20066A))

#define CAN_MSGARH28           (*((uword volatile far *) 0x20068A))

#define CAN_MSGARH29           (*((uword volatile far *) 0x2006AA))

#define CAN_MSGARH3            (*((uword volatile far *) 0x20036A))

#define CAN_MSGARH30           (*((uword volatile far *) 0x2006CA))

#define CAN_MSGARH31           (*((uword volatile far *) 0x2006EA))

#define CAN_MSGARH4            (*((uword volatile far *) 0x20038A))

#define CAN_MSGARH5            (*((uword volatile far *) 0x2003AA))

#define CAN_MSGARH6            (*((uword volatile far *) 0x2003CA))

#define CAN_MSGARH7            (*((uword volatile far *) 0x2003EA))

#define CAN_MSGARH8            (*((uword volatile far *) 0x20040A))

#define CAN_MSGARH9            (*((uword volatile far *) 0x20042A))

#define CAN_MSGARL0            (*((uword volatile far *) 0x200308))

#define CAN_MSGARL1            (*((uword volatile far *) 0x200328))

#define CAN_MSGARL10           (*((uword volatile far *) 0x200448))

#define CAN_MSGARL11           (*((uword volatile far *) 0x200468))

#define CAN_MSGARL12           (*((uword volatile far *) 0x200488))

#define CAN_MSGARL13           (*((uword volatile far *) 0x2004A8))

#define CAN_MSGARL14           (*((uword volatile far *) 0x2004C8))

#define CAN_MSGARL15           (*((uword volatile far *) 0x2004E8))

#define CAN_MSGARL16           (*((uword volatile far *) 0x200508))

#define CAN_MSGARL17           (*((uword volatile far *) 0x200528))

#define CAN_MSGARL18           (*((uword volatile far *) 0x200548))

#define CAN_MSGARL19           (*((uword volatile far *) 0x200568))

#define CAN_MSGARL2            (*((uword volatile far *) 0x200348))

#define CAN_MSGARL20           (*((uword volatile far *) 0x200588))

#define CAN_MSGARL21           (*((uword volatile far *) 0x2005A8))

#define CAN_MSGARL22           (*((uword volatile far *) 0x2005C8))

#define CAN_MSGARL23           (*((uword volatile far *) 0x2005E8))

#define CAN_MSGARL24           (*((uword volatile far *) 0x200608))

#define CAN_MSGARL25           (*((uword volatile far *) 0x200628))

#define CAN_MSGARL26           (*((uword volatile far *) 0x200648))

#define CAN_MSGARL27           (*((uword volatile far *) 0x200668))

#define CAN_MSGARL28           (*((uword volatile far *) 0x200688))

#define CAN_MSGARL29           (*((uword volatile far *) 0x2006A8))

#define CAN_MSGARL3            (*((uword volatile far *) 0x200368))

#define CAN_MSGARL30           (*((uword volatile far *) 0x2006C8))

#define CAN_MSGARL31           (*((uword volatile far *) 0x2006E8))

#define CAN_MSGARL4            (*((uword volatile far *) 0x200388))

#define CAN_MSGARL5            (*((uword volatile far *) 0x2003A8))

#define CAN_MSGARL6            (*((uword volatile far *) 0x2003C8))

#define CAN_MSGARL7            (*((uword volatile far *) 0x2003E8))

#define CAN_MSGARL8            (*((uword volatile far *) 0x200408))

#define CAN_MSGARL9            (*((uword volatile far *) 0x200428))

#define CAN_MSGCFGH0           (*((uword volatile far *) 0x200316))

#define CAN_MSGCFGH1           (*((uword volatile far *) 0x200336))

#define CAN_MSGCFGH10          (*((uword volatile far *) 0x200456))

#define CAN_MSGCFGH11          (*((uword volatile far *) 0x200476))

#define CAN_MSGCFGH12          (*((uword volatile far *) 0x200496))

#define CAN_MSGCFGH13          (*((uword volatile far *) 0x2004B6))

#define CAN_MSGCFGH14          (*((uword volatile far *) 0x2004D6))

#define CAN_MSGCFGH15          (*((uword volatile far *) 0x2004F6))

#define CAN_MSGCFGH16          (*((uword volatile far *) 0x200516))

#define CAN_MSGCFGH17          (*((uword volatile far *) 0x200536))

#define CAN_MSGCFGH18          (*((uword volatile far *) 0x200556))

#define CAN_MSGCFGH19          (*((uword volatile far *) 0x200576))

#define CAN_MSGCFGH2           (*((uword volatile far *) 0x200356))

#define CAN_MSGCFGH20          (*((uword volatile far *) 0x200596))

#define CAN_MSGCFGH21          (*((uword volatile far *) 0x2005B6))

#define CAN_MSGCFGH22          (*((uword volatile far *) 0x2005D6))

#define CAN_MSGCFGH23          (*((uword volatile far *) 0x2005F6))

#define CAN_MSGCFGH24          (*((uword volatile far *) 0x200616))

#define CAN_MSGCFGH25          (*((uword volatile far *) 0x200636))

#define CAN_MSGCFGH26          (*((uword volatile far *) 0x200656))

#define CAN_MSGCFGH27          (*((uword volatile far *) 0x200676))

#define CAN_MSGCFGH28          (*((uword volatile far *) 0x200696))

#define CAN_MSGCFGH29          (*((uword volatile far *) 0x2006B6))

#define CAN_MSGCFGH3           (*((uword volatile far *) 0x200376))

#define CAN_MSGCFGH30          (*((uword volatile far *) 0x2006D6))

#define CAN_MSGCFGH31          (*((uword volatile far *) 0x2006F6))

#define CAN_MSGCFGH4           (*((uword volatile far *) 0x200396))

#define CAN_MSGCFGH5           (*((uword volatile far *) 0x2003B6))

#define CAN_MSGCFGH6           (*((uword volatile far *) 0x2003D6))

#define CAN_MSGCFGH7           (*((uword volatile far *) 0x2003F6))

#define CAN_MSGCFGH8           (*((uword volatile far *) 0x200416))

#define CAN_MSGCFGH9           (*((uword volatile far *) 0x200436))

#define CAN_MSGCFGL0           (*((uword volatile far *) 0x200314))
#define CAN_MSGCFGL0_DIR                      ((T_Reg16 *) 0x200314)->bit3
#define CAN_MSGCFGL0_NODE                     ((T_Reg16 *) 0x200314)->bit1
#define CAN_MSGCFGL0_RMM                      ((T_Reg16 *) 0x200314)->bit0
#define CAN_MSGCFGL0_XTD                      ((T_Reg16 *) 0x200314)->bit2

#define CAN_MSGCFGL1           (*((uword volatile far *) 0x200334))
#define CAN_MSGCFGL1_DIR                      ((T_Reg16 *) 0x200334)->bit3
#define CAN_MSGCFGL1_NODE                     ((T_Reg16 *) 0x200334)->bit1
#define CAN_MSGCFGL1_RMM                      ((T_Reg16 *) 0x200334)->bit0
#define CAN_MSGCFGL1_XTD                      ((T_Reg16 *) 0x200334)->bit2

#define CAN_MSGCFGL10          (*((uword volatile far *) 0x200454))
#define CAN_MSGCFGL10_DIR                      ((T_Reg16 *) 0x200454)->bit3
#define CAN_MSGCFGL10_NODE                     ((T_Reg16 *) 0x200454)->bit1
#define CAN_MSGCFGL10_RMM                      ((T_Reg16 *) 0x200454)->bit0
#define CAN_MSGCFGL10_XTD                      ((T_Reg16 *) 0x200454)->bit2

#define CAN_MSGCFGL11          (*((uword volatile far *) 0x200474))
#define CAN_MSGCFGL11_DIR                      ((T_Reg16 *) 0x200474)->bit3
#define CAN_MSGCFGL11_NODE                     ((T_Reg16 *) 0x200474)->bit1
#define CAN_MSGCFGL11_RMM                      ((T_Reg16 *) 0x200474)->bit0
#define CAN_MSGCFGL11_XTD                      ((T_Reg16 *) 0x200474)->bit2

#define CAN_MSGCFGL12          (*((uword volatile far *) 0x200494))
#define CAN_MSGCFGL12_DIR                      ((T_Reg16 *) 0x200494)->bit3
#define CAN_MSGCFGL12_NODE                     ((T_Reg16 *) 0x200494)->bit1
#define CAN_MSGCFGL12_RMM                      ((T_Reg16 *) 0x200494)->bit0
#define CAN_MSGCFGL12_XTD                      ((T_Reg16 *) 0x200494)->bit2

#define CAN_MSGCFGL13          (*((uword volatile far *) 0x2004B4))
#define CAN_MSGCFGL13_DIR                      ((T_Reg16 *) 0x2004B4)->bit3
#define CAN_MSGCFGL13_NODE                     ((T_Reg16 *) 0x2004B4)->bit1
#define CAN_MSGCFGL13_RMM                      ((T_Reg16 *) 0x2004B4)->bit0
#define CAN_MSGCFGL13_XTD                      ((T_Reg16 *) 0x2004B4)->bit2

#define CAN_MSGCFGL14          (*((uword volatile far *) 0x2004D4))
#define CAN_MSGCFGL14_DIR                      ((T_Reg16 *) 0x2004D4)->bit3
#define CAN_MSGCFGL14_NODE                     ((T_Reg16 *) 0x2004D4)->bit1
#define CAN_MSGCFGL14_RMM                      ((T_Reg16 *) 0x2004D4)->bit0
#define CAN_MSGCFGL14_XTD                      ((T_Reg16 *) 0x2004D4)->bit2

#define CAN_MSGCFGL15          (*((uword volatile far *) 0x2004F4))
#define CAN_MSGCFGL15_DIR                      ((T_Reg16 *) 0x2004F4)->bit3
#define CAN_MSGCFGL15_NODE                     ((T_Reg16 *) 0x2004F4)->bit1
#define CAN_MSGCFGL15_RMM                      ((T_Reg16 *) 0x2004F4)->bit0
#define CAN_MSGCFGL15_XTD                      ((T_Reg16 *) 0x2004F4)->bit2

#define CAN_MSGCFGL16          (*((uword volatile far *) 0x200514))
#define CAN_MSGCFGL16_DIR                      ((T_Reg16 *) 0x200514)->bit3
#define CAN_MSGCFGL16_NODE                     ((T_Reg16 *) 0x200514)->bit1
#define CAN_MSGCFGL16_RMM                      ((T_Reg16 *) 0x200514)->bit0
#define CAN_MSGCFGL16_XTD                      ((T_Reg16 *) 0x200514)->bit2

#define CAN_MSGCFGL17          (*((uword volatile far *) 0x200534))
#define CAN_MSGCFGL17_DIR                      ((T_Reg16 *) 0x200534)->bit3
#define CAN_MSGCFGL17_NODE                     ((T_Reg16 *) 0x200534)->bit1
#define CAN_MSGCFGL17_RMM                      ((T_Reg16 *) 0x200534)->bit0
#define CAN_MSGCFGL17_XTD                      ((T_Reg16 *) 0x200534)->bit2

#define CAN_MSGCFGL18          (*((uword volatile far *) 0x200554))
#define CAN_MSGCFGL18_DIR                      ((T_Reg16 *) 0x200554)->bit3
#define CAN_MSGCFGL18_NODE                     ((T_Reg16 *) 0x200554)->bit1
#define CAN_MSGCFGL18_RMM                      ((T_Reg16 *) 0x200554)->bit0
#define CAN_MSGCFGL18_XTD                      ((T_Reg16 *) 0x200554)->bit2

#define CAN_MSGCFGL19          (*((uword volatile far *) 0x200574))
#define CAN_MSGCFGL19_DIR                      ((T_Reg16 *) 0x200574)->bit3
#define CAN_MSGCFGL19_NODE                     ((T_Reg16 *) 0x200574)->bit1
#define CAN_MSGCFGL19_RMM                      ((T_Reg16 *) 0x200574)->bit0
#define CAN_MSGCFGL19_XTD                      ((T_Reg16 *) 0x200574)->bit2

#define CAN_MSGCFGL2           (*((uword volatile far *) 0x200354))
#define CAN_MSGCFGL2_DIR                      ((T_Reg16 *) 0x200354)->bit3
#define CAN_MSGCFGL2_NODE                     ((T_Reg16 *) 0x200354)->bit1
#define CAN_MSGCFGL2_RMM                      ((T_Reg16 *) 0x200354)->bit0
#define CAN_MSGCFGL2_XTD                      ((T_Reg16 *) 0x200354)->bit2

#define CAN_MSGCFGL20          (*((uword volatile far *) 0x200594))
#define CAN_MSGCFGL20_DIR                      ((T_Reg16 *) 0x200594)->bit3
#define CAN_MSGCFGL20_NODE                     ((T_Reg16 *) 0x200594)->bit1
#define CAN_MSGCFGL20_RMM                      ((T_Reg16 *) 0x200594)->bit0
#define CAN_MSGCFGL20_XTD                      ((T_Reg16 *) 0x200594)->bit2

#define CAN_MSGCFGL21          (*((uword volatile far *) 0x2005B4))
#define CAN_MSGCFGL21_DIR                      ((T_Reg16 *) 0x2005B4)->bit3
#define CAN_MSGCFGL21_NODE                     ((T_Reg16 *) 0x2005B4)->bit1
#define CAN_MSGCFGL21_RMM                      ((T_Reg16 *) 0x2005B4)->bit0
#define CAN_MSGCFGL21_XTD                      ((T_Reg16 *) 0x2005B4)->bit2

#define CAN_MSGCFGL22          (*((uword volatile far *) 0x2005D4))
#define CAN_MSGCFGL22_DIR                      ((T_Reg16 *) 0x2005D4)->bit3
#define CAN_MSGCFGL22_NODE                     ((T_Reg16 *) 0x2005D4)->bit1
#define CAN_MSGCFGL22_RMM                      ((T_Reg16 *) 0x2005D4)->bit0
#define CAN_MSGCFGL22_XTD                      ((T_Reg16 *) 0x2005D4)->bit2

#define CAN_MSGCFGL23          (*((uword volatile far *) 0x2005F4))
#define CAN_MSGCFGL23_DIR                      ((T_Reg16 *) 0x2005F4)->bit3
#define CAN_MSGCFGL23_NODE                     ((T_Reg16 *) 0x2005F4)->bit1
#define CAN_MSGCFGL23_RMM                      ((T_Reg16 *) 0x2005F4)->bit0
#define CAN_MSGCFGL23_XTD                      ((T_Reg16 *) 0x2005F4)->bit2

#define CAN_MSGCFGL24          (*((uword volatile far *) 0x200614))
#define CAN_MSGCFGL24_DIR                      ((T_Reg16 *) 0x200614)->bit3
#define CAN_MSGCFGL24_NODE                     ((T_Reg16 *) 0x200614)->bit1
#define CAN_MSGCFGL24_RMM                      ((T_Reg16 *) 0x200614)->bit0
#define CAN_MSGCFGL24_XTD                      ((T_Reg16 *) 0x200614)->bit2

#define CAN_MSGCFGL25          (*((uword volatile far *) 0x200634))
#define CAN_MSGCFGL25_DIR                      ((T_Reg16 *) 0x200634)->bit3
#define CAN_MSGCFGL25_NODE                     ((T_Reg16 *) 0x200634)->bit1
#define CAN_MSGCFGL25_RMM                      ((T_Reg16 *) 0x200634)->bit0
#define CAN_MSGCFGL25_XTD                      ((T_Reg16 *) 0x200634)->bit2

#define CAN_MSGCFGL26          (*((uword volatile far *) 0x200654))
#define CAN_MSGCFGL26_DIR                      ((T_Reg16 *) 0x200654)->bit3
#define CAN_MSGCFGL26_NODE                     ((T_Reg16 *) 0x200654)->bit1
#define CAN_MSGCFGL26_RMM                      ((T_Reg16 *) 0x200654)->bit0
#define CAN_MSGCFGL26_XTD                      ((T_Reg16 *) 0x200654)->bit2

#define CAN_MSGCFGL27          (*((uword volatile far *) 0x200674))
#define CAN_MSGCFGL27_DIR                      ((T_Reg16 *) 0x200674)->bit3
#define CAN_MSGCFGL27_NODE                     ((T_Reg16 *) 0x200674)->bit1
#define CAN_MSGCFGL27_RMM                      ((T_Reg16 *) 0x200674)->bit0
#define CAN_MSGCFGL27_XTD                      ((T_Reg16 *) 0x200674)->bit2

#define CAN_MSGCFGL28          (*((uword volatile far *) 0x200694))
#define CAN_MSGCFGL28_DIR                      ((T_Reg16 *) 0x200694)->bit3
#define CAN_MSGCFGL28_NODE                     ((T_Reg16 *) 0x200694)->bit1
#define CAN_MSGCFGL28_RMM                      ((T_Reg16 *) 0x200694)->bit0
#define CAN_MSGCFGL28_XTD                      ((T_Reg16 *) 0x200694)->bit2

#define CAN_MSGCFGL29          (*((uword volatile far *) 0x2006B4))
#define CAN_MSGCFGL29_DIR                      ((T_Reg16 *) 0x2006B4)->bit3
#define CAN_MSGCFGL29_NODE                     ((T_Reg16 *) 0x2006B4)->bit1
#define CAN_MSGCFGL29_RMM                      ((T_Reg16 *) 0x2006B4)->bit0
#define CAN_MSGCFGL29_XTD                      ((T_Reg16 *) 0x2006B4)->bit2

#define CAN_MSGCFGL3           (*((uword volatile far *) 0x200374))
#define CAN_MSGCFGL3_DIR                      ((T_Reg16 *) 0x200374)->bit3
#define CAN_MSGCFGL3_NODE                     ((T_Reg16 *) 0x200374)->bit1
#define CAN_MSGCFGL3_RMM                      ((T_Reg16 *) 0x200374)->bit0
#define CAN_MSGCFGL3_XTD                      ((T_Reg16 *) 0x200374)->bit2

#define CAN_MSGCFGL30          (*((uword volatile far *) 0x2006D4))
#define CAN_MSGCFGL30_DIR                      ((T_Reg16 *) 0x2006D4)->bit3
#define CAN_MSGCFGL30_NODE                     ((T_Reg16 *) 0x2006D4)->bit1
#define CAN_MSGCFGL30_RMM                      ((T_Reg16 *) 0x2006D4)->bit0
#define CAN_MSGCFGL30_XTD                      ((T_Reg16 *) 0x2006D4)->bit2

#define CAN_MSGCFGL31          (*((uword volatile far *) 0x2006F4))
#define CAN_MSGCFGL31_DIR                      ((T_Reg16 *) 0x2006F4)->bit3
#define CAN_MSGCFGL31_NODE                     ((T_Reg16 *) 0x2006F4)->bit1
#define CAN_MSGCFGL31_RMM                      ((T_Reg16 *) 0x2006F4)->bit0
#define CAN_MSGCFGL31_XTD                      ((T_Reg16 *) 0x2006F4)->bit2

#define CAN_MSGCFGL4           (*((uword volatile far *) 0x200394))
#define CAN_MSGCFGL4_DIR                      ((T_Reg16 *) 0x200394)->bit3
#define CAN_MSGCFGL4_NODE                     ((T_Reg16 *) 0x200394)->bit1
#define CAN_MSGCFGL4_RMM                      ((T_Reg16 *) 0x200394)->bit0
#define CAN_MSGCFGL4_XTD                      ((T_Reg16 *) 0x200394)->bit2

#define CAN_MSGCFGL5           (*((uword volatile far *) 0x2003B4))
#define CAN_MSGCFGL5_DIR                      ((T_Reg16 *) 0x2003B4)->bit3
#define CAN_MSGCFGL5_NODE                     ((T_Reg16 *) 0x2003B4)->bit1
#define CAN_MSGCFGL5_RMM                      ((T_Reg16 *) 0x2003B4)->bit0
#define CAN_MSGCFGL5_XTD                      ((T_Reg16 *) 0x2003B4)->bit2

#define CAN_MSGCFGL6           (*((uword volatile far *) 0x2003D4))
#define CAN_MSGCFGL6_DIR                      ((T_Reg16 *) 0x2003D4)->bit3
#define CAN_MSGCFGL6_NODE                     ((T_Reg16 *) 0x2003D4)->bit1
#define CAN_MSGCFGL6_RMM                      ((T_Reg16 *) 0x2003D4)->bit0
#define CAN_MSGCFGL6_XTD                      ((T_Reg16 *) 0x2003D4)->bit2

#define CAN_MSGCFGL7           (*((uword volatile far *) 0x2003F4))
#define CAN_MSGCFGL7_DIR                      ((T_Reg16 *) 0x2003F4)->bit3
#define CAN_MSGCFGL7_NODE                     ((T_Reg16 *) 0x2003F4)->bit1
#define CAN_MSGCFGL7_RMM                      ((T_Reg16 *) 0x2003F4)->bit0
#define CAN_MSGCFGL7_XTD                      ((T_Reg16 *) 0x2003F4)->bit2

#define CAN_MSGCFGL8           (*((uword volatile far *) 0x200414))
#define CAN_MSGCFGL8_DIR                      ((T_Reg16 *) 0x200414)->bit3
#define CAN_MSGCFGL8_NODE                     ((T_Reg16 *) 0x200414)->bit1
#define CAN_MSGCFGL8_RMM                      ((T_Reg16 *) 0x200414)->bit0
#define CAN_MSGCFGL8_XTD                      ((T_Reg16 *) 0x200414)->bit2

#define CAN_MSGCFGL9           (*((uword volatile far *) 0x200434))
#define CAN_MSGCFGL9_DIR                      ((T_Reg16 *) 0x200434)->bit3
#define CAN_MSGCFGL9_NODE                     ((T_Reg16 *) 0x200434)->bit1
#define CAN_MSGCFGL9_RMM                      ((T_Reg16 *) 0x200434)->bit0
#define CAN_MSGCFGL9_XTD                      ((T_Reg16 *) 0x200434)->bit2

#define CAN_MSGCTRH0           (*((uword volatile far *) 0x200312))

#define CAN_MSGCTRH1           (*((uword volatile far *) 0x200332))

#define CAN_MSGCTRH10          (*((uword volatile far *) 0x200452))

#define CAN_MSGCTRH11          (*((uword volatile far *) 0x200472))

#define CAN_MSGCTRH12          (*((uword volatile far *) 0x200492))

#define CAN_MSGCTRH13          (*((uword volatile far *) 0x2004B2))

#define CAN_MSGCTRH14          (*((uword volatile far *) 0x2004D2))

#define CAN_MSGCTRH15          (*((uword volatile far *) 0x2004F2))

#define CAN_MSGCTRH16          (*((uword volatile far *) 0x200512))

#define CAN_MSGCTRH17          (*((uword volatile far *) 0x200532))

#define CAN_MSGCTRH18          (*((uword volatile far *) 0x200552))

#define CAN_MSGCTRH19          (*((uword volatile far *) 0x200572))

#define CAN_MSGCTRH2           (*((uword volatile far *) 0x200352))

#define CAN_MSGCTRH20          (*((uword volatile far *) 0x200592))

#define CAN_MSGCTRH21          (*((uword volatile far *) 0x2005B2))

#define CAN_MSGCTRH22          (*((uword volatile far *) 0x2005D2))

#define CAN_MSGCTRH23          (*((uword volatile far *) 0x2005F2))

#define CAN_MSGCTRH24          (*((uword volatile far *) 0x200612))

#define CAN_MSGCTRH25          (*((uword volatile far *) 0x200632))

#define CAN_MSGCTRH26          (*((uword volatile far *) 0x200652))

#define CAN_MSGCTRH27          (*((uword volatile far *) 0x200672))

#define CAN_MSGCTRH28          (*((uword volatile far *) 0x200692))

#define CAN_MSGCTRH29          (*((uword volatile far *) 0x2006B2))

#define CAN_MSGCTRH3           (*((uword volatile far *) 0x200372))

#define CAN_MSGCTRH30          (*((uword volatile far *) 0x2006D2))

#define CAN_MSGCTRH31          (*((uword volatile far *) 0x2006F2))

#define CAN_MSGCTRH4           (*((uword volatile far *) 0x200392))

#define CAN_MSGCTRH5           (*((uword volatile far *) 0x2003B2))

#define CAN_MSGCTRH6           (*((uword volatile far *) 0x2003D2))

#define CAN_MSGCTRH7           (*((uword volatile far *) 0x2003F2))

#define CAN_MSGCTRH8           (*((uword volatile far *) 0x200412))

#define CAN_MSGCTRH9           (*((uword volatile far *) 0x200432))

#define CAN_MSGCTRL0           (*((uword volatile far *) 0x200310))

#define CAN_MSGCTRL1           (*((uword volatile far *) 0x200330))

#define CAN_MSGCTRL10          (*((uword volatile far *) 0x200450))

#define CAN_MSGCTRL11          (*((uword volatile far *) 0x200470))

#define CAN_MSGCTRL12          (*((uword volatile far *) 0x200490))

#define CAN_MSGCTRL13          (*((uword volatile far *) 0x2004B0))

#define CAN_MSGCTRL14          (*((uword volatile far *) 0x2004D0))

#define CAN_MSGCTRL15          (*((uword volatile far *) 0x2004F0))

#define CAN_MSGCTRL16          (*((uword volatile far *) 0x200510))

#define CAN_MSGCTRL17          (*((uword volatile far *) 0x200530))

#define CAN_MSGCTRL18          (*((uword volatile far *) 0x200550))

#define CAN_MSGCTRL19          (*((uword volatile far *) 0x200570))

#define CAN_MSGCTRL2           (*((uword volatile far *) 0x200350))

#define CAN_MSGCTRL20          (*((uword volatile far *) 0x200590))

#define CAN_MSGCTRL21          (*((uword volatile far *) 0x2005B0))

#define CAN_MSGCTRL22          (*((uword volatile far *) 0x2005D0))

#define CAN_MSGCTRL23          (*((uword volatile far *) 0x2005F0))

#define CAN_MSGCTRL24          (*((uword volatile far *) 0x200610))

#define CAN_MSGCTRL25          (*((uword volatile far *) 0x200630))

#define CAN_MSGCTRL26          (*((uword volatile far *) 0x200650))

#define CAN_MSGCTRL27          (*((uword volatile far *) 0x200670))

#define CAN_MSGCTRL28          (*((uword volatile far *) 0x200690))

#define CAN_MSGCTRL29          (*((uword volatile far *) 0x2006B0))

#define CAN_MSGCTRL3           (*((uword volatile far *) 0x200370))

#define CAN_MSGCTRL30          (*((uword volatile far *) 0x2006D0))

#define CAN_MSGCTRL31          (*((uword volatile far *) 0x2006F0))

#define CAN_MSGCTRL4           (*((uword volatile far *) 0x200390))

#define CAN_MSGCTRL5           (*((uword volatile far *) 0x2003B0))

#define CAN_MSGCTRL6           (*((uword volatile far *) 0x2003D0))

#define CAN_MSGCTRL7           (*((uword volatile far *) 0x2003F0))

#define CAN_MSGCTRL8           (*((uword volatile far *) 0x200410))

#define CAN_MSGCTRL9           (*((uword volatile far *) 0x200430))

#define CAN_MSGDRH00           (*((uword volatile far *) 0x200302))

#define CAN_MSGDRH04           (*((uword volatile far *) 0x200306))

#define CAN_MSGDRH10           (*((uword volatile far *) 0x200322))

#define CAN_MSGDRH100          (*((uword volatile far *) 0x200442))

#define CAN_MSGDRH104          (*((uword volatile far *) 0x200446))

#define CAN_MSGDRH110          (*((uword volatile far *) 0x200462))

#define CAN_MSGDRH114          (*((uword volatile far *) 0x200466))

#define CAN_MSGDRH120          (*((uword volatile far *) 0x200482))

#define CAN_MSGDRH124          (*((uword volatile far *) 0x200486))

#define CAN_MSGDRH130          (*((uword volatile far *) 0x2004A2))

#define CAN_MSGDRH134          (*((uword volatile far *) 0x2004A6))

#define CAN_MSGDRH14           (*((uword volatile far *) 0x200326))

#define CAN_MSGDRH140          (*((uword volatile far *) 0x2004C2))

#define CAN_MSGDRH144          (*((uword volatile far *) 0x2004C6))

#define CAN_MSGDRH150          (*((uword volatile far *) 0x2004E2))

#define CAN_MSGDRH154          (*((uword volatile far *) 0x2004E6))

#define CAN_MSGDRH160          (*((uword volatile far *) 0x200502))

#define CAN_MSGDRH164          (*((uword volatile far *) 0x200506))

#define CAN_MSGDRH170          (*((uword volatile far *) 0x200522))

#define CAN_MSGDRH174          (*((uword volatile far *) 0x200526))

#define CAN_MSGDRH180          (*((uword volatile far *) 0x200542))

#define CAN_MSGDRH184          (*((uword volatile far *) 0x200546))

#define CAN_MSGDRH190          (*((uword volatile far *) 0x200562))

#define CAN_MSGDRH194          (*((uword volatile far *) 0x200566))

#define CAN_MSGDRH20           (*((uword volatile far *) 0x200342))

#define CAN_MSGDRH200          (*((uword volatile far *) 0x200582))

#define CAN_MSGDRH204          (*((uword volatile far *) 0x200586))

#define CAN_MSGDRH210          (*((uword volatile far *) 0x2005A2))

#define CAN_MSGDRH214          (*((uword volatile far *) 0x2005A6))

#define CAN_MSGDRH220          (*((uword volatile far *) 0x2005C2))

#define CAN_MSGDRH224          (*((uword volatile far *) 0x2005C6))

#define CAN_MSGDRH230          (*((uword volatile far *) 0x2005E2))

#define CAN_MSGDRH234          (*((uword volatile far *) 0x2005E6))

#define CAN_MSGDRH24           (*((uword volatile far *) 0x200346))

#define CAN_MSGDRH240          (*((uword volatile far *) 0x200602))

#define CAN_MSGDRH244          (*((uword volatile far *) 0x200606))

#define CAN_MSGDRH250          (*((uword volatile far *) 0x200622))

#define CAN_MSGDRH254          (*((uword volatile far *) 0x200626))

#define CAN_MSGDRH260          (*((uword volatile far *) 0x200642))

#define CAN_MSGDRH264          (*((uword volatile far *) 0x200646))

#define CAN_MSGDRH270          (*((uword volatile far *) 0x200662))

#define CAN_MSGDRH274          (*((uword volatile far *) 0x200666))

#define CAN_MSGDRH280          (*((uword volatile far *) 0x200682))

#define CAN_MSGDRH284          (*((uword volatile far *) 0x200686))

#define CAN_MSGDRH290          (*((uword volatile far *) 0x2006A2))

#define CAN_MSGDRH294          (*((uword volatile far *) 0x2006A6))

#define CAN_MSGDRH30           (*((uword volatile far *) 0x200362))

#define CAN_MSGDRH300          (*((uword volatile far *) 0x2006C2))

#define CAN_MSGDRH304          (*((uword volatile far *) 0x2006C6))

#define CAN_MSGDRH310          (*((uword volatile far *) 0x2006E2))

#define CAN_MSGDRH314          (*((uword volatile far *) 0x2006E6))

#define CAN_MSGDRH34           (*((uword volatile far *) 0x200366))

#define CAN_MSGDRH40           (*((uword volatile far *) 0x200382))

#define CAN_MSGDRH44           (*((uword volatile far *) 0x200386))

#define CAN_MSGDRH50           (*((uword volatile far *) 0x2003A2))

#define CAN_MSGDRH54           (*((uword volatile far *) 0x2003A6))

#define CAN_MSGDRH60           (*((uword volatile far *) 0x2003C2))

#define CAN_MSGDRH64           (*((uword volatile far *) 0x2003C6))

#define CAN_MSGDRH70           (*((uword volatile far *) 0x2003E2))

#define CAN_MSGDRH74           (*((uword volatile far *) 0x2003E6))

#define CAN_MSGDRH80           (*((uword volatile far *) 0x200402))

#define CAN_MSGDRH84           (*((uword volatile far *) 0x200406))

#define CAN_MSGDRH90           (*((uword volatile far *) 0x200422))

#define CAN_MSGDRH94           (*((uword volatile far *) 0x200426))

#define CAN_MSGDRL00           (*((uword volatile far *) 0x200300))

#define CAN_MSGDRL04           (*((uword volatile far *) 0x200304))

#define CAN_MSGDRL10           (*((uword volatile far *) 0x200320))

#define CAN_MSGDRL100          (*((uword volatile far *) 0x200440))

#define CAN_MSGDRL104          (*((uword volatile far *) 0x200444))

#define CAN_MSGDRL110          (*((uword volatile far *) 0x200460))

#define CAN_MSGDRL114          (*((uword volatile far *) 0x200464))

#define CAN_MSGDRL120          (*((uword volatile far *) 0x200480))

#define CAN_MSGDRL124          (*((uword volatile far *) 0x200484))

#define CAN_MSGDRL130          (*((uword volatile far *) 0x2004A0))

#define CAN_MSGDRL134          (*((uword volatile far *) 0x2004A4))

#define CAN_MSGDRL14           (*((uword volatile far *) 0x200324))

#define CAN_MSGDRL140          (*((uword volatile far *) 0x2004C0))

#define CAN_MSGDRL144          (*((uword volatile far *) 0x2004C4))

#define CAN_MSGDRL150          (*((uword volatile far *) 0x2004E0))

#define CAN_MSGDRL154          (*((uword volatile far *) 0x2004E4))

#define CAN_MSGDRL160          (*((uword volatile far *) 0x200500))

#define CAN_MSGDRL164          (*((uword volatile far *) 0x200504))

#define CAN_MSGDRL170          (*((uword volatile far *) 0x200520))

#define CAN_MSGDRL174          (*((uword volatile far *) 0x200524))

#define CAN_MSGDRL180          (*((uword volatile far *) 0x200540))

#define CAN_MSGDRL184          (*((uword volatile far *) 0x200544))

#define CAN_MSGDRL190          (*((uword volatile far *) 0x200560))

#define CAN_MSGDRL194          (*((uword volatile far *) 0x200564))

#define CAN_MSGDRL20           (*((uword volatile far *) 0x200340))

#define CAN_MSGDRL200          (*((uword volatile far *) 0x200580))

#define CAN_MSGDRL204          (*((uword volatile far *) 0x200584))

#define CAN_MSGDRL210          (*((uword volatile far *) 0x2005A0))

#define CAN_MSGDRL214          (*((uword volatile far *) 0x2005A4))

#define CAN_MSGDRL220          (*((uword volatile far *) 0x2005C0))

#define CAN_MSGDRL224          (*((uword volatile far *) 0x2005C4))

#define CAN_MSGDRL230          (*((uword volatile far *) 0x2005E0))

#define CAN_MSGDRL234          (*((uword volatile far *) 0x2005E4))

#define CAN_MSGDRL24           (*((uword volatile far *) 0x200344))

#define CAN_MSGDRL240          (*((uword volatile far *) 0x200600))

#define CAN_MSGDRL244          (*((uword volatile far *) 0x200604))

#define CAN_MSGDRL250          (*((uword volatile far *) 0x200620))

#define CAN_MSGDRL254          (*((uword volatile far *) 0x200624))

#define CAN_MSGDRL260          (*((uword volatile far *) 0x200640))

#define CAN_MSGDRL264          (*((uword volatile far *) 0x200644))

#define CAN_MSGDRL270          (*((uword volatile far *) 0x200660))

#define CAN_MSGDRL274          (*((uword volatile far *) 0x200664))

#define CAN_MSGDRL280          (*((uword volatile far *) 0x200680))

#define CAN_MSGDRL284          (*((uword volatile far *) 0x200684))

#define CAN_MSGDRL290          (*((uword volatile far *) 0x2006A0))

#define CAN_MSGDRL294          (*((uword volatile far *) 0x2006A4))

#define CAN_MSGDRL30           (*((uword volatile far *) 0x200360))

#define CAN_MSGDRL300          (*((uword volatile far *) 0x2006C0))

#define CAN_MSGDRL304          (*((uword volatile far *) 0x2006C4))

#define CAN_MSGDRL310          (*((uword volatile far *) 0x2006E0))

#define CAN_MSGDRL314          (*((uword volatile far *) 0x2006E4))

#define CAN_MSGDRL34           (*((uword volatile far *) 0x200364))

#define CAN_MSGDRL40           (*((uword volatile far *) 0x200380))

#define CAN_MSGDRL44           (*((uword volatile far *) 0x200384))

#define CAN_MSGDRL50           (*((uword volatile far *) 0x2003A0))

#define CAN_MSGDRL54           (*((uword volatile far *) 0x2003A4))

#define CAN_MSGDRL60           (*((uword volatile far *) 0x2003C0))

#define CAN_MSGDRL64           (*((uword volatile far *) 0x2003C4))

#define CAN_MSGDRL70           (*((uword volatile far *) 0x2003E0))

#define CAN_MSGDRL74           (*((uword volatile far *) 0x2003E4))

#define CAN_MSGDRL80           (*((uword volatile far *) 0x200400))

#define CAN_MSGDRL84           (*((uword volatile far *) 0x200404))

#define CAN_MSGDRL90           (*((uword volatile far *) 0x200420))

#define CAN_MSGDRL94           (*((uword volatile far *) 0x200424))

#define CAN_MSGFGCRH0          (*((uword volatile far *) 0x20031A))

#define CAN_MSGFGCRH1          (*((uword volatile far *) 0x20033A))

#define CAN_MSGFGCRH10         (*((uword volatile far *) 0x20045A))

#define CAN_MSGFGCRH11         (*((uword volatile far *) 0x20047A))

#define CAN_MSGFGCRH12         (*((uword volatile far *) 0x20049A))

#define CAN_MSGFGCRH13         (*((uword volatile far *) 0x2004BA))

#define CAN_MSGFGCRH14         (*((uword volatile far *) 0x2004DA))

#define CAN_MSGFGCRH15         (*((uword volatile far *) 0x2004FA))

#define CAN_MSGFGCRH16         (*((uword volatile far *) 0x20051A))

#define CAN_MSGFGCRH17         (*((uword volatile far *) 0x20053A))

#define CAN_MSGFGCRH18         (*((uword volatile far *) 0x20055A))

#define CAN_MSGFGCRH19         (*((uword volatile far *) 0x20057A))

#define CAN_MSGFGCRH2          (*((uword volatile far *) 0x20035A))

#define CAN_MSGFGCRH20         (*((uword volatile far *) 0x20059A))

#define CAN_MSGFGCRH21         (*((uword volatile far *) 0x2005BA))

#define CAN_MSGFGCRH22         (*((uword volatile far *) 0x2005DA))

#define CAN_MSGFGCRH23         (*((uword volatile far *) 0x2005FA))

#define CAN_MSGFGCRH24         (*((uword volatile far *) 0x20061A))

#define CAN_MSGFGCRH25         (*((uword volatile far *) 0x20063A))

#define CAN_MSGFGCRH26         (*((uword volatile far *) 0x20065A))

#define CAN_MSGFGCRH27         (*((uword volatile far *) 0x20067A))

#define CAN_MSGFGCRH28         (*((uword volatile far *) 0x20069A))

#define CAN_MSGFGCRH29         (*((uword volatile far *) 0x2006BA))

#define CAN_MSGFGCRH3          (*((uword volatile far *) 0x20037A))

#define CAN_MSGFGCRH30         (*((uword volatile far *) 0x2006DA))

#define CAN_MSGFGCRH31         (*((uword volatile far *) 0x2006FA))

#define CAN_MSGFGCRH4          (*((uword volatile far *) 0x20039A))

#define CAN_MSGFGCRH5          (*((uword volatile far *) 0x2003BA))

#define CAN_MSGFGCRH6          (*((uword volatile far *) 0x2003DA))

#define CAN_MSGFGCRH7          (*((uword volatile far *) 0x2003FA))

#define CAN_MSGFGCRH8          (*((uword volatile far *) 0x20041A))

#define CAN_MSGFGCRH9          (*((uword volatile far *) 0x20043A))

#define CAN_MSGFGCRL0          (*((uword volatile far *) 0x200318))
#define CAN_MSGFGCRL0_DLCC                     ((T_Reg16 *) 0x200318)->bit11
#define CAN_MSGFGCRL0_FD                       ((T_Reg16 *) 0x200318)->bit13
#define CAN_MSGFGCRL0_GDFS                     ((T_Reg16 *) 0x200318)->bit8
#define CAN_MSGFGCRL0_IDC                      ((T_Reg16 *) 0x200318)->bit10
#define CAN_MSGFGCRL0_SDT                      ((T_Reg16 *) 0x200318)->bit14
#define CAN_MSGFGCRL0_SRREN                    ((T_Reg16 *) 0x200318)->bit9
#define CAN_MSGFGCRL0_STT                      ((T_Reg16 *) 0x200318)->bit15

#define CAN_MSGFGCRL1          (*((uword volatile far *) 0x200338))
#define CAN_MSGFGCRL1_DLCC                     ((T_Reg16 *) 0x200338)->bit11
#define CAN_MSGFGCRL1_FD                       ((T_Reg16 *) 0x200338)->bit13
#define CAN_MSGFGCRL1_GDFS                     ((T_Reg16 *) 0x200338)->bit8
#define CAN_MSGFGCRL1_IDC                      ((T_Reg16 *) 0x200338)->bit10
#define CAN_MSGFGCRL1_SDT                      ((T_Reg16 *) 0x200338)->bit14
#define CAN_MSGFGCRL1_SRREN                    ((T_Reg16 *) 0x200338)->bit9
#define CAN_MSGFGCRL1_STT                      ((T_Reg16 *) 0x200338)->bit15

#define CAN_MSGFGCRL10         (*((uword volatile far *) 0x200458))
#define CAN_MSGFGCRL10_DLCC                     ((T_Reg16 *) 0x200458)->bit11
#define CAN_MSGFGCRL10_FD                       ((T_Reg16 *) 0x200458)->bit13
#define CAN_MSGFGCRL10_GDFS                     ((T_Reg16 *) 0x200458)->bit8
#define CAN_MSGFGCRL10_IDC                      ((T_Reg16 *) 0x200458)->bit10
#define CAN_MSGFGCRL10_SDT                      ((T_Reg16 *) 0x200458)->bit14
#define CAN_MSGFGCRL10_SRREN                    ((T_Reg16 *) 0x200458)->bit9
#define CAN_MSGFGCRL10_STT                      ((T_Reg16 *) 0x200458)->bit15

#define CAN_MSGFGCRL11         (*((uword volatile far *) 0x200478))
#define CAN_MSGFGCRL11_DLCC                     ((T_Reg16 *) 0x200478)->bit11
#define CAN_MSGFGCRL11_FD                       ((T_Reg16 *) 0x200478)->bit13
#define CAN_MSGFGCRL11_GDFS                     ((T_Reg16 *) 0x200478)->bit8
#define CAN_MSGFGCRL11_IDC                      ((T_Reg16 *) 0x200478)->bit10
#define CAN_MSGFGCRL11_SDT                      ((T_Reg16 *) 0x200478)->bit14
#define CAN_MSGFGCRL11_SRREN                    ((T_Reg16 *) 0x200478)->bit9
#define CAN_MSGFGCRL11_STT                      ((T_Reg16 *) 0x200478)->bit15

#define CAN_MSGFGCRL12         (*((uword volatile far *) 0x200498))
#define CAN_MSGFGCRL12_DLCC                     ((T_Reg16 *) 0x200498)->bit11
#define CAN_MSGFGCRL12_FD                       ((T_Reg16 *) 0x200498)->bit13
#define CAN_MSGFGCRL12_GDFS                     ((T_Reg16 *) 0x200498)->bit8
#define CAN_MSGFGCRL12_IDC                      ((T_Reg16 *) 0x200498)->bit10
#define CAN_MSGFGCRL12_SDT                      ((T_Reg16 *) 0x200498)->bit14
#define CAN_MSGFGCRL12_SRREN                    ((T_Reg16 *) 0x200498)->bit9
#define CAN_MSGFGCRL12_STT                      ((T_Reg16 *) 0x200498)->bit15

#define CAN_MSGFGCRL13         (*((uword volatile far *) 0x2004B8))
#define CAN_MSGFGCRL13_DLCC                     ((T_Reg16 *) 0x2004B8)->bit11
#define CAN_MSGFGCRL13_FD                       ((T_Reg16 *) 0x2004B8)->bit13
#define CAN_MSGFGCRL13_GDFS                     ((T_Reg16 *) 0x2004B8)->bit8
#define CAN_MSGFGCRL13_IDC                      ((T_Reg16 *) 0x2004B8)->bit10
#define CAN_MSGFGCRL13_SDT                      ((T_Reg16 *) 0x2004B8)->bit14
#define CAN_MSGFGCRL13_SRREN                    ((T_Reg16 *) 0x2004B8)->bit9
#define CAN_MSGFGCRL13_STT                      ((T_Reg16 *) 0x2004B8)->bit15

#define CAN_MSGFGCRL14         (*((uword volatile far *) 0x2004D8))
#define CAN_MSGFGCRL14_DLCC                     ((T_Reg16 *) 0x2004D8)->bit11
#define CAN_MSGFGCRL14_FD                       ((T_Reg16 *) 0x2004D8)->bit13
#define CAN_MSGFGCRL14_GDFS                     ((T_Reg16 *) 0x2004D8)->bit8
#define CAN_MSGFGCRL14_IDC                      ((T_Reg16 *) 0x2004D8)->bit10
#define CAN_MSGFGCRL14_SDT                      ((T_Reg16 *) 0x2004D8)->bit14
#define CAN_MSGFGCRL14_SRREN                    ((T_Reg16 *) 0x2004D8)->bit9
#define CAN_MSGFGCRL14_STT                      ((T_Reg16 *) 0x2004D8)->bit15

#define CAN_MSGFGCRL15         (*((uword volatile far *) 0x2004F8))
#define CAN_MSGFGCRL15_DLCC                     ((T_Reg16 *) 0x2004F8)->bit11
#define CAN_MSGFGCRL15_FD                       ((T_Reg16 *) 0x2004F8)->bit13
#define CAN_MSGFGCRL15_GDFS                     ((T_Reg16 *) 0x2004F8)->bit8
#define CAN_MSGFGCRL15_IDC                      ((T_Reg16 *) 0x2004F8)->bit10
#define CAN_MSGFGCRL15_SDT                      ((T_Reg16 *) 0x2004F8)->bit14
#define CAN_MSGFGCRL15_SRREN                    ((T_Reg16 *) 0x2004F8)->bit9
#define CAN_MSGFGCRL15_STT                      ((T_Reg16 *) 0x2004F8)->bit15

#define CAN_MSGFGCRL16         (*((uword volatile far *) 0x200518))
#define CAN_MSGFGCRL16_DLCC                     ((T_Reg16 *) 0x200518)->bit11
#define CAN_MSGFGCRL16_FD                       ((T_Reg16 *) 0x200518)->bit13
#define CAN_MSGFGCRL16_GDFS                     ((T_Reg16 *) 0x200518)->bit8
#define CAN_MSGFGCRL16_IDC                      ((T_Reg16 *) 0x200518)->bit10
#define CAN_MSGFGCRL16_SDT                      ((T_Reg16 *) 0x200518)->bit14
#define CAN_MSGFGCRL16_SRREN                    ((T_Reg16 *) 0x200518)->bit9
#define CAN_MSGFGCRL16_STT                      ((T_Reg16 *) 0x200518)->bit15

#define CAN_MSGFGCRL17         (*((uword volatile far *) 0x200538))
#define CAN_MSGFGCRL17_DLCC                     ((T_Reg16 *) 0x200538)->bit11
#define CAN_MSGFGCRL17_FD                       ((T_Reg16 *) 0x200538)->bit13
#define CAN_MSGFGCRL17_GDFS                     ((T_Reg16 *) 0x200538)->bit8
#define CAN_MSGFGCRL17_IDC                      ((T_Reg16 *) 0x200538)->bit10
#define CAN_MSGFGCRL17_SDT                      ((T_Reg16 *) 0x200538)->bit14
#define CAN_MSGFGCRL17_SRREN                    ((T_Reg16 *) 0x200538)->bit9
#define CAN_MSGFGCRL17_STT                      ((T_Reg16 *) 0x200538)->bit15

#define CAN_MSGFGCRL18         (*((uword volatile far *) 0x200558))
#define CAN_MSGFGCRL18_DLCC                     ((T_Reg16 *) 0x200558)->bit11
#define CAN_MSGFGCRL18_FD                       ((T_Reg16 *) 0x200558)->bit13
#define CAN_MSGFGCRL18_GDFS                     ((T_Reg16 *) 0x200558)->bit8
#define CAN_MSGFGCRL18_IDC                      ((T_Reg16 *) 0x200558)->bit10
#define CAN_MSGFGCRL18_SDT                      ((T_Reg16 *) 0x200558)->bit14
#define CAN_MSGFGCRL18_SRREN                    ((T_Reg16 *) 0x200558)->bit9
#define CAN_MSGFGCRL18_STT                      ((T_Reg16 *) 0x200558)->bit15

#define CAN_MSGFGCRL19         (*((uword volatile far *) 0x200578))
#define CAN_MSGFGCRL19_DLCC                     ((T_Reg16 *) 0x200578)->bit11
#define CAN_MSGFGCRL19_FD                       ((T_Reg16 *) 0x200578)->bit13
#define CAN_MSGFGCRL19_GDFS                     ((T_Reg16 *) 0x200578)->bit8
#define CAN_MSGFGCRL19_IDC                      ((T_Reg16 *) 0x200578)->bit10
#define CAN_MSGFGCRL19_SDT                      ((T_Reg16 *) 0x200578)->bit14
#define CAN_MSGFGCRL19_SRREN                    ((T_Reg16 *) 0x200578)->bit9
#define CAN_MSGFGCRL19_STT                      ((T_Reg16 *) 0x200578)->bit15

#define CAN_MSGFGCRL2          (*((uword volatile far *) 0x200358))
#define CAN_MSGFGCRL2_DLCC                     ((T_Reg16 *) 0x200358)->bit11
#define CAN_MSGFGCRL2_FD                       ((T_Reg16 *) 0x200358)->bit13
#define CAN_MSGFGCRL2_GDFS                     ((T_Reg16 *) 0x200358)->bit8
#define CAN_MSGFGCRL2_IDC                      ((T_Reg16 *) 0x200358)->bit10
#define CAN_MSGFGCRL2_SDT                      ((T_Reg16 *) 0x200358)->bit14
#define CAN_MSGFGCRL2_SRREN                    ((T_Reg16 *) 0x200358)->bit9
#define CAN_MSGFGCRL2_STT                      ((T_Reg16 *) 0x200358)->bit15

#define CAN_MSGFGCRL20         (*((uword volatile far *) 0x200598))
#define CAN_MSGFGCRL20_DLCC                     ((T_Reg16 *) 0x200598)->bit11
#define CAN_MSGFGCRL20_FD                       ((T_Reg16 *) 0x200598)->bit13
#define CAN_MSGFGCRL20_GDFS                     ((T_Reg16 *) 0x200598)->bit8
#define CAN_MSGFGCRL20_IDC                      ((T_Reg16 *) 0x200598)->bit10
#define CAN_MSGFGCRL20_SDT                      ((T_Reg16 *) 0x200598)->bit14
#define CAN_MSGFGCRL20_SRREN                    ((T_Reg16 *) 0x200598)->bit9
#define CAN_MSGFGCRL20_STT                      ((T_Reg16 *) 0x200598)->bit15

#define CAN_MSGFGCRL21         (*((uword volatile far *) 0x2005B8))
#define CAN_MSGFGCRL21_DLCC                     ((T_Reg16 *) 0x2005B8)->bit11
#define CAN_MSGFGCRL21_FD                       ((T_Reg16 *) 0x2005B8)->bit13
#define CAN_MSGFGCRL21_GDFS                     ((T_Reg16 *) 0x2005B8)->bit8
#define CAN_MSGFGCRL21_IDC                      ((T_Reg16 *) 0x2005B8)->bit10
#define CAN_MSGFGCRL21_SDT                      ((T_Reg16 *) 0x2005B8)->bit14
#define CAN_MSGFGCRL21_SRREN                    ((T_Reg16 *) 0x2005B8)->bit9
#define CAN_MSGFGCRL21_STT                      ((T_Reg16 *) 0x2005B8)->bit15

#define CAN_MSGFGCRL22         (*((uword volatile far *) 0x2005D8))
#define CAN_MSGFGCRL22_DLCC                     ((T_Reg16 *) 0x2005D8)->bit11
#define CAN_MSGFGCRL22_FD                       ((T_Reg16 *) 0x2005D8)->bit13
#define CAN_MSGFGCRL22_GDFS                     ((T_Reg16 *) 0x2005D8)->bit8
#define CAN_MSGFGCRL22_IDC                      ((T_Reg16 *) 0x2005D8)->bit10
#define CAN_MSGFGCRL22_SDT                      ((T_Reg16 *) 0x2005D8)->bit14
#define CAN_MSGFGCRL22_SRREN                    ((T_Reg16 *) 0x2005D8)->bit9
#define CAN_MSGFGCRL22_STT                      ((T_Reg16 *) 0x2005D8)->bit15

#define CAN_MSGFGCRL23         (*((uword volatile far *) 0x2005F8))
#define CAN_MSGFGCRL23_DLCC                     ((T_Reg16 *) 0x2005F8)->bit11
#define CAN_MSGFGCRL23_FD                       ((T_Reg16 *) 0x2005F8)->bit13
#define CAN_MSGFGCRL23_GDFS                     ((T_Reg16 *) 0x2005F8)->bit8
#define CAN_MSGFGCRL23_IDC                      ((T_Reg16 *) 0x2005F8)->bit10
#define CAN_MSGFGCRL23_SDT                      ((T_Reg16 *) 0x2005F8)->bit14
#define CAN_MSGFGCRL23_SRREN                    ((T_Reg16 *) 0x2005F8)->bit9
#define CAN_MSGFGCRL23_STT                      ((T_Reg16 *) 0x2005F8)->bit15

#define CAN_MSGFGCRL24         (*((uword volatile far *) 0x200618))
#define CAN_MSGFGCRL24_DLCC                     ((T_Reg16 *) 0x200618)->bit11
#define CAN_MSGFGCRL24_FD                       ((T_Reg16 *) 0x200618)->bit13
#define CAN_MSGFGCRL24_GDFS                     ((T_Reg16 *) 0x200618)->bit8
#define CAN_MSGFGCRL24_IDC                      ((T_Reg16 *) 0x200618)->bit10
#define CAN_MSGFGCRL24_SDT                      ((T_Reg16 *) 0x200618)->bit14
#define CAN_MSGFGCRL24_SRREN                    ((T_Reg16 *) 0x200618)->bit9
#define CAN_MSGFGCRL24_STT                      ((T_Reg16 *) 0x200618)->bit15

#define CAN_MSGFGCRL25         (*((uword volatile far *) 0x200638))
#define CAN_MSGFGCRL25_DLCC                     ((T_Reg16 *) 0x200638)->bit11
#define CAN_MSGFGCRL25_FD                       ((T_Reg16 *) 0x200638)->bit13
#define CAN_MSGFGCRL25_GDFS                     ((T_Reg16 *) 0x200638)->bit8
#define CAN_MSGFGCRL25_IDC                      ((T_Reg16 *) 0x200638)->bit10
#define CAN_MSGFGCRL25_SDT                      ((T_Reg16 *) 0x200638)->bit14
#define CAN_MSGFGCRL25_SRREN                    ((T_Reg16 *) 0x200638)->bit9
#define CAN_MSGFGCRL25_STT                      ((T_Reg16 *) 0x200638)->bit15

#define CAN_MSGFGCRL26         (*((uword volatile far *) 0x200658))
#define CAN_MSGFGCRL26_DLCC                     ((T_Reg16 *) 0x200658)->bit11
#define CAN_MSGFGCRL26_FD                       ((T_Reg16 *) 0x200658)->bit13
#define CAN_MSGFGCRL26_GDFS                     ((T_Reg16 *) 0x200658)->bit8
#define CAN_MSGFGCRL26_IDC                      ((T_Reg16 *) 0x200658)->bit10
#define CAN_MSGFGCRL26_SDT                      ((T_Reg16 *) 0x200658)->bit14
#define CAN_MSGFGCRL26_SRREN                    ((T_Reg16 *) 0x200658)->bit9
#define CAN_MSGFGCRL26_STT                      ((T_Reg16 *) 0x200658)->bit15

#define CAN_MSGFGCRL27         (*((uword volatile far *) 0x200678))
#define CAN_MSGFGCRL27_DLCC                     ((T_Reg16 *) 0x200678)->bit11
#define CAN_MSGFGCRL27_FD                       ((T_Reg16 *) 0x200678)->bit13
#define CAN_MSGFGCRL27_GDFS                     ((T_Reg16 *) 0x200678)->bit8
#define CAN_MSGFGCRL27_IDC                      ((T_Reg16 *) 0x200678)->bit10
#define CAN_MSGFGCRL27_SDT                      ((T_Reg16 *) 0x200678)->bit14
#define CAN_MSGFGCRL27_SRREN                    ((T_Reg16 *) 0x200678)->bit9
#define CAN_MSGFGCRL27_STT                      ((T_Reg16 *) 0x200678)->bit15

#define CAN_MSGFGCRL28         (*((uword volatile far *) 0x200698))
#define CAN_MSGFGCRL28_DLCC                     ((T_Reg16 *) 0x200698)->bit11
#define CAN_MSGFGCRL28_FD                       ((T_Reg16 *) 0x200698)->bit13
#define CAN_MSGFGCRL28_GDFS                     ((T_Reg16 *) 0x200698)->bit8
#define CAN_MSGFGCRL28_IDC                      ((T_Reg16 *) 0x200698)->bit10
#define CAN_MSGFGCRL28_SDT                      ((T_Reg16 *) 0x200698)->bit14
#define CAN_MSGFGCRL28_SRREN                    ((T_Reg16 *) 0x200698)->bit9
#define CAN_MSGFGCRL28_STT                      ((T_Reg16 *) 0x200698)->bit15

#define CAN_MSGFGCRL29         (*((uword volatile far *) 0x2006B8))
#define CAN_MSGFGCRL29_DLCC                     ((T_Reg16 *) 0x2006B8)->bit11
#define CAN_MSGFGCRL29_FD                       ((T_Reg16 *) 0x2006B8)->bit13
#define CAN_MSGFGCRL29_GDFS                     ((T_Reg16 *) 0x2006B8)->bit8
#define CAN_MSGFGCRL29_IDC                      ((T_Reg16 *) 0x2006B8)->bit10
#define CAN_MSGFGCRL29_SDT                      ((T_Reg16 *) 0x2006B8)->bit14
#define CAN_MSGFGCRL29_SRREN                    ((T_Reg16 *) 0x2006B8)->bit9
#define CAN_MSGFGCRL29_STT                      ((T_Reg16 *) 0x2006B8)->bit15

#define CAN_MSGFGCRL3          (*((uword volatile far *) 0x200378))
#define CAN_MSGFGCRL3_DLCC                     ((T_Reg16 *) 0x200378)->bit11
#define CAN_MSGFGCRL3_FD                       ((T_Reg16 *) 0x200378)->bit13
#define CAN_MSGFGCRL3_GDFS                     ((T_Reg16 *) 0x200378)->bit8
#define CAN_MSGFGCRL3_IDC                      ((T_Reg16 *) 0x200378)->bit10
#define CAN_MSGFGCRL3_SDT                      ((T_Reg16 *) 0x200378)->bit14
#define CAN_MSGFGCRL3_SRREN                    ((T_Reg16 *) 0x200378)->bit9
#define CAN_MSGFGCRL3_STT                      ((T_Reg16 *) 0x200378)->bit15

#define CAN_MSGFGCRL30         (*((uword volatile far *) 0x2006D8))
#define CAN_MSGFGCRL30_DLCC                     ((T_Reg16 *) 0x2006D8)->bit11
#define CAN_MSGFGCRL30_FD                       ((T_Reg16 *) 0x2006D8)->bit13
#define CAN_MSGFGCRL30_GDFS                     ((T_Reg16 *) 0x2006D8)->bit8
#define CAN_MSGFGCRL30_IDC                      ((T_Reg16 *) 0x2006D8)->bit10
#define CAN_MSGFGCRL30_SDT                      ((T_Reg16 *) 0x2006D8)->bit14
#define CAN_MSGFGCRL30_SRREN                    ((T_Reg16 *) 0x2006D8)->bit9
#define CAN_MSGFGCRL30_STT                      ((T_Reg16 *) 0x2006D8)->bit15

#define CAN_MSGFGCRL31         (*((uword volatile far *) 0x2006F8))
#define CAN_MSGFGCRL31_DLCC                     ((T_Reg16 *) 0x2006F8)->bit11
#define CAN_MSGFGCRL31_FD                       ((T_Reg16 *) 0x2006F8)->bit13
#define CAN_MSGFGCRL31_GDFS                     ((T_Reg16 *) 0x2006F8)->bit8
#define CAN_MSGFGCRL31_IDC                      ((T_Reg16 *) 0x2006F8)->bit10
#define CAN_MSGFGCRL31_SDT                      ((T_Reg16 *) 0x2006F8)->bit14
#define CAN_MSGFGCRL31_SRREN                    ((T_Reg16 *) 0x2006F8)->bit9
#define CAN_MSGFGCRL31_STT                      ((T_Reg16 *) 0x2006F8)->bit15

#define CAN_MSGFGCRL4          (*((uword volatile far *) 0x200398))
#define CAN_MSGFGCRL4_DLCC                     ((T_Reg16 *) 0x200398)->bit11
#define CAN_MSGFGCRL4_FD                       ((T_Reg16 *) 0x200398)->bit13
#define CAN_MSGFGCRL4_GDFS                     ((T_Reg16 *) 0x200398)->bit8
#define CAN_MSGFGCRL4_IDC                      ((T_Reg16 *) 0x200398)->bit10
#define CAN_MSGFGCRL4_SDT                      ((T_Reg16 *) 0x200398)->bit14
#define CAN_MSGFGCRL4_SRREN                    ((T_Reg16 *) 0x200398)->bit9
#define CAN_MSGFGCRL4_STT                      ((T_Reg16 *) 0x200398)->bit15

#define CAN_MSGFGCRL5          (*((uword volatile far *) 0x2003B8))
#define CAN_MSGFGCRL5_DLCC                     ((T_Reg16 *) 0x2003B8)->bit11
#define CAN_MSGFGCRL5_FD                       ((T_Reg16 *) 0x2003B8)->bit13
#define CAN_MSGFGCRL5_GDFS                     ((T_Reg16 *) 0x2003B8)->bit8
#define CAN_MSGFGCRL5_IDC                      ((T_Reg16 *) 0x2003B8)->bit10
#define CAN_MSGFGCRL5_SDT                      ((T_Reg16 *) 0x2003B8)->bit14
#define CAN_MSGFGCRL5_SRREN                    ((T_Reg16 *) 0x2003B8)->bit9
#define CAN_MSGFGCRL5_STT                      ((T_Reg16 *) 0x2003B8)->bit15

#define CAN_MSGFGCRL6          (*((uword volatile far *) 0x2003D8))
#define CAN_MSGFGCRL6_DLCC                     ((T_Reg16 *) 0x2003D8)->bit11
#define CAN_MSGFGCRL6_FD                       ((T_Reg16 *) 0x2003D8)->bit13
#define CAN_MSGFGCRL6_GDFS                     ((T_Reg16 *) 0x2003D8)->bit8
#define CAN_MSGFGCRL6_IDC                      ((T_Reg16 *) 0x2003D8)->bit10
#define CAN_MSGFGCRL6_SDT                      ((T_Reg16 *) 0x2003D8)->bit14
#define CAN_MSGFGCRL6_SRREN                    ((T_Reg16 *) 0x2003D8)->bit9
#define CAN_MSGFGCRL6_STT                      ((T_Reg16 *) 0x2003D8)->bit15

#define CAN_MSGFGCRL7          (*((uword volatile far *) 0x2003F8))
#define CAN_MSGFGCRL7_DLCC                     ((T_Reg16 *) 0x2003F8)->bit11
#define CAN_MSGFGCRL7_FD                       ((T_Reg16 *) 0x2003F8)->bit13
#define CAN_MSGFGCRL7_GDFS                     ((T_Reg16 *) 0x2003F8)->bit8
#define CAN_MSGFGCRL7_IDC                      ((T_Reg16 *) 0x2003F8)->bit10
#define CAN_MSGFGCRL7_SDT                      ((T_Reg16 *) 0x2003F8)->bit14
#define CAN_MSGFGCRL7_SRREN                    ((T_Reg16 *) 0x2003F8)->bit9
#define CAN_MSGFGCRL7_STT                      ((T_Reg16 *) 0x2003F8)->bit15

#define CAN_MSGFGCRL8          (*((uword volatile far *) 0x200418))
#define CAN_MSGFGCRL8_DLCC                     ((T_Reg16 *) 0x200418)->bit11
#define CAN_MSGFGCRL8_FD                       ((T_Reg16 *) 0x200418)->bit13
#define CAN_MSGFGCRL8_GDFS                     ((T_Reg16 *) 0x200418)->bit8
#define CAN_MSGFGCRL8_IDC                      ((T_Reg16 *) 0x200418)->bit10
#define CAN_MSGFGCRL8_SDT                      ((T_Reg16 *) 0x200418)->bit14
#define CAN_MSGFGCRL8_SRREN                    ((T_Reg16 *) 0x200418)->bit9
#define CAN_MSGFGCRL8_STT                      ((T_Reg16 *) 0x200418)->bit15

#define CAN_MSGFGCRL9          (*((uword volatile far *) 0x200438))
#define CAN_MSGFGCRL9_DLCC                     ((T_Reg16 *) 0x200438)->bit11
#define CAN_MSGFGCRL9_FD                       ((T_Reg16 *) 0x200438)->bit13
#define CAN_MSGFGCRL9_GDFS                     ((T_Reg16 *) 0x200438)->bit8
#define CAN_MSGFGCRL9_IDC                      ((T_Reg16 *) 0x200438)->bit10
#define CAN_MSGFGCRL9_SDT                      ((T_Reg16 *) 0x200438)->bit14
#define CAN_MSGFGCRL9_SRREN                    ((T_Reg16 *) 0x200438)->bit9
#define CAN_MSGFGCRL9_STT                      ((T_Reg16 *) 0x200438)->bit15

#define CAN_PISEL              (*((uword volatile far *) 0x200004))

#define CAN_RXIPNDH            (*((uword volatile far *) 0x200286))
#define CAN_RXIPNDH_RXIPND16                 ((T_Reg16 *) 0x200286)->bit0
#define CAN_RXIPNDH_RXIPND17                 ((T_Reg16 *) 0x200286)->bit1
#define CAN_RXIPNDH_RXIPND18                 ((T_Reg16 *) 0x200286)->bit2
#define CAN_RXIPNDH_RXIPND19                 ((T_Reg16 *) 0x200286)->bit3
#define CAN_RXIPNDH_RXIPND20                 ((T_Reg16 *) 0x200286)->bit4
#define CAN_RXIPNDH_RXIPND21                 ((T_Reg16 *) 0x200286)->bit5
#define CAN_RXIPNDH_RXIPND22                 ((T_Reg16 *) 0x200286)->bit6
#define CAN_RXIPNDH_RXIPND23                 ((T_Reg16 *) 0x200286)->bit7
#define CAN_RXIPNDH_RXIPND24                 ((T_Reg16 *) 0x200286)->bit8
#define CAN_RXIPNDH_RXIPND25                 ((T_Reg16 *) 0x200286)->bit9
#define CAN_RXIPNDH_RXIPND26                 ((T_Reg16 *) 0x200286)->bit10
#define CAN_RXIPNDH_RXIPND27                 ((T_Reg16 *) 0x200286)->bit11
#define CAN_RXIPNDH_RXIPND28                 ((T_Reg16 *) 0x200286)->bit12
#define CAN_RXIPNDH_RXIPND29                 ((T_Reg16 *) 0x200286)->bit13
#define CAN_RXIPNDH_RXIPND30                 ((T_Reg16 *) 0x200286)->bit14
#define CAN_RXIPNDH_RXIPND31                 ((T_Reg16 *) 0x200286)->bit15

#define CAN_RXIPNDL            (*((uword volatile far *) 0x200284))
#define CAN_RXIPNDL_RXIPND0                  ((T_Reg16 *) 0x200284)->bit0
#define CAN_RXIPNDL_RXIPND1                  ((T_Reg16 *) 0x200284)->bit1
#define CAN_RXIPNDL_RXIPND10                 ((T_Reg16 *) 0x200284)->bit10
#define CAN_RXIPNDL_RXIPND11                 ((T_Reg16 *) 0x200284)->bit11
#define CAN_RXIPNDL_RXIPND12                 ((T_Reg16 *) 0x200284)->bit12
#define CAN_RXIPNDL_RXIPND13                 ((T_Reg16 *) 0x200284)->bit13
#define CAN_RXIPNDL_RXIPND14                 ((T_Reg16 *) 0x200284)->bit14
#define CAN_RXIPNDL_RXIPND15                 ((T_Reg16 *) 0x200284)->bit15
#define CAN_RXIPNDL_RXIPND2                  ((T_Reg16 *) 0x200284)->bit2
#define CAN_RXIPNDL_RXIPND3                  ((T_Reg16 *) 0x200284)->bit3
#define CAN_RXIPNDL_RXIPND4                  ((T_Reg16 *) 0x200284)->bit4
#define CAN_RXIPNDL_RXIPND5                  ((T_Reg16 *) 0x200284)->bit5
#define CAN_RXIPNDL_RXIPND6                  ((T_Reg16 *) 0x200284)->bit6
#define CAN_RXIPNDL_RXIPND7                  ((T_Reg16 *) 0x200284)->bit7
#define CAN_RXIPNDL_RXIPND8                  ((T_Reg16 *) 0x200284)->bit8
#define CAN_RXIPNDL_RXIPND9                  ((T_Reg16 *) 0x200284)->bit9

#define CAN_TXIPNDH            (*((uword volatile far *) 0x20028A))
#define CAN_TXIPNDH_TXIPND16                 ((T_Reg16 *) 0x20028A)->bit0
#define CAN_TXIPNDH_TXIPND17                 ((T_Reg16 *) 0x20028A)->bit1
#define CAN_TXIPNDH_TXIPND18                 ((T_Reg16 *) 0x20028A)->bit2
#define CAN_TXIPNDH_TXIPND19                 ((T_Reg16 *) 0x20028A)->bit3
#define CAN_TXIPNDH_TXIPND20                 ((T_Reg16 *) 0x20028A)->bit4
#define CAN_TXIPNDH_TXIPND21                 ((T_Reg16 *) 0x20028A)->bit5
#define CAN_TXIPNDH_TXIPND22                 ((T_Reg16 *) 0x20028A)->bit6
#define CAN_TXIPNDH_TXIPND23                 ((T_Reg16 *) 0x20028A)->bit7
#define CAN_TXIPNDH_TXIPND24                 ((T_Reg16 *) 0x20028A)->bit8
#define CAN_TXIPNDH_TXIPND25                 ((T_Reg16 *) 0x20028A)->bit9
#define CAN_TXIPNDH_TXIPND26                 ((T_Reg16 *) 0x20028A)->bit10
#define CAN_TXIPNDH_TXIPND27                 ((T_Reg16 *) 0x20028A)->bit11
#define CAN_TXIPNDH_TXIPND28                 ((T_Reg16 *) 0x20028A)->bit12
#define CAN_TXIPNDH_TXIPND29                 ((T_Reg16 *) 0x20028A)->bit13
#define CAN_TXIPNDH_TXIPND30                 ((T_Reg16 *) 0x20028A)->bit14
#define CAN_TXIPNDH_TXIPND31                 ((T_Reg16 *) 0x20028A)->bit15

#define CAN_TXIPNDL            (*((uword volatile far *) 0x200288))
#define CAN_TXIPNDL_TXIPND0                  ((T_Reg16 *) 0x200288)->bit0
#define CAN_TXIPNDL_TXIPND1                  ((T_Reg16 *) 0x200288)->bit1
#define CAN_TXIPNDL_TXIPND10                 ((T_Reg16 *) 0x200288)->bit10
#define CAN_TXIPNDL_TXIPND11                 ((T_Reg16 *) 0x200288)->bit11
#define CAN_TXIPNDL_TXIPND12                 ((T_Reg16 *) 0x200288)->bit12
#define CAN_TXIPNDL_TXIPND13                 ((T_Reg16 *) 0x200288)->bit13
#define CAN_TXIPNDL_TXIPND14                 ((T_Reg16 *) 0x200288)->bit14
#define CAN_TXIPNDL_TXIPND15                 ((T_Reg16 *) 0x200288)->bit15
#define CAN_TXIPNDL_TXIPND2                  ((T_Reg16 *) 0x200288)->bit2
#define CAN_TXIPNDL_TXIPND3                  ((T_Reg16 *) 0x200288)->bit3
#define CAN_TXIPNDL_TXIPND4                  ((T_Reg16 *) 0x200288)->bit4
#define CAN_TXIPNDL_TXIPND5                  ((T_Reg16 *) 0x200288)->bit5
#define CAN_TXIPNDL_TXIPND6                  ((T_Reg16 *) 0x200288)->bit6
#define CAN_TXIPNDL_TXIPND7                  ((T_Reg16 *) 0x200288)->bit7
#define CAN_TXIPNDL_TXIPND8                  ((T_Reg16 *) 0x200288)->bit8
#define CAN_TXIPNDL_TXIPND9                  ((T_Reg16 *) 0x200288)->bit9

//****************************************************************************
// @Typedefs
//****************************************************************************

typedef unsigned char  ubyte;    // 1 byte unsigned; prefix: ub 
typedef signed char    sbyte;    // 1 byte signed;   prefix: sb 
typedef unsigned int   uword;    // 2 byte unsigned; prefix: uw 
typedef signed int     sword;    // 2 byte signed;   prefix: sw 
typedef unsigned long  ulong;    // 4 byte unsigned; prefix: ul 
typedef signed long    slong;    // 4 byte signed;   prefix: sl 

typedef volatile struct
{
  unsigned int    bit0      : 1;
  unsigned int    bit1      : 1;
  unsigned int    bit2      : 1;
  unsigned int    bit3      : 1;
  unsigned int    bit4      : 1;
  unsigned int    bit5      : 1;
  unsigned int    bit6      : 1;
  unsigned int    bit7      : 1;
  unsigned int    bit8      : 1;
  unsigned int    bit9      : 1;
  unsigned int    bit10     : 1;
  unsigned int    bit11     : 1;
  unsigned int    bit12     : 1;
  unsigned int    bit13     : 1;
  unsigned int    bit14     : 1;
  unsigned int    bit15     : 1;
}  T_Reg16;

#endif  // ifndef _XC164_CAN
