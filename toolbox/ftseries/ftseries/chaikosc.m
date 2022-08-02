function chosc = chaikosc(varargin)
%CHAIKOSC Chaikin Oscillator.
%
%   CHOSC = CHAIKOSC(HIGHP, LOWP, CLOSEP, TVOLUME) calculates the 
%   Chaikin Oscillator (vector), CHOSC, for the set of stock price 
%   and volume traded data (TVOLUME).  Thus, the inputs that must be 
%   included are the high (HIGHP), low (LOWP), close (CLOSEP) prices, 
%   and volume traded (TVOLUME).
%
%   CHOSC = CHAIKOSC([HIGHP  LOWP  CLOSEP  TVOLUME]) does the same 
%   as above, but the 4 input vectors are passed in as a 4-column 
%   matrix.
%
%   Chaikin Oscillator is calculated by subtracting the 10-period
%   exponential moving average of the Accumulation/Distribution (A/D) 
%   Line from the 3-period exponential moving average of the A/D Line.
%
%   Example:   load disney.mat
%              dis_ChaikOsc = chaikosc(dis_HIGH, dis_LOW, dis_CLOSE, dis_VOLUME);
%              plot(dis_ChaikOsc);
%
%   See also ADLINE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 91-94

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11.2.1 $   $Date: 2003/01/16 12:51:14 $

% Check input arguments & extract them, if they are valid.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 4
        error('Ftseries:ftseries_chaikosc:InvalidNumberOFInputDataColumns', ...
            'Need 4 columns of data: HIGH, LOW, CLOSE, and VOLUME.');
    end
    
    highp   = varargin{1}(:, 1);
    lowp    = varargin{1}(:, 2);
    closep  = varargin{1}(:, 3);
    tvolume = varargin{1}(:, 4);
case 4
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1)) | ...
            (size(varargin{3}, 1) ~= size(varargin{4}, 1))
        error('Ftseries:ftseries_chaikosc:InputVectorsMustBeTheSameLength', ...
            'Lengths of all input vectors must be the same.');
    end
    
    highp   = varargin{1}(:);
    lowp    = varargin{2}(:);
    closep  = varargin{3}(:);
    tvolume = varargin{4}(:);
otherwise
    error('Ftseries:ftseries_chaikosc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the ADLINE and its 10-period and 3-period exp. moving averages.
w = warning;
warning off Ftseries:ftseries_tsmovavg:WarnSyntaxChange

ma10p = NaN * ones(size(closep));
ma03p = ma10p;
adln  = adline(highp, lowp, closep, tvolume);
ma10p(~isnan(adln)) = tsmovavg(adln(~isnan(adln)), 'e', 10, 1);
ma03p(~isnan(adln)) = tsmovavg(adln(~isnan(adln)), 'e', 3, 1);

warning(w)

% Calculate the Chaikin Oscillator.
chosc = ma03p - ma10p;
chosc = chosc(:);

% [EOF]