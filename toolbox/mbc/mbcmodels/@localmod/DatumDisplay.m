function Type= DatumDisplay(m,Type)
% LOCALMOD/DATUMDISPLAY nicer display for response features

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:31 $

for i=1:length(Type)
   Display=Type(i).Display;
   if m.DatumType &  isempty(findstr(Display,'datum'))
      Display= strrep(Display,'(x)','(x+datum)');
      Display = strrep(Display,'(0)','(datum)');
   elseif ~m.DatumType & ~isempty(findstr(Display,'datum'))
      Display= strrep(Display,'(x+datum)','(x)');
      Display = strrep(Display,'(datum)','(0)');
   end
   Type(i).Display= Display;
end