function display(obj)
%DISPLAY Display object state
%
%  DISPLAY(OBJ) displays the object's current state at the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:32 $

if strcmp(get(0 , 'formatspacing') , 'loose')
    str = ' ';
else
    str = '';
end

disp(str);
disp([inputname(1) ' =']);
disp(str);
if isempty(obj)
    disp('Incomplete or empty cgmswitchexpr');
else
    disp(char(obj));
end
disp(str);