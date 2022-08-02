function [dd,ptr] = newconstant(dd)
% CGDDNODE/NEWCONSTANT Add a new constant to the browser
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:23:39 $

CGP = project(dd);
name='New_Constant';
name=uniquename(CGP,name);
valobj = cgconstvalue;
valobj = setname(valobj, name);
valobj = setnomvalue(valobj, 1);
ptr = xregpointer(valobj);
add(dd, ptr);
dd = info(address(dd));