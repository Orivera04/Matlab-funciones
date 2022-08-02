function out = isempty(f)
%ISEMPTY Cguncexpr isempty method.
%
%  boolean = ISEMPTY(f);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:02 $

if isempty(f.function) || isempty(getinputs(f))
   out = 1;
else
   out = 0;
end