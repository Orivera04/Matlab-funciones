function tsmat = ftstomtx(varargin)
%@FINTS/FTSTOMTX Convert dates and/or data from a FINTS object to a matrix.
%
%   NOTE: This function is obsolete and will be removed in future versions
%   of the Financial Time Series Toolbox. Please use the function FTS2MAT
%   instead.
%
%   TSMAT = FTSTOMTX(FTS) takes the dates and the data series in the
%   financial time series object FTS and put them into the matrix TSMAT
%   as columns.  The order of the columns is basically the order of the
%   data series in the object FTS.  The dates are represented as serial 
%   date numbers.
%
%   TSMAT = FTSTOMTX(FTS, DATESFLAG) gives you the option to specify 
%   whether or not you want the dates vector included.  DATESFLAG = 0 
%   specifies the exclusion of the dates; this is the default behavior.
%   DATESFLAG = 1 includes the dates from the matrix.
%
%   TSMAT = FTSTOMTX(FTS, SERIESNAMES) extracts the data series named
%   SERIESNAMES and put its values along with the dates vector into the
%   matrix TSMAT.  SERIESNAMES can be a cell array of strings.  The 
%   dates vector will be the first column.
%
%   TSMAT = FTSTOMTX(FTS, DATESFLAG, SERIESNAMES) puts into a matrix 
%   specific data series named SERIESNAMES into the matrix.  The second 
%   input argument DATESFLAG must be specified in using this syntax.  If 
%   you input an empty matrix ([]) as its input, the default behavior is
%   adopted.  SERIESNAMES can be a cell array of strings.
%
%   See also @FINTS/SUBSREF.

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:50:55 $

% Warn that this function will be obsolete and removed.
warning('Ftseries:ftstomtx:ObsoleteAndWillBeRemoved', ...
    sprintf(['This function is obsolete and will be removed in future\n', ...
        'versions of the Financial Time Series Toolbox. Please use the\n', ...
        'function FTS2MAT instead.']));

fts = varargin{1};
% If the object is of an older version, convert it.
if fintsver(fts) == 1
    fts = ftsold2new(fts); % This sorts the fts too.
elseif ~issorted(fts)
    fts = sortfts(fts);
end

switch nargin
case 1   % ftstomtx(FTS)
    tsmat = fts.data{4};
    
case 2   % ftstomtx(FTS, DATESFLAG) or ftstomtx(FTS, SERIESNAMES)
    switch class(varargin{2})
    case 'double'   % ftstomtx(FTS, DATESFLAG)
        datesflag = varargin{2};
        if isempty(datesflag) | ~datesflag   % DATESFLAG = 0: exclude DATES (default).
            tsmat = fts.data{4};
        else   % DATESFLAG = 1: include DATES.
            tsmat = [fts.data{3}, fts.data{4}];
        end
    case {'char', 'cell'}   % ftstomtx(FTS, SERIESNAMES)
        seriesnames = varargin{2};
        if isempty(seriesnames)
            tsmat = fts.data{4};
        else
            nameidx = getnameidx(fts.names, seriesnames);
            if any(~nameidx)
                error('Ftseries:ftstomtx:InputStringNotFoundInObject', ...
                    'One or more of the strings is not in this object''s fields.');
            end
            tsmat = fts.data{4}(:, nameidx-3);
        end
    end
    
case 3   % ftstomtx(FTS, DATESFLAG, SERIESNAMES)
    if isnumeric(varargin{2}) & (ischar(varargin{3}) | iscell(varargin{3}))
        datesflag = varargin{2};
        seriesnames = varargin{3};
        
        % Check and make sure that the flag is 1 or 0
        if varargin{2} ~= 1
            error('Ftseries:ftseries_fints_fts2mtx:DATEFLAGMustBe1or0', ...
                'A valid DATESFLAG entry is 1 or 0.');
        end
    else
        error('Ftseries:ftstomtx:SecondArgIsDATEFLAGAndThirdArgIsSERIESNAMES', ...
            '2nd argument is DATEFLAG (numeric) and 3rd is SERIESNAMES (string).');
    end
    nameidx = getnameidx(fts.names, seriesnames);
    if any(~nameidx)
        error('Ftseries:ftstomtx:InputStringNotFoundInObject', ...
            'One or more of the strings is not in this object''s fields.');
    end
    if isempty(datesflag) | ~datesflag   % DATESFLAG = 0: exclude DATES (default).
        tsmat = fts.data{4}(:, nameidx-3);
    else   % DATESFLAG = 1: include DATES.
        tsmat = [fts.data{3}, fts.data{4}(:, nameidx-3)];
    end
    
otherwise
    error('Ftseries:ftstomtx:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% [EOF]
