function [ssf, lChanges, nameMap] = pUpdateToValidNames(ssf, nameMap)
%PUPDATTOVALIDNAMES updates a sweepsetfilter to validmlnames from old format
%
%  [SSF, CHANGES, NAMEMAP] = MAKEVALIDNAMES(SSF, NAMEMAP)
%  
%  This function modifies the relevent pieces of a sweepsetfilter using the
%  NAMEMAP from a sweepset such that it all hooks together correctly.
%  Currently this only updates the filters, variables and defineTests
%  fields of the object, since the other fields were added with expression
%  checking in place.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/04/04 03:32:02 $ 

lChanges = false;
% Do we point at anything worth looking at?
if ~isvalid(ssf.pSweepset)
    return
end

% First check the variables for consistency with the underlieing sweepset
ssNames  = get(info(ssf.pSweepset), 'name');
lengthSS = length(ssNames);
ssfNames = get(ssf.variableSweepset, 'name');
[newNames, lChanges, ssfNameMap] = generateValidUniqueNames([ssNames ; ssfNames]);
% Check if any names changed in the sweepset (This shouldn't happen)
if any(lChanges(1:lengthSS))
    warning('mbc:sweepsetfilter:InvalidState', 'Name update encountered an non-uniquely named sweepset');
end
% Did any change affect the sweepset names
ssfChanges = lChanges(lengthSS+1:end);
if any(ssfChanges)
    % First update the appened sweepset
    ssf.variableSweepset = set(ssf.variableSweepset, 'name', newNames(lengthSS+1:end));
    % Change the names in the variables varName field
    [ssfNewNames, lChanged] = pUpdateToValidNames({ssf.variables.varName}, ssfNameMap);
    if lChanged
        [ssf.variables.varName] = deal(ssfNewNames{:});
    end
    % And finally update the name map
    nameMap = [nameMap ; ssfNameMap];
end

% Update the variable expressions
for i = 1:length(ssf.variables)
    % Only update variables without errors
    if ssf.variables(i).OK
        % Update the expression
        ssf.variables(i).varExp = updateExpression(ssf.variables(i).varExp, nameMap);
        % Update the variable string to reflect the change
        ssf.variables(i).varString = [ssf.variables(i).varName ' = ' ssf.variables(i).varExp];
        % Update the inline expression
        ssf.variables(i).inlineExp = vectorize(mbcinline(ssf.variables(i).varExp));
    end
end

% Update the filter expressions
for i = 1:length(ssf.filters)
    % Only update variables without errors
    if ssf.filters(i).OK
        % Update the expression
        ssf.filters(i).filterExp = updateExpression(ssf.filters(i).filterExp, nameMap);
        % Update the inline expression
        ssf.filters(i).inlineExp = vectorize(mbcinline(ssf.filters(i).filterExp));
    end
end

% Update the variables to keep
[ssf.variablesToKeep, varsChanged] = pUpdateToValidNames(ssf.variablesToKeep, nameMap);

% Update the test definitions
if ~isempty(ssf.defineTests)
    % Check the variables first
    ssf.defineTests.variable = pUpdateToValidNames(ssf.defineTests.variable, nameMap);
    % What about the test number alias - only update if it is a string
    if ischar(ssf.defineTests.testnumAlias)
        ssf.defineTests.testnumAlias = pUpdateToValidNames(ssf.defineTests.testnumAlias, nameMap);
    end
end

% Did we change the name map ?
lChanges = any(ssfChanges) || varsChanged;