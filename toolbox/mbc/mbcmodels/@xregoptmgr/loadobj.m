function om= loadobj(om,varargin);
% xregoptmgr/LOADOBJ attempts to resolve function handles of 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:56:50 $


% update any parameters that have spaces in them
for n = 1:length(om.foptions)
    if ~isvarname( om.foptions(n).Param )
        oldname = om.foptions(n).Param;
        newname = validmlname( oldname );
        warning('mbc:xregoptmgr:InvalidParameterName',...
            ['Parameter "%s" in "%s" has been renamed "%s".\n',...
            'Parameter names must now be valid MATLAB variable names.'],...
            oldname, om.name, newname);
        om.foptions(n).Param = newname;
    end
end

if isa(om.algorithm,'cell')
	% context algorithm - make sure these are chars
	for i=1:2
		if isa(om.algorithm{i},'function_handle')
			om.algorithm{i}= func2str(om.algorithm{i});
		end
	end
elseif isa(om.algorithm,'function_handle')
	om.algorithm= func2str(om.algorithm);
end

if isstruct(om) | om.version==1
	om= xregoptmgr(om);
	if om.version==1
		om.version= 2;
	end
end

if om.IsMaster
	omrec= i_buildOM(om,varargin{:});
	om=	i_RecoverHandles(om,omrec);
	om.IsMaster= 1;
end

if isfield(om.foptions,'Default')
	om.foptions= mv_rmfield(om.foptions,'Default');
end

function om= i_RecoverHandles(om,omrec)

if ~checkfhandle(om.RunFcn)
	om.RunFcn= omrec.RunFcn;
end
if ~checkfhandle(om.ConstraintFunc)
	om.ConstraintFunc= omrec.ConstraintFunc;
end
if ~checkfhandle(om.costFunc)
	om.costFunc= omrec.costFunc;
end
for i=1:length(om.foptions)
	% loop through options
	CHG=0;
	opt= om.foptions(i);
	if isstruct(opt.Value) & isfield(om,'IsMaster') 
		opt.Value= xregoptmgr(opt.Value);
	end
	
	if isa(opt.Value,'xregoptmgr')
      %moved this line to here - caused problems when omrec had less (ordinary) options than om
      recOpt= omrec.foptions(i); 
		if ~strcmp(opt.Value.name,recOpt.Value.name)
			recOpt.Value= i_buildOM(opt.Value);
		end
		opt.Value= i_RecoverHandles(opt.Value,recOpt.Value);
		opt.CheckInput= 'xregoptmgr';
		CHG= 1;
	end
	if isa(opt.CheckInput,'function_handle')
        
        recOpt= omrec.foptions(i);
		opt.CheckInput= recOpt.CheckInput;
		CHG= 1;
	end
	if CHG
		om.foptions(i)= opt;
	end
end
% this will make inner level optimMgrs nested.
om.IsMaster=0;


function [omrec,om]= i_buildOM(om,varargin);

persistent CTXTLIST

if isempty(CTXTLIST)
	CTXTLIST= {};
end
switch om.Context
case 'rbf'
	om.Context= 'xregrbf';
case 'hybridrbf'
	om.Context= 'xreghybridrbf';
end
if ~isempty(om.Context)
    pos= find(cellfun('isclass',CTXTLIST,om.Context));
    if isempty(pos)
        ctxt= feval(om.Context);
        CTXTLIST=[CTXTLIST {ctxt}];
    else
        ctxt= CTXTLIST{pos};
    end
    if isa(om.algorithm,'cell')
        % context algorithm
        omrec= feval(om.algorithm{2},ctxt,varargin{:});
    elseif ~strcmp(om.algorithm,'contextImplementation')
        try
            omrec= xregoptmgr(om.algorithm,ctxt);
        catch
            omrec= om;
        end
    else
        omrec= om;
    end
else
    omrec= om;
end
	
	
	
function OK=  checkfhandle(fh)

if isa(fh,'function_handle')
	fhinfo= functions(fh);
	OK= (strcmp(fhinfo.type,'subfunction') & isempty(fhinfo.file));
else
	OK= ~isempty(fh);
end
