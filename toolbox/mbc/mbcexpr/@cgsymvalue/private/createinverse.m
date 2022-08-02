function invObj = createinverse(objname, eqstr, invname)
%CREATEINVERSE Create the inverse formula object 
%
%  INVOBJ = CREATEINVERSE(NAME, EQSTR, INVANME) constructs an inline object
%  that is the inverse of the formula 'NAME = EQSTR' with respect to teh
%  variable named INVNAME.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:15:55 $ 

syminv = solve([objname ' = ', eqstr], invname);
if length(syminv)>1
    %Take first solution
    syminv = syminv(1);
end
invObj = vectorize(inline(syminv));