function mprcts = medprice(ftsa, varargin)
%@FINTS/MEDPRICE Median Price of a FINTS object.
%
%   MPRCTS = MEDPRICE(FTS) calculates the median prices MPRC of a financial 
%   time series object FTS.  The object must minimally contain the series 
%   'High' and 'Low'.  The median price is just the average of the high 
%   and low price each period.  MPRCTS is a FINTS object with the same dates
%   as FTS and the data series 'MedPrice'.
%
%   MPRCTS = MEDPRICE(FTS, ParameterName, ParameterValue, ... ) does the
%   same thing as above with the exception of the parameter name-value 
%   pairs.  The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'HighName'  :  high prices series name
%         'LowName'   :  low prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_MedPrice = medprice(dis); 
%              plot(dis_MedPrice);
%
%   See also FINTS/WCLOSE, FINTS/TYPPRICE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 177-178

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:22:38 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
switch nargin
case 1
case {3, 5}
    for nidx = 1:2:nargin-1
        switch lower(varargin{nidx}(1))
        case 'h'   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'   % 'LowName'
            lownm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_medprice:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_medprice:InvalidNumberOfInputs', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_medprice:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);

% Calculate median prices by calling generalized MEDPRICE.
mprc = medprice(highp, lowp);

% Assign output time series.
mprcts           = fints;
mprcts           = chfield(mprcts,'series1','MedPrice');    % rename the series
mprcts.data{1}   = ['MedPrice: ', ftsa.data{1}];            % desc
mprcts.data{2}   = ftsa.data{2};                            % freq
mprcts.data{3}   = ftsa.data{3};                            % dates
mprcts.data{4}   = mprc(:);                                 % data
mprcts.data{5}   = ftsa.data{5};                            % times
mprcts.datacount = length(mprc);
mprcts.serscount = 1;

% [EOF]