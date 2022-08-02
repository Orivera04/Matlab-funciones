function [foptsOut]= foptions(U,fopts);
%XREGUSERMOD/FOPTIONS 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:09 $

foptsOut= feval(U.funcName,U,'foptions',fopts);
if isempty(foptsOut)
   foptsOut= fopts;
end
   