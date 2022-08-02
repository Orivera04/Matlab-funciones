function tprcts = typprice(ftsa, varargin)
%@FINTS/TYPPRICE Typical Price of a FINTS object.
%
%   TPRCTS = TYPPRICE(FTS) calculates the typical prices from the stock
%   data contained in the financial time series object FTS.  The object 
%   must contain, at least, the 'High', 'Low', and 'Close' data series.  
%   The typical price is the average of the closing price plus the high 
%   and low prices.  TPRCTS is a FINTS object of the same dates as FTS and
%   contains the data series named 'TypPrice'.
%
%   TPRCTS = TYPPRICE(FTS, ParameterName, ParameterValue, ...) does the
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
%              dis_TypPrice = typprice(dis);
%              plot(dis_TypPrice);
%
%   see also FINTS/MEDPRICE, FINTS/WCLOSE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 291-292

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:19:13 $

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
            error('Ftseries:ftseries_fints_typprice:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_typprice:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_typprice:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);

% Calculate the typical prices by calling the generalized TYPPRICE.
tprc = typprice(highp, lowp, closep);

% Assign output time series.
tprcts           = fints;
tprcts           = chfield(tprcts,'series1','TypPrice');    % rename series name
tprcts.data{1}   = ['TypPrice: ', ftsa.data{1}];            % desc           
tprcts.data{2}   = ftsa.data{2};                            % freq
tprcts.data{3}   = ftsa.data{3};                            % dates  
tprcts.data{4}   = tprc(:);                                 % data
tprcts.data{5}   = ftsa.data{5};                            % times
tprcts.datacount = length(tprc);
tprcts.serscount = 1;

% [EOF]