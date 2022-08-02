function empty=isempty(m)
%ISEMPTY
%
%  empty = ISEMPTY(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:35 $

inputs = getinputs(m);
empty = ~isvalid(inputs(1)) || length(inputs)==1;