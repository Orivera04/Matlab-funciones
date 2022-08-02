function [ssf] = applyDefaultTestDefinition(ssf)
%APPLYDEFAULTTESTDEFINITION A short description of the function
%
%  SSF = APPLYDEFAULTTESTDEFINITION(SSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:08:35 $ 

% TO DO - Get these names from the user settings
names = {'LOGNO' 'logno' 'TESTNUM' 'testnum'};
[dummy, ind] = find(ssf, names);
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
