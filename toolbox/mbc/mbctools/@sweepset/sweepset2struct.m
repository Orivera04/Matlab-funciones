function out = sweepset2struct(ss, INCLUDE_LOGNO)
%SWEEPSET2STRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:11:44 $



% By default, don't include LOGNO
if nargin < 2
    INCLUDE_LOGNO = false;
end

% Get the variable information
name = {ss.var.name};
units = {ss.var.units};
description = {ss.var.descript};

% Add variable names to structure
out.varNames = name;
% Convert the units to chars
out.varUnits = cell(size(name));
for i = 1:length(name)
    out.varUnits{i} = char(units{i});
end
% If all descriptions are empty then return only an empty matrix
if all(cellfun('isempty', description))
    out.varDescriptions = [];
else
    out.varDescriptions = description;
end

out.comment = ss.comment;
out.data = ss.data;
% Would like to change this sweepset field to be called filename
out.filename = ss.number;

% How about LOGNO
if INCLUDE_LOGNO & ~any(strcmp(name, 'LOGNO'))
    % Make sure we have appended the extra variable name and unit
    out.varNames = [out.varNames {'LOGNO'}];
    out.varUnits = [out.varUnits {''}];
    % Make sure that varDescriptions is only appended to if it's not empty
    if ~isempty(out.varDescriptions)
        out.varDescriptions = [out.varDescriptions {''}];
    end
    % Get the LOGNO's to append
    lognos = testnum(ss);
    % Get the start and end index of the tests
    startIndex = tstart(ss);
    endIndex = cumsum(tsizes(ss));
    % Which colunm in the data are we putting the LOGNO in
    newColumn = size(out.data, 2) + 1;
    % Make sure it's initialized to zero (note it is possible to have zero
    % tests in a sweepset, this initialization will take care of that)
    out.data(end, newColumn) = 0;
    for i = 1:length(lognos)
        out.data(startIndex(i):endIndex(i), newColumn) = lognos(i);
    end
end
