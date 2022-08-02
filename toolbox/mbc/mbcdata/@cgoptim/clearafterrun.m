function optim = clearafterrun(optim)
%CLEARAFTERRUN Perform post-optimization run tasks
%
%  OPTIM = CLEARAFTERRUN(OPTIM)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:02 $ 

rstr = optim.running;

% Free off any temporary pointers
if ~isempty(rstr.pref)
    optim.oppointLabels = {};
    optim.oppoints = [];
    optim.oppointValueLabels = {};
    freeptr(rstr.pref);
end
rstr.flag = 0;
rstr.pref = [];
optim.running = rstr;

