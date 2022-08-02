function display(c) 
%DISPLAY Hyperfeed connection object display method.

%   Author(s): C.F.Garvin, 03-27-00
%   Copyright 1999-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $   $Date: 2002/04/14 16:23:02 $

tmp = struct(c) ;   %Extract the structure for display

if isequal(get(0,'FormatSpacing'),'compact')  %Display based on formatting
  disp([inputname(1) ' =']);
  disp(tmp)
else
  disp(' ')
  disp([inputname(1) ' =']);
  disp(' ')
  disp(tmp)
end
