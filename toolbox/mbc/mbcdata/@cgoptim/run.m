function [optim, output, OK, msg] = run(optim, anydsflag, dialogflag, CGBH)
%RUN Optimization bookkeeper class run routine
%
%  [OPTIM, OUTPUT, OK, MSG] = RUN(OPTIM, ANYDSFLAG, DLGFLAG, CGBH) Some help here
%  ...
%  This method now assumes that the Optimization contains a data set 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.6.1 $    $Date: 2004/02/09 06:53:50 $

% Prepares the data sets runs the optimization routine 
% Inputs:	Optim	:	Optimisation object
%    	Dialogflag	:	0 or 1 depending on whether the user should enter the constant values and
%             lower, upper and initial values through a gui dialog, or if these should be automatically set from the data dictionaty. 
% 			
% Outputs:	Optim	:	Updated optimisation object with lower and upper bounds stored in the optimisation manager (om.Constraints).
% 	      output	:	Structure or array of structures giving output diagnostic information. Each output field name and value will be displayed. An array of structures is used when the output information is different for each operating point set, and the number of structures must equal the number of points in the primary data set.  
% 	          OK	:	-1, 0 or 1. -1 = user cancelled from 'set constant
% 	          values' or 'free variable set up'. 0 = Optimization failure,
% 	          1 = Optimization success.
%           	Msg	:	Error message to display when OK = 0


if nargin < 3
    dialogflag = 1;
end

OK = 1;
output.cost = Inf;
msg = '';
datasets = optim.oppoints;

% Save the original datasets
saveddatasets = info(datasets);

OK = prepareDataSets(optim,dialogflag);
if ~OK
    passign(datasets, saveddatasets);
    OK = -1;
    optim.lastOK = -1;
    optim.lastErr = '';
    optim.diagStat = [];    
    return
end

[optim, x0, OK] = freeVariableSetUp(optim, dialogflag, anydsflag);
optim.x0 = x0;
if ~OK
    passign(datasets, saveddatasets);
    OK = -1;
    optim.lastOK = -1;
    optim.lastErr = '';
    optim.diagStat = [];
    return
end

% wrap cgoptim
cos = cgoptimstore(optim);

% perform some pre-run checks
[OK, msg] = checkrun(optim, 'runtime');

% run the optimisation if passed pre-run checking
if OK
    try
        om = optim.om;
        if nargin > 3
            CGBH.addTimedStatusMsg('Optimization started. Performing initial tasks...', 3);
        end
        cos = run(om, cos, x0, optim.fname);
        % Retrieve info
        [OK, msg, output] = getOutputInfo(cos);
    catch
        OK = 0;
        output.cost = Inf;
        msg = lasterr;
    end
end


if OK
    optim = get(cos,'cgoptim'); 
    
    % Addition for custom solutions. Any custom solutions stored by
    % optimisation should be deleted, as they will no longer make sense
    % after a new run
    optim.outputSelection = cgoptcsol;
end

passign(datasets, saveddatasets);

