function [noSecTime,idxNST,msg] = rmvsec(timeWSec)
%RMVSEC produces a list of indices where the first occurance of a certain
%   time or dates/times occurs. This function does so by sorting the list,
%   dropping the second data from the given times or dates/times, and then
%   finding the index of that number from the given list of times or
%   dates/times.
%
%   NOTE: noSecTime will contain date information if date information is
%         is provided in timeWSec.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $  $Date: 2004/04/06 01:09:33 $

% Variables
msg = '';

% Check input
if ~isnumeric(timeWSec)
    %'Ftseries:rmvsec:TimeMustBeNumeric'
    msg = 'Times must be a numeric column vector column vector.';
end

if size(timeWSec,2) == 1
    % Serial dates and/or times

    if sum(mod(timeWSec,1)) == 0
        % Dates only
        [datesOnly, datesOnlyIdx] = sort(timeWSec);
        [uniqDates,idxUD,j] = unique(datesOnly);
        for idxD = 1:length(uniqDates)
            holdD = uniqDates(idxD);

            % Get the correct datarows by comparing the serial dates/times.
            % Comparing via a tolerance of eps.
            dDiff = abs(holdD - datesOnly);
            wantedDatarowsLocation = dDiff < eps;
            wantedDatarowsIdx = datesOnlyIdx(logical(wantedDatarowsLocation));
            firstOccurD(idxD) = min(wantedDatarowsIdx);
        end

        % Get the dates from the original matrix.
        noSecTime = timeWSec(firstOccurD);
        % Get the corresponding index of these dates
        idxNST = firstOccurD;
    else
        % If dates/times as one serial number or just times

        % Get rid of seconds
        [Y,M,D,H,MI,S] = datevec(timeWSec);

        % Find where any 'S' = 60 and leave it the same.
        % This prevents rounding errors.
        roundedS = round(S);
        loc60 = find(roundedS == 60);
        S = zeros(length(Y),1);
        S(loc60) = 60;

        [noSecTime,idxNST] = parseYMDHMIS(Y,M,D,H,MI,S);
    end
else
    % YMDHMIS entry
    Y    = timeWSec(:,1);
    M    = timeWSec(:,2);
    D    = timeWSec(:,3);
    H    = timeWSec(:,4);
    MI   = timeWSec(:,5);
    S    = timeWSec(:,6);

    % Find where any 'S' = 60 and leave it the same.
    % This prevents rounding errors
    roundedS = round(S);
    loc60 = find(roundedS == 60);
    S = zeros(length(Y),1);
    S(loc60) = 60;

    [noSecTime,idxNST] = parseYMDHMIS(Y,M,D,H,MI,S);
end

% - parseYMDHMIS -------------------------------------------------------------
function [noSecTime,idxNST] = parseYMDHMIS(Y,M,D,H,MI,S)
% PARSEYMDHMIS finds the first occurrance of duplicate dates.

noSec = datenum([Y,M,D,H,MI,S]);
[noSecSorted, noSecSortedIdx] = sort(noSec);

% Grab only the first occurrence of a time and its data
[uniqDatesNTimes,idxUniq,j] = unique(noSecSorted);

for idx = 1:length(uniqDatesNTimes)
    holdDT = uniqDatesNTimes(idx);

    % Get the correct datarows by comparing the serial dates/times.
    % Comparing via a tolerance of 0.001 (or 1.157407407407408e-008) seconds.
    dtDiff = abs(holdDT - noSecSorted);
    wantedDatarowsLocation = dtDiff < (0.001/60/60/24);
    wantedDatarowsIdx = noSecSortedIdx(logical(wantedDatarowsLocation));
    firstOccurDT(idx) = min(wantedDatarowsIdx);
end

% Get the dates and times from the original matrix.
noSecTime = noSec(firstOccurDT);
% Get the corresponding index of these dates
idxNST = firstOccurDT;

% [EOF]
