function nParameters = garchcount(Coefficients)
%GARCHCOUNT Count number of GARCH Toolbox estimation coefficients.
%   Given a GARCH Toolbox specification structure containing coefficient
%   estimates and equality constraint information, count and return the 
%   number of estimated coefficients. This function is a helper utility
%   designed to support the GARCH Toolbox model selection function AICBIC.
%
%   NumParams = garchcount(Coeff)
%
% Input:
%   Coeff - GARCH Toolbox specification structure containing the estimated 
%     coefficients and equality constraints. Coeff is an output of the 
%     estimation function GARCHFIT. Type "help garchfit" for details.
%
% Output:
%   NumParams - Number of estimated parameters. NumParams is defined as the 
%     number of estimated parameters included in the conditional mean and
%     variance specifications, less any parameters held constant as equality
%     constraints during the estimation. NumParams is needed for
%     calculating the AIC/BIC statistics. Type "help aicbic" for details.
%
% See also GARCHFIT, AICBIC, GARCHDISP.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.8.4.1 $   $Date: 2003/05/08 21:45:20 $


if ~isstruct(Coefficients)
   error('GARCH:garchcount:NonStructureInput' , ' ''Coeff'' must be a structure.')
end

%
% Extract model orders.
%

R   =  garchget(Coefficients , 'R');               % Conditional mean AR order.
M   =  garchget(Coefficients , 'M');               % Conditional mean MA order.
P   =  garchget(Coefficients , 'P');               % Conditional variance order for lagged variances.
Q   =  garchget(Coefficients , 'Q');               % Conditional variance order for lagged residuals.
nX  =  length(garchget(Coefficients , 'Regress')); % Number of regressors.

%
% Set some logical flags.
%

if isnan(garchget(Coefficients , 'C'))
   isConstantInMean  =  logical(0);    % Mean equation constant is NOT included.
else
   isConstantInMean  =  logical(1);    % Mean equation includes a constant.
end

varianceModel  =  garchget(Coefficients , 'VarianceModel');
[varianceModel , InMeanString] = strtok(varianceModel , '-');
isVarianceInMean = ~isempty(InMeanString);

distribution    =  garchget(Coefficients , 'Distribution');
distribution    =  distribution(~isspace(distribution));
isDistributionT =  strcmp(upper(distribution),'T');       % Set a flag to indicate a T distribution.

%
% Count the total number of parameters included in the composite
% mean and variance model.
%

nTotalParameters  =  isConstantInMean + R + M + nX + isVarianceInMean + 1 + P + Q + isDistributionT;

if any(strcmp(upper(varianceModel) , {'EGARCH' 'GJR'}))
   nTotalParameters  =  nTotalParameters + Q;             % Allow for Leverage terms.
end

%
% Extract equality constraint information for coefficients.
%

FixC        =  garchget(Coefficients , 'FixC');
FixAR       =  garchget(Coefficients , 'FixAR');
FixMA       =  garchget(Coefficients , 'FixMA');
FixRegress  =  garchget(Coefficients , 'FixRegress');
FixInMean   =  garchget(Coefficients , 'FixInMean');
FixK        =  garchget(Coefficients , 'FixK');
FixGARCH    =  garchget(Coefficients , 'FixGARCH');
FixARCH     =  garchget(Coefficients , 'FixARCH');
FixLeverage =  garchget(Coefficients , 'FixLeverage');
FixDoF      =  garchget(Coefficients , 'FixDoF');

if isempty(FixC)       , FixC        = zeros(isConstantInMean,1); end
if isempty(FixAR)      , FixAR       = zeros(R,1);  end
if isempty(FixMA)      , FixMA       = zeros(M,1);  end
if isempty(FixRegress) , FixRegress  = zeros(nX,1); end
if isempty(FixInMean)  , FixInMean   = zeros(isVarianceInMean,1); end

if isempty(FixK)       , FixK        = 0;                         end
if isempty(FixGARCH)   , FixGARCH    = zeros(P,1);                end
if isempty(FixARCH)    , FixARCH     = zeros(Q,1);                end
if isempty(FixLeverage), FixLeverage = zeros(length(garchget(Coefficients, 'Leverage')),1); end
if isempty(FixDoF)     , FixDoF      = zeros(isDistributionT,1);  end

%
% Format the equality constraint vector and count parameters.
%

Fix  = logical([FixC ;    FixAR(:) ;   FixMA(:) ;  FixRegress(:) ; FixInMean ; ...
                FixK ; FixGARCH(:) ; FixARCH(:) ; FixLeverage(:) ; FixDoF  ]);

nParameters  =  nTotalParameters - sum(Fix);         % Subtract equality constraints
