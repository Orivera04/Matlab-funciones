function display(m)
%DISPLAY Cgminmaxexpr display method
%
%  DISPLAY(OBJ) displays the current state of OBJ at the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:48 $



if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

len = length(getinputs(m));
switch len
case 1
   disp('cgminmaxexpr object containing 1 expression.');
otherwise
   disp(sprint('cgminmaxexpr object containing %d expressions.', len));
end

disp(str);