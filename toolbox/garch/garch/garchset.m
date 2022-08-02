function options = garchset(varargin)
%GARCHSET Create/alter GARCH Toolbox specification structure.
%   GARCHSET provides the main user-interface for specifying GARCH Toolbox
%   parameters, and is the preferred method for creating and modifying GARCH 
%   model specification structures. 
%
%   Spec = garchset('Parameter1', Value1 , 'Parameter2' , Value2 , ...) 
%   Spec = garchset(OldSpec , 'Parameter1' , Value1 , ...)
%   Spec = garchset
%   garchset
%
%   The first calling syntax creates a GARCH specification structure Spec in
%   which the input argument list is specified as parameter/value pairs. The 
%   Parameter portion of the pair must be recognized as a valid field of the 
%   output structure Spec; the Value portion of the pair is then assigned to
%   it's paired Parameter field such that the named parameters have the specified 
%   values. It is sufficient to type only the leading characters that uniquely 
%   identify a parameter. Case is ignored for parameter names. Valid parameters 
%   fields are listed below.
%
%   The second calling syntax modifies an existing GARCH specification 
%   structure, OldSpec, changing the named parameters to the specified values.
%   
%   The third calling syntax (with no input arguments) creates a specification 
%   structure template for the GARCH Toolbox default model: The conditional 
%   mean equation is a simple constant plus additive noise, while the 
%   conditional variance equation of the additive noise is a GARCH(1,1) model.
%
%   The fourth calling syntax (with no input arguments and no output arguments) 
%   displays all parameter field names and default values where appropriate.
%
% Inputs:
%   Parameter - String representing a valid parameter field of the output 
%     structure Spec (see below).
%
%   Value - The value assigned to the corresponding Parameter. 
%
%   OldSpec - An existing specification structure to be changed, probably 
%     created from a previous call to GARCHSET, or the output of GARCHFIT.
%
% Output:
%   Spec - The first three calling syntaxes return a structure encapsulating 
%     the style, orders, and coefficients (if specified) of the conditional 
%     mean and variance specifications of a GARCH model. It also encapsulates
%     the relevant parameters associated with the function FMINCON of the MATLAB 
%     Optimization Toolbox; type "help fmincon" or "help optimset" for 
%     additional details.
% 
% GARCHSET Parameters:
%
%  (1) General Parameters:
%
%      Comment - Summary comment. [ string | {model summary string} ]
% Distribution - Conditional distribution of innovations.
%                [ string | 'T' | {'Gaussian'} ]
%          DoF - Degrees of freedom parameter for T distributions (must be > 2). 
%                [ scalar | {[]} ]
%
%  (2) Conditional Mean Parameters:
%
%            R - Auto-regressive model order of an ARMA(R,M) model.
%                [ non-negative integer scalar | {0} ]
%            M - Moving-average model order of an ARMA(R,M) model.
%                [ non-negative integer scalar | {0} ]
%            C - Conditional mean constant. [ scalar coefficient | {[]} ]
%           AR - Auto-regressive coefficients associated with a stationary AR
%                polynomial. [ R-element vector | {[]} ]
%           MA - Moving average coefficients associated with an invertible MA
%                polynomial. [ M-element vector | {[]} ] 
%      Regress - Linear regression coefficients.
%                [ vector of coefficients | {[]} ]
%
%  (3) Conditional Variance Parameters:
%
%VarianceModel - Conditional variance model. 
%                [ string | 'GARCH' | 'EGARCH' | 'GJR' | {'Constant'} ]
%            P - Model order of GARCH(P,Q), EGARCH(P,Q), and GJR(P,Q) models. 
%                [ non-negative integer scalar | {0} ]
%            Q - Model order of GARCH(P,Q), EGARCH(P,Q), and GJR(P,Q) models.
%                [ non-negative integer scalar | {0} ]
%            K - Conditional variance constant. 
%                [ scalar coefficient | {[]} ]
%        GARCH - Coefficients related to lagged conditional variances.
%                [ P-element vector | {[]} ]
%         ARCH - Coefficients related to lagged innovations. 
%                [ Q-element vector | {[]} ]
%     Leverage - Leverage coefficients for asymmetric EGARCH(P,Q) and GJR(P,Q)
%                models. [ Q-element vector | {[]} ]
%
%  (4) Optimization Parameters (Used only by GARCHFIT during estimation):
%
%      Display - Optimization iteration display flag. [ string | 'off' | {'on'}]
%  MaxFunEvals - Maximum number of objective function evaluations allowed.
%                [ positive integer | {100*(number of estimated parameters)} ]
%      MaxIter - Maximum number of iterations allowed. 
%                [ positive integer | {400} ]
%       TolCon - Termination tolerance on the constraint violation.
%                [ positive scalar | {1e-007} ]
%       TolFun - Termination tolerance on the objective function value.
%                [ positive scalar | {1e-006} ]
%         TolX - Termination tolerance on parameter estimates. 
%                [ positive scalar | {1e-006} ]
%
%  (5) Equality Constraint Parameters (Used only by GARCHFIT; use sparingly):
%
%       FixDoF - Equality constraint indicator for DoF parameter.
%                [ logical scalar | {[]} ]
%         FixC - Equality constraint indicator for C constant. 
%                [ logical scalar | {[]} ]
%        FixAR - Equality constraint indicator for AR coefficients. 
%                [ R-element logical vector | {[]} ]
%        FixMA - Equality constraint indicator for MA coefficients.
%                [ M-element logical vector | {[]} ]
%   FixRegress - Equality constraint indicator for Regress coefficients.
%                [ logical vector | {[]} ]
%         FixK - Equality constraint indicator for K constant.
%                [ logical scalar | {[]} ]
%     FixGARCH - Equality constraint indicator for GARCH coefficients. 
%                [ P-element logical vector | {[]} ]
%      FixARCH - Equality constraint indicator for ARCH coefficients. 
%                [ Q-element logical vector | {[]} ]
%  FixLeverage - Equality constraint indicator for Leverage coefficients. 
%                [ Q-element logical vector | {[]} ]
%
% See also GARCHGET, GARCHFIT, GARCHSIM, GARCHPRED, OPTIMSET, FMINCON.

%   Copyright 1999-2004 The MathWorks, Inc.
%   $Revision: 1.15.4.3 $   $Date: 2004/04/06 01:10:07 $

%
% SPECIAL NOTE: Variance-in-Mean Models
%
% In addition to the fields formally documented, the GARCH Toolbox specification 
% structure supports the following UNDOCUMENTED parameters:
%
%       InMean - Scalar coefficient for variance-in-mean models. 
%                [ scalar coefficient | {[]} ]
%    FixInMean - Equality constraint indicator for InMean coefficient.
%                [ logical scalar | {[]} ]
%
% In the code that follows, the 'InMean' parameter is a coupling coefficient
% that allows inclusion of the conditional variance as an explanatory variable
% in the conditional mean equation. Users may SET/GET the 'InMean' and 'FixInMean'
% parameter fields for all supported volatility models (i.e., GARCH-M, EGARCH-M, 
% and GJR-M models).
%
% However, in all cases, it is the conditional VARIANCE that is included in 
% the mean equation.
%

%
% Print out possible values of properties.
%

if (nargin == 0) & (nargout == 0)
   fprintf('\n');

   fprintf('       Comment: [ string ]\n\n');
   fprintf('  Distribution: [ string | ''T'' | {''Gaussian''} ]\n');
   fprintf('           DoF: [ scalar degrees of freedom > 2 (T distribution) | {[]} ]\n\n');

   fprintf('             R: [ non-negative integer scalar AR model order | {0} ]\n');
   fprintf('             M: [ non-negative integer scalar MA model order | {0} ]\n\n');

   fprintf('             C: [ scalar constant in conditional mean | {[]} ]\n\');
   fprintf('            AR: [ R-element vector of stationary AR coefficients | {[]} ]\n');
   fprintf('            MA: [ M-element vector of invertible MA coefficients | {[]} ]\n');
   fprintf('       Regress: [ vector of linear regression coefficients | {[]} ]\n\n');

   fprintf(' VarianceModel: [ string for conditional variance model ]\n');

   fprintf('             P: [ non-negative integer scalar | {0} ]\n');
   fprintf('             Q: [ non-negative integer scalar | {0} ]\n\n');

   fprintf('             K: [ scalar constant in conditional variance | {[]} ]\n');
   fprintf('         GARCH: [ P-element vector of coefficients | {[]} ]\n');
   fprintf('          ARCH: [ Q-element vector of coefficients | {[]} ]\n');
   fprintf('      Leverage: [ Q-element vector of coefficients (EGARCH & GJR models) | {[]} ]\n\n');

   fprintf('       Display: [ string | ''off'' | {''on''} ]\n');
   fprintf('   MaxFunEvals: [ positive integer | {100*(number of estimated parameters) ]\n');
   fprintf('       MaxIter: [ positive integer | {400} ]\n');
   fprintf('        TolCon: [ positive scalar | {1e-007} ]\n');
   fprintf('        TolFun: [ positive scalar | {1e-006} ]\n');
   fprintf('          TolX: [ positive scalar | {1e-006} ]\n\n');

   fprintf('        FixDoF: [ logical scalar | {[]} ]\n');
   fprintf('          FixC: [ logical scalar | {[]} ]\n');
   fprintf('         FixAR: [ logical R-element vector | {[]} ]\n');
   fprintf('         FixMA: [ logical M-element vector | {[]} ]\n');
   fprintf('    FixRegress: [ logical vector | {[]} ]\n\n');

   fprintf('          FixK: [ logical scalar | {[]} ]\n');
   fprintf('      FixGARCH: [ logical P-element vector | {[]} ]\n');
   fprintf('       FixARCH: [ logical Q-element vector | {[]} ]\n');
   fprintf('   FixLeverage: [ logical Q-element vector | {[]} ]\n\n');
   return;
end

%
% Return the default model when no inputs are specified: 
%
%   y(t) = C + e(t) where e(t) is a simple GARCH(1,1) model (a la Bollerslev 1986).
%

if nargin == 0
   options  =  garchset('VarianceModel' , 'GARCH' , 'P' , 1 , 'Q' , 1);
   return
end


%
% Assign the list of valid fields.
%
% NOTE: Although the actual fields present in any given output specification
%       structure depend upon the particular ARMAX(R,M,Nx)/GARCH(P,Q) model 
%       selected, ONLY the fields 'Comment', 'Distribution', 'C', 'VarianceModel', 
%       and 'K' are present in every output structure.
%

fields = {'Comment'; 'Distribution'; 'R'             ; 'M'          ; 'P'       ;
          'Q'      ; 'DoF'         ; 'C'             ; 'AR'         ; 'MA'      ; 
          'InMean' ; 'Regress'     ; 'VarianceModel' ; 'K'          ; 'GARCH'   ; 
          'ARCH'   ; 'Leverage'    ; 'FixDoF'        ; 'FixC'       ; 'FixAR'   ;
          'FixMA'  ; 'FixInMean'   ; 'FixRegress'    ; 'FixK'       ; 'FixGARCH';
          'FixARCH'; 'FixLeverage' ; 'Display'       ; 'MaxFunEvals'; 'MaxIter' ;
          'TolFun' ; 'TolCon'      ; 'TolX'         };

lowerFields  =  lower(fields);

%
% Scrub the input argument list from a top-level perspective.
%

if rem(nargin , 2) == 1

%
%  When updating an existing specification structure, ensure that the structure
%  is the first input in the argument list. This situation will have an odd number
%  of inputs, and the first input is the ONLY structure in the list.
%
   if ~isstruct(varargin{1})
      error('GARCH:garchset:NonStructure' , ' First Input Must Be a Structure for an Odd Number of Inputs.');
   end

   for i = 2:nargin
       if isstruct(varargin{i})
          error('GARCH:garchset:TooManyStructures' , ' Only the First Input May Be Structure.');
       end
   end

   updateFlag  =  logical(1);    % An existing structure will be updated.
   oldSpec     =  varargin{1};   % Save the existing structure to be updated.

%
%  Extract the parameter/value pairs from the input list for further error checking.
%
   parameters =  varargin(2:2:nargin-1);
   values     =  varargin(3:2:nargin);

else

%
%  An even number of inputs implies that we are NOT updating an existing specification
%  structure. This situation should ONLY have parameter/value pairs, and no structures
%  should appear in the input argument list. 
%

   for i = 1:nargin
       if isstruct(varargin{i})
          error('GARCH:garchset:NoStructureAllowed' , ' No Structures Allowed for an Even Number of Inputs.');
       end
   end

   updateFlag  =  logical(0);    % No existing structure to be updated.

%
%  Extract the parameter/value pairs from the input list for further error checking.
%
   parameters =  varargin(1:2:nargin-1);
   values     =  varargin(2:2:nargin);

end

%
% Create an empty shell for the output specification structure.
%

options = struct('Comment'    , [] , 'Distribution', [] , 'DoF'          , [] , 'R'      , [] , ...
                 'M'          , [] , 'C'           , [] , 'AR'           , [] , 'MA'     , [] , ...
                 'Regress'    , [] , 'InMean'      , [] , 'VarianceModel', [] , 'P'      , [] , ...
                 'Q'          , [] , 'K'           , [] , 'GARCH'        , [] , 'ARCH'   , [] , ...
                 'Leverage'   , [] , 'FixDoF'      , [] , 'FixC'         , [] , 'FixAR'  , [] , ...
                 'FixMA'      , [] , 'FixRegress'  , [] , 'FixInMean'    , [] , 'FixK'   , [] , ...
                 'FixGARCH'   , [] , 'FixARCH'     , [] , 'FixLeverage'  , [] , 'Display', [] , ...
                 'MaxFunEvals', [] , 'MaxIter'     , [] , 'TolFun'       , [] , 'TolCon' , [] , ...
                 'TolX'       , []);
%
% Assign the fields of the existing input specification structure (if any)
% to the output specification structure. 
%

if updateFlag

%
%  Add some special-purpose code to handle the GARCH Toolbox version 1.0
%  specification structure. The v1.0 structure buried the optimization
%  related fields {'Display', 'MaxFunEvals', 'MaxIter', 'TolFun', 'TolCon', 
%  and 'TolX'} in a nested structure field called 'Optimization'. 
%
   if isfield(oldSpec , 'Optimization')
%
%     The presence of the 'Optimization' field indicates a version 1.0 structure.
%     If the user did not specify values for the optimization-related fields, the 
%     version 1.0 structure ALWAYS placed the default FMINCON parameter values 
%     into the optimization-related fields. 
%
%     The new specification structure includes ONLY those fields (1) which
%     are necessary for a given model, and/or (2) for which the user specified 
%     values for the parameters. Thus, the code below determines if the default
%     values for the optimization-related fields are in effect. If the fields 
%     contain default values, then the fields are set to empty matrices such that
%     the output specification structure will NOT even contain these fields. If 
%     non-default values are found, they are assigned to the corresponding field.
%
%     Regardless of the value (default or not), temporarily bring the optimization
%     fields up one level and proceed.
%
      if strcmpi(oldSpec.Optimization.Display , 'iter') & strcmpi(oldSpec.Optimization.Diagnostics , 'on')
         oldSpec.Display  =  [];
      else
         oldSpec.Display  =  oldSpec.Optimization.Display;
      end

      if strcmpi(oldSpec.Optimization.MaxFunEvals , '100*numberofvariables')
         oldSpec.MaxFunEvals  =  [];
      else
         oldSpec.MaxFunEvals  =  oldSpec.Optimization.MaxFunEvals;
      end

      if isequal(oldSpec.Optimization.MaxIter , 400)
          oldSpec.MaxIter  =  [];
      else
          oldSpec.MaxIter  =  oldSpec.Optimization.MaxIter;
      end

      if isequal(oldSpec.Optimization.TolFun , 1.0e-6)
          oldSpec.TolFun  =  [];
      else
          oldSpec.TolFun  =  oldSpec.Optimization.TolFun;
      end

      if isequal(oldSpec.Optimization.TolCon , 1.0e-6)
          oldSpec.TolCon  =  [];
      else
          oldSpec.TolCon  =  oldSpec.Optimization.TolCon;
      end

      if isequal(oldSpec.Optimization.TolX , 1.0e-6)
          oldSpec.TolX  =  [];
      else
          oldSpec.TolX  =  oldSpec.Optimization.TolX;
      end

      oldSpec  =  rmfield(oldSpec , 'Optimization');

   end

   for n = 1:length(fields)
       if isfield(oldSpec , fields{n}) 
          options = setfield(options , fields{n} , getfield(oldSpec , fields{n}));
       end
   end

end

%
% Scrub the parameters (i.e., specification structure fields) from the input list.
%

for n = 1:length(parameters)

%
%   Ensure that all parameters (i.e., specification structure fields) in 
%   parameter/value pairs are strings.
%
    if ~ischar(parameters{n})
       error('GARCH:garchset:NonStringInput' , ' Input Argument Number %s Must Be a String Parameter Name.' , num2str(2*n + updateFlag - 1));
    end
%
%   Ensure that all parameters represent valid, unambiguous field names.
%
    matches = strmatch(lower(parameters{n}) , lowerFields);

    if isempty(matches)
% 
%      No matches found: Parameter is unknown.
%
       error('GARCH:garchset:InvalidParameter' , ' Unrecognized Parameter Name ''%s''.' , parameters{n})

    elseif length(matches) > 1
% 
%      More than one match:
%
       exacts = strmatch(lower(parameters{n}) , lowerFields , 'exact');

       if length(exacts) == 1
% 
%         An exact match if OK.
%
          matches = exacts;

       else
%
%         The parameter is ambiguous and additional information is needed to resolve.
%
          message = [' Ambiguous Parameter Name '''  parameters{n} ''' (' fields{matches(1)}];

          for exacts = matches(2:length(matches))'
              message = [message ', ' fields{exacts}];
          end

          error('GARCH:garchset:AmbiguousParameter' , [message ').'])

       end

    end
%
%   Update the output specification structure with the input the parameter/value pairs.
%
    options  =  setfield(options , fields{matches} , values{n});

end

%
%         * * * * *  Error/consistency checks & default setting.  * * * * * 
%

%
% Check Auto-Regressive & Moving-Average specifications. 
%
% Note: The AR & MA coefficients are SPECIFIED as a user would read
%       them from a difference equation written in recursive form. 
%       However, when TESTING for AR stationarity and MA invertibility, 
%       a polynomial is formed whose roots are the eigenvalues. The AR/MA
%       process is stationary/invertible only if ALL eigenvalues lie inside
%       the unit circle. 
%
% Example: Consider the ARMA(2,2) model with difference equation 
%
%       y(t) = 0.6y(t-1) + 0.2y(t-1) + e(t) - 0.6e(t-1) + 0.08e(t-2)
%
%       The AR coefficient vector would be entered as [ 0.6  0.20].
%       The MA coefficient vector would be entered as [-0.6  0.08].
%
%       The AR polynomial equation is 
%
%              (z^2 - 0.6z - 0.20) = 0 
%
%       with roots (eigenvalues) z = (0.84 , -0.24) (see Hamilton, page 13).
%
%       The MA polynomial equation is 
%
%              (z^2 - 0.6z + 0.08) = 0
%
%       with roots (eigenvalues) z = (0.4 , 0.2) (see Hamilton, page 31).
%       
%       Thus, the AR coefficients are negated when determining the 
%       roots of the AR polynomial.
%

errorCode  =  errorCheck(options.R , -options.AR , [1 2 4 5 6 9]);

switch errorCode(1)
   case {1 , 2 , 4}
      error('GARCH:garchset:InvalidR' , ' Auto-regressive order ''R'' must be a non-negative, integer, scalar.');
   case 5
      error('GARCH:garchset:NonVectorAR' , ' Auto-regressive coefficients ''AR'' must be a vector.');
   case 6
      error('GARCH:garchset:NonStationaryAR' , ' Auto-regressive polynomial ''AR'' must be stationary.');
   case 9
      error('GARCH:garchset:MismatchAR' , ' Length of ''AR'' vector must equal auto-regressive order ''R''.');
   otherwise
      if ~isempty(options.AR)
         options.AR  =  options.AR(:)';
         if isempty(options.R) , options.R  = length(options.AR); end
      end
end

%
% Check Moving-Average specification.
%

errorCode  =  errorCheck(options.M , options.MA , [1 2 4 5 6 9]);

switch errorCode(1)
   case {1 , 2 , 4}
      error('GARCH:garchset:InvalidM' , ' Moving-average order ''M'' must be a non-negative, integer, scalar.');
   case 5
      error('GARCH:garchset:NonVectorMA' , ' Moving-average coefficients ''MA'' must be a vector.');
   case 6
      error('GARCH:garchset:NonInvertibleMA' , ' Moving-average polynomial ''MA'' must be invertible.');
   case 9
      error('GARCH:garchset:MismatchMA' , ' Length of ''MA'' vector must equal moving-average order ''M''.');
   otherwise
      if ~isempty(options.MA)
         options.MA  =  options.MA(:)'; 
         if isempty(options.M) , options.M  = length(options.MA); end
      end
end

%
% Temporarily set volatility model orders 'P' and 'Q' to zero if they are empty.
% This facilitates 'VarianceModel' field inference, but must be flagged so we can 
% check for errors later on.
%

restoreP  =  isempty(options.P);
restoreQ  =  isempty(options.Q);

if restoreP , options.P = 0; end
if restoreQ , options.Q = 0; end

%
% Set a flag to infer variance-in-mean models from a non-empty 'InMean' parameter.
%

isVarianceInMean  =  ~isempty(options.InMean);

%
% Set a flag to indicate the presence a constant in the mean equation. 
%
% Note: Although the mean equation includes a constant 'C' by default, a user 
%       may remove the constant entirely by specifying C = NaN. Please note
%       that this is the ONLY parameter for which a NaN is a valid specification.
%

if isnan(options.C)
   isConstantInMean  =  logical(0);    % Mean equation constant is NOT included.
else
   isConstantInMean  =  logical(1);    % Mean equation includes a constant.
end

%
% Check the conditional variance specification model.
%
% This code segment is placed here because the error checking (immediately 
% following) is dependent upon the volatility model selected. That is, the ARCH, 
% GARCH, & Leverage (if any) coefficient fields are subject to different positivity 
% and stationarity constraints.
%

if isempty(options.VarianceModel)

%
%  The volatility model has NOT been specified. 
%
%  If ANY serial dependence in the variance process is found, then assume the
%  traditional GARCH(P,Q) volatility model. This behavior provides backward 
%  compatibility with version 1.0 of the GARCH Toolbox.
%
%  Notice that Constant, EGARCH, and GJR models are NEVER assumed (i.e., 
%  the 'VarianceModel' parameter must be specified as 'Constant', 'EGARCH',
%  or 'GJR' in the input argument list to obtain these models).
%
   options.VarianceModel  =  'GARCH';

else

%
%  The volatility model has been specified, so ensure that it's a supported model.
%
%  NOTE: The presence of an appended dash (i.e., '-') in the 'VarianceModel' field 
%        is an indication that the conditional variance, regardless of which
%        volatility model is used, is included in the conditional mean equation.
%        This indicates, for example, a GARCH-M, an EGARCH-M, or a GJR-M model.
%
   options.VarianceModel(isspace(options.VarianceModel))  =  [];

   [options.VarianceModel , InMeanString] = strtok(upper(options.VarianceModel) , '-');

   isVarianceInMean  =  isVarianceInMean  |  ~isempty(InMeanString);

%
%  Notice that since GARCH(0,0) = EGARCH(0,0) = GJR(0,0) models are all just 
%  constant conditional variance models, the Constant variance model is allowed
%  to be upgraded to any other GARCH(P,Q), EGARCH(P,Q), or GJR(P,Q) model. This
%  behavior provides backward compatibility with version 1.0 of the GARCH Toolbox.
%
   varianceModels  =  {'CONSTANT' ; 'GARCH' ; 'EGARCH' ; 'GJR'};

   n  =  find(strcmpi(options.VarianceModel , varianceModels));

   if isempty(n) | (length(n) > 1)
      if isVarianceInMean
         error('GARCH:garchset:InvalidVarianceInMeanModel' , ' ''VarianceModel'' for in-mean models must be ''Constant-M'', ''GARCH-M'', ''EGARCH-M'', or ''GJR-M''.');
      else
         error('GARCH:garchset:InvalidVarianceModel' , ' ''VarianceModel'' must be ''Constant'', ''GARCH'', ''EGARCH'', or ''GJR''.');
      end
   end

   options.VarianceModel  =  varianceModels{n};

   if n == 1
%
%     Gracefully handle the 'Constant' conditional variance model.
%
      if ~((options.P == 0) & (length(options.GARCH) == 0) & ...
           (options.Q == 0) & (length(options.ARCH)  == 0))
         error('GARCH:garchset:InvalidConstantVarianceModel' , ' ''Constant'' variance models require ''P'' and ''Q'' to be 0.');
      end

      options.VarianceModel  =  'Constant';  % Capitalize the 'C' for aesthetics.

   end

end

%
% 'Leverage' terms are only valid for 'EGARCH' or 'GJR' volatility models.
%

if ~isempty(options.Leverage) & ~any(strcmpi(options.VarianceModel , {'EGARCH'  'GJR'}))
   error('GARCH:garchset:InvalidAsymmetricVarianceModel' , ' ''Leverage'' coefficients require ''EGARCH'' or ''GJR'' variance models.');
end

%
% Restore volatility model orders 'P' and 'Q' to the original 
% unspecified (i.e., []) status if necessary.
%

if restoreP , options.P = []; end
if restoreQ , options.Q = []; end

%
% For a given volatility model (i.e., 'GARCH(P,Q)', 'EGARCH(P,Q)', 'GJR(P,Q)', 
% or 'Constant'), impose model order-to-coefficient compatibility and variance
% positivity & stationarity constraints.
%

switch options.VarianceModel

%
%  GARCH Volatility Model Error Checking.
%
   case 'GARCH'
%
%     Check 'GARCH' coefficient parameter specification.
%
      errorCode  =  errorCheck(options.P , options.GARCH , [1 2 4 5 7 8 9]);

      switch errorCode(1)
         case {1 , 2 , 4}
            error('GARCH:garchset:InvalidP' , ' Model order ''P'' must be a non-negative, integer, scalar.');
         case 5
            error('GARCH:garchset:NonVectorGARCH' , ' ''GARCH'' coefficients must be a vector.');
         case 7
            error('GARCH:garchset:GARCHPQ_NegativeGARCH' , ' GARCH(P,Q) models require non-negative ''GARCH'' coefficients.');
         case 8
            error('GARCH:garchset:GARCHPQ_NonStationaryGARCH' , ' Sum of ''GARCH'' coefficients must be < 1 for GARCH(P,Q) models.')
         case 9
            error('GARCH:garchset:InconsistentP' , ' Length of ''GARCH'' coefficient vector must equal model order ''P''.');
         otherwise
            if ~isempty(options.GARCH)
               options.GARCH  =  options.GARCH(:)'; 
               if isempty(options.P) , options.P  = length(options.GARCH); end
            end
      end

%
%     Check 'ARCH' coefficient parameter specification.
%
      errorCode  =  errorCheck(options.Q , options.ARCH , [1 2 4 5 7 8 9]);

      switch errorCode(1)
         case {1 , 2 , 4}
            error('GARCH:garchset:InvalidQ' , ' Model order ''Q'' must be a non-negative, integer, scalar.');
         case 5
            error('GARCH:garchset:NonVectorARCH' , ' ''ARCH'' coefficients must be a vector.');
         case 7
            error('GARCH:garchset:GARCHPQ_NegativeARCH' , ' GARCH(P,Q) models require non-negative ''ARCH'' coefficients.');
         case 8
            error('GARCH:garchset:GARCHPQ_NonStationaryARCH' , ' Sum of ''ARCH'' coefficients must be < 1 for GARCH(P,Q) models.')
         case 9
            error('GARCH:garchset:InconsistentQ' , ' Length of ''ARCH'' coefficient vector must equal model order ''Q''.');
         otherwise
            if ~isempty(options.ARCH)
               options.ARCH  =  options.ARCH(:)';
               if isempty(options.Q) , options.Q  = length(options.ARCH); end
            end
      end

%
%     Check combined 'ARCH' & 'GARCH' parameters.
%
      errorCode  =  errorCheck([] , [options.ARCH(:) ; options.GARCH(:)] , 8);

      if errorCode == 8
         error('GARCH:garchset:GARCHPQ_NonStationary' , ' Sum of ''ARCH'' + ''GARCH'' coefficients must be < 1 for GARCH(P,Q) models.')
      end

%
%     Check constant associated with the conditional variance model specification.
%
      errorCode  =  errorCheck(options.K , [] , [3 4]);

      switch errorCode(1)
         case {3 , 4} , error('GARCH:garchset:GARCHPQ_K' , ' GARCH(P,Q) model constant ''K'' must be a positive scalar.')
      end

%
%  EGARCH Volatility Model Error Checking.
%
   case 'EGARCH'
%
%     Check 'GARCH' coefficient parameter specification.
%
      errorCode  =  errorCheck(options.P , -options.GARCH , [1 2 4 5 6 9]);

      switch errorCode(1)
         case {1 , 2 , 4}
            error('GARCH:garchset:InvalidP' , ' Model order ''P'' must be a non-negative, integer, scalar.');
         case 5
            error('GARCH:garchset:NonVectorGARCH' , ' ''GARCH'' coefficients must be a vector.');
         case 6
            error('GARCH:garchset:EGARCHPQ_NonStationaryGARCH' , ' EGARCH(P,Q) models require stationary ''GARCH'' polynomial coefficients.');
         case 9
            error('GARCH:garchset:InconsistentP' , ' Length of ''GARCH'' coefficient vector must equal model order ''P''.');
         otherwise
            if ~isempty(options.GARCH)
               options.GARCH  =  options.GARCH(:)'; 
               if isempty(options.P) , options.P  = length(options.GARCH); end
            end
      end

%
%     Check 'ARCH' coefficient parameter specification.
%
      errorCode  =  errorCheck(options.Q , options.ARCH , [1 2 4 5 9]);

      switch errorCode(1)
         case {1 , 2 , 4}
            error('GARCH:garchset:InvalidQ' , ' Model order ''Q'' must be a non-negative, integer, scalar.');
         case 5
            error('GARCH:garchset:NonVectorARCH' , ' ''ARCH'' coefficients must be a vector.');
         case 9
            error('GARCH:garchset:InconsistentQ' , ' Length of ''ARCH'' coefficient vector must equal model order ''Q''.');
         otherwise
            if ~isempty(options.ARCH)
               options.ARCH  =  options.ARCH(:)';
               if isempty(options.Q) , options.Q  = length(options.ARCH); end
            end
      end

%
%     Check 'Leverage' parameter specification.
%
      errorCode  =  errorCheck(options.Q , options.Leverage , [5 9]);

      switch errorCode(1)
         case 5
            error('GARCH:garchset:NonVectorLeverage' , ' ''Leverage'' coefficients must be a vector.');
         case 9
            error('GARCH:garchset:InconsistentLeverage' , ' Length of ''Leverage'' coefficient vector must equal model order ''Q''.');
         otherwise
            if ~isempty(options.Leverage)
               options.Leverage  =  options.Leverage(:)';
               if isempty(options.Q) , options.Q  = length(options.Leverage); end
            end
      end

%
%     Check constant associated with the conditional variance model specification.
%
      errorCode  =  errorCheck(options.K , [] , 4);

      switch errorCode(1)
         case 4 , error('GARCH:garchset:EGARCHPQ_K' , ' EGARCH(P,Q) model constant ''K'' must be a scalar.')
      end

%
%  GJR Volatility Model Error Checking.
%
   case 'GJR'
%
%     Check 'GARCH' coefficient parameter specification.
%
      errorCode  =  errorCheck(options.P , options.GARCH , [1 2 4 5 7 8 9]);

      switch errorCode(1)
         case {1 , 2 , 4}
            error('GARCH:garchset:InvalidP' , ' Model order ''P'' must be a non-negative, integer, scalar.');
         case 5
            error('GARCH:garchset:NonVectorGARCH' , ' ''GARCH'' coefficients must be a vector.');
         case 7
            error('GARCH:garchset:GJRPQ_NegativeGARCH' , ' GJR(P,Q) models require non-negative ''GARCH'' coefficients.');
         case 8
            error('GARCH:garchset:GJRPQ_NonStationaryGARCH' , ' Sum of ''GARCH'' coefficients must be < 1 for GJR(P,Q) models.')
         case 9
            error('GARCH:garchset:InconsistentP' , ' Length of ''GARCH'' coefficient vector must equal model order ''P''.');
         otherwise
            if ~isempty(options.GARCH)
               options.GARCH  =  options.GARCH(:)'; 
               if isempty(options.P) , options.P  = length(options.GARCH); end
            end
      end

%
%     Check 'ARCH' coefficient parameter specification.
%
      errorCode  =  errorCheck(options.Q , options.ARCH , [1 2 4 5 7 8 9]);

      switch errorCode(1)
         case {1 , 2 , 4}
            error('GARCH:garchset:InvalidQ' , ' Model order ''Q'' must be a non-negative, integer, scalar.');
         case 5
            error('GARCH:garchset:NonVectorARCH' , ' ''ARCH'' coefficients must be a vector.');
         case 7
            error('GARCH:garchset:GJRPQ_NegativeARCH' , ' GJR(P,Q) models require non-negative ''ARCH'' coefficients.');
         case 8
            error('GARCH:garchset:GJRPQ_NonStationaryARCH' , ' Sum of ''ARCH'' coefficients must be < 1 for GJR(P,Q) models.')
         case 9
            error('GARCH:garchset:InconsistentQ' , ' Length of ''ARCH'' coefficient vector must equal model order ''Q''.');
         otherwise
            if ~isempty(options.ARCH)
               options.ARCH  =  options.ARCH(:)';
               if isempty(options.Q) , options.Q  = length(options.ARCH); end
            end
      end

%
%     Check 'Leverage' parameter specification.
%
      errorCode  =  errorCheck(options.Q , 0.5*options.Leverage , [5 8 9]);

      switch errorCode(1)
         case 5
            error('GARCH:garchset:NonVectorLeverage' , ' ''Leverage'' coefficients must be a vector.');
         case 8
            error('GARCH:garchset:GJRPQ_NonStationaryLeverage' , ' Half of sum of ''Leverage'' coefficients must be < 1 for GJR(P,Q) models.');
         case 9
            error('GARCH:garchset:InconsistentLeverage' , ' Length of ''Leverage'' coefficient vector must equal model order ''Q''.');
         otherwise
            if ~isempty(options.Leverage)
               options.Leverage  =  options.Leverage(:)';
               if isempty(options.Q) , options.Q  = length(options.Leverage); end
            end
      end

%
%     Check that ARCH(i) + Leverage(i) >= 0 for (1 <= i <= Q), but do so only
%     if both vectors have been specified. This highlights the distinction between
%     the 'Leverage' vector and the 'GARCH' and 'ARCH' vectors. Whereas no
%     elements of the 'GARCH' and 'ARCH' vectors may be negative, an element of 
%     the 'Leverage' vector may be negative provided it does not exceed the
%     magnitude of the corresponding 'ARCH' element. This means that the 'GARCH' 
%     and 'ARCH' vectors may be checked in isolation, but the 'Leverage' vector
%     may be checked only after the 'ARCH' vector has also been specified.
%
      if ~(isempty(options.ARCH) | isempty(options.Leverage))

         errorCode  =  errorCheck([] , [options.ARCH(:) + options.Leverage(:)] , 7);

         if errorCode == 7
            error('GARCH:garchset:GJRPQ_NegativeARCHLeverage' , ' GJR(P,Q) models require ARCH(i) + Leverage(i) >= 0 for 1<=i<=Q.')
         end

      end

%
%     Check combined 'ARCH' + 'GARCH' + 'Leverage' parameters.
%
      errorCode  =  errorCheck([] , [options.ARCH(:) ; options.GARCH(:) ; 0.5*options.Leverage(:)] , 8);

      if errorCode == 8
         error('GARCH:garchset:GJRPQ_NonStationary' , ' Sum of ARCH + GARCH + 0.5*Leverage coefficients must be < 1 for GJR(P,Q) models.');
      end

%
%     Check constant associated with the conditional variance model specification.
%
      errorCode  =  errorCheck(options.K , [] , [3 4]);

      switch errorCode(1)
         case {3 , 4} , error('GARCH:garchset:GJRPQ_K' , ' GJR(P,Q) model constant ''K'' must be a positive scalar.')
      end


   otherwise     % 'Constant' conditional variance
%
%     Check constant associated with the 'Constant' conditional variance model specification.
%
      errorCode  =  errorCheck(options.K , [] , [3 4]);

      switch errorCode(1)
         case {3 , 4} , error('GARCH:garchset:Constant_K' , ' Constant variance model constant ''K'' must be a positive scalar.')
      end

end   % End of SWITCH statement.


%
% Check constant associated with the conditional mean model specification.
%

errorCode  =  errorCheck(options.C , [] , 4);

if errorCode == 4
   error('GARCH:garchset:NonScalarC' , ' Mean equation model constant ''C'' must be a scalar.')
end


%
% Check the degrees-of-freedom of a T-distribution.
%

errorCode  =  errorCheck(options.DoF - 2 , [] , [3 4]);

switch errorCode(1)
   case {3 , 4} , error('GARCH:garchset:NonScalarDoF' , ' T-distribution degrees of freedom ''DoF'' must be a scalar > 2.')
end

%
% Check for LLF distribution and degree-of-freedom consistency & set defaults.
%

options.Distribution  =  options.Distribution(~isspace(options.Distribution));

i  =  find(strcmpi(options.Distribution , {'GAUSSIAN' 'T'}));
n  =  [~isempty(options.Distribution) ~isempty(options.DoF)];

if all(n) 

   if isempty(i) | (i ~= 2)
      error('GARCH:garchset:AmbiguousDistribution' , ' ''Distribution'' must be ''T'' when degrees of freedom ''DoF'' is specified.');
   end

else

   if n(1) & isempty(i)
      error('GARCH:garchset:InvalidDistribution' , ' ''Distribution'' must be either ''Gaussian'' or ''T''.');
   end

   if n(2)
      options.Distribution  =  'T';
   end

   if ~any(n)
      options.Distribution  =  'Gaussian';
   end

end

options.Distribution     =  lower(options.Distribution);
options.Distribution(1)  =  upper(options.Distribution(1));

%
% Check the coefficient associated with the variance-in-mean model specification.
%

errorCode  =  errorCheck(options.InMean , [] , 4);

if errorCode == 4
   error('GARCH:garchset:NonScalarInMean' , ' Variance-in-Mean coefficient ''InMean'' must be a scalar.')
end

%
% Check Boolean equality constraints.
%

if ~isempty(options.FixC)

   if isempty(options.C)
      error('GARCH:garchset:UnspecifiedC' , ' Mean model constant ''C'' must be specified along with ''FixC''.');
   end

   if (prod(size(options.FixC)) ~= 1) | ((sum((options.FixC == 0) + (options.FixC == 1))) ~= 1)
      error('GARCH:garchset:InvalidFixC' , ' ''FixC'' must be a logical (0,1) scalar.');
   end

end

if ~isempty(options.FixK)

   if isempty(options.K)
      error('GARCH:garchset:UnspecifiedK' , ' Variance model constant ''K'' must be specified along with ''FixK''.');
   end

   if (prod(size(options.FixK)) ~= 1) | ((sum((options.FixK == 0) + (options.FixK == 1))) ~= 1)
      error('GARCH:garchset:InvalidFixK' , ' ''FixK'' must be a logical (0,1) scalar.');
   end

end

if ~isempty(options.FixDoF)

   if isempty(options.DoF)
      error('GARCH:garchset:UnspecifiedDoF' , ' Degrees of freedom ''DoF'' must be specified along with ''FixDoF''.');
   end

   if (prod(size(options.FixDoF)) ~= 1) | ((sum((options.FixDoF == 0) + (options.FixDoF == 1))) ~= 1)
      error('GARCH:garchset:InvalidFixDoF' , ' ''FixDoF'' must be a logical (0,1) scalar.');
   end

end

if ~isempty(options.FixAR)

   if isempty(options.AR)
      error('GARCH:garchset:UnspecifiedAR' , ' ''AR'' coefficients must be specified along with ''FixAR''.');
   end

   if (prod(size(options.FixAR)) ~= length(options.FixAR)) | ...
      ((sum((options.FixAR == 0) + (options.FixAR == 1))) ~= length(options.FixAR))
      error('GARCH:garchset:InvalidFixAR' , ' ''FixAR'' must be a logical (0,1) vector.');
   end

   if ~isempty(options.R) & (options.R  ~= length(options.FixAR))
      error('GARCH:garchset:InconsistentFixAR' , ' Length of logical ''FixAR'' vector must equal model order ''R''.');
   end

   options.FixAR  =  options.FixAR(:)';

end

if ~isempty(options.FixMA)

   if isempty(options.MA)
      error('GARCH:garchset:UnspecifiedMA' , ' ''MA'' coefficients must be specified along with ''FixMA''.');
   end

   if (prod(size(options.FixMA)) ~= length(options.FixMA)) | ...
      ((sum((options.FixMA == 0) + (options.FixMA == 1))) ~= length(options.FixMA))
      error('GARCH:garchset:InvalidFixMA' , ' ''FixMA'' must be a logical (0,1) vector.');
   end

   if ~isempty(options.M) & (options.M  ~= length(options.FixMA))
      error('GARCH:garchset:InconsistentFixMA' , ' Length of logical ''FixMA'' vector must equal model order ''M''.');
   end

   options.FixMA  =  options.FixMA(:)'; 

end

if ~isempty(options.FixARCH)

   if isempty(options.ARCH)
      error('GARCH:garchset:UnspecifiedARCH' , ' ''ARCH'' coefficients must be specified along with ''FixARCH''.');
   end

   if (prod(size(options.FixARCH)) ~= length(options.FixARCH)) | ...
      ((sum((options.FixARCH == 0) + (options.FixARCH == 1))) ~= length(options.FixARCH))
      error('GARCH:garchset:InvalidFixARCH' , ' ''FixARCH'' must be a logical (0,1) vector.');
   end

   if ~isempty(options.Q) & (options.Q  ~= length(options.FixARCH))
      error('GARCH:garchset:InconsistentFixARCH' , ' Length of logical ''FixARCH'' vector must equal model order ''Q''.');
   end

   options.FixARCH  =  options.FixARCH(:)'; 

end

if ~isempty(options.FixLeverage)

   if isempty(options.Leverage)
      error('GARCH:garchset:UnspecifiedLeverage' , ' ''Leverage'' coefficients must be specified along with ''FixLeverage''.');
   end

   if (prod(size(options.FixLeverage)) ~= length(options.FixLeverage)) | ...
      ((sum((options.FixLeverage == 0) + (options.FixLeverage == 1))) ~= length(options.FixLeverage))
      error('GARCH:garchset:InvalidFixLeverage' , ' ''FixLeverage'' must be a logical (0,1) vector.');
   end

   if ~isempty(options.Q) & (options.Q  ~= length(options.FixLeverage))
      error('GARCH:garchset:InconsistentFixLeverage' , ' Length of logical ''FixLeverage'' vector must equal model order ''Q''.');
   end

   options.FixLeverage  =  options.FixLeverage(:)'; 

end

if ~isempty(options.FixGARCH)

   if isempty(options.GARCH)
      error('GARCH:garchset:UnspecifiedGARCH' , ' ''GARCH'' coefficients must be specified along with ''FixGARCH''.');
   end

   if (prod(size(options.FixGARCH)) ~= length(options.FixGARCH)) | ...
      ((sum((options.FixGARCH == 0) + (options.FixGARCH == 1))) ~= length(options.FixGARCH))
      error('GARCH:garchset:InvalidFixGARCH' , ' ''FixGARCH'' must be a logical (0,1) vector.');
   end

   if ~isempty(options.P) & (options.P  ~= length(options.FixGARCH))
      error('GARCH:garchset:InconsistentFixGARCH' , ' Length of logical ''FixGARCH'' vector must equal model order ''P''.');
   end

   options.FixGARCH  =  options.FixGARCH(:)'; 

end

if ~isempty(options.Regress)

   if prod(size(options.Regress)) ~= length(options.Regress)
      error('GARCH:garchset:NonVectorRegress' , ' Regression coefficients ''Regress'' must be a vector.');
   end

   options.Regress  =  options.Regress(:)'; 

end

if ~isempty(options.FixRegress)

   if isempty(options.Regress)
      error('GARCH:garchset:UnspecifiedRegress' , ' ''Regress'' coefficients must be specified along with ''FixRegress''.');
   end

   if (prod(size(options.FixRegress)) ~= length(options.FixRegress)) | ...
      ((sum((options.FixRegress == 0) + (options.FixRegress == 1))) ~= length(options.FixRegress))
      error('GARCH:garchset:InvalidFixRegress' , ' ''FixRegress'' must be a logical (0,1) vector.');
   end

   options.FixRegress  =  options.FixRegress(:)'; 

end

if ~isempty(options.Regress) & ~isempty(options.FixRegress) & ...
    (length(options.Regress) ~=  length(options.FixRegress))
   error('GARCH:garchset:InconsistentFixRegress' , ' Vectors ''Regress'' and ''FixRegress'' must be the same length.');
end

if ~isempty(options.FixInMean)

   if isempty(options.InMean)
      error('GARCH:garchset:UnspecifiedInMean' , ' Variance-in-mean coefficient ''InMean'' must be specified along with ''FixInMean''.');
   end

   if (prod(size(options.FixInMean)) ~= 1) | ((sum((options.FixInMean == 0) + (options.FixInMean == 1))) ~= 1)
      error('GARCH:garchset:InvalidFixInMean' , ' ''FixInMean'' must be a logical (0,1) scalar.');
   end

end

%
% Set model orders of conditional mean & variance if unspecified.
%

if isempty(options.R) , options.R  =  0; end
if isempty(options.M) , options.M  =  0; end
if isempty(options.P) , options.P  =  0; end
if isempty(options.Q) , options.Q  =  0; end

%
% Prevent GARCH(P>0,Q=0) models. It's OK for both P = Q = 0, but 
% it makes no sense to have P > 0 when Q = 0.
%

if (options.P > 0) & (options.Q == 0)
   error('GARCH:garchset:InvalidP' , ' When model order ''Q'' is 0, order ''P'' must also be 0.');
end

%
% Construct the summary comment from the model orders if unspecified
% OR if the summary comment string was originally constructed from the 
% input specification automatically. 
%
% The comment is assumed to have been constructed automatically if a
% trailing NULL is found in the comment string. This feature is here
% so that the comment, when inferred from the input specification, is 
% updated when the mean or variance models are updated. However, if a
% user has specified his/her own comment, then it will NOT be overwritten.
%

if isempty(options.Comment) | any(options.Comment == char(0))

	  if isVarianceInMean
      meanString  =  ['Variance + ARMAX(' num2str(options.R) ',' num2str(options.M) ',?)'];
   else
      meanString  =  ['ARMAX(' num2str(options.R) ',' num2str(options.M) ',?)'];
   end

   if strcmpi(options.VarianceModel , 'Constant')
      varianceString  =  'Constant';
   else
      varianceString  =  [options.VarianceModel '(' num2str(options.P) ',' num2str(options.Q) ')'];
			end
			
			options.Comment =  ['Mean: ' meanString '; Variance: ' varianceString char(0)];

end

%
% Check the parameters associated with FMINCON of the Optimization Toolbox.
%

if ~isempty(options.Display)
   if ~(strcmpi(options.Display , 'on') | strcmpi(options.Display , 'off'))
      error('GARCH:garchset:InvalidDisplay' , ' ''Display'' must be a character string: {''ON'' or ''OFF''}');
   end
end

if ~isempty(options.MaxFunEvals)
   if prod(size(options.MaxFunEvals)) > 1
      error('GARCH:garchset:NonScalarMaxFunEvals' , ' ''MaxFunEvals'' must be a scalar.');
   end
   if (round(options.MaxFunEvals) ~= options.MaxFunEvals) | (options.MaxFunEvals <= 0)
      error('GARCH:garchset:NonIntegerMaxFunEvals' , ' ''MaxFunEvals'' must be a positive integer.');
   end
end

if ~isempty(options.MaxIter)
   if prod(size(options.MaxIter)) > 1
      error('GARCH:garchset:NonScalarMaxIter' , ' ''MaxIter'' must be a scalar.');
   end
   if (round(options.MaxIter) ~= options.MaxIter) | (options.MaxIter <= 0)
      error('GARCH:garchset:NonIntegerMaxIter' , ' ''MaxIter'' must be a positive integer.');
   end
end

if ~isempty(options.TolCon)
   if (prod(size(options.TolCon)) > 1) | (options.TolCon <= 0)
      error('GARCH:garchset:NonScalarTolCon' , ' ''TolCon'' must be a positive scalar.');
   end
end

if ~isempty(options.TolFun)
   if (prod(size(options.TolFun)) > 1) | (options.TolFun <= 0)
      error('GARCH:garchset:NonScalarTolFun' , ' ''TolFun'' must be a positive scalar.');
   end
end

if ~isempty(options.TolX)
   if (prod(size(options.TolX)) > 1) | (options.TolX <= 0)
      error('GARCH:garchset:NonScalarTolX' , ' ''TolX'' must be a positive scalar.');
   end
end

%
% At this point, the output specification structure has been
% completely scrubbed. We now proceed with the removal of all
% non-essential or irrelevant fields. This removal process is
% new to the GARCH Toolbox version 1.1, and is intended to 
% present to the user ONLY those fields which they care about
% or have explicitly set. The ultimate intent is to avoid
% inundating the user with irrelevent information.
%

if options.R == 0
   options  =  rmfield(options , {'R' , 'AR' , 'FixAR'});
else
   if isempty(options.FixAR) | ~any(options.FixAR)
      options  =  rmfield(options , 'FixAR');
   end
end

if options.M == 0
   options  =  rmfield(options , {'M' , 'MA' , 'FixMA'});
else
   if isempty(options.FixMA) | ~any(options.FixMA)
      options  =  rmfield(options , 'FixMA');
   end
end

if (options.P == 0)
   options  =  rmfield(options , {'P' , 'GARCH' , 'FixGARCH'});
else
   if isempty(options.FixGARCH) | ~any(options.FixGARCH)
      options  =  rmfield(options , 'FixGARCH');
   end
end

if (options.Q == 0) | any(strcmpi(options.VarianceModel , {'GARCH' , 'Constant'}))
   options  =  rmfield(options , {'Leverage' , 'FixLeverage'});
else
   if isempty(options.FixLeverage) | ~any(options.FixLeverage)
      options  =  rmfield(options , 'FixLeverage');
   end
end

if (options.Q == 0)
   options  =  rmfield(options , {'Q' , 'ARCH' , 'FixARCH'});
else
   if isempty(options.FixARCH) | ~any(options.FixARCH)
      options  =  rmfield(options , 'FixARCH');
   end
end

if strcmpi(options.Distribution , 'Gaussian')
   options  =  rmfield(options , {'DoF' , 'FixDoF'});
else
   if isempty(options.FixDoF) | ~any(options.FixDoF)
      options  =  rmfield(options , 'FixDoF');
   end
end

if isempty(options.InMean) & ~isVarianceInMean
   options  =  rmfield(options , {'InMean' , 'FixInMean'});
else
   if isempty(options.FixInMean) | ~any(options.FixInMean)
      options  =  rmfield(options , 'FixInMean');
   end
end

if isempty(options.Regress)
   options  =  rmfield(options , {'Regress' , 'FixRegress'});
else
   if isempty(options.FixRegress) | ~any(options.FixRegress)
      options  =  rmfield(options , 'FixRegress');
   end
end

if isConstantInMean
   if isempty(options.FixC) | ~any(options.FixC)
      options  =  rmfield(options , 'FixC');
   end
else
   options  =  rmfield(options , 'FixC');
end

if isempty(options.FixK) | ~any(options.FixK)
   options  =  rmfield(options , 'FixK');
end

if isempty(options.Display)
   options  =  rmfield(options , 'Display');
end

if isempty(options.MaxFunEvals)
   options  =  rmfield(options , 'MaxFunEvals');
end

if isempty(options.MaxIter)
   options  =  rmfield(options , 'MaxIter');
end

if isempty(options.TolFun)
   options  =  rmfield(options , 'TolFun');
end

if isempty(options.TolCon)
   options  =  rmfield(options , 'TolCon');
end

if isempty(options.TolX)
   options  =  rmfield(options , 'TolX');
end

%
% Restore the '-M' token to the 'VarianceModel' field so specification structure
% may be recognized as variance-in-mean model when updated.
%

if isVarianceInMean
   options.VarianceModel  =  [options.VarianceModel '-M'];
end



function errorCode = errorCheck(scalar , vector , codes)
%ERRORCHECK Check parameter values and sizes of paired scalars/vectors.
%   Given a scalar and a corresponding vector input, this function implements
%   a library of error checks. The checks involve testing the scalar in 
%   isolation, testing the vector in isolation, and testing for consistency
%   between them. Either SCALAR or VECTOR may be empty ([]).
%
%   errorCode = errorCheck(scalar , vector , codes)
%
%Inputs:
%  scalar - A scalar input; for example, an integer model order number or a
%    continuous parameter coefficient.
%
%  vector - A vector input; for example, a vector parameter coefficients or
%    flags.
%
%  codes - A vector of error codes of interest.
%
%Output:
%  errorCode - The error codes specified in CODES that were found to exist.
%
%  Several tests are performed on the SCALAR and VECTOR, and the function 
%  tests against a library of conditions. Once the library of checks is made,
%  the actual errors of interest in CODES are retained if the error condition
%  occurred. For example, if CODES = [1 4 5], and error conditions 1 and 5 
%  are found, the ERRORCODE = [1 5].
%  
%  The current library of error codes is:
%    1 = SCALAR is not an integer
%    2 = SCALAR is negative
%    3 = SCALAR is not positive
%    4 = SCALAR is not a scalar
%    5 = VECTOR is not a vector (i.e., is a matrix)
%    6 = VECTOR of polynomial coefficients is non-stationary
%    7 = VECTOR has negative elements
%    8 = VECTOR of polynomial coefficients is non-stationary (GARCH sum)
%    9 = SCALAR/VECTOR dimension inconsistency
%

errorCode  =  zeros(1,9);    % Initialize codes to no error condition.
codes      =  codes(:)';

n  =  [~isempty(scalar)  ~isempty(vector)];

if any(n) 
%
%  Check the scalar input.
%
   if n(1)
      if any(round(scalar) ~= scalar)            % non-integer
         errorCode(1) = 1; 
      end
      if any(scalar <  0)                        % negativity
         errorCode(2) = 2;
      end
      if any(scalar <= 0)                        % non-positivity
         errorCode(3) = 3;
      end
      if prod(size(scalar)) ~= 1                 % non-scalar
         errorCode(4) = 4;
      end
   end
%
%  Check the vector input.
%
   if n(2)
      V  =  vector(:);
      if prod(size(vector)) ~= length(vector)    % non-vector
         errorCode(5) = 5;
      end
      if any(abs(roots([1 ; V])) >= 1)         % non-stationary
         errorCode(6) = 6;
      end
      if any(vector < 0)                         % negativity
         errorCode(7) = 7;
      end
      if sum(vector) >= 1                        % non-stationary
         errorCode(8) = 8;
      end
   end
%
%  Check for consistency between the scalar and vector inputs.
%
   if all(n)
      if scalar ~= length(vector)                % dimension inconsistency
         errorCode(9) = 9;
      end
   end

end

%
% Retain only the errors we actually care about (i.e., the 'real' errors!).
%

errorCode  =  errorCode(find(errorCode));

if ~isempty(errorCode)
   [C , E]            =  meshgrid(codes , errorCode);
   delta              =  C - E;
   delta(delta == 0)  =  NaN;
   errorCode          =  codes(isnan(sum(delta,1)));
end

%
% If no error codes of interest remain, then at least pad it with a zero
% so the SWITCH statement outside will not error out on an empty matrix [].
%

if isempty(errorCode)
   errorCode  =  0;
end
