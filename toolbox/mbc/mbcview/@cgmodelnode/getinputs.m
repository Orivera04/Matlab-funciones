function inputs=getinputs(node)
%GETINPUTS Return list of inputs
%
%  P = GETINPUTS(ND)  Returns an array of pointers to inports.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.4.2 $  $Date: 2004/02/09 08:24:23 $

d = getdata(node);
inputs = getinports(d.info);