function [fixedName,msg] = rmvspaces(holdName)
% RMVSPACES removes leading and lagging spaces from the input. It also
%   trims down spaces with lengths greater than one space to one space in
%   length (i.e. 'input1[][]input2' --> 'input1[]input2'; [] = space). 
%   Input CANNOT be of type cell sized 1 by X.

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.2 $   $Date: 2002/01/18 21:50:41 $

% Set up variables
msg = '';

% Remove trailing spaces
db = deblank(holdName);

% Flip it and remove leading spaces
dbflrc = deblank(fliplr(char(db)));

% Check to see if there are 2 or more spaces between date and time
twoSpace = strfind(dbflrc,'  ');

% Keep removing 2 spaces until one space is left between date and time
while ~isempty(twoSpace)
    replacement = strrep(dbflrc,'  ',' ');
    twoSpace = strfind(replacement,'  ');
    dbflrc = replacement;
end

% Check to see if dbflrc is empty. Need the check here due to inputs from
% subsref or subsasgn like f(' ').
if isempty(dbflrc)
    msg = 'A string containing Dates or Dates and Times is expected.';
    fixedName = [];
    return
end

% Flip it back so it is readable
fixedName = fliplr(dbflrc);

% [EOF]