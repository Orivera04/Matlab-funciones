function [dd,ptr] = newformula(dd)
%NEWFORMULA Add a new formula to the browser
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:23:40 $

CGP = project(dd);
name='New_Formula';
name=uniquename(CGP,name);
SV = cgsymvalue;
SV = setname(SV, name);

pDD = address(dd);
[SV, ok] = editequation(SV, pDD);

if ok
    ptr = xregpointer(SV);
    pDD.add(ptr);
else
    ptr = xregpointer;
end
dd = pDD.info;