function wpctrts = willpctr(ftsa, nperiods, varargin)
%@FINTS/WILLPCTR William's PercentR (%R) of a FINTS object.
%
%   WPCTRTS = WILLPCTR(FTS) calculates the William's PercentR (%R) values 
%   for the given financial time series object FTS for a 14 periods.  The 
%   object must contain at least 3 data series named 'High' (high prices), 
%   'Low' (low prices), and 'Close' (closing prices).
%
%   WPCTRTS = WILLPCTR(FTS, NPERIODS) calculates the William's PercentR
%   (%R) values for the given financial time series object FTS for a given
%   number of periods, NPERIODS.  NPERIODS must be a scalar integer.
%
%   WPCTRTS = WILLPCTR(FTS, NPERIODS, ParameterName, ParameterValue, ... )      
%   does the same thing as above with the exception of the 
%   parameter name-value pairs.  The purpose for these pairs is to specify 
%   the name(s) for the required data series in case they are different 
%   than the expected default name(s).  Valid ParameterName's are:
%
%         'HighName'  :  high prices series name
%         'LowName'   :  low prices series name
%         'CloseName' :  closing prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_WillPctR = willpctr(dis);
%              plot(dis_WillPctR);
%
%   See also FINTS/WILLAD, FINTS/STOCHOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 316-317

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:18:34 $

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
    nperiods = 14;
case 2
    if prod(size(nperiods)) ~= 1 | floor(nperiods) ~= nperiods
        error('Ftseries:ftseries_fints_willpctr:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
case {4, 6, 8}
    if prod(size(nperiods)) ~= 1 | floor(nperiods) ~= nperiods
        error('Ftseries:ftseries_fints_willpctr:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    for nidx = 1:2:nargin-2
        switch lower(varargin{nidx}(1)),
        case 'h'   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l'   % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'c'   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_willpctr:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_willpctr:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames = {highnm lownm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_willpctr:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp   = ftsa.data{4}(:, snameidx(1)-3);
lowp    = ftsa.data{4}(:, snameidx(2)-3);
closep  = ftsa.data{4}(:, snameidx(3)-3);

% Calculate William's PercentR (%R) by calling generalized WILLPCTR.
wpctr = willpctr(highp, lowp, closep, nperiods);

% Assign output time series.
wpctrts           = fints;
wpctrts           = chfield(wpctrts,'series1','WillPctR');  % rename series name
wpctrts.data{1}   = ['WillPctR: ', ftsa.data{1}];           % desc
wpctrts.data{2}   = ftsa.data{2};                           % freq
wpctrts.data{3}   = ftsa.data{3};                           % dates
wpctrts.data{4}   = wpctr(:);                               % data
wpctrts.data{5}   = ftsa.data{5};                           % times
wpctrts.datacount = length(wpctr);
wpctrts.serscount = 1;

% [EOF]