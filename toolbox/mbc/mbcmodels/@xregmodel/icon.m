function [image,ic]= icon(TS);
% LOCALMOD/ICON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:13 $

image= 8:10;

if nargout>1
	% load icon from MAT file
	ic= imread([xregrespath,'\gloreg.bmp']);
end
