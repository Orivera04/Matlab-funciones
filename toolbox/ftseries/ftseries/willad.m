function wadl = willad(varargin)
%WILLAD  Williams Accumulation/Distribution Line.
%
%   WADL = WILLAD(HIGHP, LOWP, CLOSEP) calculates the Williams 
%   Accumulation/Distribution Line, WADL, for the set of stock price data.
%   The prices needed for this function are the high (HIGHP), low (LOWP), 
%   and closing (CLOSEP) prices.  All three are required.
%
%   WADL = WILLAD([HIGHP  LOWP  CLOSEP]) is similar to the above with the
%   exception of the input.  Instead of having 3 separate price vectors as
%   input arguments, the input argument must be a 3-column matrix.  The 
%   first column corresponds to the high prices, the second, the low prices,
%   and the third bears the closing prices.
%
%   Example:   load disney.mat
%              dis_WillAD = willpctr(dis_HIGH, dis_LOW, dis_CLOSE);
%              plot(dis_WillAD);
%
%   See also WILLPCTR, ADLINE, ADOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 314-315

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10.2.1 $   $Date: 2003/01/16 12:51:27 $

% Check input arguments & extract them, if they are valid.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_willad:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    
    highp   = varargin{1}(:, 1);
    lowp    = varargin{1}(:, 2);
    closep  = varargin{1}(:, 3);
case 3
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1))
        error('Ftseries:ftseries_willad:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    
    highp   = varargin{1}(:);
    lowp    = varargin{2}(:);
    closep  = varargin{3}(:);
otherwise
    error('Ftseries:ftseries_willad:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate True Range High (TRH) and True Range Low (TRL).
% Some instances of NaN's in data may cause errors.
tvec = 2:length(highp);
TRH = max(closep(tvec-1), highp(tvec));
TRL = min(closep(tvec-1), lowp(tvec));

% Calculate Today's A/D.
case1 = find(closep(tvec) > closep(tvec-1));
todaysad(case1) = closep(case1) - TRL(case1);

case2 = find(closep(tvec) < closep(tvec-1));
todaysad(case2) = closep(case2) - TRH(case2);

case3 = find(closep(tvec) == closep(tvec-1));
todaysad(case3) = 0;

% Calculate the Williams A/D Line.
allad = [closep(1) todaysad]';
wadl = NaN*ones(size(allad));
wadl(~isnan(allad)) = cumsum(allad(~isnan(allad)));

% [EOF]
