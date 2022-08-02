function m= saveobj(m);
%XREGUSERMOD/SAVEOBJ remove function handle from object to be saved

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:41 $

if ~ischar(m.funcName)
    m.funcName= func2str(m.funcName);
end
m.xregmodel= saveobj(m.xregmodel);
