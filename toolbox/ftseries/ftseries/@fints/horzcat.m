function ftshc = horzcat(varargin)
%@FINTS/HORZCAT implements the horizontal concatenation of FINTS objects.  
%
%   HORZCAT merges the data columns of two or more financial time series
%   objects.  HORZCAT requires that all time series objects have the 
%   same exact dates and/or times.
%
%   The concatenation process will add a suffix to the current name(s) 
%   of the data series, if necessary.  It will add the suffixes when 
%   there is a multiple occurrence of the same data series names.  The 
%   suffix will bear the format '_<var_name><N>' where <var_name> is the 
%   name of the object variable name used during the concatenation call 
%   and N is a number indicating the position of the time series object 
%   in the input argument list (from left to right) on the concatenation 
%   command.  The N part will only appear if the variable name, 
%   <var_name> is the same.
%
%   For example:
%
%      myfts   = fints((today:today+4)', (1:5)',   'DataSeries', 'd');
%      yourfts = fints((today:today+4)', (11:15)', 'DataSeries', 'd');
%      anfts   = fints((today:today+4)', (21:25)', 'DataSeries', 'd');
%      newfts  = [myfts yourfts anfts yourfts];
%      fieldnames(newfts,1)
%
%   All input objects, myfts, yourfts, and anfts, contain a data series 
%   called 'DataSeries', the resulting object, newfts, will have 
%   data series names: DataSeries_myfts, DataSeries_yourfts2, 
%   DataSeries_anfts and DataSeries_yourfts4.  The execution of the 
%   codes above will produce the following result:
%
%      ans = 
%
%          'DataSeries_myfts'
%          'DataSeries_yourfts2'
%          'DataSeries_anfts'
%          'DataSeries_yourfts4'
%
%   If you want to change the data series names, you can use the command 
%   CHFIELD.
%
%   If all of your object's frequency indicators are the same, the new 
%   object will have that same frequency indicator.  However, if one of 
%   the objects concatenated has a different one than the other(s), the 
%   frequency of the resulting object will be set to 'Unknown' (0).
%
%   The description field will be concatenated as well.  They will be 
%   separated by '//' (double forwardslashes).
%
%   See also @FINTS/CHFIELD, @FINTS/FIELDNAMES, @FINTS/VERTCAT.

%   NOTE: This method is always called before VERTCAT.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.14.2.2 $   $Date: 2004/04/06 01:08:23 $

% Do the horizontal concatenation only if there is more than 1 element
% in a row (i.e. nargin > 1).  If there is only 1 element per row, just 
% pass it out immediately.
if nargin > 1
    
    % Check to see if the inputs are FINTS objects & check object version
    isFintTmp = [];
    ftsverTmp = [];
    timeDataTmp = [];
    holdVer1Counter = 0;
    for idx = 1:nargin
        % Check for FINTS
        isFint = isa(varargin{idx},'fints');
        isFintTmp = [isFintTmp; isFint];
        
        % Check for version
        [ftsVersion,timeData] = fintsver(varargin{idx});
        ftsverTmp = [ftsverTmp; ftsVersion];
        timeDataTmp = [timeDataTmp; timeData];
        
        % Convert each object if necessary and display warning msg later
        if ftsVersion == 1
            holdVer1Counter = holdVer1Counter + 1;
            w = warning('off');
            varargin{idx} = ftsold2new(varargin{idx});
            warning(w);
        end
    end
    
    if prod(double(isFintTmp)) == 0
        % Objects must all be of type FINTS
        error('Ftseries:ftseries_fints_horzcat:MustBeFints', ...
            'All inputs must be FINTS objects.');
    end
    
    if length(unique(timeDataTmp)) > 1
        % Cannot concatenate objects that have time to those without
        error('Ftseries:ftseries_fints_horzcat:MustAllContainOrNotContainTime', ...
            sprintf(['All time series objects must either contain or not\n', ...
                'contain time information.']));
    end
    
    % Check objects to make sure that they are compatible to be 
    % horizontally concatenated.  And, get all the input argument name(s).
    argname = cell(1, nargin);
    freqind = varargin{1}.data{2};
    for iaidx = 1:nargin
        if isempty(inputname(iaidx))
            argname{iaidx} = 'ans'; 
        else
            argname{iaidx} = inputname(iaidx); 
        end
        fts(iaidx) = varargin{iaidx};
        if ~isa(fts(iaidx), 'fints')
            error('Ftseries:ftseries_fints_horzcat:MustBeFints', ...
                'Objects to be concatenated must be of FINTS class.');
        end
        if iaidx~=1
            % Check next object in line
            if isempty(fts(iaidx).data{2}) | isempty(fts(iaidx-1).data{2})
                % Probably will not happen. I left this code in because it was legacy code.
                error('Ftseries:ftseries_fints_horzcat:MustSetFreq', ...
                    'Please set the frequencies of all of the objects.');
            elseif fts(iaidx).data{2} ~= freqind
                freqind = 0;
            end
            % Check for lengths and dates 
            if length(fts(iaidx).data{3})~=length(fts(iaidx-1).data{3})
                error('Ftseries:ftseries_fints_horzcat:MustBeSameLength', ...
                    'Objects must have the same lengths.');
            elseif any(~(fts(iaidx).data{3}==fts(iaidx-1).data{3}))
                error('Ftseries:ftseries_fints_horzcat:MustHaveSameDates', ...
                    'Objects must have the same dates.');
            end
        end
    end
    
    % Check if there are any variable name collisions.
    collision = 0;
    uniqarg = unique(argname);
    if length(uniqarg) ~= length(argname(:))
        collision = 1;
        vnameidx = getnameidx(uniqarg, argname);
        vnamecnt = hist(vnameidx, length(uniqarg));
    end
    
    % Count the occurences of data series names.
    namelist = [fts(:).names];
    namelist(find(getnameidx({'desc', 'freq', 'dates','times'}, namelist))) = '';
    uniqname = unique(namelist)';
    
    namecheck = zeros(nargin, length(uniqname));
    nameidx   = getnameidx(uniqname, namelist);
    namecnt   = hist(nameidx, length(uniqname));
    
    % Instantiate a new object (w/out times heading) and fill the contents
    ftshc = fints;
    ftshc.names = ftshc.names(1:end-1); % Add times heading later.
    
    for iaidx = 1:nargin
        ftshc.data{1} = [ftshc.data{1}, fts(iaidx).data{1}];
        if iaidx ~= nargin
            ftshc.data{1} = [ftshc.data{1}, ' // '];
        end
        
        % Determine the indices to names and data.
        if iaidx == 1
            namesstart = 4;
            namesend = 3 + length(fts(iaidx).names(4:end-1));
            
            datastart = 1;
            dataend = size(fts(iaidx).data{4},2);
        else
            namesstart = length(ftshc.names) + 1;
            namesend = length(ftshc.names) + length(fts(iaidx).names(4:end-1));
            
            datastart = size(ftshc.data{4}, 2) + 1;
            dataend = size(ftshc.data{4}, 2) + size(fts(iaidx).data{4},2);
        end
        
        nameidx = getnameidx(uniqname, fts(iaidx).names(4:end-1));
        
        namestat = namecnt(nameidx);
        suffix = cell(size(nameidx))';
        if collision
            vnameidx = getnameidx(uniqarg, argname{iaidx});
            vnamestat = vnamecnt(vnameidx);
            if vnamestat > 1
                suffix(find(namestat~=1)) = cellstr(repmat(['_', argname{iaidx}, num2str(iaidx)], length(find(namestat~=1)), 1));
            else
                suffix(find(namestat~=1)) = cellstr(repmat(['_', argname{iaidx}], length(find(namestat~=1)), 1));
            end
        else
            suffix(find(namestat~=1)) = cellstr(repmat(['_', argname{iaidx}], length(find(namestat~=1)), 1));
        end
        
        ftshc.names(namesstart:namesend) = strcat(fts(iaidx).names(4:end-1)', suffix);
        
        % Set the data
        ftshc.data{4}(:, datastart:dataend) = fts(iaidx).data{4}(:, 1:end);
    end % end of 'for iaidx = 1:nargin'
    
    % Add the 'times' column heading if FINTS objects are from FTS Version 2.0
    ftshc.names(length(ftshc.names)+1) = cellstr('times');
    
    % Fill the new object.
    ftshc.data{2}   = freqind;                  % Frequency
    ftshc.data{3}   = fts(1).data{3};           % Dates
    ftshc.data{end} = fts(1).data{end};         % Times
    ftshc.datacount = fts(1).datacount;         % data count
    ftshc.serscount = length(ftshc.names) - 4;  % series count
    
    % Turn off backtrace
    wb = warning('off','backtrace');
    
    % Display any warning messages
    if holdVer1Counter == nargin
        % All inputs are version 1.0/1.1 objects
        warning('Ftseries:ftseries_fints_horzcat:ObjsAllOldVersions', ...
            sprintf(['The FINTS objects being concatenated are ALL\n', ...
                'objects from an older version of the Financial Time\n', ...
                'Series Toolbox (1.0/1.1). The object created from the\n', ...
                'concatenation has been converted to an object\n', ...
                'compatible with the Financial Time Series Toolbox\n', ...
                'Version 2.0. Please save and use this new object. If\n', ...
                'you would like to update any existing old objects,\n', ...
                'please see the function @FINTS/FINTSVER and\n', ...
                '@FINTS/FTSOLD2NEW.\n']));
    elseif (holdVer1Counter < nargin) & (holdVer1Counter > 0)
        % Some inputs are version 1.0/1.1 objects and some are Version 2.0 objects
        warning('Ftseries:ftseries_fints_horzcat:SomeObjsOldVersions', ...
            sprintf(['SOME of the FINTS objects being concatenated\n', ...
                'are objects from an older version of the Financial\n', ...
                'Time Series Toolbox (1.0 or 1.1). The object created\n', ...
                'from the concatenation has been converted to an object\n', ...
                'compatible with the Financial Time Series Toolbox\n', ...
                'Version 2.0. Please save and use this new object.\n', ...
                'If you would like to update any existing old objects,\n', ...
                'please see the functions @FINTS/FINTSVER and\n', ...
                '@FINTS/FTSOLD2NEW.\n']));
    end
else
    % Check for version
    ftsVersion = fintsver(varargin{1});
    
    ftshc = varargin{1};
end % end of 'if nargin > 1'

% Sort it in case its not sorted. Dont sort if object is 0x0
if length(ftshc) ~= 0
    ftshc = sortfts(ftshc);
end

% Check to see if all the dates and times are monotonically increasing
w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
monoDHold = [];
for idx = 1:nargin
    monoDHold = [monoDHold;issorted(varargin{idx})];
end
if any(monoDHold) == 0
    monoD = 0;
else
    monoD = 1;
end
warning(w2);

% Turn off backtrace
wb = warning('off','backtrace');

if monoD ~= 1
    warning('Ftseries:ftseries_fints_horzcat:NonMonotonic', ...
        sprintf(['The dates and/or times in the referenced object\n', ...
            'were not monotonically increasing. It is recommended that\n', ...
            'all dates and/or times be in chronological order.\n']));
end

% Warn duplicate dates
% Note: Keep this warning as the last warning displayed.
if ftsVersion == 1
    % No time information from version 1.0/1.1
    if ftsuniq(ftshc.data{3}) == 0
        warning('Ftseries:ftseries_fints_horzcat:DuplicateDates', ...
            sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                'exist. FINTS objects must not contain duplicate dates. The\n', ...
                'function FTSUNIQ may be of assistance in determining which\n', ...
                'dates are duplicates.\n']));
    end
else
    if isempty(ftshc.data{5})
        % No time information from version 2.0
        if ftsuniq(ftshc.data{3}) == 0
            warning('Ftseries:ftseries_fints_horzcat:DuplicateDates', ...
                sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                    'exist. FINTS objects must not contain duplicate dates. The\n', ...
                    'function FTSUNIQ may be of assistance in determining which\n', ...
                    'dates are duplicates.\n']));
        end
    else
        % Contains time information from version 2.0
        if ftsuniq(ftshc.data{3}+ftshc.data{5}) == 0
            warning('Ftseries:ftseries_fints_horzcat:DuplicateDatesAndTimes', ...
                sprintf(['The dates and times in this object are not unique and\n', ...
                    'duplicate dates and times exist. FINTS objects must not\n', ...
                    'contain duplicate dates and times. The function FTSUNIQ\n', ...
                    'may be of assistance in determining which dates and times\n', ...
                    'are duplicates.\n']));
        end
    end
end

% Restore old backtrace state 
warning(wb)

% [EOF]
