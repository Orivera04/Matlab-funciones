function idccallbacks(callaction)
%IDCCALLBACKS Callback actions specific to IDC.

%   Author(s): C.F.Garvin, 02-07-00
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.3 $   $Date: 2002/04/14 16:22:50 $


switch callaction
  
  case 'nsw'
    
    %NSW,ENT is IDC command to open the IDC's security lookup dialog
    lookdata = idcdatafeed(5,'nsw,ent');
    
    %Add selected securities to list
    if ~isempty(lookdata{1})
      slobj = findobj(gcf,'Tag','SelectedSecurities');
      cursym = get(slobj,'String');
      
      %Append new securities to list
      allsym = [cursym;lookdata];
      [newselsym,ind] = unique(allsym);
      
      %Display new list
      set(slobj,'String',allsym(sort(ind)))
      
    end
    
    %Bring main dialog into focus
    figure(findobj('Tag','DataFeedDlg'));
    
end
