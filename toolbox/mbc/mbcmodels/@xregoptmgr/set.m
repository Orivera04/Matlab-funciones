function varargout= set(OM,Property,Value);
% xregoptmgr/SET 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.8.2.3 $  $Date: 2004/02/09 07:56:57 $

if (nargout==0) && (nargin==1)
	% display options on command line
	optstr= cell(length(OM.foptions),1);
	for i= 1:length(OM.foptions)
		optstr{i}= OM.foptions(i).Param;
		cstr=  OM.foptions(i).CheckInput;
		if ~isempty(cstr) 
			if isstr(cstr)
				optstr{i}= [optstr{i} sprintf('  [ %s ]',cstr)];
			else
				% cell option check {type,[LB UB]}
				optstr{i}= [optstr{i} sprintf('  [ %s [%g,%g] ]',cstr{:})];
			end
		end
	end
	disp(char(optstr))
	return
end

opts= upper({OM.foptions.Param});
Property= upper(Property);

pos= findstr(Property,'.');
if ~isempty(pos);
	% uses the dot notation
	mainProp= get(OM,Property(1:pos(1)-1));
	mainProp= set(mainProp,Property(pos(1)+1:end),Value);
	OM= set(OM,Property(1:pos(1)-1),mainProp);
	if nargout>0 | isempty(inputname(1))
		varargout{1}= OM;
	else
		assignin('caller',inputname(1),OM);
	end
	return
end


pind= strmatch(Property,opts);

if isempty(pind)
	% search sub optim managers
	[s,subOM]= suboptimMgrs(OM);
	found=0;
	for i=1:length(subOM);
		try
			subOM{i}= set(subOM{i},Property,Value);
			OM= set(OM,s{i},subOM{i});
			found=found+1;
		end
	end
	if found==0
		error('Invalid property for optimisation manager options')
	elseif found>1
		error('Ambiguous property for optimisation manager')
	end
elseif length(pind)>1
	pind= strmatch(upper(Property),upper(opts),'exact');
	if isempty(pind)
		error('Ambiguous property for optimisation manager')
	end
   % assign new value
	OM.foptions(pind).Value = Value;
else
	cstr= OM.foptions(pind).CheckInput;
	if iscell(cstr)
		copts= cstr{2};
		cstr = cstr{1};
	else
		copts=[];
	end
	if ~isempty(cstr) & isstr(cstr)
		pbar= findstr(cstr,'|');
		if ~isempty(pbar);
			% options are emnumerated strings separated by |'s
			pbar= [1 pbar+1 length(cstr)+1];
			c= cell(length(pbar)-1,1);
			for i= 1:length(pbar)-1
				c{i} = cstr(pbar(i):pbar(i+1)-1);
			end
			optind= strmatch(upper(Value),upper(c));
			if isempty(optind)
				error(['Enumerated type for ',Property,' must be from ',cstr])
			end
        else
            if ~isempty(OM.foptions(pind).Name)
                Property = OM.foptions(pind).Name;
            end
            switch cstr
            case {'numeric','double'}
                if numel(Value)~=1 | ~isnumeric(Value)
                    error(['Scalar numerical input is required for ',Property])
                end
                if isnan(Value)
                    error(['NaN is not supported for ',Property])
                end
                if ~isreal(Value)
                    error(['Complex numbers are not supported for ',Property])
                end
                
                if ~isempty(copts) & (Value<copts(1) | Value>copts(2))
                    error(sprintf('Numerical input must be in range [%g,%g]',copts))
                end
            case {'int','int32'}
                if numel(Value)~=1 | ~isnumeric(Value) | 	Value~=fix(Value) | ~isreal(Value) | isnan(Value)
                    error(['Integer input is required for ',Property])
                end
                if ~isempty(copts) & (Value<copts(1) | Value>copts(2))
                    error(sprintf('Numerical input must be in range [%g,%g]',copts))
                end
            case {'boolean','bool'}
                if ~islogical(Value) & ( isnumeric(Value) & ~any(Value == [0 1]) ) 
                    error(['Boolean input is required for ',Property])
                end
            case	'range'
                if any(~isnumeric(Value))
                    error(['Numeric values are required for ',Property])
                end
                if any(~isreal(Value) | isnan(Value))
                    error(['Complex numbers and NaN''s are not supported for ',Property])
                end
                if ~isempty(copts) & any(Value<copts(1) | Value>copts(2))
                    error(sprintf('Numerical input must be in range [%g,%g]',copts))
                end
                if length(Value) ==2
                    if Value(1) >=Value(2)
                        error(['The range of ' Property ' must be strictly increasing'])
                    end 
                elseif length(Value) == 1
                    % this is OK
                else 
                    error(['One or two numerical values are required for ',Property])
                end
            case 'vector'
                if any(~isnumeric(Value))
                    error(['Numeric values are required for ',Property])
                end
                if any(~isreal(Value) | isnan(Value) | isinf(Value))
                    error(['Complex numbers and NaN''s and Inf''s are not supported for ',Property])
                end
                if ~isempty(copts) & any(Value<copts(1) | Value>copts(2))
                    error(sprintf('All numerical inputs must be in range [%g,%g]',copts))
                end
                if size(Value, 1) > 1
                   error(['Must supply a row vector for ',Property])
                end
            case {'evalstr','MATLAB Callback'}
                OldVal= OM.foptions(pind).Value;	
                if isa(Value,'char') & isa(OldVal,'cell')
                    % {Expr,CatchExpr}
                    OldVal{1}= Value;
                    Value= OldVal;
                elseif ~isa(Value,'cell') | length(Value)~=2 | ~all(cellfun('isclass',Value,'char'))
                    error('Evalstr must either be {Expression,ErrorExpr} or ExpressionString')
                end
            case 'sparse'
                if ~issparse(Value)
                    % sparse is no longer a class
                    error(['Input for ',Property,' must be sparse.'])
                end            
            otherwise
                if ~isa(Value,cstr)
                    % check class
                    error(['Input for ',Property,' must be a ',cstr])
                end
            end
		end
	elseif isa(cstr,'function_handle');
		cstr= OM.foptions(pind).CheckInput;
		if iscell(cstr)
			OK= feval(cstr{:});
		else
			OK= feval(cstr);
		end
	end
	if isa(Value,'xregoptmgr')
		Value.IsMaster= 0;
	end
	% assign new value
	OM.foptions(pind).Value = Value;
	
end	




if nargout>0 | isempty(inputname(1))
   varargout{1}= OM;
else
   assignin('caller',inputname(1),OM);
end