function delete(obj)
%DELETE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:45 $

vec = [obj.text obj.leftbutton obj.edit obj.rightbutton];
delete(vec);