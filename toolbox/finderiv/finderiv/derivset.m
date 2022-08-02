function options = derivset(varargin)
%DERIVSET Create/alter derivatives Options structure.
%
%   Options = derivset('Parameter1', Value1, 'Parameter2', Value2,...) 
%   Options = derivset(Options, 'Parameter1', Value1, 'Parameter2', Value2,...) 
%   Options = derivset(OldOptions, NewOptions)
%   Options = derivset
%
%   The first calling syntax creates a derivatives pricing options structure 
%   Options in which the named parameters have the specified values.  Any 
%   unspecified parameters are set to default values for that parameter when 
%   Options is passed to the derivatives function. It is sufficient to type 
%   only the leading characters that uniquely identify the parameter name.  
%   Case is also ignored for parameter names. For parameter values, correct 
%   case and the complete string are required.
%   
%   The second calling syntax modifies an existing derivatives pricing options   
%   structure Options by changing the named parameters to the specified values.
%
%   The third calling syntax combines an existing options structure OldOptions
%   with a new options structure NewOptions. Any parameters in NewOptions with
%   non-empty values overwrite the corresponding old parameters in OldOptions. 
%
%   The fourth calling syntax creates an options structure Options where all the 
%   fields are set to the default values.
%
%
% Inputs:
%   Parameter - String representing a valid parameter field of the output 
%               structure Options (see below).
%
%   Value     - The value assigned to the corresponding Parameter. 
%
%   Options   - An existing Options specification structure to be changed,
%               probably created from a previous call to derivset.
%
%   DERIVSET Parameter names:
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
%   Options   - Structure encapsulating the properties of a derivatives options 
%               structure.
%
% Examples:
%   Options = derivset('Diagnostics','on')
%   Options = derivset(Options, 'ConstRate', 'off')
%
% Notes:
%   Calling derivset with no input arguments and no output arguments displays 
%   all parameter names and information about their possible values.
%
%   See also DERIVGET.
%

%   Author(s): M. Reyes-Kattar, 05/01/2000
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.5.2.2 $  $Date: 2003/09/22 19:14:01 $

%----------------------------------------------------
% Print out possible values of properties.
%----------------------------------------------------

if (nargin == 0) & (nargout == 0)
    fprintf('            Diagnostics: [ on   | {off} ]\n');
    fprintf('               Warnings: [ {on} | off   ]\n');
    fprintf('              ConstRate: [ {on} | off   ]\n');
    fprintf('          BarrierMethod: [ {unenhanced} | interp ]\n');
    fprintf('\n');
    return;
end

optimdef = struct('Diagnostics', 'off', ...
                  'Warnings', 'on', ...
                  'ConstRate', 'on', ...
                  'BarrierMethod', 'unenhanced');

options = optimdef;
if nargin == 0
    return
end


numberargs = nargin; % we might change this value, so assign it

Names = fieldnames(options);
[m,n] = size(Names);
names = lower(Names);

i = 1;
while i <= numberargs
    arg = varargin{i};
    if isstr(arg)                         % arg is an option name
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        if ~isa(arg,'struct')
            error('finderiv:derivset:InvalidParameterName',['Expected argument %d to be a string parameter name ' ...
                    'or an options structure\ncreated with DERIVSET.'], i);
        end
        for j = 1:m
            if any(strcmp(fieldnames(arg),Names{j,:}))
                val = getfield(arg, Names{j,:});
            else
                val = getfield(optimdef, Names{j,:});;
            end
            if ~isempty(val)
                if ischar(val)
                    val = lower(deblank(val));
                end
                [valid, errmsg] = checkfield(Names{j,:},val);
                if valid
                    options = setfield(options, Names{j,:},val);
                else
                    error(errmsg);
                end
            end
        end
        i = i + 1;
    end
end

% A finite state machine to parse name-value pairs.
if rem(numberargs-i+1,2) ~= 0
    error('finderiv:derivset:InvalidInputs','Arguments must occur in name-value pairs.');
end
expectval = 0;                          % start expecting a name, not a value
while i <= numberargs
    arg = varargin{i};
    
    if ~expectval
        if ~isstr(arg)
            error('finderiv:derivset:InvalidParameterName','Expected argument %d to be a string parameter name.', i);
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error('finderiv:derivset:InvalidParameterName','Unrecognized parameter name ''%s''.', arg);
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if length(k) == 1
                j = k;
            else
                msg = sprintf('Ambiguous parameter name ''%s'' ', arg);
                msg = [msg '(' Names{j(1),:}];
                for k = j(2:length(j))'
                    msg = [msg ', ' Names{k,:}];
                end
                msg = sprintf('%s).', msg);
                error('finderiv:derivset:InvalidParameterName',msg);
            end
        end
        expectval = 1;                      % we expect a value next
        
    else           
        if ischar(arg)
            arg = lower(deblank(arg));
        end
        [valid, errmsg] = checkfield(Names{j,:},arg);
        if valid
            options = setfield(options, Names{j,:},arg);
        else
            error(errmsg);
        end
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error('finderiv:derivset:InvalidParameterValue','Expected value for parameter ''%s''.', arg);
end

%-------------------------------------------------
function f = getfield(s,field)
%GETFIELD Get structure field contents.
%   F = GETFIELD(S,'field') returns the contents of the specified
%   field.  This is equivalent to the syntax F = S.field.
%   S must be a 1-by-1 structure.  
% 

sref.type = '.'; sref.subs = field;
f = subsref(s,sref);

%-------------------------------------------------
function s = setfield(s,field,value)
%SETFIELD Set structure field contents.
%   S = SETFIELD(S,'field',V) sets the contents of the specified
%   field to the value V.  This is equivalent to the syntax S.field = V.
%   S must be a 1-by-1 structure.  The changed structure is returned.
%

sref.type = '.'; sref.subs = field;
s = subsasgn(s,sref,value);

%-------------------------------------------------
function [valid, errmsg] = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   [VALID, MSG] = CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%
valid = 1;
errmsg = '';

switch field
case {'Diagnostics', 'Warnings', 'ConstRate' } % off,on
    if isempty(value) | ~isa(value,'char') | ~any(strcmp(value,{'on';'off'}))
        valid = 0;
        errmsg = sprintf('Invalid value for 0PTIONS parameter "%s": must be ''off'', or ''on''.',field);
    end
case {'BarrierMethod'}
    if isempty(value) | ~isa(value,'char') | ~any(strcmp(value,{'unenhanced';'interp'}))
        valid = 0;
        errmsg = sprintf('Invalid value for 0PTIONS parameter "%s": must be ''unenhanced'', or ''interp''.',field);
    end
otherwise
    valid = 0;
    error('Unknown field name for Options structure.')
end
