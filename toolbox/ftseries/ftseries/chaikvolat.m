function chvol = chaikvolat(varargin)
%CHAIKVOLAT Chaikin's Volatility.
%
%   CHVOL = CHAIKVOLAT(HIGHP, LOWP) calculates the Chaikin's Volatility
%   from the series of stock prices, HIGHP and LOWP, which represents the
%   high and low prices, respectively.  CHVOL is a vector which contains 
%   the Chaikin's Volatility values which are calculated based on a 
%   10-period exponential moving average and 10-period period difference.
%
%   CHVOL = CHAIKVOLAT([HIGHP  LOWP]) does the same as above but instead
%   of having 2 vectors as inputs, it has a 2-column matrix as the input.
%
%   CHVOL = CHAIKVOLAT(HIGHP, LOWP, NPERDIFF, MANPER) does the same as 
%   above with the exception that one can manually set the period 
%   difference NPERDIFF and the length of the exponential moving average
%   MANPER in periods.  The default for NPERDIFF and MANPER is 10.
%
%   CHVOL = CHAIKVOLAT([HIGHP  LOWP], NPERDIFF, MANPER) does the same 
%   as above but instead of having 2 vectors as inputs, it has a 
%   2-column matrix as the first input.
%
%   Example:   load disney.mat
%              dis_ChaikVol = chaikvolat(dis_HIGH, dis_LOW);
%              plot(dis_ChaikVol);
%
%   See also CHAIKOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 304-305

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11.2.1 $   $Date: 2003/01/16 12:51:15 $

% Check input arguments.
switch nargin
case 1   % chaikvolat([HIGHP LOWP])
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_chaikvolat:HighAndLowPricesRequired', ...
            'Two columns of information required: HIGH and LOW prices.');
    end
    highp = varargin{1}(:, 1);
    lowp  = varargin{1}(:, 2);
    nperdiff = 10;
    manper   = 10;
case 2   % chaikvolat(HIGHP, LOWP) or chaikvolat([HIGHP LOWP], NPERDIFF)
    switch size(varargin{1}, 2)
    case 1
        if size(varargin{2}, 1) ~= size(varargin{1}, 1)
            error('Ftseries:ftseries_chaikvolat:InputsMustBeTheSameLength', ...
                'The first and second input must be vectors of the same length.');
        end
        highp = varargin{1};
        lowp  = varargin{2};
        nperdiff = 10;
        manper   = 10;
    case 2
        if prod(size(varargin{2})) ~= 1
            error('Ftseries:ftseries_chaikvolat:NPERDIFFMustBeScalar', ...
                'NPERDIFF must be a scalar integer.');
        end
        highp = varargin{1}(:, 1);
        lowp  = varargin{1}(:, 2);
        nperdiff = varargin{2};
        manper   = 10;
    end
case 3   % chaikvolat(HIGHP, LOWP, NPERDIFF) or chaikvolat([HIGHP LOWP], NPERDIFF, MANPER)
    switch size(varargin{1}, 2)
    case 1
        if size(varargin{2}, 1) ~= size(varargin{1}, 1)
            error('Ftseries:ftseries_chaikvolat:InputsMustBeTheSameLength', ...
                'The first and second input must be vectors of the same length.');
        end
        if prod(size(varargin{3})) ~= 1
            error('Ftseries:ftseries_chaikvolat:NPERDIFFMustBeScalar', ...
                'NPERDIFF must be a scalar integer.');
        end
        highp = varargin{1};
        lowp  = varargin{2};
        nperdiff = varargin{3};
        manper   = 10;
    case 2
        if prod(size(varargin{2})) ~= 1 | prod(size(varargin{3})) ~= 1
            error('Ftseries:ftseries_chaikvolat:NPERDIFFAndMANPERMustBeScalar', ...
                'NPERDIFF and MANPER must be scalar integers.');
        end
        highp = varargin{1}(:, 1);
        lowp  = varargin{1}(:, 2);
        nperdiff = varargin{2};
        manper   = varargin{3};
    end
case 4   % chaikvolat(HIGHP, LOWP, NPERDIFF, MANPER)
    if size(varargin{2}, 1) ~= size(varargin{1}, 1)
        error('Ftseries:ftseries_chaikvolat:InputsMustBeTheSameLength', ...
            'The first and second input must be vectors of the same length.');
    end
    if prod(size(varargin{3})) ~= 1 | prod(size(varargin{4})) ~= 1
        error('Ftseries:ftseries_chaikvolat:NPERDIFFAndMANPERMustBeScalar', ...
            'NPERDIFF and MANPER must be scalar integers.');
    end
    highp = varargin{1};
    lowp  = varargin{2};
    nperdiff = varargin{3};
    manper   = varargin{4};
otherwise
    error('Ftseries:ftseries_chaikvolat:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the MANPER-day exponential moving average of HIGHP-LOWP.
w = warning;
warning off Ftseries:ftseries_tsmovavg:WarnSyntaxChange

hlema = NaN*ones(size(highp));
hlema(~isnan(highp)) = tsmovavg(highp(~isnan(highp))-lowp(~isnan(lowp)), 'e', manper, 1);

warning(w)

% Calculate the Chakin's Colatility based on NPERDIFF period difference.
chvol = NaN*ones(size(hlema));
for pidx = nperdiff:length(chvol)
    chvol(pidx) = ((hlema(pidx)-hlema(pidx-nperdiff+1))./(hlema(pidx-nperdiff+1))) * 100;
end

% [EOF]