function [unq,dup] = ftsuniq(dt)
%FTSUNIQ determines if the dates and/or times are unique within a
%   FINTS object.
%
%   UNQ = FTSUNIQ(DT) returns 1 if the dates and/or times of a
%   FINTS object are unique, and 0 if there are duplicates of the
%   dates and/or times in the object. DT is a single column vector
%   of serial dates and/or times.
%
%   [UNQ,DUP] = FTSUNIQ(DT) returns a structure DUP where
%   DUP.DT contains the strings of the duplicate dates and/or times
%   and their locations in the object. DUP.INTIDX contains the 
%   integer indices of duplicate dates and/or times in the object.

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.3 $   $Date: 2002/02/05 15:53:26 $

% Make sure the dates and/or times are numeric
if ~isnumeric(dt)
    error('Ftseries:ftsuniq:DATESnTIMESMustBSerialNums', ...
        'The dates and/or times must be in the form of serial numbers.');
end

% Are the dates and/or times unique
if length(unique(dt)) == length(dt)
    unq = 1;
else
    unq = 0;
end

if nargout == 2
    % Sort the dates and/or times
    sortedDT = sort(dt);
    
    % Diff them to see which ones are duplicates
    diffSorted = diff(sortedDT);
    
    % Index of the duplicates in the sorted dates and/or times
    idxDupSorted = find(diffSorted == 0);
    
    % Actual serial dates/times of the duplicates
    unqSerialDups = unique(sortedDT(idxDupSorted));
    
    % Create cell array to hold the dates and/times of the duplicates
    % do not create a times column if times do not exist.
    if sum(mod(dt,1)) == 0
        % DT contains only dates
        dup.DT = cell(length(unqSerialDups),2);
        justDates = 1;
    else
        % DT contains dates and times
        dup.DT = cell(length(unqSerialDups),3);
        justDates = 0;
    end
    
    % Find idx of the repeated dates/times in the UNSORTED dates/times
    dup.intIdx = [];
    for idx = 1:length(unqSerialDups)
        holdIdx = find(unqSerialDups(idx) == dt);
        dup.intIdx = [dup.intIdx ; holdIdx];
        
        % Give the location of the duplicate dates/times for each date/time
        if justDates
            dup.DT(idx,2) = cellstr(num2str(holdIdx'));
        else
            dup.DT(idx,3) = cellstr(num2str(holdIdx'));
        end
    end
    
    % Create cell array to hold the dates and/times of the duplicates
    % do not create a times column if times do not exist.
    if isempty(unqSerialDups)
        dup.DT = [];
    else
        if sum(mod(dt,1)) == 0
            dup.DT(:,1) = cellstr(datestr(unqSerialDups,1));
        else
            dup.DT(:,1) = cellstr(datestr(unqSerialDups,1));
            dup.DT(:,2) = cellstr(datestr(unqSerialDups,15));
        end
    end
end

% [EOF]
