function D = rename(D,name)
%% DYNAMIC/RENAME
%% change D.simName and D.xregusermod.funcName

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:59:02 $

D.simName = name;
nf=feval(name,D,'nfactors');
oldnf= length(get(D,'symbols'));
if nf~= oldnf;
    D.xregusermod= xregusermod;
    D.xregusermod = set(D.xregusermod, 'nfactors',nf);
end
D.xregusermod= rename(D.xregusermod,name);
