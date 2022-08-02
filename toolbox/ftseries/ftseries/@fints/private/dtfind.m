function ind = dtfind(wanted, theDates, theTimes)
%DTFIND finds index of date and time in the object.
%
%   WARNING: use this function at your own risk.
%
%   wanted   - serial date/time desired
%   theDates - serial dates only
%   theTimes - serial times only

%   Aurthor: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.2 $   $Date: 2002/01/18 21:50:43 $

% Get the date from the date and time
onlyDate = floor(wanted);

% Get the time from the date and time
onlyTime = wanted - onlyDate;

% Find data row idx'es
datarows = find(onlyDate == theDates);

% Check to see if the to date exists
if isempty(datarows)
    ind = [];
    return
end

% Get the correct datarows by comparing the serial dates/times.
% Comparing via a tolerance of 30 seconds.
tDiff = abs(onlyTime - theTimes(datarows));
wantedDatarowsLocation = tDiff < (30/60/60/24);  

idx = datarows(logical(wantedDatarowsLocation));

% Check to see if idx exists again
if isempty(idx)
    ind = [];
else
    ind = idx;
end