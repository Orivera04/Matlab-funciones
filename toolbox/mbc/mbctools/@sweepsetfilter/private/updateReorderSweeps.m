function [obj, ss] = updateReorderSweeps(obj, ss)
%UPDATEREORDERSWEEPS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:11:57 $

% Get the sweepset without sweep reordering
f = getFlags;

if nargin < 2
    ss = ApplyObject(obj, [f.APPLY_DATA f.APPLY_VARS f.APPLY_FILT f.APPLY_TEST]);
end

% Store to see if order is changed in the update process
INITIAL_order = obj.reorderSweeps;

% Make sure that the sweeps reordering is OK
if ~isempty(obj.reorderSweeps);
	% If the number of sweeps is less than or equal to the max in reorder then reset
	if size(ss, 3) < max(obj.reorderSweeps{1})
		obj.reorderSweeps = {};
	end
    % Apply the sweep reorder change
    ss = ApplyObject(obj, f.APPLY_REOR, ss);
end

% Has the order actually changed
if ~isidentical(obj.reorderSweeps, INITIAL_order)
    queueEvent(obj, 'ssfSweepOrderChanged');
end

% Now ensure that everyone knows the sweepsetfilter has changed - if we are
% an ssf this will update the cache, else it is upto derived classes to
% ensure that they make their changes and call the pUpdateSweepsetCache
% method
[obj, ss] = pSweepsetfilterChanged(obj, ss);

