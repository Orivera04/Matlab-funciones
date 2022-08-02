function garchdisp(Coefficients , Errors)
%GARCHDISP Display GARCH Toolbox estimation results.
%   Given a GARCH Toolbox specification structure containing coefficient
%   estimates and equality constraint information, and the corresponding 
%   structure of standard errors, GARCHDISP displays the coefficient 
%   estimates, standard errors, and T-statistics obtained from the estimation
%   function GARCHFIT. 
%
%   garchdisp(Coeff , Errors)
%
% Inputs:
%   Coeff - Structure containing the estimated coefficients. Coeff is an output
%     of the estimation function GARCHFIT. Type "help garchfit" for details.
%
%   Errors - Structure containing the estimation errors (i.e., the standard 
%     errors) of the coefficients in Coeff. Errors is also an output of the 
%     estimation function GARCHFIT. Type "help garchfit" for details.
%
% Outputs:
%   This function is for display purposes only. It simply displays matched 
%   GARCH Toolbox estimation results in a convenient fashion, and passes no 
%   output arguments. The tabular display includes parameter estimates, 
%   standard errors, and T-statistics for each parameter in the conditional 
%   mean and variance models. Parameters held fixed during the estimation 
%   process will have the word 'Fixed' printed under the standard error and 
%   T-statistic columns, indicating the parameter was set as an equality 
%   constraint.
%
% See also GARCHFIT, GARCHCOUNT.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.11.4.1 $   $Date: 2003/05/08 21:45:21 $

if nargin < 2
   error('GARCH:garchdisp:UnspecifiedInput' , ' ''Coeff'' and ''Errors'' structures must both be specified.')
end

if ~isstruct(Coefficients)
   error('GARCH:garchdisp:NonStructureCoeff' , ' ''Coeff'' must be a structure.')
end

if ~isstruct(Errors)
   error('GARCH:garchdisp:NonStructureErrors' , ' ''Errors'' must be a structure.')
end

%
% Temporarily disable some warnings.
%

warning('off' , 'MATLAB:conversionToLogical')
warning('off' , 'MATLAB:divideByZero')

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

distribution    =  lower(garchget(Coefficients , 'Distribution'));
distribution    =  distribution(~isspace(distribution));
distribution(1) =  upper(distribution(1));               % Capitalize the first letter.
isDistributionT =  strcmp(upper(distribution),'T');      % Set a flag to indicate a T distribution.

%
% Extract parameter estimates.
%

C        =  garchget(Coefficients , 'C');        % Conditional mean constant.
AR       =  garchget(Coefficients , 'AR');       % Conditional mean AR coefficients.
MA       =  garchget(Coefficients , 'MA');       % Conditional mean MA coefficients.
regress  =  garchget(Coefficients , 'Regress');  % Regression coefficients.
InMean   =  garchget(Coefficients , 'InMean');   % Variance-in-mean coefficient.

K        =  garchget(Coefficients , 'K');        % Conditional variance constant.
GARCH    =  garchget(Coefficients , 'GARCH');    % Conditional variance coefficients for lagged variances.
ARCH     =  garchget(Coefficients , 'ARCH');     % Conditional variance coefficients for lagged residuals.
Leverage =  garchget(Coefficients , 'Leverage'); % Conditional variance Leverage coefficients.

DoF      =  garchget(Coefficients , 'DoF');

parameters =  [repmat(     C,isConstantInMean,1) ; AR(:) ;    MA(:) ; regress(:) ; ...
               repmat(InMean,isVarianceInMean,1) ;  K    ; GARCH(:) ;    ARCH(:) ; Leverage(:) ; 
               repmat(   DoF, isDistributionT,1)];
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
if isempty(FixLeverage), FixLeverage = zeros(length(Leverage),1); end
if isempty(FixDoF)     , FixDoF      = zeros(isDistributionT,1);  end


Fix  = logical([FixC ;    FixAR(:) ;   FixMA(:) ;  FixRegress(:) ; FixInMean ; ...
                FixK ; FixGARCH(:) ; FixARCH(:) ; FixLeverage(:) ; FixDoF  ]);

%
% Extract standard errors of the parameter estimates.
%

eC        =  garchget(Errors , 'C');
eAR       =  garchget(Errors , 'AR');
eMA       =  garchget(Errors , 'MA');
eRegress  =  garchget(Errors , 'Regress');
eInMean   =  garchget(Errors , 'InMean');

eK        =  garchget(Errors , 'K');
eGARCH    =  garchget(Errors , 'GARCH');
eARCH     =  garchget(Errors , 'ARCH');
eLeverage =  garchget(Errors , 'Leverage');
eDoF      =  garchget(Errors , 'DoF');

errors   =  [repmat(     eC,isConstantInMean,1) ; eAR(:) ;    eMA(:) ; eRegress(:) ; 
             repmat(eInMean,isVarianceInMean,1) ;  eK    ; eGARCH(:) ;    eARCH(:) ; eLeverage(:) ; 
             repmat(   eDoF, isDistributionT,1)];
%
% The presence of any NaN's in the input standard "Errors" structure will
% propagate into the "errors" vector above. At this point, any NaN's indicate
% that an error occurred in the calculation of the parameter estimation
% covariance matrix. The following flag indicates the presence or absence 
% of such an error condition.
%

errorFlag  =  any(isnan(errors));  % TRUE indicates an error occurred.

%
% Compute the total number of parameters estimated in the composite 
% conditional mean and variance models, excluding any held fixed as 
% user-specified equality constraints.
%

nTotalParameters  =  isConstantInMean + R + M + nX + isVarianceInMean + 1 + P + Q + isDistributionT;

if any(strcmp(upper(varianceModel) , {'EGARCH' 'GJR'}))
   nTotalParameters  =  nTotalParameters + Q;             % Allow for Leverage terms.
end

nEstimatedParameters  =  nTotalParameters - sum(Fix);     % Subtract equality constraints

%
% Display summary information.
%

disp   (' ')
disp   (['  ' deblank(fliplr(deblank(fliplr(garchget(Coefficients,'Comment')))))])
disp   (' ')
fprintf('  Conditional Probability Distribution: %s\n'   , distribution);
fprintf('  Number of Model Parameters Estimated: %d\n\n' , nEstimatedParameters);

header =  ['                               Standard          T     ' ;
           '  Parameter       Value          Error       Statistic ' ;
           ' -----------   -----------   ------------   -----------'];

disp(header)

%
% Format annotation strings and display the information. Note that
% the standard errors and T-statistics of parameters held fixed (equality
% constraints) during the estimation have zero estimation error, but are 
% visually highlighted with the string 'Fixed'.
%

n  =  [ones(isConstantInMean,1)  1:R  1:M  1:nX  ones(isVarianceInMean,1)  1  1:P  1:Q]' ;

if any(strcmp(upper(varianceModel) , {'EGARCH' 'GJR'}))
   n  =  [n ; [1:Q]'];
end

n  =  [n ; ones(isDistributionT,1)];

strings  =  strvcat(repmat('          C' , isConstantInMean , 1) , ...
                    repmat('      AR(#)' , R                , 1) , ...
                    repmat('      MA(#)' , M                , 1) , ...
                    repmat(' Regress(#)' , nX               , 1) , ...
                    repmat('     InMean' , isVarianceInMean , 1) , ...
                           '          K'                         , ...
                    repmat('   GARCH(#)' , P                , 1) , ...
                    repmat('    ARCH(#)' , Q                , 1) , ...
                    repmat('Leverage(#)' , length(Leverage) , 1) , ...
                    repmat('        DoF' , isDistributionT  , 1));
 
for row = 1:nTotalParameters
%
%   If no error occurred in the parameter estimation covariance 
%   matrix, then indicate that a particular parameter was held 
%   fixed throughout the optimization by printing 'Fixed'.
%
%   Otherwise, allow a NaN error condition to appear in the printout
%   to indicate the presence of an error condition.
%

    if Fix(row) & ~errorFlag
       fprintf(' %s    %-13.5g  %-s\n' , strrep(strings(row,:),'#',int2str(n(row))) , parameters(row) , 'Fixed            Fixed')
    else
       Tval = parameters(row) / errors(row); % Compute T-statistic for this parameter.
       fprintf(' %s    %-13.5g  %-13.5g %9.4f\n' , strrep(strings(row,:),'#',int2str(n(row))) , [parameters(row) errors(row) Tval]')
    end

end

%
% Restore warnings.
%

warning('on' , 'MATLAB:conversionToLogical')
warning('on' , 'MATLAB:divideByZero')
