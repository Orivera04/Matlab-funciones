function cnt = count(obj)
%COUNT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:03:00 $

if isempty(obj.next)
	cnt = 1;
else
	cnt = count(obj.next) + 1;
end
