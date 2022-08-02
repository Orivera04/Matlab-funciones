function obj = resetCurrentPoint(obj)
%RESETCURRENTPOINT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:04 $

obj.currentPoint = 1;

if ~isempty(obj.next)
	obj.next = resetCurrentPoint(obj.next);
end