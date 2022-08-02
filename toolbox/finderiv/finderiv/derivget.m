function o = derivget(options,name,flag)
%DERIVGET Get derivatives Options parameters.
%
%   ParameterValue = derivget(Options, 'ParameterName')
%
%   Extracts the value of the named parameter from the derivative options
%   structure Options. It is sufficient to type only the leading characters
%   that uniquely identify the parameter.  Case is ignored for parameter
%   names.  
%
% Inputs:
%   Options       - A Structure encapsulating the properties of a derivatives 
%                   options structure.
%
%   ParameterName - String indicating the parameter name to be accessed. The 
%                   value of the named parameter is extracted from the structure
%                   Options. It is sufficient to type only the leading characters 
%                   that uniquely identify the parameter. Case is ignored for 
%                   parameter names.
%
%   DERIVGET Parameter names:
%	   Diagnostics   - Print diagnostic information [ on | {off}]. This
%	                   option applies only for  HJM and BDT pricing.
%
%	   Warnings      - Display warnings[ {on} | off ]. This
%	                   option applies only for  HJM and BDT pricing.
%
%      ConstRate     - Assume constant rates between tree nodes [ {on} | off]. 
%                      This option applies only for  HJM and BDT pricing.
%
%      BarrierMethod - Method for pricing Barrier Options. Specifying 
%                      "unenhanced" uses no correction calculation. Specifying 
%                      "interp" uses an enhanced valuation interpolating between
%                      nodes on barrier boundaries.
%                      [{unenhanced} | interp]
%
% Output:
%   ParameterValue - The value of the named parameter ParameterName extracted
%                    from the structure Options. 
%
% Examples:
%   Options = derivset('Diagnostics','on')
%   Value   = derivget(Options, 'ConstRate')
%   
%   See also DERIVSET.

%   Author(s): M. Reyes-Kattar, 05/01/2000
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.4.2.2 $  $Date: 2003/09/22 19:14:00 $

%----------------------------------------------------
% Checking input arguments
%----------------------------------------------------
if nargin < 2
  error('finderiv:derivget:InvalidInputs','Not enough input arguments.');
end

if nargin < 3
   flag = [];
end

% undocumented usage for fast access with no error checking
if isequal('fast',flag)
   o = derivgetfast(options,name);
   return
end

if isempty(options) | ~isa(options,'struct')
  error('finderiv:derivget:InvalidOptionsStructure','First argument must be an options structure created with DERIVSET.');
end

optionsstruct = derivset;

Names = fieldnames(optionsstruct);
[m,n] = size(Names);
names = lower(Names);

lowName = lower(name);
j = strmatch(lowName,names);
if isempty(j)               % if no matches
  error('finderiv:derivget:InvalidPropertyName',['Unrecognized property name ''%s''.' ...
                 'See DERIVSET for possibilities.'], name);
elseif length(j) > 1            % if more than one match
  % Check for any exact matches (in case any names are subsets of others)
  k = strmatch(lowName,names,'exact');
  if length(k) == 1
    j = k;
  else
    msg = sprintf('Ambiguous property name ''%s'' ', name);
    msg = [msg '(' Names{j(1),:}];
    for k = j(2:length(j))'
      msg = [msg ', ' Names{k,:}];
    end
    msg = sprintf('%s).', msg);
    error('finderiv:derivget:InvalidPropertyName',msg);
  end
end

if any(strcmp(Names,Names{j,:}))
   o = getfield(options, Names{j,:});
end

%------------------------------------------------------------------
function value = derivgetfast(options,name)
%DERIVGETFAST Get DERIVATIVES OPTIONS parameter with no error checking so fast.
%   VAL = DERIVGETFAST(OPTIONS,FIELDNAME will get the value of the FIELDNAME 
%   from OPTIONS with no error checking or fieldname completion.
%

S = struct('type','.','subs',name);
S.type = '.'; S.subs = name;


value = subsref(options,S);


%-------------------------------------------------
function f = getfield(s,field)
%GETFIELD Get structure field contents.
%   F = GETFIELD(S,'field') returns the contents of the specified
%   field.  This is equivalent to the syntax F = S.field.
%   S must be a 1-by-1 structure and field must be deblanked already.  
% 

sref.type = '.'; sref.subs = field;
f = subsref(s,sref);
