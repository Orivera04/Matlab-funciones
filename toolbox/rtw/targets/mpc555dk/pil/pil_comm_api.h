/*
 * File: pil_comm_api.h
 *
 * Abstract:
 *   Provide high level access routines for interfacing Processor in the
 *   loop to the CommAPI subsystem.
 *
 *
 * $Revision: 1.13.4.2 $
 * $Date: 2004/04/19 01:28:09 $
 *
 * Copyright 2001-2003 The MathWorks, Inc.
 */

#if !defined(PIL_COMM_API_h)
#define PIL_COMM_API_h

#ifdef __cplusplus 
#define EXTERN_C extern "C" 
#else
#define EXTERN_C extern
#endif

#define POSIX_SUCCESS 0

#define USE_NACKS

typedef enum PacketTypes_tag
{
/*
  PacketType definitions are tied directly to PacketStats logging. Any 
  changes to this enum must also be reflected in the PacketStats
  typedef.
 */
   UNDEFINED_PACKET=0,
   TERMINATE_PACKET,
   INIT_PACKET,
   STEP_PACKET,
   UDATA_PACKET,
   YDATA_PACKET,
   ANNO_PACKET,
   DSR_PACKET,
   MODEL_CHECKSUM_PACKET,
   ACK_PACKET,
/* Code dependencies rely in NACK_PACKET being the last defined packet type. */
   NACK_PACKET
} PacketTypeEnum;

typedef struct PacketStats_tag {
/*
  PacketStats is accessed as an indexed array of integers using 
  PacketTypes for the index. Further, it has additional counters for
  unhandled and total packets. This imposes that the order and size be
  directly related to the PacketTypes enum.
 */
    int Undefined;
    int Terminate;
    int Init;
    int Step;
    int Udata;
    int Ydata;
    int Announce;
    int DSR;
    int Checksum;
    int Ack;
    int Nack;
    int Unhandled;
    int Total;
}  PacketStats;

#if 0
typedef struct PacketStruct_tag {
  int   Type;
  int   DataSize;
  char *Data;
  char  DataBuff[];
} PacketStruct;
#else
typedef char PacketStruct;
#endif

#ifndef COMMAPI_h
#ifndef SFCONNECTOR_h
typedef void SFConnector;
#endif
#endif

typedef enum ModelState_tag {
    WaitForInit,
    WaitForData,
    WaitForStep,
    Processing
} ModelStateEnum;

typedef enum CommState_tag {
    WaitingForConnection,
    ConnectionOpen,
    WaitingForData,
    WaitForPacket,
    ProcessingPacket,
    SendingPacket
} CommStateEnum;

EXTERN_C ModelStateEnum ModelState;
EXTERN_C SFConnector *ptrConnector;

extern PacketStats TxPackets;
extern PacketStats TxPacketsBad;
extern PacketStats RxPackets;
extern PacketStats RxPacketsBad;

/* Functions */
#ifdef __cplusplus
#define PORT_HEAD EXTERN_C __declspec(dllexport)
#else
#define PORT_HEAD EXTERN_C 
#endif

PORT_HEAD void CommClearPacketStats(PacketStats *PacketStatRec);
PORT_HEAD void CommLogPacket(PacketStats *PacketStatRec, int PacketType);
PORT_HEAD  int CommGetPacket(PacketStruct **OutPacket, int *BufferSize);
PORT_HEAD  int CommSendPacket(PacketStruct *OutPacket, int PacketSize, PacketTypeEnum PacketType);
PORT_HEAD  int CommSendStep(void);
PORT_HEAD  int CommSendTerminate(void);
PORT_HEAD  int CommSendInit(void);
PORT_HEAD void CommStep(void);
PORT_HEAD void CommInit(int initarg);
PORT_HEAD void CommTerminate(void);
PORT_HEAD  int CommReleaseCommChannel(void *ptrConnector);
PORT_HEAD  bool CommWaitForConnection(int port);
PORT_HEAD bool CommIsSameEndian(void);
PORT_HEAD char CommGetPacketType(void);

PORT_HEAD  int CommSendACK();
PORT_HEAD  int CommSendNACK();
PORT_HEAD int CommDSRSendPacket(PacketStruct *OutPacket, int PacketSize, PacketTypeEnum PacketType);
PORT_HEAD int CommDSRSendStep(void);
PORT_HEAD int CommDSRSendInit(void);
PORT_HEAD int CommDSRGetPacketNoACK(PacketStruct **OutPacket, int *BufferSize);

PORT_HEAD int CommErrorStatus(void);
PORT_HEAD bool UserStopSimulation(char *queryMSG);
PORT_HEAD void CloseUI(void);

#ifdef _WIN32
PORT_HEAD void set_tlc_callback(void *model_step, void *model_init_pil, void *model_init, \
		void *model_terminate_pil, void *model_terminate);
PORT_HEAD void set_tlc_RS232(unsigned long ulBaud, unsigned int uiBits, \
              unsigned int uiParity, unsigned int uiStop, unsigned int uiTimeout);
#endif

PORT_HEAD SFConnector *CommGetCommChannel(int port);
PORT_HEAD int CommGetPacketWithoutACK(PacketStruct **OutPacket, int *BufferSize);
PORT_HEAD int CommSendPacketWithACK(PacketStruct *OutPacket, int PacketSize, PacketTypeEnum PacketType);
PORT_HEAD int CommSendPacketWithoutACK(PacketStruct *OutPacket, int PacketSize, PacketTypeEnum PacketType);
PORT_HEAD unsigned long CommGetPacketSize(void);
PORT_HEAD char *CommGetPacketBuffer(void);
PORT_HEAD int CommPendingCString(SFConnector *ptrConnector, bool *pending, int timeoutSecs, int timeoutUSecs);

#endif /* !defined(PIL_COMM_API_h) */
/* End of file */   
