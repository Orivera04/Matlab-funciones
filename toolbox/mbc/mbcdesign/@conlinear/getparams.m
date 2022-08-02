function p=getparams(c);
%GETPARAMS  Return parameters for object
%
%  S=GETPARAMS(C) returns a structure containing the parameters
%  for the constraint object C.  For conlinear objects the fields
%  are:
%       A:  vector
%       b:  scalar
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:20 $

p.A=c.A;
p.b=c.b;
return