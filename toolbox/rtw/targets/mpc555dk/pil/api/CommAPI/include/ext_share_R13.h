/* File: ext_share.h
 * Absract:
 *	External mode shared data structures used by the external communication
 *	mex link, the generated code, and Simulink.
 *
 * Copyright 1994-2003 The MathWorks, Inc.
 *
 * $Revision: 1.1.6.2 $
 */

#ifndef __EXTSHARE__
#define __EXTSHARE__

typedef enum { 
    /*================================
     * Messages/actions to target.
     *==============================*/

    /* connection actions */
    EXT_CONNECT,
    EXT_DISCONNECT_REQUEST,
    EXT_DISCONNECT_CONFIRMED,

    /* parameter upload/download actions */
    EXT_SETPARAM,
    EXT_GETPARAMS,

    /* data upload actions */
    EXT_SELECT_SIGNALS,
    EXT_SELECT_TRIGGER,
    EXT_ARM_TRIGGER,
    EXT_CANCEL_LOGGING,
    EXT_CHECK_UPLOAD_DATA,

    /* model control actions */
    EXT_MODEL_START,
    EXT_MODEL_STOP,
    EXT_MODEL_PAUSE,
    EXT_MODEL_STEP,
    EXT_MODEL_CONTINUE,

    /* data request actions */
    EXT_GET_TIME,

    /*================================
     * Messages/actions from target.
     *==============================*/
    
    /* responses */
    EXT_CONNECT_RESPONSE,   /* must not be 0! */
    EXT_DISCONNECT_REQUEST_RESPONSE,
    EXT_SETPARAM_RESPONSE,
    EXT_GETPARAMS_RESPONSE,
    EXT_MODEL_SHUTDOWN,
    EXT_MODEL_SHUTDOWN_DATA_PENDING,
    EXT_GET_TIME_RESPONSE,
    EXT_MODEL_START_RESPONSE,
    EXT_MODEL_PAUSE_RESPONSE,
    EXT_MODEL_STEP_RESPONSE,
    EXT_MODEL_CONTINUE_RESPONSE,


    EXTENDED = 255          /* reserved for extending beyond 254 ID's */
} ExtModeAction;


typedef enum {
  LittleEndian,
  BigEndian
} MachByteOrder;

#ifndef TARGETSIMSTATUS_DEFINED
#define TARGETSIMSTATUS_DEFINED
typedef enum {
    TARGET_STATUS_NOT_CONNECTED,
    TARGET_STATUS_WAITING_TO_START,
    TARGET_STATUS_STARTING, /* in the process of starting - host waiting 
                               for confirmation */

    TARGET_STATUS_RUNNING,
    TARGET_STATUS_PAUSED
} TargetSimStatus;
#endif

/*
 * The message header used for the message socket consists of 2 32 bit
 * unsigned ints [size, type].  size is the number of bytes coming after
 * the header.  It is always expressed in target bytes.
 */
typedef struct MsgHeader_tag {
    uint32_T type;  /* message type */
    uint32_T size;  /* number of bytes */
} MsgHeader;
#define NUM_HDR_ELS (2)

#ifndef FALSE
enum {FALSE, TRUE};
#endif

#define NO_ERR (0)

#define EXT_NO_ERROR ((boolean_T)(0))
#define EXT_ERROR ((boolean_T)(1))

typedef enum {
    UPMSG_PRETRIG_FIRST_DATA_PT, /* first pre-trig point       */ /* xxx need? */
    UPMSG_PRETRIG_DATA_PT,       /* other pre-trig point       */ 
    UPMSG_FIRST_DATA_PT,         /* first post trig data point */ /* xxx need? */
    UPMSG_DATA_PT,               /* other post-trig data point */

    /*
     * This message is sent from the target to signal the end of a data
     * collection event (e.g., each time that the duration is reached).
     * This message only applies to normal mode (see
     * UPMSG_TERMINATE_LOG_SESSION)
     */
    UPMSG_TERMINATE_LOG_EVENT,     

    /*
     * This message is sent from the target at the end of each data logging
     * session.  This occurs either at the end of a oneshot or at the end
     * of normal mode (i.e., the last in a series of oneshots).
     */
    UPMSG_TERMINATE_LOG_SESSION

} UploadMsgType;

#define UNKNOWN_BYTES_NEEDED (-1)

#define PRIVATE static
#define PUBLIC

#endif /* __EXTSHARE__ */
