function [obj, ss] = pUpdateCachedSweepset(obj, ss)
%PUPDATECACHEDSWEEPSET updates the cache and propogates to derived objects
%
%  [OBJ, SS] = PUPDATECACHEDSWEEPSET(OBJ, SS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:09:19 $ 

% Check what changes have been made to the sweepset as a result of the changes
if obj.allowsCacheing
    cachedSS = obj.cachedSweepset;
    % Check the double data
    sz = size(cachedSS);
    
    dblSS = double(ss);
    dblCachedSS = double(cachedSS);
    
    tsizesSS = tsizes(ss);
    tsizesCachedSS = tsizes(cachedSS);
    % Has the data changed? The data will have changed if any other
    % dimensions of the new data are smaller than the cached copy OR the
    % indexed subset of the new data is different to the cached copy OR the
    % sizes of any of the test have changed.
    if any(size(ss) < size(cachedSS)) || ...
            ~isidentical(dblCachedSS, dblSS(1:sz(1), 1:sz(2))) || ...
            ~isequal(tsizesCachedSS, tsizesSS(1:sz(3)))
        queueEvent(obj, 'ssDataChanged');
    end
    % Have the number of records changed
    if ~isequal(size(ss, 1), size(cachedSS, 1))
        queueEvent(obj, 'ssRecordsChanged');
    end
    % Have the variable names changed
    if ~isequal(get(ss, 'name'), get(cachedSS, 'name'))
        queueEvent(obj, 'ssNamesChanged');
    end
    % Have the units changed
    if ~isequal(get(ss, 'units'), get(cachedSS, 'units'))
        queueEvent(obj, 'ssUnitsChanged');
    end
    % Have the tests or testnums changed
    if ~(isequal(tsizesSS, tsizesCachedSS) && isidentical(testnum(ss), testnum(cachedSS)))
        queueEvent(obj, 'ssTestsChanged');
    end
    % TO DO - Add the ssFilenameChanged test and event in here.
else
    % Just post all allowed sweepset events
    queueEvent(obj, 'AllSweepsetEvents');
end

% At this point we can update the cached object because we have got a
% complete copy of the data object
if obj.allowsCacheing
    obj.cachedSweepset = ss;
end

% Now cascade the update to the sweep notes which are defined on the
% sweepset passed through whatever object this actually is
[obj, ss] = updateSweepNotes(obj, ss);