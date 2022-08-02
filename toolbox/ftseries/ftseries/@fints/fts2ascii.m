function stat = fts2ascii(fname, fts, exttext)
%@FINTS/FTS2ASCII writes a FINTS object into an ASCII file.
%
%   STAT = FTS2ASCII(FILENAME, FTS) writes the financial time 
%   series object, FTS, into a text (ASCII) file named FILENAME.
%   STAT indicates whether it's successful (1) or not (0).
%
%   STAT = FTS2ASCII(FILENAME, FTS, EXTTEXT) writes the contents
%   of the object FINTS into the text file FILENAME with an added
%   text description.  EXTTEXT is an optional argument for extra 
%   description  The EXTTEXT will appear on the line immediately 
%   after the description line (line 2).
%
%   The data in the file will be TAB-delimited.
%
%   See also ASCII2FTS.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.9.2.2 $   $Date: 2004/04/06 01:08:20 $

% Check input argument.
stat = 0;
switch nargin
    % Case 1 is covered by the FTS2ASCII (this function is @FINTS/FTS2ASCII) 
case 2
    exttext = '';
    stat = 1;
case 3
    stat = 1;
otherwise
    error('Ftseries:fints_fts2ascii:TooManyInputs', ...
        'Too many arguments. Three input arguments is the maximum allowed.');
end

% Check and convert old fts object from old to new
% Although ftsold2new calls fintsver, I still need to call fintsver
% to get the version number 
[ftsVersion,timeData] = fintsver(fts);
w = warning('off');
fts = ftsold2new(fts);
warning(w);

% Turn off backtrace
wb = warning('off','backtrace');

% Warn of object conversion
if ftsVersion == 1
    warning('Ftseries:fints_fts2ascii:ObjConverted', ...
        sprintf(['The FINTS object being written is an object\n', ...
            'of an old version of the Financial Time Series Toolbox.\n', ...
            'Some functionality of this version of the Financial\n', ...
            'Time Series Toolbox (v2.0) may not apply to this object.\n', ...
            'Please convert the object to a compatible version and\n', ...
            'use it when using the Financial Time Series Toolbox\n', ...
            'Version 2.0. Please see the function @FINTS/FTSOLD2NEW.\n']));
end

% Check to see if all the dates and times are monotonically increasing
w2 = warning('off'); % This is necessary due to a duplicate warning msg in ISSORTED
monoD = issorted(fts);
warning(w2);

% Turn it off again (was turned on by the previous warning call)
wb = warning('off','backtrace');

if monoD ~= 1
    fts = sortfts(fts);
    warning('Ftseries:fints_fts2ascii:NonMonotonic', ...
        sprintf(['The dates and/or times in the referenced object\n', ...
            'were not monotonically increasing. It is recommended that\n', ...
            'all dates and/or times be in chronological order.\n']));
end

% Restore old backtrace state 
warning(wb)

% Create column headers in the right order
if timeData == 1
    % There is time data
    colHead = [fts.names(3) fts.names(end) fts.names(4:end-1)];
    
    % Call the other FTS2ASCII.
    stat = fts2ascii(fname, [fts.data{3} fts.data{5}], fts.data{4}, colHead, ...
        fts.data{1}, exttext);
else
    % There is no time data
    colHead = fts.names(3:end-1);
    
    % Call the other FTS2ASCII.
    stat = fts2ascii(fname, fts.data{3}, fts.data{4}, colHead, ...
        fts.data{1}, exttext);
end

% [EOF]
