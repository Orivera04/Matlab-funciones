function out = isempty(m)
%ISEMPTY cgmodexpr isempty method
%
%  BOOL = ISEMPTY(M);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:17 $

out = (isempty(m.model) || isempty(getinputs(m)));