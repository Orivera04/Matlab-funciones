function  [map, newOrder] = DefineSweepSet(map, vars, Limits, REORDER, testnumAlias);
% SWEEPSET/DEFINESWEEPSET
% Sweeps= DEFINESWEEPSET(map,vars,Limits);
%
% -----------------------------------------------
% Setup a array for distinct sweeps.  Remember
% that US maps use one LOGNUM for several sweeps.
% -----------------------------------------------
%
% There is a special case variable name defined in this function - '#rec' - which
% represents grouping by record number. In this case only, the tolerance is taken as
% representing the constant number of records in each sweep. Reordering will still
% take place if requested.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:05:57 $

% Define the newOrder variable
newOrder = 1:size(map.data, 1);

% Nothing to reorder?
if isempty(map)
	return
end
% If we have no variables to define the test groupings then we treat the data as one big sweep
if isempty(vars)
	map.xregdataset = xregdataset(1,-1,size(map.data, 1));
	return
end
% Make sure the variables are a cell array
if ischar(vars)& ~iscell(vars)
	vars = {vars};
end

% Find out if '#rec' is in vars and remove the tolerance from limits
BREAK_ON_RECORD_NO = 0;
[s, recIndex] = intersect(vars, '#rec');
if ~isempty(recIndex)
	BREAK_ON_RECORD_NO = 1;
	recordsPerSweep = ceil(abs(Limits(recIndex)));
	vars(recIndex) = [];
	Limits(recIndex) = [];
end

% If we have a cell array of strings as vars then find their valid indices
if iscell(vars)
	% Get valid variable indicies by finding the valid names
	% Note that vars can contain invalid strings, which are ignored
	[ind, found] = find(map, vars);
	varIndex = found(found > 0);
	Limits = Limits(found > 0);
else
	varIndex = vars;
end

% What data are we going to split on
data = map.data(:, varIndex);

% Are we reordering
if nargin > 3 & REORDER
    % What about the old type of broken rordering - compatability with
    % prior releases must be ensured. We should only get here if an old
    % type of sweepsetfilter has been loaded.
    if ischar(REORDER)
        if strcmp(REORDER, 'OldReorder-ThisFieldShouldBeLogical')
            if nargin == 4
                [map, newOrder] = i_oldDefineSweepSet(map, vars, Limits, REORDER);
            else
                [map, newOrder] = i_oldDefineSweepSet(map, vars, Limits, REORDER, testnumAlias);
            end
            return
        else
            error('mbc:sweepset:InvalidArgument', 'The reorder field can only be a char array if an old type od sweepsetfilter is loaded');
        end
    end
    % Place the data into bins of width Limits and normalise down to
    % integers to do the binning
	bindata = floor((data - repmat(min(data),size(data,1),1))./repmat(Limits(:)',size(data,1),1));
    % Sort into order with the bins (note that sorting on like entries does
    % preseve order)
	[reorderedBinData, newOrder] = sortrows(bindata);
    % Re-index the sweepset
	S = substruct('()',{newOrder, ':'});
	map = subsref(map, S);
    % The data to split on is now the reordered Bin Data
	data = reorderedBinData;
    % Need to drop limits to unity since we have divided by them already
    Limits = ones(size(Limits));
end

if BREAK_ON_RECORD_NO
	SweepStart = 1:recordsPerSweep:map.nrec;
	SweepSizes = diff([SweepStart map.nrec+1]);
	stypes= -ones(length(SweepSizes), 1);
else
    % Find the differences between successive data points
	diffdata = diff(data, 1 ,1);
	% Find possible breaks (add 1's at each end to capture endpoints)
	f = find( [1 ;  any(abs(diffdata) >= repmat(Limits(:)',size(diffdata,1),1),2) ; 1] );
	
	SweepStart = f(1:end-1);
	SweepSizes = diff(f);

	if ~isempty(find(map,'M_TEST_TYPE'))
		stypes = map.data( SweepStart,find(map,'M_TEST_TYPE'));
	elseif ~isempty(find(map,'stype'))
		stypes = map.data( SweepStart,find(map,'stype'));
	else
		% can't find logno so make some defaults default lognos
		stypes= -ones(length(SweepSizes), 1);
	end
end
lognos = 1:length(SweepSizes);

% Has an alias for testnumber been supplied
if nargin > 4 
	if ischar(testnumAlias)
		testnumAlias = find(map, testnumAlias);
	end
	if ~isempty(testnumAlias) & testnumAlias(1) > 0
		lognos = map.data(SweepStart, testnumAlias(1));
	end
end

map.xregdataset = xregdataset(lognos,stypes,SweepSizes);




% --------------------------------------------------------------------
%
% LEGACY CODE TO DEAL WITH THE OLD REORDER BUG THAT IS FIXED FOR R13+
%
% --------------------------------------------------------------------
function  [map, newOrder] = i_oldDefineSweepSet(map, vars, Limits, REORDER, testnumAlias)
% SWEEPSET/DEFINESWEEPSET
% Sweeps= DEFINESWEEPSET(map,vars,Limits);
%
% -----------------------------------------------
% Setup a array for distinct sweeps.  Remember
% that US maps use one LOGNUM for several sweeps.
% -----------------------------------------------
%
% There is a special case variable name defined in this function - '#rec' - which
% represents grouping by record number. In this case only, the tolerance is taken as
% representing the constant number of records in each sweep. Reordering will still
% take place if requested.

% Define the newOrder variable
newOrder = 1:size(map.data, 1);

if isempty(map)
	return
end
% If we have no variables to define the test groupings then we treat the data as one big sweep
if isempty(vars)
	map.xregdataset = xregdataset(1,-1,size(map.data, 1));
	return
end
if ischar(vars)& ~iscell(vars)
	vars = {vars};
end

% Find out if '#rec' is in vars and remove the tolerance from limits
BREAK_ON_RECORD_NO = 0;
[s, recIndex] = intersect(vars, '#rec');
if ~isempty(recIndex)
	BREAK_ON_RECORD_NO = 1;
	recordsPerSweep = ceil(abs(Limits(recIndex)));
	vars(recIndex) = [];
	Limits(recIndex) = [];
end

% If we have a cell array of strings as vars then find their valid indices
if iscell(vars)
	% Get valid variable indicies by finding the valid names
	% Note that vars can contain invalid strings, which are ignored
	[ind, found] = find(map, vars);
	varIndex = found(found > 0);
	Limits = Limits(found > 0);
else
	varIndex = vars;
end

data = map.data(:, varIndex);

if nargin > 3 & REORDER
	bindata = (data - repmat(min(data),size(data,1),1))./repmat(Limits(:)',size(data,1),1);
	[a, newOrder] = sortrows(floor(bindata));
	S = substruct('()',{newOrder, ':'});
	map = subsref(map, S);
	data = map.data(:,varIndex);
end

if BREAK_ON_RECORD_NO
	SweepStart = 1:recordsPerSweep:map.nrec;
	SweepSizes = diff([SweepStart map.nrec+1]);
	stypes= -ones(length(SweepSizes), 1);
else
	diffdata = diff(data, 1 ,1);
	% find possible breaks (add 1's at each end to capture endpoints)
	f = find( [1 ;  any(abs(diffdata) > repmat(Limits(:)',size(diffdata,1),1),2) ; 1] );
	
	SweepStart = f(1:end-1);
	SweepSizes = diff(f);

	if ~isempty(find(map,'M_TEST_TYPE'))
		stypes = map.data( SweepStart,find(map,'M_TEST_TYPE'));
	elseif ~isempty(find(map,'stype'))
		stypes = map.data( SweepStart,find(map,'stype'));
	else
		% can't find logno so make some defaults default lognos
		stypes= -ones(length(SweepSizes), 1);
	end
end
lognos = 1:length(SweepSizes);

% Has an alias for testnumber been supplied
if nargin > 4 
	if ischar(testnumAlias)
		testnumAlias = find(map, testnumAlias);
	end
	if ~isempty(testnumAlias) & testnumAlias(1) > 0
		lognos = map.data(SweepStart, testnumAlias(1));
	end
end

map.xregdataset = xregdataset(lognos,stypes,SweepSizes);
