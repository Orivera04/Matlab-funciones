function om =createom(om,cos, evalFcn, omname, params);
%XREGOPTMGR/CREATEOM interface to creates an xregoptmgr
%
% om =createom(om,cos, evalFcn, omname, params);
%    om       xregoptimgr
%    cos      context object
%    evalFcn  function to evaluate/run optimisation
%    omname   name for optmgr
%    params   either xregoptmgr, struct with fields type, label, value, or a cell array {type, label, value}



%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:56:43 $

% this method was written to support cgoptim problems

if nargin<4
    omname = om.name;
    params = [];
end

% update the om based on inputs
om.RunFcn= evalFcn;
om.Context= class(cos);
om.name = omname;

if isempty( params )
    % nothing more to do
    return;
end

if isa(params,'xregoptmgr');
    % parameters is an option so make an option parameter
    om  = AddOption(om,'Options',params, 'xregoptmgr');
    return
elseif iscell(params)
    % convert cell array
    d2= cellfun('size',params,2);
    if any(d2~=3)
        error(['Incorrect number of fields in parameter structure in entries ',sprintf('%d ',find(d2~=3))])
    end
    params= cat(1,params{:});
    params= struct('type',params(:,1),'label',params(:,2),'value',params(:,3));
elseif isstruct(params)
    % structure array with type, value, label field
    expectednames= {'type','value','label'};
    fnames= fieldnames(params);
    
    if ~all(ismember(expectednames,fnames))
        error('Structure with fields ''type'',''label'',''value'' is required')
    end
else
    error('Invalid input');
end    

% add all the options with some parsing
for i=1:length(params);
    type = params(i).type;
    name = params(i).label;
    default_value = params(i).value;
    
    % do some preliminary parsing
    switch lower(type)
    case 'int'
        if numel(default_value)~=1 | ~isnumeric(default_value) | 	default_value~=fix(default_value) | ~isreal(default_value) | isnan(default_value)
            error(['Parse error: ', default_value, ' not int']);
        end     
        om  = AddOption(om, name, default_value, {'int', [-Inf, Inf]});
    case {'double', 'number'}
        if ~isa(default_value, 'double');
            error(['Parse error: ', default_value, ', not double']);
        end
        om  = AddOption(om, name, default_value, {'numeric', [-Inf, Inf]});
    case {'boolean', 'checkbox'}
        if ~islogical(default_value) 
            error(['Parse error: ', default_value, ' not boolean']);
        end  
        om  = AddOption(om, name, default_value, 'boolean');
    case {'char', 'list'}
        if ~ischar('char');
            error(['Parse error: ', default_value, ' not char']);
        end
        ind = find(default_value == '|');
        if isempty(ind);
            om  = AddOption(om, name, default_value, default_value);
        else
            ind = ind(1);
            om  = AddOption(om, name, default_value(1:ind-1), default_value);
        end
    case 'vector'
        if ~isa(default_value, 'double');
            error(['Parse error: ', default_value, ', not double']);
        end
        om  = AddOption(om, name, default_value, {'vector', [-Inf, Inf]});  
    otherwise
        error(['Parse error: the type ', type, ' has been defined in params']);    
    end
end

