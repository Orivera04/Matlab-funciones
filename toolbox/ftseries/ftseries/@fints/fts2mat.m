function tsmat = fts2mat(varargin)
%@FINTS/FTS2MAT Convert dates and/or data from a FINTS object to a matrix.
%
%   TSMAT = FTS2MAT(FTS) takes the data series in the financial time series
%   object FTS and puts them into the matrix TSMAT as columns.  The order of
%   the columns is identical to the order of the data series in the object FTS. 
%
%   TSMAT = FTS2MAT(FTS, DATESFLAG) gives you the option to specify 
%   whether or not to include the dates vector.  DATESFLAG = 0 specifies
%   the exclusion of the dates, which is the default behavior.  DATESFLAG = 1
%   includes the dates from FTS, and always places them in the first column
%   of TSMAT.  The dates are represented as serial date numbers. 
%
%   If time exists, the dates and times are reported as one serial number
%   in the first column of TSMAT.
%
%   TSMAT = FTS2MAT(FTS, SERIESNAMES) extracts the data series named
%   SERIESNAMES.  SERIESNAMES can be a cell array of strings.
%
%   TSMAT = FTS2MAT(FTS, DATESFLAG, SERIESNAMES) is similar to the above
%   except for the ability to include the dates (and times) vector as the
%   first column of the matrix. If an empty matrix, [], is used for DATESFLAG
%   the default behavior is adopted.
%
%   See also @FINTS/SUBSREF.

% Copyright 2002 The MathWorks, Inc.

%   Author: P. N. Secakusuma, P. Wang


if nargin < 1
    error('Ftseries:fts2mat:InvalidNumOfInputs', ...
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
case 1   % fts2mat(FTS)
    tsmat = fts.data{4};
case 2   % fts2mat(FTS, DATESFLAG) or fts2mat(FTS, SERIESNAMES)
    switch class(varargin{2})
    case 'double'   % fts2mat(FTS, DATESFLAG)
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
    case {'char', 'cell'}   % fts2mat(FTS, SERIESNAMES)
        seriesnames = varargin{2};
        if isempty(seriesnames)
            tsmat = fts.data{4};
        else
            nameidx = getnameidx(fts.names, seriesnames);
            if (nameidx == 1) | (nameidx == 2) | (nameidx == 3) | (nameidx == length(fts.names))
                error('Ftseries:fts2mat:InvalidDataSeriesName', ...
                    '''desc'', ''freq'', ''dates'', and ''times'' are not valid data series names.');
            end
            if any(~nameidx)
                error('Ftseries:fts2mat:InputStringNotFoundInObject', ...
                    'One or more of the strings is not in this object''s fields.');
            end
            tsmat = fts.data{4}(:, nameidx-3);
        end
    end
case 3   % fts2mat(FTS, DATESFLAG, SERIESNAMES)
    if isnumeric(varargin{2}) & (ischar(varargin{3}) | iscell(varargin{3}))
        datesflag = varargin{2};
        seriesnames = varargin{3};
        
        % Check and make sure that the flag is 1 or 0
        if (varargin{2} ~= 1) & (varargin{2} ~= 0) 
            error('Ftseries:ftseries_fints_fts2mat:DATEFLAGMustBe1or0', ...
                'A valid DATESFLAG entry is 1 or 0.');
        end
    else
        error('Ftseries:fts2mat:SecondArgIsDATEFLAGAndThirdArgIsSERIESNAMES', ...
            '2nd argument is DATEFLAG (numeric) and 3rd is SERIESNAMES (string).');
    end
    nameidx = getnameidx(fts.names, seriesnames);
    if (nameidx == 1) | (nameidx == 2) | (nameidx == 3) | (nameidx == length(fts.names))
        error('Ftseries:fts2mat:InvalidDataSeriesName', ...
            '''desc'', ''freq'', ''dates'', and ''times'' are not valid data series names.');
    end
    if any(~nameidx)
        error('Ftseries:fts2mat:InputStringNotFoundInObject', ...
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
    error('Ftseries:fts2mat:InvalidNumOfInputs', ...
        'Invalid number of input arguments.');
end

% [EOF]
