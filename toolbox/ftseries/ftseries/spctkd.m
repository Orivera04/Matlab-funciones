function [spctk, spctd] = spctkd(varargin)
%SPCTKD  Slow Stochastics, PercentK (S%K) and PercentD (S%D).
%
%   [SPCTK, SPCTD] = SPCTKD(FASTPCTK, FASTPCTD) calculates the slow
%   stochastics, S%K and S%D, using the default 3-period exponential
%   moving average for S%D.  The inputs must be the fast stochastics,
%   F%K and F%D. Also, they both must be single column-oriented 
%   vectors  The outputs, SPCTK and SPCTD, are column vectors 
%   representing the respective slow stochastics.
%
%   [SPCTK, SPCTD] = SPCTKD([FASTPCTK  FASTPCTD]) is similar to the 
%   above with the exception that the input must be a 2-column matrix 
%   rather than 2 separate vectors.  The first column must be the F%K 
%   values and the second must be the F%D values.
%
%   [SPCTK, SPCTD] = SPCTKD(FASTPCTK, FASTPCTD, DPERIODS, DMAMETHOD) 
%   calculates the slow stochastics, S%K and S%D, using the 
%   DPERIODS-period DMAMETHOD moving average for S%D.
%
%   [SPCTK, SPCTD] = SPCTKD([FASTPCTK  FASTPCTD], DPERIODS, DMAMETHOD) 
%   is similar to the above with the exception that the input must be 
%   a 2-column matrix rather than 2 separate vectors.  The first 
%   column must be the F%K values and the second must be the F%D values.
%
%   Valid moving average methods for DMAMETHOD are Exponential ('e'), 
%   Triangular ('t'), and Modified ('m').  Please refer to the help for 
%   TSMOVAVG for explanations on those methods.
%
%   Example:   load disney.mat
%              [dis_FPctK, dis_FPctD] = fpctkd(dis_HIGH, dis_LOW, dis_CLOSE);
%              [dis_SPctK, dis_SPctD] = spctkd(dis_FPctK, dis_FPctD);
%              plot([dis_SPctK, dis_SPctD]);
%
%   See also FPCTKD, STOCHOSC.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 268-271

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.13.2.1 $   $Date: 2003/01/16 12:51:22 $

% Check input argument.
switch nargin
case 1   % spctkd([FASTPCTK  FASTPCTD])
    if size(varargin{1}, 2) ~= 2
        error('Ftseries:ftseries_spctkd:FastKAndFastDRequired', ...
            'Two columns of data required: Fast PercentK and Fast PercentD.');
    end
    fpctk     = varargin{1}(:, 1);
    fpctd     = varargin{1}(:, 2);
    dperiods  = 3;
    dmamethod = 'e';
case 2    % 2 possibilities
    switch size(varargin{1}, 2)
    case 1   % spctkd(FASTPCTK, FASTPCTD)
        fpctk     = varargin{1}(:);
        fpctd     = varargin{2}(:);
        if (size(fpctk, 1) ~= size(fpctd, 1))
            error('Ftseries:ftseries_spctkd:LengthOfInputsMustAgree', ...
                'Lengths of all input vectors must agree.');
        end
        dperiods  = 3;
        dmamethod = 'e';
    case 2   % spctkd([FASTPCTK  FASTPCTD], DPERIODS)
        fpctk     = varargin{1}(:, 1);
        fpctd     = varargin{1}(:, 2);
        dperiods  = varargin{2};
        if prod(size(dperiods)) ~= 1 | mod(dperiods,1) ~= 0
            error('Ftseries:ftseries_spctkd:DPERIODSMustBeScalar', ...
                'DPERIODS must be a scalar integer.');
        elseif isempty(dperiods)
            dperiods = 3;
        end
        dmamethod = 'e';
    otherwise
        error('Ftseries:ftseries_spctkd:FirstArgMustBeA1or2ColumnMatrix', ...
            'First argument must either be a 1- or 2-column matrix.');
    end
case 3   % 2 possibilities
    switch size(varargin{1}, 2)
    case 1   % spctkd(FASTPCTK, FASTPCTD, DPERIODS)
        fpctk     = varargin{1}(:);
        fpctd     = varargin{2}(:);
        dperiods  = varargin{3};
        if (size(fpctk, 1) ~= size(fpctd, 1))
            error('Ftseries:ftseries_spctkd:LengthOfInputsMustAgree', ...
                'Lengths of all input vectors must agree.');
        end
        if prod(size(dperiods)) ~= 1 | mod(dperiods,1) ~= 0
            error('Ftseries:ftseries_spctkd:DPERIODSMustBeScalar', ...
                'DPERIODS must be a scalar integer.');
        elseif isempty(dperiods)
            dperiods = 3;
        end
        dmamethod = 'e';
    case 2  % spctkd([FASTPCTK  FASTPCTD], DPERIODS, DMAMETHOD)
        fpctk     = varargin{1}(:, 1);
        fpctd     = varargin{1}(:, 2);
        dperiods  = varargin{2};
        dmamethod = varargin{3}; 
        if prod(size(dperiods)) ~= 1 | mod(dperiods,1) ~= 0
            error('Ftseries:ftseries_spctkd:DPERIODSMustBeScalar', ...
                'DPERIODS must be a scalar integer.');
        elseif isempty(dperiods)
            dperiods = 3;
        end
        if isempty(dmamethod)
            dmamethod = 'e';
        elseif ~ischar(varargin{3})
            error('Ftseries:ftseries_spctkd:DMAMETHODMustBeString', ...
                'DMAMETHOD must be a string.');
        end
    otherwise
        error('Ftseries:ftseries_spctkd:FirstArgMustBeA1or2ColumnMatrix', ...
            'First argument must either be a 1- or 2-column matrix.');
    end
case 4   % spctkd(FASTPCTK, FASTPCTD, DPERIODS, DMAMETHOD)
    fpctk     = varargin{1}(:);
    fpctd     = varargin{2}(:);
    dperiods  = varargin{3};
    dmamethod = varargin{4};
    if (size(fpctk, 1) ~= size(fpctd, 1))
        error('Ftseries:ftseries_spctkd:LengthOfInputsMustAgree', ...
            'Lengths of all input vectors must agree.');
    end
    if prod(size(dperiods)) ~= 1 | mod(dperiods,1) ~= 0
        error('Ftseries:ftseries_spctkd:DPERIODSMustBeScalar', ...
            'DPERIODS must be a scalar integer.');
    elseif isempty(dperiods)
        dperiods = 3;
    end
    if isempty(dmamethod)
        dmamethod = 'e';
    elseif ~ischar(varargin{4})
        error('Ftseries:ftseries_spctkd:DMAMETHODMustBeString', ...
            'DMAMETHOD must be a string.');
    end
otherwise
    error('Ftseries:ftseries_spctkd:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check for data sufficiency.
if length(fpctk) < dperiods
    error('Ftseries:ftseries_hhigh:DPERIODSTooLarge', ...
        'DPERIODS is too large for the number of data points.');
end

% Calculate the Slow PercentK (S%K) (which is equal to F%D).
spctk = fpctd;

% Calculate the Slow PercentD (S%D) (moving average of S%K).
w = warning;
warning off Ftseries:ftseries_tsmovavg:WarnSyntaxChange

spctd = NaN*ones(size(spctk));
spctd(~isnan(spctk)) = tsmovavg(spctk(~isnan(spctk)), dmamethod, dperiods, 1);

warning(w)

% [EOF]
