function value = garchget(options , parameter)
%GARCHGET Get GARCH Toolbox specification parameters.
%   GARCHGET provides the main user-interface for accessing GARCH Toolbox
%   structures, and is the preferred method for extracting GARCH model 
%   specification parameters.
%
%   ParameterValue = garchget(Spec , 'ParameterName')
%
% Inputs:
%   Spec - A GARCH Toolbox specification structure encapsulating the relevant 
%     styles, orders, coefficients, and optimization parameters of the 
%     conditional mean and variance specifications of a GARCH model. Spec
%     is typically created with the companion function GARCHSET. Type "help 
%     garchset" for details.
%
%   ParameterName - The parameter name to be accessed. The value of the named 
%     parameter is extracted from the structure Spec. It is sufficient to type
%     only the leading characters that uniquely identify the parameter. Case 
%     is ignored for parameter names. ParameterName may be specified as either
%     a MATLAB character array (i.e., character string) or as a single-element 
%     cell array whose contents are a character array. In either case, the 
%     string should represent a parameter name recognized as a valid field of
%     the corresponding GARCH Toolbox specification structure Spec.
%
% Output:
%   ParameterValue - The value of the parameter specified in ParameterName. 
%     If the parameter is a field in Spec, then the named parameter is
%     extracted from the corresponding structure field in Spec; if the 
%     parameter is not a field in Spec, but otherwise a valid parameter, 
%     then the appropriate model default value of the requested parameter 
%     is returned. 
%
% Example:
%   Spec = garchset('P',1,'Q',1);    % Create a GARCH(P = 1 , Q = 1) model.
%      P = garchget(Spec , 'P');     % Extract the order P = 1.
%   
% See also GARCHSET, GARCHFIT, GARCHSIM, GARCHPRED, OPTIMSET, OPTIMGET.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.10.4.1 $   $Date: 2003/05/08 21:45:23 $

%
% Scrub the input argument list from a top-level perspective:
%
% There should be 2 (and only 2) input arguments. The first should be a
% GARCH Toolbox specification structure. The second should be either a
% character string, or a single-element cell array whose contents are a
% character string. In either case, the string should represent a 
% parameter name recognized as a valid field of the corresponding GARCH
% Toolbox specification structure.
%

if nargin ~= 2
   error('GARCH:garchget:IncorrectNumberOfInputs' , ' GARCHSET Requires 2 Input Arguments.');
end

if ~isstruct(options)
   error('GARCH:garchget:NonStructureInput' , ' First Input Argument Must Be a GARCH Toolbox Specification Structure.');
end

if iscellstr(parameter)
   parameter  =  char(parameter(:));
   if size(parameter,1) ~= 1
      error('GARCH:garchget:TooManyInputs' , ' Only a Single Parameter May Be Requested.');
   end
else
   if ~ischar(parameter)
      error('GARCH:garchget:NonStringInput' , ' The Second Input Argument Must a Character String.');
   end
end

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
% Assign the list of valid fields and the corresponding default values.
% 
% NOTES: 
%
%  (1) Version 1.1 (and beyond) of the GARCH Toolbox will allow a host of 
%      valid fields to be set/get. However, in an attempt to minimize the 
%      number of non-essential or irrelevant fields presented to the user, 
%      ONLY those fields that are actually needed for a particular model 
%      will be present in the specification structure. This is in contrast 
%      to GARCH Toolbox version 1.0, in which all fields were present in 
%      the specification structure regardless of whether or not they were
%      needed.
%
%  (2) Although the actual fields present in any given output specification
%      structure depend upon the particular ARMAX(R,M,Nx)/GARCH(P,Q) model 
%      selected, ONLY the fields 
%
%           'Comment'
%           'Distribution'
%           'C'
%           'VarianceModel'
%           'K' 
%
%      are guaranteed to exist in every output structure.
%
%  (3) To maintain backward compatibility with GARCH Toolbox v1.0, all fields
%      are still settable & gettable regardless of whether or not they are 
%      present (i.e., regardless of whether or not they exist) in the specification 
%      structure. However, in order to do this, each field (i.e., parameter) 
%      must now be assigned an appropriate default value in the event the field 
%      is missing from the structure.
%
% The following code segment creates the parameter fields (column 1) and the
% corresponding default parameter values (column 2).
%
%          Field Name        Default Value
%          ----------        -------------
fields = {'Comment'          ''
          'Distribution'     'Gaussian'
          'R'                0
          'M'                0
          'P'                0
          'Q'                0
          'DoF'              []
          'C'                []
          'AR'               []
          'MA'               []
          'InMean'           []
          'Regress'          []
          'VarianceModel'    'GARCH'
          'K'                []
          'GARCH'            []
          'ARCH'             []
          'Leverage'         []
          'FixDoF'           []
          'FixC'             []
          'FixAR'            []
          'FixMA'            []
          'FixInMean'        []
          'FixRegress'       []
          'FixK'             []
          'FixGARCH'         []
          'FixARCH'          []
          'FixLeverage'      []
          'Display'          'on'
          'MaxFunEvals'      '100*numberofvariables'
          'MaxIter'          400
          'TolFun'           1e-6
          'TolCon'           1e-7
          'TolX'             1e-6};

%
% The above assignment is really just for readability, so now extract the
% the actual field names (column 1) and the default values (column 2).
%

defaults     =  fields(:,2);
fields       =  fields(:,1);
lowerFields  =  lower(fields);

%
% Scrub the requested parameter (i.e., specification structure field) 
% and return the corresponding parameter value.
%
% NOTES: 
%
%  (1) Some special-purpose code is needed to handle the GARCH Toolbox 
%      version 1.0 specification structure. The v1.0 structure buried 
%      the optimization-related fields 
%
%       {'Display', 'MaxFunEvals', 'MaxIter', 'TolFun', 'TolCon', 'TolX'} 
%
%      in a nested structure field called 'Optimization' which is eventually 
%      passed to the optimization function FMINCON by the estimation function 
%      GARCHFIT. 
%
%  (2) In particular, the 'Display' field is meant to allow users to view the
%      optimization process, but differs slightly from the 'Display' field
%      associated with the specification structure of the Optimization Toolbox
%      (e.g., try calling OPTIMSET('FMINCON')). The GARCH Toolbox 'Display' 
%      field has only 2 choices: 'on' and 'off'. These choices are actually 
%      mapped to the 2 fields 'Display' and 'Diagnostics' of the Optimization 
%      Toolbox. This results in an all-or-nothing iterative view of the 
%      optimization process. The mapping is shown below.
%
%         GARCH Toolbox         Optimization Toolbox
%          'Display'         'Display'    'Diagnostics'
%         -------------      -----------  --------------
%            'on'             'iter'         'on'
%            'off'            'off'          'off'
%

%
% Find the index of the 'Display' field in the list of valid parameter field 
% names. If the optimization-related group of fields always begin with 'Display', 
% and are kept grouped together at the end of the list, this should minimize 
% future code maintenance in the event other fields are added to the list.
%

firstOptimizationIndex =  strmatch('Display' , fields , 'exact');
optimizationFields     =  lowerFields((end - 5):end);
matches                =  strmatch(lower(parameter) , optimizationFields , 'exact');

%
% Determine if the an optimization-related field has been requested from a
% Version 1.0 GARCH Toolbox specification structure.
%

if isfield(options , 'Optimization') & ~isempty(matches)

%
%  The presence of the 'Optimization' field indicates a Version 1.0 structure.
%  If the user did not specify values for the optimization-related fields, the 
%  version 1.0 structure ALWAYS placed the default FMINCON parameter values 
%  into the optimization-related fields. 
%
%  The specification structure for versions of the GARCH Toolbox AFTER Version 1.0 
%  includes ONLY those fields which
%
%     (1) are necessary for a given model, and/or 
%     (2) the user has explicitly specified parameter values. 
%

   value  =  getfield(options.Optimization , fields{matches + firstOptimizationIndex - 1});

%
%  While the Optimization Toolbox 'Display' field may be 'off', 'iter', 'notify', 
%  or 'final',  the GARCH Toolbox 'Display' field may be only 'on' or 'off'. If 
%  the Optimization Toolbox 'Display' is NOT 'off', then turn it 'on'.
%

   if strcmpi(fields{matches + firstOptimizationIndex - 1},'Display') & ~strcmpi(value , 'off')
      value  =  'on';
   end

else

%
%  The requested parameter field is NOT an optimization-related field from a
%  Version 1.0 GARCH Toolbox specification structure, so ensure that the requested 
%  parameter (i.e., specification structure field) represents a valid, unambiguous 
%  field name.
%

   matches = strmatch(lower(parameter) , lowerFields);

   if isempty(matches)

% 
%     No matches found: Parameter is unknown.
%
      error('GARCH:garchget:InvalidParameter' , ' Unrecognized Parameter Name ''%s''.' , parameter)

   elseif length(matches) > 1

% 
%     More than one match, so proceed with an exact match if possible.
%
      exacts = strmatch(lower(parameter) , lowerFields , 'exact');

      if length(exacts) == 1
% 
%        An exact match is OK.
%
         matches = exacts;

      else
%
%        The parameter is ambiguous and additional information is needed to resolve.
%
         message = [' Ambiguous Parameter Name '''  parameter ''' (' fields{matches(1)}];

         for exacts = matches(2:length(matches))'
             message = [message ', ' fields{exacts}];
         end

         error('GARCH:garchget:AmbiguousParameter' , [message ').'])

      end

   end

%
%  Determine if the requested parameter field exists in the input specification 
%  structure. If it does, then extract the value of the parameter; if it does not,
%  then assign the default parameter value.
%

   if isfield(options , fields{matches})

      value  =  getfield(options , fields{matches});

   else

      value  =  defaults{matches};

   end


end
