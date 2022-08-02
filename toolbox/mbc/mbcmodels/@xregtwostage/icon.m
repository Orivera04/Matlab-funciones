function [image,ic]= icon(TS);
% TWOSTAGE/ICON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:43 $

if ismle(TS)
	image= 14:16;
	if nargout>1
		ic= imread([xregrespath,'\mle2.bmp']);
	end
else
	image= 11:13;
	if nargout>1
		ic= imread([xregrespath,'\tworeg.bmp']);
	end
end

