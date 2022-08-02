function wclsts = wclose(ftsa, varargin)
%@FINTS/WCLOSE Weighted Close of a FINTS object.
%
%   WCLSTS = WCLOSE(FTS) calculates the weighted close prices from the 
%   stock in the financial time series object FTS.  The object must 
%   contain, at least, the 'High', 'Low', and 'Close' data series.  The 
%   weighted close price is the average of twice the closing price plus 
%   the high and low prices.  WCLSTS is a FINTS object of the same dates 
%   as FTS and contains the data series named 'WClose'.
%
%   WCLSTS = WCLOSE(FTS, ParameterName, ParameterValue, ...) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'HighName'  :  high prices series name
%         'LowName'   :  low prices series name
%         'CloseName' :  closing prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_WClose = wclose(dis);
%              plot(dis_WClose);
%
%   See also FINTS/MEDPRICE, FINTS/TYPPRICE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 312-313

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:18:44 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa);
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
closenm = 'close';
switch nargin
case 1
case {3, 5, 7}
    for nidx = 1:2:nargin-1
        switch lower(varargin{nidx}(1))
        case 'h'   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'   % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_wclose:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_wclose:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_wclose:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);

% Calculate the weighted close prices by calling the generalized WCLOSE.
wcls = wclose(highp, lowp, closep);

% Assign output time series.
wclsts           = fints;
wclsts           = chfield(wclsts,'series1','WClose');  % rename series name
wclsts.data{1}   = ['WClose: ', ftsa.data{1}];          % desc
wclsts.data{2}   = ftsa.data{2};                        % freq
wclsts.data{3}   = ftsa.data{3};                        % dates
wclsts.data{4}   = wcls(:);                             % data
wclsts.data{5}   = ftsa.data{5};                        % times
wclsts.datacount = length(wcls);
wclsts.serscount = 1;

% [EOF]