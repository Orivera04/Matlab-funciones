function display(relexp)
%DISPLAY Display method
%
%  DISPLAY(OBJ) outputs a description of the object to the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $  $Date: 2004/02/09 07:15:17 $

if strmatch(get(0 , 'formatspacing') , 'loose')
    str = ' ';
else
    str = '';
end

disp(str)
if isempty(relexp)
    disp('Empty or incomplete cgrelexpr');
else
    inputs = getinputs(relexp);
    disp(['(', inputs(1).getname, ')', relexpr.rel, '(', inputs(2).getname, ')']);
end
disp(str)
