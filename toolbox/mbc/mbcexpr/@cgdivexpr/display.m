function display(d)
%DISPLAY Display method
%
%  DISPLAY(OBJ) will display the state of the object at the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:39 $

if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str);
disp([inputname(1) ' =']);
disp(str);
if isempty(d)
   disp('Incomplete or empty cgdivexpr');
else
   disp(char(d));
end
disp(str);