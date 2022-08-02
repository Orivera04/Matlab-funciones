function mprc = medprice(varargin)
%MEDPRICE Median Price.
%
%   MPRC = MEDPRICE(HIGHP, LOWP) calculates the median prices MPRC from
%   the high (HIGHP) and low (LOWP) prices.  The median price is just the
%   average of the high and low price each period.
%
%   MPRC = MEDPRICE([HIGHP  LOWP]) does the same thing as above with a
%   2-column matrix as the input rather than 2 individual vectors.  The 
%   columns of the matrix represent the high and low prices, in that 
%   order.
%
%   Example:   load disney.mat
%              dis_MedPrice = medprice(dis_HIGH, dis_LOW); 
%              plot(dis_MedPrice);
%
%   See also WCLOSE, TYPPRICE.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 177-178

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10 $   $Date: 2002/01/21 12:29:02 $

% Check input arguments.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_medprice:HIGHAndLOWRequired', ...
            'Two columns of data required: HIGH and LOW.');
    end
    highp   = varargin{1}(:, 1);
    lowp    = varargin{1}(:, 2);
case 2
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1))
        error('Ftseries:ftseries_medprice:InputVectorLengthsMustAgree', ...
            'The lengths of all input vectors must agree.');
    end
    highp   = varargin{1}(:);
    lowp    = varargin{2}(:);
otherwise
    error('Ftseries:ftseries_medprice:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the median prices.
mprc = (highp + lowp) / 2;

% [EOF]