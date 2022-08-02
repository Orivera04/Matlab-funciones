function om = setAltMgrs(om,alt);
%SETALTMGRS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:58 $

for i=1:length(alt)
	if isa(alt{i},'function_handle')
		alt{i}= func2str(alt{i});
	end
end
om.Alternatives= alt;