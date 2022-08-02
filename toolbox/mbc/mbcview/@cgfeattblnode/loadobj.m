function Node = loadobj(in)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:00 $

if isa(in,'struct')
    Node = cgfeattblnode;    
    Node.SFData = [];
    Node.Version = 0;
    Node.cgtablenode = in.cgtablenode;
else
    Node = in;
end
return