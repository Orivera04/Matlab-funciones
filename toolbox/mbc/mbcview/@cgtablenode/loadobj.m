function Node = loadobj(in)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:29:52 $

if isa(in,'struct')
    Node = cgtablenode;    
    Node.Data = [];
    Managers.InitialisationManager = [];
    Managers.FillManager = [];
    Managers.OptimisationManager = [];
    Node.Managers = Managers;
    Node.Version = 0;
    Node.InversionData = [];
    Node.cgcontainer = in.cgcontainer;
else
    Node = in;
end
return