function options = ddeset(varargin)
%DDESET Create/alter DDE OPTIONS structure.
%   OPTIONS = DDESET('NAME1',VALUE1,'NAME2',VALUE2,...) creates an
%   integrator options structure OPTIONS in which the named properties have
%   the specified values.  Any unspecified properties have default values.
%   It is sufficient to type only the leading characters that uniquely
%   identify the property.  Case is ignored for property names.
%   
%   OPTIONS = DDESET(OLDOPTS,'NAME1',VALUE1,...) alters an existing options
%   structure OLDOPTS.
%   
%   OPTIONS = DDESET(OLDOPTS,NEWOPTS) combines an existing options structure
%   OLDOPTS with a new options structure NEWOPTS.  Any new properties
%   overwrite corresponding old properties.
%   
%   DDESET with no input arguments displays all property names and their
%   possible values.
%   
%DDESET PROPERTIES
%   
%RelTol - Relative error tolerance  [ positive scalar {1e-3} ]
%   This scalar applies to all components of the solution vector, and
%   defaults to 1e-3 (0.1% accuracy) in all solvers.  The estimated error in
%   each integration step satisfies e(i) <= max(RelTol*abs(y(i)),AbsTol(i)).
%
%AbsTol - Absolute error tolerance  [ positive scalar or vector {1e-6} ]
%   A scalar tolerance applies to all components of the solution vector.
%   Elements of a vector of tolerances apply to corresponding components of
%   the solution vector.  AbsTol defaults to 1e-6 in all solvers.
%   
%Stats - Display computational cost statistics  [ on | {off} ]
%   
%Events - Locate events  [ function name ]
%   If not empty, the solver locates where functions of t,y,Z vanish.  
%   These event functions are all evaluated in a function of the form
%   [VALUE,ISTERMINAL,DIRECTION] = G(T,Y,Z).  The name of this function is
%   provided as the value of this option.  VALUE(K) is the value of the Kth 
%   event function.  ISTERMINAL(K) = 1 if the integration is to terminate at
%   a zero of this event function and 0 otherwise. DIRECTION(K) = 0 if all 
%   zeros of this event function are to be computed, +1 if only zeros where 
%   the event function is increasing, and -1 if only zeros where the event 
%   function is decreasing.
%   
%MaxStep - Upper bound on step size  [ positive scalar ]
%   MaxStep defaults to one-tenth of the tspan interval in all solvers.
%
%MinStep - Lower bound on step size [ positive scalar ]
%   Minimum resolution desired of the solution.  The solver will accept a 
%   step of this size even if the error test is not passed. When solving
%   DDEs, MinStep must be smaller than the minimum lag.  A warning is issued
%   if a step of size MinStep is accepted.
%
%InitialStep - Suggested initial step size  [ positive scalar ]
%   The solver will try this first.  By default the solvers determine an
%   initial step size automatically.
%   
%Jumps -  Discontinuities in solution [ vector ]
%   Points t where the history or solution may have a jump discontinuity
%   in a low order derivative.
%
%InitialY - Initial value of solution [ vector ]
%   By default the initial value of the solution is the value returned by
%   HISTORY at the initial point.  A different initial value can be supplied
%   as the value of the InitialY property.

%   DDESET is a modification of the ODESET function written by
%   Mark W. Reichelt and Lawrence F. Shampine.

% Print out possible values of properties.
if (nargin == 0) & (nargout == 0)
  fprintf('          AbsTol: [ positive scalar or vector {1e-6} ]\n');
  fprintf('          Events: [ function name ]\n');
  fprintf('        InitialY: [ vector ]\n');
  fprintf('     InitialStep: [ positive scalar ]\n');
  fprintf('           Jumps: [ vector ]\n');  
  fprintf('         MaxStep: [ positive scalar ]\n');
  fprintf('         MinStep: [ positive scalar ]\n');
  fprintf('          RelTol: [ positive scalar {1e-3} ]\n');
  fprintf('           Stats: [ on | {off} ]\n');
  fprintf('\n');
  return;
end

Names = [
         'AbsTol      '
         'Events      '
         'InitialY    '
         'InitialStep '
         'Jumps       '
         'MaxStep     '
         'MinStep     '
         'RelTol      '
         'Stats       '
                       ];
[m,n] = size(Names);
names = lower(Names);

% Combine all leading options structures o1, o2, ... in ddeset(o1,o2,...).
options = [];
for j = 1:m
  eval(['options.' Names(j,:) '= [];']);
end
i = 1;
while i <= nargin
  arg = varargin{i};
  if isstr(arg)                         % arg is an option name
    break;
  end
  if ~isempty(arg)                      % [] is a valid options argument
    if ~isa(arg,'struct')
      error(sprintf(['Expected argument %d to be a string property name ' ...
                     'or an options structure\ncreated with DDESET.'], i));
    end
    for j = 1:m
      if any(strcmp(fieldnames(arg),deblank(Names(j,:))))
        eval(['val = arg.' Names(j,:) ';']);
      else
        val = [];
      end
      if ~isempty(val)
        eval(['options.' Names(j,:) '= val;']);
      end
    end
  end
  i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(nargin-i+1,2) ~= 0
  error('Arguments must occur in name-value pairs.');
end
expectval = 0;                          % start expecting a name, not a value
while i <= nargin
  arg = varargin{i};
    
  if ~expectval
    if ~isstr(arg)
      error(sprintf('Expected argument %d to be a string property name.', i));
    end
    
    lowArg = lower(arg);
    j = strmatch(lowArg,names);
    if isempty(j)                       % if no matches
      error(sprintf('Unrecognized property name ''%s''.', arg));
    elseif length(j) > 1                % if more than one match
      % Check for any exact matches (in case any names are subsets of others)
      k = strmatch(lowArg,names,'exact');
      if length(k) == 1
        j = k;
      else
        msg = sprintf('Ambiguous property name ''%s'' ', arg);
        msg = [msg '(' deblank(Names(j(1),:))];
        for k = j(2:length(j))'
          msg = [msg ', ' deblank(Names(k,:))];
        end
        msg = sprintf('%s).', msg);
        error(msg);
      end
    end
    expectval = 1;                      % we expect a value next
    
  else
    eval(['options.' Names(j,:) '= arg;']);
    expectval = 0;
      
  end
  i = i + 1;
end

if expectval
  error(sprintf('Expected value for property ''%s''.', arg));
end
