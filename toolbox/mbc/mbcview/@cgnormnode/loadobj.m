function Node = loadobj(in)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:41 $

if isa(in,'struct')
    Node = cgnormnode;    
    Node.Data = [];
    Node.SFData = [];
    Managers.AutoSpaceManager = [];
    Managers.InitialisationManager = [];
    Managers.OptimisationManager = [];
    Node.Managers = Managers;
    Node.Version = 0;
    Node.cgcontainer = in.cgcontainer;
else
    Node = in;
end
return