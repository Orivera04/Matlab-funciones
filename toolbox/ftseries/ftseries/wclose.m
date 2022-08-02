function wcls = wclose(varargin)
%WCLOSE  Weighted Close.
%
%   WCLS = WCLOSE(HIGHP, LOWP, CLOSEP) calculates the weighted close prices 
%   WCLS based on the high (HIGHP), low (LOWP), and closing (CLOSEP) prices
%   per period.  The weighted close price is the average of twice the 
%   closing price plus the high and low prices.
%
%   WCLS = WCLOSE([HIGHP  LOWP  CLOSEP]) does the same thing as above with 
%   the exception of the input argument.  Instead of having 3 separate 
%   vectors as inputs, it takes a 3-column matrix that consists of the 
%   high, low, and closing prices, in that order.
%
%   Example:   load disney.mat
%              dis_WClose = wclose(dis_HIGH, dis_LOW, dis_CLOSE);
%              plot(dis_WClose);
%
%   See also MEDPRICE, TYPPRICE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 312-313

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $   $Date: 2002/01/21 12:30:42 $

% Check input arguments & extract them, if they are valid.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_wclose:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    
    highp   = varargin{1}(:, 1);
    lowp    = varargin{1}(:, 2);
    closep  = varargin{1}(:, 3);
case 3
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1))
        error('Ftseries:ftseries_wclose:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    
    highp   = varargin{1}(:);
    lowp    = varargin{2}(:);
    closep  = varargin{3}(:);
otherwise
    error('Ftseries:ftseries_wclose:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the weighted close prices.
wcls = ((2*closep) + highp + lowp) / 4;

% [EOF]
