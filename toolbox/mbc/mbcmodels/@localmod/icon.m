function [image,ic]= icon(TS);
% LOCALMOD/ICON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:15 $

image= 5:7;
i= 2;

if nargout>1
	% load icon from MAT file
	ic= imread([xregrespath,'\locreg.bmp']);
end
