function out = get(obj,prop)
%cgExprModel/GET method.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:40 $
if nargin == 1
	out = get(obj.xregexportmodel);
	out.valptrs = 'vector of pointers to the value pointers';
else
	switch lower(prop)
	case 'valptrs'
		out = obj.valPtrs;
	otherwise  
		try
			out = get(obj.xregexportmodel,prop);
		catch
			error(['cgExprModel\get: Unknown property ' prop '.']);
		end
	end
end