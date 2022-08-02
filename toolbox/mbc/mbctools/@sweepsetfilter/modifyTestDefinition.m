function [obj] = modifyTestDefinition(obj, newTest)
%MODIFYTESTDEFINITION chage test definition rules
%
%  OBJ = MODIFYTESTDEFINITION(OBJ, NEWTESTS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/04/04 03:32:01 $ 

if iscell(newTest) & length(newTest) == 4
	newTest = cell2struct(newTest(:), {'variable' 'tolerance' 'reorder' 'testnumAlias'});
end
test = [struct('variable',{},'tolerance',{}, 'reorder', {}, 'testnumAlias', {}) newTest];
% Ensure that variable is a cell array
if ischar(test.variable)
    test.variable = {test.variable};
end
% Test to see if we have changed the reorder flag - this is used to decide if we need
% to fire the ssfBadDataChangedEvent
BAD_DATA_CHANGED = false;
% When an ssf is created obj.defineTests is a 0x0 struct hence need to test empty
if ~isempty(obj.defineTests) && ~isequal(obj.defineTests.reorder, test.reorder)
    BAD_DATA_CHANGED = true;
end
% Update the object field
obj.defineTests = test;
% Ensure everything is up-to-date
obj = updateDefineTests(obj);
% Tell everyone that the tests have changed
queueEvent(obj, 'ssfTestDefinitionChanged');
if BAD_DATA_CHANGED
    queueEvent(obj, 'ssfBadDataChanged');    
end