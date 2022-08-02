function chartOut = mpt_temp_promote(chartIn)
%MPT_TEMP_PROMOTE function determines when temps are promoted to filescope
%
%   [CHARTOUT]= MPT_TEMP_PROMOTE(CHARTIN)
%   This function determines when a temporary variable in stateflow is
%   promoted to a filescope variable to support various optimizations.
%   This function determines when the promotion has occured and remapps the
%   promoted variable to be a Local (filescope) so that MPT knows when to
%   provide a declaration in the generated file.
%
%   Inputs:
%            chartIn :  Chart data structure input to the function.  
%
%   Output:
%            chartOut : Chart data structure output that has the promoted
%                       variables recategorized for follow on processing


%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/04/15 00:28:37 $
%   $ Date:  $ $ Revision:  $
%

%
% Set teh default condition of the cart pass through
%

chartOut =  chartIn;

%
% Clear the promotion determination flag
%

statePresent = 0;

%
% Check for presence of state(s) in the chart as the means of determining
% if a promotion is required.
%

for i=1:length(chartIn.stateTree)
    if strcmp(chartIn.stateTree{i}.stateType,'AndState')==1 | strcmp(chartIn.stateTree{i}.stateType,'OrState')==1,
        statePresent = 1;
    end
end

%
% If promotion is required remap temporaries to local for that chart
%

if statePresent == 1,
   for itx=1:length(chartIn.temporary)
        chartIn.local{end+1} = chartIn.temporary{itx};
        chartIn.local{end}.scope='LOCAL';
   end
   chartIn.temporary =[];
end

%
% At the end make the final assignment for correct output.
%

chartOut = chartIn;


return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%