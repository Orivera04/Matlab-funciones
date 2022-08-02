function OK= checkmodel(U);
% DYNAMIC/CHECKMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:46 $


OK=1;


	
	
mfile= which([name(U),'(U)'] );

if isempty(mfile)
	error(['Transient M-File not found: ',name(U)])
end


slName= U.simName;
if exist(slName)~=4
	error(['Cannot find SIMULINK model: ',slName])
end


try 
	[LB,UB]= range(U);
	LB= LB(:)';
	y= EvalModel(U,[0 LB(2:end)]);
catch
	error('Cannot evaluate transient model')
end


% this call may load a mat file with usermods so we want to prevent recursive calls
MODELS= getpref(mbcprefs('mbc'),'dynamic');
if ~any(strcmp(name(U),MODELS.models))
	% add to list
	modelcfg(U);
end

	
