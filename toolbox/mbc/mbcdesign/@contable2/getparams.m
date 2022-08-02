function p=getparams(c);
%GETPARAMS  Return parameters for object
%
%  S=GETPARAMS(C) returns a structure containing the parameters
%  for the constraint object C.  For contable1 objects the fields
%  are:
%       breakx:  vector
%       table:  vector
%       factors:  [N,M]
%       le:  0/1
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:59:03 $

p.breakx=c.breakcols;
p.breaky=c.breakrows;
p.table=c.table;
p.factors=c.factors;
p.le=c.le;
return