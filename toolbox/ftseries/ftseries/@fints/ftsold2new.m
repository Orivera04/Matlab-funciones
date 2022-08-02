function ftsn = ftsold2new(fts) 
%@FINTS/FTSOLD2NEW converts an FTS object from any Finanacial Time Series
%   Toolbox Version less than 2.0 to a Finanacial Time Series Toolbox 
%   Version 2.0 object.
%
%   FTSN = FTSOLD2NEW(FTS) converts the FTS object to a Finanacial Time
%   Series Toolbox Version 2.0 object.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.5.2.2 $   $Date: 2004/04/06 01:08:22 $

% Check version of the FTS object. If it is < ver. 2, convert it to
% a ver. 2 object.
ftsVersion = fintsver(fts);

if ftsVersion == 1
    fts.names{length(fts.names)+1} = 'times';
    fts.data{5} = [];
    
    % Turn off backtrace
    wb = warning('off','backtrace');
    
    % Warn users that object is different
    warning('Ftseries:ftsold2new:DifferentObjectVersions', ...
        sprintf(['The FINTS object being referenced is an object\n' ...
            'from an earlier version of the Financial Time Series\n', ...
            'Toolbox (1.0 or 1.1), and the object being displayed\n', ...
            'has been converted to an object compatible with the\n', ...
            'Financial Time Series Toolbox Version 2.0. Please\n', ...
            'save and use this new object instead of the older\n', ...
            'object. If you would like to update any existing old\n', ...
            'objects, please see the functions @FINTS/FINTSVER and\n', ...
            '@FINTS/FTSOLD2NEW.\n']));
    
    % Check to see if all the dates and times are monotonically increasing
    w1 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
    monoD = issorted(fts);
    warning(w1);
    
    % Turn it off again (was turned on by the previous warning call)
    wb = warning('off','backtrace');
    
    if monoD ~= 1
        fts = sortfts(fts);
        warning('Ftseries:ftsold2new:NonMonotonic', ...
            sprintf(['The dates and/or times in the referenced object\n', ...
                'were not monotonically increasing. It is recommended that\n', ...
                'all dates and/or times be in chronological order.\n']));
    end
    
    % Warn duplicate dates
    % Note: Keep this warning as the last warning displayed.
    if ftsuniq(fts.data{3}) == 0
        warning('Ftseries:ftsold2new:DuplicateDates', ...
            sprintf(['The dates in this object are not unique and duplicate dates\n', ...
                'exist. FINTS objects must not contain duplicate dates. The\n', ...
                'function FTSUNIQ may be of assistance in determining which\n', ...
                'dates are duplicates.\n']));
    end
    
    % Restore old backtrace state 
    warning(wb)
    
    % Create new FTS object
    ftsn = fts;
else
    
    % Check to see if all the dates and times are monotonically increasing
    w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
    monoD = issorted(fts);
    warning(w2);
    
    % Turn it off again (was turned on by the previous warning call)
    wb = warning('off','backtrace');
    
    if monoD ~= 1
        fts = sortfts(fts);
        warning('Ftseries:ftsold2new:NonMonotonic', ...
            sprintf(['The dates and/or times in the referenced object\n', ...
                'were not monotonically increasing. It is recommended that\n', ...
                'all dates and/or times be in chronological order.\n']));
    end
    
    % Restore old backtrace state 
    warning(wb)
    
    % Copy existing object into new FTS object
    ftsn = fts;
end

% [EOF]
