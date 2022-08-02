function options = setgaopt(varargin)
%SETGAOPT Create/alter GAMINCON options structure.
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:02:14 $

   % Print out possible values of properties.
   if (nargin == 0) & (nargout == 0)
      fprintf('        Display: [ ''off'' | {''none''} | ''iter'' | ''final'' ]\n');
      fprintf('           TolX: [ positive scalar {1e-6} ]\n')
      fprintf('         TolFun: [ positive scalar {1e-6} ]\n');
      fprintf('         TolCon: [ positive scalar {1e-6} ]\n');
      fprintf('        GradObj: [ ''on'' | {''off''} ]\n');
      fprintf('     GradConstr: [ ''on'' | {''off''} ]\n');
      fprintf('  DiffMinChange: [ positive scalar {1e-8} ]\n');
      fprintf('  DiffMaxChange: [ positive scalar {1e-1} ]\n');
      fprintf('    MaxFunEvals: [ positive scalar (integer) ]\n');
      fprintf('        MaxIter: [ positive scalar (integer) {10}]\n');
      fprintf('      MaxGAIter: [ positive scalar (integer) {200} ]\n');
      fprintf('    MaxNoChange: [ positive scalar (integer) {30} ]\n');
      fprintf('  MaxSimilarity: [ positive scalar less than 1 {0.95} ]\n');
      fprintf('        PopSize: [ positive scalar (integer) ]\n');
      fprintf('  Hybridization: [ structure with the fields ''name'' and ''option'' ]\n');
      fprintf('        Fitness: [ structure with the fields ''name'' and ''option'' ]\n');
      fprintf('      Selection: [ structure with the fields ''name'' and ''option'' ]\n');
      fprintf('      Crossover: [ structure with the fields ''name'' and ''option'' ]\n');
      fprintf('       Mutation: [ structure with the fields ''name'' and ''option'' ]\n');
      fprintf('\n');
      return;
   end
   options = struct('Display','',...
		    'TolX',[],...
		    'TolFun',[],...
		    'TolCon',[],...
		    'GradObj','',...
		    'GradConstr','',...
		    'DiffMinChange',[],...
		    'DiffMaxChange',[],...
		    'MaxFunEvals',[],...
		    'MaxIter',[],...
		    'MaxGAIter',[],...
		    'MaxNoChange',[],...
		    'MaxSimilarity',[],...
		    'PopSize',[],...
		    'Hybridization',[],...
		    'Fitness',[],...
		    'Selection',[],...
		    'Crossover',[],...
		    'Mutation',[]);
   numberargs = nargin; % we might change this value, so assign it
   
   % If we pass in a function name then return the defaults.
   if ((numberargs==1) & (ischar(varargin{1}) | isa(varargin{1},'function_handle')))
      if ischar(varargin{1})
	 funcname = lower(varargin{1});
	 if (~exist(funcname))
            error(sprintf('No default options: the function ''%s'' does not exist on the path.',funcname));
	 end
      elseif (isa(varargin{1},'function_handle'))
	 funcname = func2str(varargin{1});
      end
      try 
	 optionsfcn = feval(varargin{1},'defaults');
      catch
	 error(sprintf('No default options available for the function ''%s''.',funcname));
      end
      % To get output, run the rest of optimset as if called with optimset(options, optionsfcn)
      varargin{1} = options;
      varargin{2} = optionsfcn;
      numberargs = 2;
   end
   NAMES = fieldnames(options);
   [m,n] = size(NAMES);
   names = lower(NAMES);
   i = 1;
   while (i <= numberargs)
      arg = varargin{i};
      if isstr(arg)                         % arg is an option name
	 break;
      end
      if (~isempty(arg))                      % [] is a valid options argument
	 if (~isa(arg,'struct'))
            error(sprintf('Expected argument %d to be a string parameter name or an options structure.',i));
	 end
	 for (j = 1:m)
            if (any(strcmp(fieldnames(arg),NAMES{j,:})))
	       val = getfield(arg,NAMES{j,:});
            else
	       val = [];
            end
            if (~isempty(val))
	       if (ischar(val))
		  val = lower(deblank(val));
	       end
	       [valid,errmsg] = checkfield(NAMES{j,:},val);
	       if (valid)
		  options = setfield(options,NAMES{j,:},val);
	       else
		  error(errmsg);
	       end
            end
	 end
      end
      i = i+1;
   end
   % A finite state machine to parse name-value pairs.
   if (rem(numberargs-i+1,2) ~= 0)
      error('Arguments must occur in name-value pairs.');
   end
   expectval = 0;                          % start expecting a name, not a value
   while (i <= numberargs)
      ARG = varargin{i};
      if (~expectval)
	 if (~isstr(ARG))
            error(sprintf('Expected argument %d to be a string parameter name.',i));
	 end
	 arg = lower(ARG);
	 j = strmatch(arg,names);
	 if (isempty(j))                       % if no matches
            error(sprintf('Unrecognized parameter name ''%s''.',ARG));
	 elseif (length(j) > 1)                % if more than one match
	    % Check for any exact matches (in case any names are subsets of others)
	    k = strmatch(arg,names,'exact');
	    if (length(k) == 1)
	       j = k;
            else
	       error(sprintf('Ambiguous parameter name ''%s'' ',ARG))
            end
	 end
	 expectval = 1;                      % we expect a value next
      else           
	 if (ischar(ARG))
            arg = lower(deblank(ARG));
	 else
	    arg = ARG;
	 end
	 [valid,errmsg] = checkfield(NAMES{j,:},arg);
	 if (valid)
            options = setfield(options,NAMES{j,:},arg);
	 else
            error(errmsg);
	 end
	 expectval = 0;
      end
      i = i+1;
   end
   if (expectval)
      error(sprintf('Expected value for parameter ''%s''.',ARG));
   end
   return

function s = setfield(s,field,value)
%SETFIELD Set structure field contents.
%   S = SETFIELD(S,'field',V) sets the contents of the specified
%   field to the value V.  This is equivalent to the syntax S.field = V.
%   S must be a 1-by-1 structure.  The changed structure is returned.
%

   sref.type = '.';
   sref.subs = field;
   s = subsasgn(s,sref,value);
   
function f = getfield(s,field)
%GETFIELD Get structure field contents.
%   F = GETFIELD(S,'field') returns the contents of the specified
%   field.  This is equivalent to the syntax F = S.field.
%   S must be a 1-by-1 structure.  
% 

   sref.type = '.';
   sref.subs = field;
   f = subsref(s,sref);

function [valid,msg] = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   [VALID, MSG] = CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%

   valid = true;
   msg = '';
   % empty matrix is always valid
   if isempty(value)
      return
   end
   switch (field)
   case 'Display'
      if (~isa(value,'char') | ~any(strcmp(value,{'on';'off';'none';'iter';'final'})))
	 valid = false;
	 msg = sprintf('%s option parameter must be: ''off'',''on'',''iter'', or ''final''.',field);
      end
   case {'TolX','TolFun','TolCon','DiffMaxChange','DiffMinChange'}
      if (~(isa(value,'double') & (value >= 0)))
	 valid = false;
	 if ischar(value)
            msg = sprintf('Invalid value for 0PTIONS parameter %s: must be a real positive number (not a string).',field);
	 else
            msg = sprintf('Invalid value for 0PTIONS parameter %s: must be a real positive number.',field);
	 end
      end
   case {'GradConstr','GradObj'}
      if (~isa(value,'char') | ~any(strcmp(value,{'on';'off'})))
	 valid = false;
	 msg = sprintf('%s option parameter must be ''off'' or ''on''.',field);
      end
   case 'MaxFunEvals'
      if (~(isa(value,'double') & (value >= 0) & (round(value) == value)) & ~isequal(value,'100*numberofvariables'))
	 valid = false;
	 if (ischar(value))
            msg = sprintf('%s option parameter must be a positive integer number (not a string).',field);
	 else
            msg = sprintf('%s option parameter must be a positive integer number.',field);
	 end
      end
   case {'MaxIter','MaxGAIter','MaxNoChange','PopSize'}
      if (~(isa(value,'double') & (value >= 0) & (round(value) == value)))
	 valid = false;
	 if (ischar(value))
            msg = sprintf('%s option parameter must be a positive integer number (not a string).',field);
	 else
            msg = sprintf('%s option parameter must be a positive integer number.',field);
	 end
      end
   case 'MaxSimilarity'
      if (~(isa(value,'double') & (value >= 0) & (value <= 1)))
	 valid = false;
	 if (ischar(value))
            msg = sprintf('%s option parameter must be a real positive number (not a string).',field);
	 else
            msg = sprintf('%s option parameter must be a real positive number less than 1.',field);
	 end
      end
   case {'Hybridization','Fitness','Selection','Crossover','Mutation'}
      if (~isa(value,'struct'))
	 valid = false;
	 msg = sprintf('%s option parameter must be a structure array.',field);
      else
	 names = fieldnames(value);
	 if (isempty(strmatch('name',names)) | isempty(strmatch('option',names)))
	    valid = false;
	    msg = sprintf('%s option parameter fields must be ''name'' and ''option''.',field);
	 else
	 end
      end
   otherwise
      error('Unknown field name for Options structure.')
   end
   return
