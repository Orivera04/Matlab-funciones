function display(ifexp)
%DISPLAY Ifexpr display method.
%
%  DISPLAY(IFEXP) displays the state of IFEXP at the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:10 $

if strmatch(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

disp(str)
if isempty(ifexp)
   disp('Empty or incomplete cgifexpr');
else
   disp(['IF ',get(ifexp,'leftname'),' < ' ,get(ifexp,'rightname')]);
   disp(['    ',getname(ifexp),' = eval(',get(ifexp,'out1name'),')']);
   disp(['ELSE'])
   disp(['    ',getname(ifexp),' = eval(',get(ifexp,'out2name') ')']);
   disp(['END']);
end
disp(str)