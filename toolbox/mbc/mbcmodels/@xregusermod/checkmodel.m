function OK= checkmodel(U);
% xregusermod/CHECKMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:58 $


OK=1;
if ~isGrowth(U)
	
	
	mfile= which([name(U),'(U)'] );
	if isempty(mfile)
		error(['User-defined M-File not found: ',name(U)])
	end

	try 
		[LB,UB]= range(U);
		x= (LB+UB)/2;
		y= EvalModel(U,x);
	catch
		error('Cannot evaluate user defined model')
	end
	
	% check in list (add if not)
 	USERMODELS= getpref(mbcprefs('mbc'),'usermodels');
	if ~any(strcmp(name(U),USERMODELS.models))
		% add to list
		modelcfg(U);
	end
	
	
	
	% sone sort of checksum would be useful
	
end