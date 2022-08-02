function tprc = typprice(varargin)
%TYPPRICE Typical Price.
%
%   TPRC = TYPPRICE(HIGHP, LOWP, CLOSEP) calculates the typical prices 
%   TPRC from the high (HIGHP), low (LOWP), and closing (CLOSEP) prices.  
%   The typical price is just the average of the high, low, and closing 
%   prices for each period.
%
%   TPRC = TYPPRICE([HIGHP  LOWP  CLOSEP]) does the same thing as above 
%   with a 3-column matrix as the input rather than 2 individual vectors.  
%   The columns of the matrix represent the high, low, and closing prices, 
%   in that order.
%
%   Example:   load disney.mat
%              dis_TypPrice = typprice(dis_HIGH, dis_LOW, dis_CLOSE);
%              plot(dis_TypPrice);
%
%   See also MEDPRICE, WCLOSE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 291-292

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:30:30 $

% Check input arguments & extract them, if they are valid.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_typprice:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    
    highp   = varargin{1}(:, 1);
    lowp    = varargin{1}(:, 2);
    closep  = varargin{1}(:, 3);
case 3
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1)),
        error('Ftseries:ftseries_typprice:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    
    highp   = varargin{1}(:);
    lowp    = varargin{2}(:);
    closep  = varargin{3}(:);
otherwise
    error('Ftseries:ftseries_typprice:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the weighted close prices.
tprc = (highp + lowp + closep) / 3;

% [EOF]