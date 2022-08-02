function ftsvc = vertcat(varargin)
%@FINTS/VERTCAT implements the vertical concatenation of FINTS objects.  
%
%   VERTCAT adds data points to a time series object. Contrary to 
%   @FINTS/HORZCAT, the objects that are to be vertically 
%   concatenated must NOT have any duplicate dates and/or times, or
%   any overlapping dates and/or times.  
%
%   For example:
%
%      myfts   = fints((today:today+4)', (1:5)', 'DataSeries', 'd');
%      yourfts = fints((today+5:today+9)', (11:15)', 'DataSeries', 'd');
%      newfts1 = [myfts; yourfts];
%
%      myfts   = fints((today:today+4)', (1:5)', 'DataSeries', 'd');
%      hisfts  = fints((today+5:7:today+34)', (11:15)', 'DataSeries', 'w');
%      newfts2 = [myfts; hisfts];
%
%   If all of your object's frequency indicators are the same, the new 
%   object will have that same frequency indicator.  However, if one of 
%   the objects concatenated has a different FREQ than the other(s), the 
%   frequency of the resulting object will be set to 'Unknown' (0).  So, 
%   in the example above, newfts1 has a 'Daily' frequency while newfts2 
%   has 'Unknown' for frequency indicator.
%
%   The description field will be concatenated as well.  They will be 
%   separated by '||' (double vertical bars).
%
%   See also @FINTS/HORZCAT. 

%   NOTE: This method is always called after HORZCAT.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.14.2.2 $   $Date: 2004/04/06 01:09:39 $

% Turn off backtrace
wb = warning('off','backtrace');

% Do the vertical concatenation only if there is more than 1 element
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
        [ftsver,timeData] = fintsver(varargin{idx});
        ftsverTmp = [ftsverTmp; ftsver];
        timeDataTmp = [timeDataTmp; timeData];
        
        % Convert each object if necessary and display warning msg later
        if ftsver == 1
            holdVer1Counter = holdVer1Counter + 1;
            w = warning('off');
            varargin{idx} = ftsold2new(varargin{idx});
            warning(w);
        end
    end
    
    if prod(double(isFintTmp)) == 0
        % Objects must all be of type FINTS
        error('Ftseries:ftseries_fints_vertcat:MustBeFINTS', ...
            'All inputs must be FINTS objects.');
    end
    
    if length(unique(timeDataTmp)) > 1
        % Cannot concatenate objects that have time to those without
        error('Ftseries:ftseries_fints_vertcat:MustAllConatinOrNotContainTime', ...
            sprintf(['All time series objects must either contain or\n', ...
                'not contain time information.']));
    end
    
    % Check objects to make sure that they are compatible to be 
    % vertically cancatenated.
    freqind = varargin{1}.data{2};
    for iaidx = 1:nargin
        fts(iaidx) = varargin{iaidx};
        if ~isa(fts(iaidx), 'fints')
            error('Ftseries:ftseries_fints_vertcat:MustBeFINTS', ...
                'Objects to be concatenated must be of FINTS class.');
        elseif isempty(fts(iaidx).data{2})
            error('Ftseries:ftseries_fints_vertcat:SetFreq', ...
                'Please set the frequency of the objects.');
        end
        if iaidx~=1
            % Check next object in line
            if fts(iaidx).data{2} ~= freqind
                freqind = 0;
            end
            % Check repeated dates
            if length(fts(iaidx).data{3}) > length(fts(iaidx-1).data{3})
                if timeData == 0
                    % No time data
                    if ~isempty(datefind(fts(iaidx-1).data{3}, fts(iaidx).data{3}))
                        error('Ftseries:ftseries_fints_vertcat:OverlappingDates', ...
                            sprintf(['There may be some overlaping dates. Please use\n', ...
                                'FTSUNIQ to determine the dates that may be overlapping.']));
                    end
                else
                    % There is time data
                    if ~isempty(datefind((fts(iaidx-1).data{3} + fts(iaidx-1).data{5}), ...
                            (fts(iaidx).data{3}) + fts(iaidx).data{5}))
                        error('Ftseries:ftseries_fints_vertcat:OverlappingDatesAndTimes', ...
                            sprintf(['There may be some overlaping dates and times. Please use\n', ...
                                'FTSUNIQ to determine the dates and times that may\n', ...
                                'be overlapping.']));
                    end
                end
            elseif length(fts(iaidx).data{3}) < length(fts(iaidx-1).data{3})
                if timeData == 0
                    % No time data
                    if ~isempty(datefind(fts(iaidx).data{3}, fts(iaidx-1).data{3}))
                        error('Ftseries:ftseries_fints_vertcat:OverlappingDates', ...
                            sprintf(['There may be some overlaping dates. Please use\n', ...
                                'FTSUNIQ to determine the dates that may be overlapping.']));
                    end
                else
                    % There is time data
                    if ~isempty(datefind((fts(iaidx).data{3} + fts(iaidx).data{5}), ...
                            (fts(iaidx-1).data{3} + fts(iaidx-1).data{5})))
                        error('Ftseries:ftseries_fints_vertcat:OverlappingDatesAndTimes', ...
                            sprintf(['There may be some overlaping dates and times. Please use\n', ...
                                'FTSUNIQ to determine the dates and times that may\n', ...
                                'be overlapping.']));
                    end
                end
            elseif length(fts(iaidx).data{3}) == length(fts(iaidx-1).data{3})
                if timeData == 0
                    % No time data
                    if any(fts(iaidx).data{3} == fts(iaidx-1).data{3});
                        error('Ftseries:ftseries_fints_vertcat:MustNotHaveTheSameDates', ...
                            'Objects must NOT have the same dates.');
                    end
                else
                    % There is time data
                    if any((fts(iaidx).data{3} + fts(iaidx).data{5}) == (fts(iaidx-1).data{3} + fts(iaidx-1).data{5}))
                        error('Ftseries:ftseries_fints_vertcat:MustNotHaveTheSameDates', ...
                            'Objects must NOT have the same dates.');
                    end
                end
            end
            
            % Check for number of data series and data series names
            if fts(iaidx).serscount~=fts(iaidx-1).serscount
                error('Ftseries:ftseries_fints_vertcat:MustHaveTheSameNumOfSeries', ...
                    'Objects must have the same number data series.');
            elseif ~all(strcmp(fts(iaidx).names, fts(iaidx-1).names))
                error('Ftseries:ftseries_fints_vertcat:MustHaveTheSameSeriesNames', ...
                    'Objects must have the same data series names.');
            end
        end
    end
    
    % Instantiate a new object and fill the contents.
    ftsvc = fts(1);
    for iaidx = 2:nargin
        ftsvc.data{1} = [ftsvc.data{1}, ' || ', fts(iaidx).data{1}];
        
        ftsvc.data{3} = [ftsvc.data{3}; fts(iaidx).data{3}];
        ftsvc.data{4} = [ftsvc.data{4}; fts(iaidx).data{4}];
        ftsvc.data{5} = [ftsvc.data{5}; fts(iaidx).data{5}];
    end
    ftsvc.data{2} = freqind;
    ftsvc.datacount = size(ftsvc.data{3}, 1);
    
    % Sort it after the vert. concatenation. if object is 0x0 dont sort
    if length(ftsvc) ~= 0
        ftsvc = sortfts(ftsvc);
    end
    
    % Display any warning messages
    if holdVer1Counter == nargin
        % All inputs are version 1.0/1.1 objects
        warning('Ftseries:fints_vertcat:AllOldObjs', ...
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
        warning('Ftseries:fints_vertcat:SomeAreOldObjs', ...
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
    ftsvc = varargin{1};
end % end of 'if nargin > 1'

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
end%monoD = issorted(ftsvc);
warning(w2);

% Turn it off again (was turned on by the previous warning call)
wb = warning('off','backtrace');

if monoD ~= 1
    warning('Ftseries:fints_vertcat:NonMonotonic', ...
        sprintf(['The dates and/or times in the referenced object\n', ...
            'were not monotonically increasing. It is recommended that\n', ...
            'all dates and/or times be in chronological order.\n']));
end

% Warn duplicate dates
% Note: Keep this warning as the last warning displayed.
if isempty(ftsvc.data{5})
    % No time information
    if ftsuniq(ftsvc.data{3}) == 0
        warning('Ftseries:fints_vertcat:DuplicateDates', ...
            sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                'exist. FINTS objects must not contain duplicate dates. The\n', ...
                'function FTSUNIQ may be of assistance in determining which\n', ...
                'dates are duplicates.\n']));
    end
else
    % Contains time information
    if ftsuniq(ftsvc.data{3} + ftsvc.data{5}) == 0
        warning('Ftseries:fints_vertcat:DuplicateDatesAndTimes', ...
            sprintf(['The dates and times in this object are not unique and\n', ...
                'duplicate dates and times exist. FINTS objects must not\n', ...
                'contain duplicate dates and times. The function FTSUNIQ\n', ...
                'may be of assistance in determining which dates and times\n', ...
                'are duplicates.\n']));
    end
end

% Restore old backtrace state 
warning(wb)

% [EOF]
