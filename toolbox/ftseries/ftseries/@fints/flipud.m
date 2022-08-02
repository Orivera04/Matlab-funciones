function fts = flipud(ftsa)
% FLIPUD Overloaded for FINTS objects: flip data in up/down direction.
%
%   NOTE: This function is obsolete and will be removed in future versions
%   of the Financial Time Series Toolbox. 
%
%   FTS = FLIPUD(FTSA) flips the data in the FINTS object FTSA in the 
%   up/down direction.  The result is in another FINTS object FTS which 
%   contains the same data series names as FTSA.
%
%   Example:   load disney
%              flup_dis = flipud(dis);
%              plot(flup_dis);

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/04/14 16:31:15 $

% Warn that this function will be obsolete and removed.
warning('Ftseries:fints_flipud:ObsoleteAndWillBeRemoved', ...
    sprintf(['This function is obsolete and will be removed in future\n', ...
        'versions of the Financial Time Series Toolbox.\n']));

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts.
end

fts = ftsa;

fts.data{1} = ['FLIPUD of ', ftsa.data{1}];

fts.data{3} = [flipud(ftsa.data{3})];   % dates
fts.data{4} = [flipud(ftsa.data{4})];   % data
fts.data{5} = [flipud(ftsa.data{5})];   % times

% [EOF]
