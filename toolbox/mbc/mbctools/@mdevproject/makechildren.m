function presp=makechildren(MP,OpenDialog)
%MAKECHILDREN Create new child testplans
%
%  NEWP = MAKECHILDREN(PROJ) creates a new default testplan in the project.
%  NEWP = MAKECHILDREN(PROJ, OpenDialog) where OpenDialog is a boolean
%  flag, allows the optional display of a dialog that allows the user to
%  choose a new testplan type.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.4 $  $Date: 2004/02/09 08:03:39 $

if nargin<2
    OpenDialog=0;
end

if OpenDialog
    [T,ok]=xreg_tptemplates('create');
    if ok
        presp= xregpointer(T);
    else
        presp= xregpointer;
    end
else
    % default testplan
    m= model(MP);
    if isempty(m);
        m= xregcubic;
    end
    T= mdevtestplan('Testplan',m,-1);
    presp=address(T);
end

if presp~=0
    MP= AddChild(MP,presp);
end
