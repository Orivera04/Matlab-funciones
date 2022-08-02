function adln = adline(varargin)
%ADLINE  Accumulation/Distribution Line.
%
%   ADLN = adline(HIGHP, LOWP, CLOSEP, TVOLUME) calculates the 
%   Accumulation/Distribution Line (vector), ADLN, for a set of stock
%   price and volume traded data (TVOLUME).  Thus, the inputs that must 
%   be included are the high (HIGHP), low (LOWP), close (CLOSEP) 
%   prices, and volume traded (TVOLUME).
%
%   ADLN = adline([HIGHP  LOWP  CLOSEP  TVOLUME]) does the same as 
%   above but the 4 input vectors are passed in as a 4-column matrix.
%
%   Example:   load disney.mat
%              dis_ADLine = adline(dis_HIGH, dis_LOW, dis_CLOSE, dis_VOLUME);
%              plot(dis_ADLine);
%
%   See also ADOSC, WILLAD, WILLPCTR.

%
%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 52-53

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $   $Date: 2002/01/21 12:27:36 $

% Check input arguments & extract them, if they are valid.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 4
        error('Ftseries:ftseries_adline:InvalidNumberOfInputDataColumns', ...
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
        error('Ftseries:ftseries_adline:InputVectorsMustBeTheSameLength', ...
            'Lengths of all input vectors must be the same.');
    end
    
    highp   = varargin{1}(:);
    lowp    = varargin{2}(:);
    closep  = varargin{3}(:);
    tvolume = varargin{4}(:);
otherwise
    error('Ftseries:ftseries_adline:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the Accumulation/Distribution Line.
tadln = NaN * ones(size(closep));
adln = tadln;
nzero = find((highp-lowp) ~= 0);
tadln(nzero) = (((closep(nzero)-lowp(nzero))-(highp(nzero)-closep(nzero))) ./ ...
    (highp(nzero)-lowp(nzero))) .* tvolume(nzero);
adln(~isnan(tadln)) = cumsum(tadln(~isnan(tadln)));

% [EOF]