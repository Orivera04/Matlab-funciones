/*
* File: mpc555dk_init.h
*
* Abstract:
*   Declares that the section specifics for a function usr_init that enables
*   a user the insert initialization code at power up.
*
*   A user inluding this file must declare a function 
*
*   void usr_init(void)
*
* $Revision: 1.1 $
* $Date: 2002/09/13 09:03:26 $ 
*
* Copyright 2002 The MathWorks, Inc.
* */

#ifndef __MWERKS__
#pragma section INITIALIZATION ".usr_init" ".usr_init"
#pragma use_section INITIALIZATION usr_init
#else
#pragma section code_type ".usr_init" 
#endif
