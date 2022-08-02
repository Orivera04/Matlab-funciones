# File : dep_template.mk
#
# Abstract : Used by makedepend to ensure that if a header file is deleted it is not attempted to be remade
#
# $Revision: 1.1 $
# $Date: 2002/09/13 09:03:35 $
#
# Copyright 2002 The MathWorks, Inc.

#
#
.PHONY : %.h %.hpp

