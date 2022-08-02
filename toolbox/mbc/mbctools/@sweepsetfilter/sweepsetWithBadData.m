function [out, indexMap, ss] = sweepsetWithBadData(obj)
% SWEEPSETFILTER/SWEEPSETWITHBADDATA
%
% [badSS, INDEXMAP, SS] = sweepsetWithBadData(obj)
%
% returns a sweepset (badSS) that allows the user to see which records and tests
% were removed from the underlying sweepset. There is a distinct similarity
% between sweepset(obj) and sweepsetWithBadData(obj). The INDEXMAP output
% is intended to allow correct indexing between the 'good' sweepset (SS) and the
% 'bad' sweepset (badSS) in that sweep i in SS is sweep INDEXMAP(i) in badSS. Thus
% INDEXMAP should have the same number of entries as size(SS, 3) and not
% have a larger index value than size(badSS, 3)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:12:24 $

% What does the sweepsetfilter currently support
flags = obj.allowsFlag;

% Get the flag definitions
f = getFlags;

% Initialise the output object with a sweepset that has the desired data
% modifications and applied variables. Also get the actual sweepset version
% for use later.
out = ApplyObject(obj, [f.APPLY_DATA f.APPLY_VARS]);
ss  = ApplyObject(obj, [f.APPLY_FILT f.APPLY_TEST], out);
% Need a copy of out before it is modified for test grouping stuff
initialOut = out;

% All records being filtered will become NaN rather than being removed
% after the comparison with ss
if bitget(flags, f.APPLY_FILT) && ~isempty(obj.recordsToRemove)
	out(obj.recordsToRemove, :) = NaN;
end

% Change the test definitions - OK here's the difficult bit. We need to
% retain the same testnumbers as in ss but make the tsizes appropriate for
% the sweepset with bad data.
if  bitget(flags, f.APPLY_TEST) && ~isempty(obj.defineTests)
    if isReordered(obj)
        % Something different if the define tests reorders the data
        % - probably add the filtered data to the end of the sweepset and
        % carry out the reorder explicitly
        [sizes, testnum, type, reorder] = i_defineTestsWithReorder(obj, initialOut, ss);
        % Remember to reorder out
        out = out(reorder, :);
    else
        [sizes, testnum, type] = i_defineTestsWithoutReorder(obj, initialOut, ss);
        % Carry out the required reorder
    end
    % Apply the new tsizes and testnumbers to out
    out = pSetsizes(out, sizes, testnum, type);
end

% Fifth apply record and variable filters
if bitget(flags, f.APPLY_SFILT) && ~(isempty(obj.sweepsToRemove) && isempty(obj.variablesToKeep))
	out(:, :, obj.sweepsToRemove) = NaN;
end

% Note that indexMap must simply take into account the removed tests from
% the sweepset - so start with all the tests from ss which should be that
% same as or one less than the number of tests in out (see define with or
% without reorder.)
indexMap = 1:size(ss, 3);
if ~isempty(obj.sweepsToRemove)
    % Now remove the appropriate ones
    indexMap(obj.sweepsToRemove) = [];
end
if nargout > 2
    % Do this to the ss as well so we can pass on the current state of the good
    % and bad sweepsets.
    ss = ApplyObject(obj, [f.APPLY_SFILT], ss);
end

% NOTE THAT the output ss does not have any cascaded modifications as the
% derived classes of sweepsetfilter are expected to take ss as the output
% state of a call to sweepset(derivedClass.sweepsetfilter). This output is
% used to continue the calculation of sweepsetWithBadData

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function [sizes, testnums, types] = i_defineTestsWithoutReorder(obj, out, ss)
% What variables are available to try and guess the sweep grouping
CAN_GUESS_GROUP = ~isempty(obj.defineTests);
% Get the data for guessing
if CAN_GUESS_GROUP
    % Get the variables used for defining tests
    guessVariables = obj.defineTests.variable;
    % If the testnumAlias is a char then add that as well
    if ischar(obj.defineTests.testnumAlias)
        guessVariables{end+1} = obj.defineTests.testnumAlias;
    end
    % Do all the variables exist in the sweepset
    [dummy, variablesFound] = find(ss, guessVariables);
    % Remove those not found in ss
    variablesFound = variablesFound(variablesFound > 0);
    % Remove any duplicate variables
    variablesFound = unique(variablesFound);
    % Get the data from those variables for attempting to match tests
    dblMatchSS  = double(ss(:, variablesFound));
    dblMatchOut = double(out(:, variablesFound));
end
% Note - we know this array of indices is sorted but sort just for good
% measure
indexInOut = sort(obj.recordsToRemove);
% Which records in ss are the recordsToRemove located after
indexInSS = indexInOut - cumsum(sign(indexInOut));
% Get tsizes from ss, and the index in ss at which each sweep starts and
% ends
% Default oututs
testnums = testnum(ss);
types = type(ss);
sizes  = tsizes(ss);

starts = cumsum([1 sizes]);
ends   = starts(2:end) - 1;
numTests = length(sizes);
if numTests == 0
    return
end
% Deal specifically with those records before the first record in ss
sizes(1) = sizes(1) + sum(indexInSS == 0);
% Iterate over each test in ss and extend it's size appropriately
for i = 1:numTests    
    % Find the elements in indexInSS that are located between the start and
    % end of test i
    found = find(indexInSS >= starts(i) & indexInSS <= ends(i));
    % Iterate over the found records to decide in which sweep they should
    % be located
    for j = 1:length(found)
        % Where in the sweep is this record 
        if indexInSS(found(j)) < ends(i) | i == numTests
            % If it is not at the end, or this is the last sweep
            sizes(i) = sizes(i) + 1;
        else
            % Is it part of this sweep or the next - test by looking for
            % any equality between the match variables and the record it is
            % aligned against in SS           
            if any(dblMatchSS(indexInSS(found(j)),:) == dblMatchOut(indexInOut(found(j)), :))
                sizes(i) = sizes(i) + 1;
            else
                sizes(i+1) = sizes(i+1) + 1;
            end
        end
    end
end
% Check we haven't made a boo boo
if sum(sizes) ~= size(out, 1) | length(sizes) ~= size(ss, 3)
    error('mbc:sweepsetfilter:InvalidState', 'Something has gone wrong trying to compute the tsizes in sweepsetWithBadData');
end

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function [sizes, testnums, types, reorder] = i_defineTestsWithReorder(obj, out, ss)
% With a reorder we just append the extra records at the end of ss
sizes = [tsizes(ss) length(obj.recordsToRemove)];
testnums = [testnum(ss) 1];
types = [type(ss) 1];
% Work out the reorder of out
outGuids = getGuids(out);
ssGuids  = getGuids(ss);
newOrder = getIndices(outGuids, ssGuids);
% Remove the elements of newOrder that weren't found
newOrder(newOrder == 0) = [];
reorder = [newOrder ; obj.recordsToRemove(:)];
