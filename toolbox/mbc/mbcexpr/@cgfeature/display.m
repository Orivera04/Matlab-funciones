function display(SF)
%DISPLAY Display object state.
% 
%  DISPLAY(OBJ) displays the state of OBJ at the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:33 $

if strcmp(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
disp([inputname(1) ' =']);
disp(str)

   if isempty(SF.eqexpr)
       eq = 'no equation';
   else
       eq = 'an equation';
   end
if ~isempty(SF.modelexpr)
    mo = 'a comparison model';
else
    mo = 'no comparison model';
end
if ~isempty(SF.oppoint)
    op = 'an operating point data set';
else
    op = 'no operating point data set';
end

disp(['Feature with ',eq,', ',mo,' and ',op,'.']);