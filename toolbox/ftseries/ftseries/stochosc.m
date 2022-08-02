function stosc = stochosc(varargin)
%STOCHOSC Stochastic Oscillator.
%
%   STOSC = STOCHOSC(HIGHP, LOWP, CLOSEP) calculates the Fast PercentK 
%   (F%K) and Fast PercentD (F%D) from the stock price data, HIGHP 
%   (high prices), LOWP (low prices), and CLOSEP (closing prices).  It 
%   uses %K period default of 10 periods, %D period default of 3 
%   periods, and %D moving average default method of exponential ('e').
%   STOSC is a 2-column matrix whose first column is the F%K values and
%   the second is the F%D values.
%
%   STOSC = STOCHOSC([HIGHP  LOWP  CLOSEP]) is similar to above 
%   except the input arguments being a 3-column matrix of high (HIGHP), 
%   low (LOWP, and closing prices (CLOSEP), in that order.  The default 
%   %K period used is also 10 periods, %D period default of 3 periods, 
%   and %D moving average default method of exponential ('e').
%
%   STOSC = STOCHOSC(HIGHP, LOWP, CLOSEP, KPERIODS, DPERIODS, DMAMETHOD) 
%   calculates the Fast PercentK (F%K) and Fast PercentD (F%D) from the 
%   stock price data, HIGHP (high prices), LOWP (low prices), and CLOSEP 
%   (closing prices).  The %K period is manually set through KPERIODS.  
%   The %D period is manually set through DPERIODS.  And, %D moving
%   average method is specified in DMAMETHOD.
%
%   STOSC= STOCHOSC([HIGHP  LOWP  CLOSEP], KPERIODS, DPERIODS, DMAMETHOD) 
%   is similar to above except the input arguments being a 3-column 
%   matrix of high (HIGHP), low (LOWP, and closing prices (CLOSEP), in 
%   that order.  The %K period is manually set through KPERIODS.  The 
%   %D period is manually set through DPERIODS.  And, %D moving average 
%   method is specified in DMAMETHOD.
%
%   Valid moving average methods for %D are Exponential ('e') and 
%   Triangular ('t').  Please refer to the help for TSMOVAVG for 
%   explanations on those methods.
%
%   Example:   load disney.mat
%              dis_StochOsc = stochosc(dis_HIGH, dis_LOW, dis_CLOSE);
%              plot(dis_StochOsc);
%
%   See also FPCTKD, SPCTKD.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 268-271

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10.2.1 $   $Date: 2003/01/16 12:51:23 $

% Check input arguments & extract them, if they are valid.
switch nargin
case 1   % stochosc([HIGHP  LOWP  CLOSEP])
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_stochosc:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    highp    = varargin{1}(:, 1);
    lowp     = varargin{1}(:, 2);
    closep   = varargin{1}(:, 3);
    kperiods = 10;
    dperiods  = 3;
    dmamethod = 'e';
case 2   % stochosc([HIGHP  LOWP  CLOSEP], KPERIODS)
    if size(varargin{1}, 2) ~= 3
        error('Ftseries:ftseries_stochosc:HIGH_LOW_CLOSERequired', ...
            'Three columns of data required: HIGH, LOW, and CLOSE.');
    end
    highp     = varargin{1}(:, 1);
    lowp      = varargin{1}(:, 2);
    closep    = varargin{1}(:, 3);
    kperiods  = varargin{2};
    if numel(kperiods) ~= 1 || mod(kperiods,1) ~= 0
        error('Ftseries:ftseries_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    dperiods  = 3;
    dmamethod = 'e';
case 3   % Two possibilities of input syntaxes. 
    switch size(varargin{1}, 2)
    case 1   % stochosc(HIGHP, LOWP, CLOSEP)
        highp     = varargin{1}(:);
        lowp      = varargin{2}(:);
        closep    = varargin{3}(:);
        if (size(highp, 1) ~= size(lowp, 1)) || ...
                (size(lowp, 1) ~= size(closep, 1))
            error('Ftseries:ftseries_stochosc:LengthOfInputsMustAgree', ...
                'Lengths of all input vectors must agree.');
        end
        kperiods  = 10;
        dperiods  = 3;
        dmamethod = 'e';
    case 3   % stochosc([HIGHP  LOWP  CLOSEP], KPERIODS, DPERIODS)
        highp     = varargin{1}(:, 1);
        lowp      = varargin{1}(:, 2);
        closep    = varargin{1}(:, 3);
        kperiods  = varargin{2};
        if numel(kperiods) ~= 1 || mod(kperiods,1) ~= 0
            error('Ftseries:ftseries_stochosc:KPERIODSMustBeScalar', ...
                'KPERIODS must be a scalar integer.');
        elseif isempty(kperiods)
            kperiods = 10;
        end
        if numel(dperiods) ~= 1 || mod(dperiods,1) ~= 0
            error('Ftseries:ftseries_stochosc:DPERIODSMustBeScalar', ...
                'DPERIODS must be a scalar integer.');
        elseif isempty(dperiods)
            dperiods = 3;
        end
        dperiods  = 3;
        dmamethod = 'e';
    otherwise
        error('Ftseries:ftseries_stochosc:FirstArgMustBe1or3ColumnMatrix', ...
            'First argument must be a 1- or 3-column matrix.');
    end
case 4   % Two possibilities of input syntaxes. 
    switch size(varargin{1}, 2)
    case 1  % stochosc(HIGHP, LOWP, CLOSEP, KPERIODS)
        highp     = varargin{1}(:);
        lowp      = varargin{2}(:);
        closep    = varargin{3}(:);
        kperiods  = varargin{4};
        if (size(highp, 1) ~= size(lowp, 1)) || ...
                (size(lowp, 1) ~= size(closep, 1))
            error('Ftseries:ftseries_stochosc:LengthOfInputsMustAgree', ...
                'Lengths of all input vectors must agree.');
        end
        if numel(kperiods) ~= 1 || mod(kperiods,1) ~= 0
            error('Ftseries:ftseries_stochosc:KPERIODSMustBeScalar', ...
                'KPERIODS must be a scalar integer.');
        elseif isempty(kperiods)
            kperiods = 10;
        end
        dperiods  = 3;
        dmamethod = 'e';
    case 3   % stochosc([HIGHP  LOWP  CLOSEP], KPERIODS, DPERIODS, DMAMETHOD)
        highp     = varargin{1}(:, 1);
        lowp      = varargin{1}(:, 2);
        closep    = varargin{1}(:, 3);
        kperiods  = varargin{2};
        dperiods  = varargin{3};
        dmamethod = varargin{4};
        if numel(kperiods) ~= 1 || mod(kperiods,1) ~= 0
            error('Ftseries:ftseries_stochosc:KPERIODSMustBeScalar', ...
                'KPERIODS must be a scalar integer.');
        elseif isempty(kperiods)
            kperiods = 10;
        end
        if numel(dperiods) ~= 1 || mod(dperiods,1) ~= 0
            error('Ftseries:ftseries_stochosc:DPERIODSMustBeScalar', ...
                'DPERIODS must be a scalar integer.');
        elseif isempty(dperiods)
            dperiods = 3;
        end
        if isempty(dmamethod)
            dmamethod = 'e';
        elseif ~ischar(dmamethod)
            error('Ftseries:ftseries_stochosc:InvalidMethod', ...
                'Valid method must be ''e'' or ''t''.');
        end
    otherwise
        error('Ftseries:ftseries_stochosc:FirstArgMustBe1or3ColumnMatrix', ...
            'First argument must be a 1- or 3-column matrix.');
    end
case 5   % stochosc(HIGHP, LOWP, CLOSEP, KPERIODS, DPERIODS)
    highp     = varargin{1}(:);
    lowp      = varargin{2}(:);
    closep    = varargin{3}(:);
    kperiods  = varargin{4};
    dperiods  = varargin{5};
    if (size(highp, 1) ~= size(lowp, 1)) || ...
            (size(lowp, 1) ~= size(closep, 1))
        error('Ftseries:ftseries_stochosc:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    if numel(kperiods) ~= 1 || mod(kperiods,1) ~= 0
        error('Ftseries:ftseries_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    if numel(dperiods) ~= 1 || mod(dperiods,1) ~= 0
        error('Ftseries:ftseries_stochosc:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 10;
    end
    dmamethod = 'e';
case 6   % stochosc(HIGHP, LOWP, CLOSEP, KPERIODS, DPERIODS, DMAMETHOD)
    highp     = varargin{1}(:);
    lowp      = varargin{2}(:);
    closep    = varargin{3}(:);
    kperiods  = varargin{4};
    dperiods  = varargin{5};
    dmamethod = varargin{6};
    if (size(highp, 1) ~= size(lowp, 1)) || ...
            (size(lowp, 1) ~= size(closep, 1))
        error('Ftseries:ftseries_stochosc:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    if numel(kperiods) ~= 1 || mod(kperiods,1) ~= 0
        error('Ftseries:ftseries_stochosc:KPERIODSMustBeScalar', ...
            'KPERIODS must be a scalar integer.');
    elseif isempty(kperiods)
        kperiods = 10;
    end
    if numel(dperiods) ~= 1 || mod(dperiods,1) ~= 0
        error('Ftseries:ftseries_stochosc:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 10;
    end
    if isempty(dmamethod)
        dmamethod = 'e';
    elseif ~ischar(dmamethod)
        error('Ftseries:ftseries_stochosc:InvalidMethod', ...
            'Valid method must be ''e'' or ''t''.');
    end
otherwise
    error('Ftseries:ftseries_stochosc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check for data suffiency.
if (length(highp) < kperiods) || (length(highp) < dperiods)
    error('Ftseries:ftseries_stochosc:KPERIODS_DPERIODSTooLarge', ...
        'KPERIODS and/or DPERIODS are greater than the number of data points.');
end

% Calculate the PercentK (%K).
pctk        = repmat(NaN,size(closep));
llv         = llow(lowp, kperiods);
hhv         = hhigh(highp, kperiods);
nzero       = find((hhv-llv) ~= 0);
pctk(nzero) = ((closep(nzero)-llv(nzero))./(hhv(nzero)-llv(nzero))) * 100;

% Calculate the PercentD (%D).
w = warning;
warning off Ftseries:ftseries_tsmovavg:WarnSyntaxChange

pctd               = NaN*ones(size(closep));
pctd(~isnan(pctk)) = tsmovavg(pctk(~isnan(pctk)), dmamethod, dperiods, 1);

warning(w)

% Form the output matrix.
stosc = [pctk pctd];

% [EOF]
