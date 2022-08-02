function display(c)
%DISPLAY Display object description at command line
%
%  STR = DISPLAY(C)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:07 $

if strcmp(get(0 , 'formatspacing') , 'loose')
    str = ' ';
else
    str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

if isempty(c)
    disp('Empty Clip Expression');
else
    disp(sprintf('Clip: [%s], min %g, max %g', char(getinputs(c)), c.bound(1), c.bound(2)));
end