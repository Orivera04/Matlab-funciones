function [ftsver,ftsdata5] = fintsver(fts)
%@FINTS/FINTSVER determines the version of the FTS object.
%
%   FTSVER = FINTSVER(FTS) determines if the FTS is an object from the 
%   Financial Time Series Toolbox Version 2.0 or earlier. FTSVER == 1
%   indicates that the FTS is an object from a previous version of the
%   Financial Time Series Toolbox Version 1.0 or 1.1. FTSVER == 2
%   indicates that the FTS is an object from Version 2 of the toolbox.
%
%   [FTSVER,TIMEDATA] = FINTSVER(FTS) returns whether or not the there is
%   time information in the object. TIMEDATA == 0 means there is no time
%   information, and TIMEDATA == 1 means that there is time information.

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.2 $   $Date: 2002/01/18 21:50:46 $

% Check to see if input is a FINTS object
if ~isa(fts,'fints')
    error('Ftseries:fintsver:InputMustBeAFints', ...
        'Input must be a FINTS object.');
end

% Check to see if there is time data. Old objects did not have fts.data{5}.
% If an error occurs, then the FTS object is an old version from a FTS
% Toolbox prior to version 2.0.
try
    if isempty(fts.data{5})
        % New fts object
        ftsver = 2;
        % No time data
        ftsdata5 = 0;
    else
        % New fts object
        ftsver = 2;
        % There is time data
        ftsdata5 = 1;
    end
catch
    % Old fts object
    ftsver = 1;
    % No time data
    ftsdata5 = 0;
end

% [EOF]