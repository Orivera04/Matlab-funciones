/* mpc5xx.h
 *
 * Single header file included to allow switching between processor types
 * without changing the source files as simple as possible.
 *
 * Copyright 2003 The MathWorks, Inc.
 *
 * $Version: $ $Date: 2004/04/19 01:24:48 $
 * */
#ifndef _MPC5XX_H_
#define _MPC5XX_H_

#undef __VARIANT__


#ifdef MPC533_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc533.h"
#endif

#ifdef MPC534_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc533.h"
#endif

#ifdef MPC535_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc535.h"
#endif

#ifdef MPC536_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc535.h"
#endif

#ifdef MPC555_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc555.h"
#endif

#ifdef MPC561_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc561.h"
#endif

#ifdef MPC562_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc561.h"
#endif

#ifdef MPC563_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc563.h"
#endif

#ifdef MPC564_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc563.h"
#endif

#ifdef MPC565_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc565.h"
#endif

#ifdef MPC566_VARIANT
#ifdef __VARIANT__
#error MPC5<XX>_VARIANT defined for more than one <XX>. Check your compiler flags.
#endif
#define __VARIANT__
#include "mpc565.h"
#endif

#ifndef __VARIANT__
#error MPC5<XX>_VARIANT not defined. Please define MPC5<XX>_VARIANT to choose \
	    the processor type to build against.
#endif

#endif
