function tsmat = fts2mtx(varargin)
%@FINTS/FTS2MTX Convert dates and/or data from a FINTS object to a matrix.
%
%   NOTE: This function is obsolete and will be removed in future versions
%   of the Financial Time Series Toolbox. Please use the function FTS2MAT
%   instead.
%
%   TSMAT = FTS2MTX(FTS) takes the data series in the financial time series
%   object FTS and puts them into the matrix TSMAT as columns.  The order of
%   the columns is identical to the order of the data series in the object FTS. 
%
%   TSMAT = FTS2MTX(FTS, DATESFLAG) gives you the option to specify 
%   whether or not to include the dates vector.  DATESFLAG = 0 specifies
%   the exclusion of the dates, which is the default behavior.  DATESFLAG = 1
%   includes the dates from FTS, and always places them in the first column
%   of TSMAT.  The dates are represented as serial date numbers. 
%
%   If time exists, the dates and times are reported as one serial number
%   in the first column of TSMAT.
%
%   TSMAT = FTS2MTX(FTS, SERIESNAMES) extracts the data series named
%   SERIESNAMES.  SERIESNAMES can be a cell array of strings.
%
%   TSMAT = FTS2MTX(FTS, DATESFLAG, SERIESNAMES) is similar to the above
%   except for the ability to include the dates (and times) vector as the
%   first column of the matrix. If an empty matrix, [], is used for DATESFLAG
%   the default behavior is adopted.
%
%   See also @FINTS/SUBSREF.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:50:53 $


% Warn that this function will be obsolete and removed.
warning('Ftseries:ftstomtx:ObsoleteAndWillBeRemoved', ...
    sprintf(['This function is obsolete and will be removed in future\n', ...
        'versions of the Financial Time Series Toolbox. Please use the\n', ...
        'function FTS2MAT instead.']));

if nargin < 1
    error('Ftseries:fts2mtx:InvalidNumOfInputs', ...
        'There must be at least one input.');
end

fts = varargin{1};

% If the object is of an older version, convert it.
[ftsVersion,timeData] = fintsver(fts);
if ftsVersion
    w = warning('off');
    fts = ftsold2new(fts); % This sorts the fts too.
    warning(w);
elseif ~issorted(fts);
    fts = sortfts(fts);
end

switch nargin
case 1   % fts2mtx(FTS)
    tsmat = fts.data{4};
case 2   % fts2mtx(FTS, DATESFLAG) or fts2mtx(FTS, SERIESNAMES)
    switch class(varargin{2})
    case 'double'   % fts2mtx(FTS, DATESFLAG)
        datesflag = varargin{2};
        if isempty(datesflag) | ~datesflag   % DATESFLAG = 0: exclude DATES (default).
            tsmat = fts.data{4};
        else   % DATESFLAG = 1: include DATES.
            if timeData
                tsmat = [fts.data{3} + fts.data{5}, fts.data{4}];
            else
                tsmat = [fts.data{3}, fts.data{4}];
            end
        end
    case {'char', 'cell'}   % fts2mtx(FTS, SERIESNAMES)
        seriesnames = varargin{2};
        if isempty(seriesnames)
            tsmat = fts.data{4};
        else
            nameidx = getnameidx(fts.names, seriesnames);
            if (nameidx == 1) | (nameidx == 2) | (nameidx == 3) | (nameidx == length(fts.names))
                error('Ftseries:fts2mtx:InvalidDataSeriesName', ...
                    '''desc'', ''freq'', ''dates'', and ''times'' are not valid data series names.');
            end
            if any(~nameidx)
                error('Ftseries:fts2mtx:InputStringNotFoundInObject', ...
                    'One or more of the strings is not in this object''s fields.');
            end
            tsmat = fts.data{4}(:, nameidx-3);
        end
    end
case 3   % fts2mtx(FTS, DATESFLAG, SERIESNAMES)
    if isnumeric(varargin{2}) & (ischar(varargin{3}) | iscell(varargin{3}))
        datesflag = varargin{2};
        seriesnames = varargin{3};
        
        % Check and make sure that the flag is 1 or 0
        if (varargin{2} ~= 1) & (varargin{2} ~= 0) 
            error('Ftseries:ftseries_fints_fts2mtx:DATEFLAGMustBe1or0', ...
                'A valid DATESFLAG entry is 1 or 0.');
        end
    else
        error('Ftseries:fts2mtx:SecondArgIsDATEFLAGAndThirdArgIsSERIESNAMES', ...
            '2nd argument is DATEFLAG (numeric) and 3rd is SERIESNAMES (string).');
    end
    nameidx = getnameidx(fts.names, seriesnames);
    if (nameidx == 1) | (nameidx == 2) | (nameidx == 3) | (nameidx == length(fts.names))
        error('Ftseries:fts2mtx:InvalidDataSeriesName', ...
            '''desc'', ''freq'', ''dates'', and ''times'' are not valid data series names.');
    end
    if any(~nameidx)
        error('Ftseries:fts2mtx:InputStringNotFoundInObject', ...
            'One or more of the strings is not in this object''s fields.');
    end
    if isempty(datesflag) | ~datesflag   % DATESFLAG = 0: exclude DATES (default).
        tsmat = fts.data{4}(:, nameidx-3);
    else   % DATESFLAG = 1: include DATES.
        if timeData
            tsmat = [fts.data{3} + fts.data{5}, fts.data{4}(:, nameidx-3)];
        else
            tsmat = [fts.data{3}, fts.data{4}(:, nameidx-3)];
        end
    end
otherwise
    error('Ftseries:fts2mtx:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% [EOF]
