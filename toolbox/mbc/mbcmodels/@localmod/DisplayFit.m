function DisplayFit(L,str)
% LOCALMOD/DISPLAYFIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:35 $

h= L.FitOptions.DispHndl;
if ~isempty(h)
   if h==0
      fprintf(str);
      fprintf('\n');
   elseif ishandle(h) & strcmp(get(h,'vis'),'on')
      if ~isempty(findobj(h,'type','uicontrol','style','listbox'))
         OldStr= get(h,'string');
         str= [OldStr; {str}];
         set(h,'string',str,'listboxtop',max(length(str)-5,1),'value',length(str));
      else
         set(h,'string',str);
      end
      drawnow
   end
end
   
