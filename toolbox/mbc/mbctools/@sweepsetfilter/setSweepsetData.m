function ssf= setSweepsetData(ssf,ss);
%SWWEEPSETFILTER/setSweepsetData

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:12:17 $

% Set the sweepset for the sweepsetfilter (This will trigger an UpdateAll in the
% sweepsetfilter and hence all relevent events will be triggered)
ssf = setSweepset(ssf, ss);
% Do we need to set any default test groupings?
if isempty(get(ssf, 'definetests'))
    % TO DO - Get these names from the user settings
    names = {'LOGNO' 'logno' 'TESTNUM' 'testnum'};
    [dummy, ind] = find(ss, names);
	% Remove the not found names
	ind = find(ind ~= -1);
	if ~isempty(ind)
        % Create the test definition structure - note use of eps rather
        % than zero since we require the change to be greater than or equal
        % to the tolerance
        testDefinition = struct('variable', names{ind(1)}, 'tolerance', eps, 'reorder', false, 'testnumAlias', names{ind(1)});
    else
        testDefinition = struct('variable', '#rec', 'tolerance', 1, 'reorder', false, 'testnumAlias', '');
    end
    % Add it to the 
    ssf = modifyTestDefinition(ssf, testDefinition);    
end
