function ftse = extfield(fts, fldnames)
%@FINTS/EXTFIELD Extracts select data series into a new FINTS object.
%
%   FTSE = EXTFIELD(FTS, FLDNAMES) extract the dates and data series 
%   FLDNAMES into a new FINTS object, FTSE, from the object FTS.  The 
%   new object, FTSE, will have all the dates of FTS with only the
%   selected data series.
%
%   The names of the data series desired are specified in FLDNAMES 
%   which must be string if a single data series (fieldnames) name is
%   desired, and a cell array if a list of data series names 
%   (fieldnames) is desired. 
%
%   Please note that the field names are case-sensitive.
%
%   For example:
%
%      ftse = extfield(fts, 'Close');
%
%   This function is the exact opposite of the function RMFIELD.
%
%   See also RMFIELD, GETFIELD, SETFIELD, FIELDNAMES.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $   $Date: 2002/01/21 12:24:54 $

% If the object is of an older version, convert it.
if fintsver(fts) == 1
    fts = ftsold2new(fts); % This sorts the fts too.
elseif ~issorted(fts)
    fts = sortfts(fts);
end

% Check the number of input arguments.
if nargin ~= 2
    error('Ftseries:ftseries_fints_extfield:NoFieldsSpecified', ...
        'Please specify the series name(s) to be extracted.');
end
if isempty(fldnames) | (iscell(fldnames) & isempty(char(fldnames{:})))
    fldnames = fts.names(4:(end-1)); % -1 takes into account time
end

% Check the types of input arguments for validity.
if ischar(fldnames)
    if size(fldnames, 1) ~= 1
        error('Ftseries:ftseries_fints_extfield:UseCellArray', ...
            'Only 1 string is allowed.  Use a cell array for a list.');
    end
elseif iscell(fldnames)
    if (size(fldnames, 1) ~= 1) & (size(fldnames, 2) ~= 1)
        error('Ftseries:ftseries_fints_extfield:FieldNamesMustBeInAColOrRowCellArray', ...
            'FLDNAMES need to be in a column/row cell array.');
    end
else
    error('Ftseries:ftseries_fints_extfield:FieldNamesMustBeAStringOrColOrRowCellArray', ...
        'FLDNAMES need to be a string or a column/row cell array.');
end

% Get all the fieldnames (data series names) in the original object.
fnames = fieldnames(fts,1);

% Find the desired names in the list of available data series names.
fnmidx = getnameidx(fnames, fldnames);

% Give error if one or more of the given FLDNAMES are not found.
if any(~fnmidx)
    error('Ftseries:ftseries_fints_extfield:FieldNamesNotInObject', ...
        'One or more names cannot be found in the object.');
end

% Find the ones to be removed from the original object.
remfnm = find(~ismember(1:length(fnames), fnmidx));

% Create the new series by removing some of the data series.
w = warning('off');
ftse = rmfield(fts, fnames(remfnm));
warning(w);

% [EOF]