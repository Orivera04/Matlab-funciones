function wadlts = willad(ftsa, varargin)
%@FINTS/WILLAD William's Accumulation/Distribution Line of a FINTS object.
%
%   WADLTS = WILLAD(FTS) calculates the William's Accumulation/Distribution 
%   Line, WADLTS, for the set of stock price data contained in the financial 
%   time series object FTS.  The object must contain the prices needed for  
%   this function; they are the high, low, and closing prices.  The function 
%   assumes that the series are named 'High', 'Low', and 'Close'. All three 
%   are required.  WADLTS is a FINTS object with the same dates as FTS but 
%   only one series named 'WillAD'.
%
%   WADLTS = WILLAD(FTS, ParameterName, ParameterValue, ... ) does the
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
%              dis_WillAD = willad(dis);
%              plot(dis_WillAD);
%
%   See also FINTS/WILLPCTR, FINTS/ADLINE, FINTS/ADOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 314-315

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12 $   $Date: 2002/01/21 12:18:39 $

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
        case 'h'  % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'  % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'c'  % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_willad:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_willad:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_willad:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);

% Calculate William's A/D Line by calling generalized WILLAD.
wadl = willad(highp, lowp, closep);

% Assign output time series.
wadlts           = fints;
wadlts           = chfield(wadlts,'series1','WillAD');  % rename series name
wadlts.data{1}   = ['WillAD: ', ftsa.data{1}];          % desc
wadlts.data{2}   = ftsa.data{2};                        % freq
wadlts.data{3}   = ftsa.data{3};                        % dates
wadlts.data{4}   = wadl(:);                             % data
wadlts.data{5}   = ftsa.data{5};                        % times
wadlts.datacount = length(wadl);
wadlts.serscount = 1;

% [EOF]