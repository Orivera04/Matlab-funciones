function str = char(s)
%CHAR Return string description of object
%
%  STR = CHAR(OBJ) outputs a string description.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:46 $

if s.NRight==0
   str = get(s,'leftname');
else
   str = [get(s,'leftname'),' - ',get(s,'rightname')];
end
