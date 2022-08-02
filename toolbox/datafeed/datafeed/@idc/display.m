function display(c)
%DISPLAY IDC connection object display method.

%   Author(s): C.F.Garvin, 12-07-99
%   Copyright 1999-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $   $Date: 2002/04/14 16:23:52 $

tmp = struct(c);   %Extract the structure for display

%Need calls to check queued and status fields

if isequal(get(0,'FormatSpacing'),'compact')  %Display based on formatting
  disp([inputname(1) ' =']);
  disp(tmp)
else
  disp(' ')
  disp([inputname(1) ' =']);
  disp(' ')
  disp(tmp)
end
