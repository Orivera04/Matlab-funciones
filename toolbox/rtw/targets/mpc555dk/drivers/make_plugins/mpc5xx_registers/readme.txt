
              WELCOME to the MPC500 Header files

This is the README.TXT file for the m500r305.zip file. This file has everything
you need to start writing C programs for mpc500 parts except the compiler. It
defines all of the registers and bit fields for MPC500 devices.

Preliminary support for CodeWarrior Embedded PowerPC 5.0 has been added but it 
has not yet been fully tested.

There are 2 major changes from the old header files that were dedicated for each
part. The first change is that all of the parts have now been combined into one
file set and that there is only one way to use the files now. The different part
files were combined to make it easier for customers working with several of the
MPC500 devices. The different methods of using the files was removed because they
did not provide the performance boost as hoped.

This start-up pack has been setup using the Diab Data compiler, changes may
be needed for other compilers. This zip file contains the following files:

mpc555.h    -The header file for the MPC555 it defines all of the mpc555
             registers and bit fields in the registers.

mpc561.h    -The header file for the MPC561 it defines all of the mpc561
             registers and bit fields in the registers.

mpc563.h    -The header file for the MPC563 it defines all of the mpc563
             registers and bit fields in the registers.

mpc565.h    -The header file for the MPC565 it defines all of the mpc565
             registers and bit fields in the registers.

mpc533.h    -The header file for the MPC533 it defines all of the mpc533
             registers and bit fields in the registers.

mpc535.h    -The header file for the MPC535 it defines all of the mpc535
             registers and bit fields in the registers.

m_common.h  -Common type definitions and configuration.

m_flash.h   -Header file for the CMF FLASH modules.

m_qadc64.h  -Header file for all version of the QADC module.

m_qsmcm.h   -Header file for the QSMCM module.

m_mios.h    -Header file for all version of the MIOS module.

m_toucan.h  -Header file for the TOUCAN and DLCMD2 modules.

m_tpu3.h    -Header file for the TPU3 modules.

m_sram.h    -Header file for the SRAM modules.

m_dptram.h  -Header file for the DPTRAM module.

m_uimb.h    -Header file for the UIMB module.

m_usiu.h    -Header file for the USIU module.

mpc500.c    -This file contains general setup code for using the mpc500 devices.

samp555.c   -A sample program for the MPC555.

samp561.c   -A sample program for the MPC561.

samp563.c   -A sample program for the MPC563.

samp565.c   -A sample program for the MPC565.

makefile    -A makefile to build the three example programs. It requires a 
             make program.

ex_tbl.s   -This file contains the exception table definitions for MPC500
            devices. All exception routines are extern and imported to 
            this file.        

ex_tblc.s  -This file contains the reduced size exception table definitions
            for the MPC500 using the exception table relocation feature.
            All exception routines are extern and imported to this file.

ex_funcs.c -This file contains empty exception routines that are referenced 
            by the exception table file ex_tbl.s or ex_tblc.s. (This file
            mat need to be changed for a different compiler)

mpc500_util.c - This file contains the utility routine for modules like the
             TPU, etc. See AN2360 for full details.

mpc500_util.h - This file contains macros for modules like the TPU. See
             AN2360 for full details.

mpc500.dld  -This is a linker file for the mpc500. (This is specific
             to the Diab linker). 

crt0m500.s  -This is the file that configures the system and them calls the C
             main function. This is the standard file from Diab with a call to
             the mpc555 setup routine inserted. (This file will be different 
             for every compiler)

If you do not have a make program, try using GNU make. You can get GNU
make for windows at http://sourceware.cygnus.com/cygwin/ and for DOS at
http://www.delorie.com/djgpp/.

If you have any questions please feel free to contact me or send an email
to the MPC500 mailing list at MPC500@yahoogroups.com.

-Jeff
 13 Feb 2003





