function ftso = tsmovavg(ftsi, mode, varargin)
%@FINTS/TSMOVAVG calculates the (weighted) moving average of vector of data.
%
%   Syntax: VO = TSMOVAVG(VI, 's', LAG, DIM)        => SIMPLE, s
%           VO = TSMOVAVG(VI, 'e', TIMEPER, DIM)    => EXPONENTIAL, e
%           VO = TSMOVAVG(VI, 't', NUMPER, DIM)     => TRIANGULAR, t
%           VO = TSMOVAVG(VI, 'w', WEIGHTS, DIM)    => WEIGHTED, w
%           VO = TSMOVAVG(VI, 'm', NUMPER, DIM)     => MODIFIED, m
%
%   NOTE: The Simple and Weighted moving averages have a new calling
%   syntax. This is different from previous versions of this function.
%   The simple moving average does not require a LEAD input and the
%   weighted moving average does not require a PIVOT point. [END NOTE]   
%  
%   VI is assumed to be a row vector or row-oriented matrix. DIM is an
%   optional input, and if it is not included as an input, the default
%   value 2 is assumed. DIM = 2 means that each row is a variable and
%   each column is an observation (row-oriented matrix). If a column-
%   oriented matrix is supplied for VI (i.e. each column is a variable 
%   and each row is an observation) then a DIM must be included and set
%   to the value DIM = 1. VO is identical in form to VI. 
%
%   Simple Moving Average:
%   LAG is the parameter indicating the number of previous data points to
%   be used in conjunction with the current data point when calculating 
%   the moving average. LAG can also be thought of as the window size or
%   number of periods of the moving average.
%
%   Exponential Moving Average:
%   Exponential moving average is a weighted moving average, where TIMEPER is
%   the time period of the exponential moving average. Exponential moving 
%   averages reduce the lag by applying more weight to recent prices. For 
%   example, a 10 period exponential moving average weights the most recent
%   price by 18.18%.
% 
%   Exponential Percentage = 2/(TIMEPER + 1) or 2/(WINDOW_SIZE + 1)
%
%   Triangular Moving Average:
%   Triangular moving average is a double-smoothing of the data. The first
%   simple moving average is calculated with a window width of
%   CEIL((NUMPER+1)/2). Then a second simple moving average is calculated
%   on the first moving average with the same window size.
%
%   Weighted Moving Average:
%   A weighted moving average is calculated with a weight vector, WEIGHTS.
%   The length of the weight vector determines the size of the window. If
%   larger weight factors are used for more recent prices and smaller factors
%   for previous prices, the trend will be more responsive to recent changes.
%
%   Modified Moving Average:
%   The modified moving average calculation is similar to the simple moving
%   average calculation. NUMPER can be thought of as the LAG of the simple
%   moving average. The first modified moving average value, VO(NUMPER), is
%   calculated the same way the first simple moving average value is 
%   calculated. All subsequent values are calculated by adding the new 
%   price and then subtracting the last average from the resulting sum.
%
%   See also MEAN, PERAVG.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 184-192

%   Author: P. Wang
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.12.2.4 $  $Date: 2004/04/06 01:09:38 $


% If the object is of an older version, convert it.
if fintsver(ftsi) == 1
    ftsi = ftsold2new(ftsi); % This sorts the fts too.
elseif ~issorted(ftsi);
    ftsi = sortfts(ftsi);
end

% Pre allocate memory
ftso = ftsi;

% Input checking
if nargin ~= 3
    error('Ftseries:ftseries_fints_tsmovavg:InvalidNumInputs', ...
        'Invalid number of inputs. Please see ''help fints/tsmovavg''.');
end

% Call TSMOVAVG
switch lower(mode)
    case {'s', 'simple'}
        try
            ftso.data{4} = tsmovavg(ftsi.data{4}, 's', varargin{1}, 1);
        catch
            errMsg = lasterror;
            error('Ftseries:ftseries_fints_tsmovavg:InvalidInputsSimple', ...
                errMsg.message');
        end
    case {'e', 'exponential'}
        try
            ftso.data{4} = tsmovavg(ftsi.data{4}, 'e', varargin{1}, 1);
        catch
            errMsg = lasterror;
            error('Ftseries:ftseries_fints_tsmovavg:InvalidInputsExponential', ...
                errMsg.message');
        end
    case {'t', 'triangular'}
        try
            ftso.data{4} = tsmovavg(ftsi.data{4}, 't', varargin{1}, 1);
        catch
            errMsg = lasterror;
            error('Ftseries:ftseries_fints_tsmovavg:InvalidInputsTriangular', ...
                errMsg.message');
        end
    case {'w', 'weighted'}
        try
            ftso.data{4} = tsmovavg(ftsi.data{4}, 'w', varargin{1}, 1);
        catch
            errMsg = lasterror;
            error('Ftseries:ftseries_fints_tsmovavg:InvalidInputsWeighted', ...
                errMsg.message');
        end
    case {'m', 'modified'}
        try
            ftso.data{4} = tsmovavg(ftsi.data{4}, 'm', varargin{1}, 1);
        catch
            errMsg = lasterror;
            error('Ftseries:ftseries_fints_tsmovavg:InvalidInputsModified', ...
                errMsg.message');
        end
    otherwise
        error('Ftseries:ftseries_fints_tsmovavg:InvalidMode', ...
            'Invalid mode. Valid modes are: ''s'', ''e'', ''t'', ''w'', or ''m''.');
end

% [EOF]
