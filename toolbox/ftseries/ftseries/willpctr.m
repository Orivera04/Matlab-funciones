function wpctr = willpctr(varargin)
%WILLPCTR Williams PercentR (%R).
%
%   WPCTR = WILLPCTR(HIGHP, LOWP, CLOSEP) calculates the Williams 
%   PercentR (%R) values for the given set of stock prices for 14 periods.
%   The stock prices needed are the high (HIGHP), low (LOWP), and closing 
%   (CLOSEP) prices.  WPCTR is a vector that represents the Williams 
%   PercentR values from the stock data.
%
%   WPCTR = WILLPCTR([HIGHP LOWP CLOSEP]) is similar to the above with the
%   exception of the input.  Instead of having 3 separate price vectors as
%   input arguments, the input argument must be a 3-column matrix.  The 
%   first column corresponds to the high prices, the second, the low prices,
%   and the third bears the closing prices.
%
%   WPCTR = WILLPCTR(HIGHP, LOWP, CLOSEP, NPERIODS) calculates the 
%   Williams PercentR (%R) values for the given set of stock prices for
%   a specified number of periods (NPERIODS).  NPERIODS must be a scalar
%   integer.  If NPERIODS is not provided, a 14-period default is used.
%
%   WPCTR = WILLPCTR([HIGHP  LOWP  CLOSEP], NPERIODS) is similar to the 
%   above with the exception of the first input.  The first input argument
%   must be a 3-column matrix representing the high, low, and closing
%   prices.
%
%   Example:   load disney.mat
%              dis_WillPctR = willpctr(dis_HIGH, dis_LOW, dis_CLOSE);
%              plot(dis_WillPctR);
%
%   See also WILLAD, STOCHOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 316-317

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10.2.1 $   $Date: 2003/01/16 12:51:28 $

% Check input arguments.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_willpctr:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    highp    = varargin{1}(:, 1);
    lowp     = varargin{1}(:, 2);
    closep   = varargin{1}(:, 3);
    nperiods = 14;
case 2
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_willpctr:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    if prod(size(varargin{2})) ~= 1 | floor(varargin{2}) ~= varargin{2}
        error('Ftseries:ftseries_willpctr:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    highp    = varargin{1}(:, 1);
    lowp     = varargin{1}(:, 2);
    closep   = varargin{1}(:, 3);
    nperiods = varargin{2};
case 3
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1))
        error('Ftseries:ftseries_willpctr:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    highp    = varargin{1}(:);
    lowp     = varargin{2}(:);
    closep   = varargin{3}(:);
    nperiods = 14;
case 4
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1))
        error('Ftseries:ftseries_willpctr:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    if prod(size(varargin{4})) ~= 1 | floor(varargin{4}) ~= varargin{4}
        error('Ftseries:ftseries_willpctr:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    end
    highp    = varargin{1}(:);
    lowp     = varargin{2}(:);
    closep   = varargin{3}(:);
    nperiods = varargin{4};
otherwise
    error('Ftseries:ftseries_willpctr:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check number of data against NPERIODS.
if length(highp) < nperiods
    error('Ftseries:ftseries_willpctr:NPERIODSTooLarge', ...
        'NPERIODS is too large for the number of data available.');
end

% Calculate the Highest High and Lowest Low.
hhvnper = hhigh(highp, nperiods);
llvnper = llow(lowp, nperiods);


% Calculate the Williams PercentR.
wpctr        = NaN*ones(size(closep));
nzero        = find((hhvnper-llvnper) ~= 0);
wpctr(nzero) = ((hhvnper(nzero)-closep(nzero))./(hhvnper(nzero)-llvnper(nzero))) * -100;

% [EOF]
