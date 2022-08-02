function display(s)
%DISPLAY Display object state at command line
%
%  DISPLAY(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:49 $

if strcmp(get(0 , 'formatspacing') , 'loose')
    str = ' ';
else
    str = '';
end

disp(str);
disp([inputname(1) ' =']);
disp(str);
if isempty(s)
    disp('Incomplete or empty SubExpr object')
else
    disp(char(s));
end

disp(str);