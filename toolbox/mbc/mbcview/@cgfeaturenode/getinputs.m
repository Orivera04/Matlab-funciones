function inputs=getinputs(node)
%GETINPUTS
%
%  INPUTS = GETINPUTS(NODE) returns an array of pointers to inports.
%  Primitive implementation using the getptrs method for now.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:22:48 $

d = getdata(node);
inputs = getinports(d.info);

m = d.get('model');
if ~isempty(m) & ~isempty(m.info)
    minputs = m.getinports;
    inputs = unique([inputs minputs]);
end

