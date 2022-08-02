function [monod,err] = issorted(fts)
%@FINTS/ISSORTED determines whether the dates and times of a FINTS object
%   are monotonically increasing (chronologically increasing).
%
%   MONOD = ISSORTED(FTS) will return 1 if the dates and times are
%   monotonically increasing or 0 if they are not.
%
%   See also @FINTS/SORTFTS.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.4.2.2 $   $Date: 2004/04/06 01:08:25 $

% Check to see if input is a FINTS object
if ~isa(fts,'fints')
    error('Input must be a FINTS object.');
end

% Check the object version
[ftsVersion,timeData] = fintsver(fts);
if ftsVersion == 1
    % Find any dates that are not monotonically increasing
    deltaDates = diff(fts.data{3});
    
    % Turn off backtrace
    wb = warning('off','backtrace');
    
    % Warn if old object is being displayed
    if ftsVersion == 1
        warning('Ftseries:issorted:ObjIsAnOldVersion', ...
            sprintf(['The FINTS object being referenced is an object of an old\n', ...
                'version of the Financial Time Series Toolbox. Some functionality\n', ...
                'of this version of the Financial Time Series Toolbox may not apply\n', ...
                'to this object. Please use the function @FINTS/FTSOLD2NEW to\n', ...
                'convert this object to a compatible version.\n']));
    end
    
    % Restore old backtrace state 
    warning(wb)
elseif ftsVersion == 2
    if timeData == 0
        % Find any dates that are not monotonically increasing
        deltaDates = diff(fts.data{3});
    elseif timeData == 1
        % Find any dates/times that are not monotonically increasing
        deltaDates = diff(fts.data{3} + fts.data{end});
    end
end

% Find a sign change
signChange = find(deltaDates < 0);

if ~isempty(signChange)
    monod = 0;
else
    monod = 1;
end

% [EOF]
