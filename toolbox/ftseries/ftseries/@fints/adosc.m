function adots = adosc(ftsa, varargin)
%@FINTS/ADOSC  Accumulation/Distribution (A/D) Oscillator of a FINTS object.
%
%   ADOTS = adosc(FTS) calculates the Accumulation/Distribution (A/D)
%   Oscillator, ADOTS, for the set of stock price data contained in the 
%   financial time series object FTS.  The object must contain the prices 
%   needed for this function: high, low, opening, and closing prices.  The
%   function assumes that the series are named 'High', 'Low', 'Open', and 
%   'Close'. Please note that ALL four are required.  ADOTS is a FINTS
%   object with the same dates a FTS, but with one series named 'ADOsc'.
%
%   ADOTS = adosc(FTS, ParameterName, ParameterValue, ... ) does the
%   same as above with the exception of the parameter name-value pairs.
%   The purpose for these pairs is to specify the name(s) for the
%   required data series in case they are different than the expected
%   default name(s).  Valid ParameterName's are:
%
%         'HighName'  :  high prices series name
%         'LowName'   :  low prices series name
%         'OpenName'  :  opening prices series name
%         'CloseName' :  closing prices series name
%
%   ParameterValue's are the strings that represents the valid 
%   ParameterName's listed above.
%
%   Example:   load disney.mat
%              dis_ADOsc = adosc(dis);
%              plot(dis_ADOsc);
%
%   See also FINTS/ADLINE, FINTS/WILLAD.

%   Reference: Kaufman, P. J., The New Commodity Trading Systems and Methods, 
%              New York: John Wiley & Sons, 1987

%   Author: P. N. Secakusuma, P.Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.12 $   $Date: 2002/01/21 12:25:48 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

% Check input arguments.
highnm  = 'high';
lownm   = 'low';
opennm  = 'open';
closenm = 'close';
switch nargin
case 1
case {3, 5, 7, 9}
    for nidx = 1:2:nargin-1
        switch lower(varargin{nidx}(1))
        case 'h',   % 'HighName'
            highnm = lower(varargin{nidx+1});
        case 'l',   % 'LowName'
            lownm = lower(varargin{nidx+1});
        case 'o',   % 'OpenName'
            opennm = lower(varargin{nidx+1});
        case 'c',   % 'CloseName'
            closenm = lower(varargin{nidx+1});
        otherwise
            error('Ftseries:ftseries_fints_adosc:InvalidParameterName', ...
                'Invalid ParameterName.');
        end
    end
otherwise
    error('Ftseries:ftseries_fints_adosc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end
snames   = {highnm lownm opennm closenm};
snameidx = getnameidx(lower(ftsa.names), snames);
if any(~snameidx)
    error('Ftseries:ftseries_fints_adosc:MissingSeriesNames', ...
        'One or more required series are not found. Please check names.');
end
highp  = ftsa.data{4}(:, snameidx(1)-3);
lowp   = ftsa.data{4}(:, snameidx(2)-3);
openp  = ftsa.data{4}(:, snameidx(3)-3);
closep = ftsa.data{4}(:, snameidx(4)-3);

% Calculate A/D Oscillator by calling generalized ADOSC.
ado = adosc(highp, lowp, openp, closep);

% Assign output time series.
adots           = fints;
adots = chfield(adots,'series1','ADOsc');          % Rename the default series name
adots.data{1}   = ['ADOscillator: ', ftsa.data{1}]; % desc
adots.data{2}   = ftsa.data{2};                     % freq
adots.data{3}   = ftsa.data{3};                     % dates
adots.data{4}   = ado(:);                           % data
adots.data{5}   = ftsa.data{5};                     % time
adots.datacount = length(ado);
adots.serscount = 1;

% [EOF]