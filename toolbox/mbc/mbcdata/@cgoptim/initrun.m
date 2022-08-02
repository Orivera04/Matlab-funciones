function [optim, anyds] = initrun(optim)
%INITRUN Perform intialization tasks for Optimization run routine
%
%  [OPTIM, ANYDS] = INITRUN(OPTIM)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:53:40 $ 

% Check to see if user quitted previous run through debug 
rstr = optim.running;
if ~isempty(rstr) & rstr.flag == 1
    optim.oppointLabels = {};
    optim.oppoints = [];
    optim.oppointValueLabels = {};
    % Tidy up spare pointer
    freeptr(rstr.pref);
end   

% Running flag - This allows us to determine whether the user has stopped
% their optimization prematurely thru debugging. If this is the case, then
% we will need to delete any temporary pointers
optim.running.flag = 1;
optim.running.pref = [];

datasets = optim.oppoints;
if isempty(datasets)
   anyds = false;
else
   anyds = true;
end

if ~anyds 
    % When no data set is specified, make a temporary one
    optim.oppointLabels = {'OperatingPointSet1'};
    optim.running.pref = xregpointer(cgoppoint);
    optim.oppoints = optim.running.pref;
    optim.oppointValues = {[]};
    optim.oppointValueLabels = {{}};
end



