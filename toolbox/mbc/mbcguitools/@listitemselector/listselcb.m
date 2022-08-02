function listselcb(sl,lsttp)
% LISTSELCB  Callback function for listitemselector
%
%   LISTITEMCB(OBJ,LIST) where LIST is 'base' or 'sel'
%
%   This function handles clicks on the list boxes, and fires
%   the custom callback if necessary.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:05 $

% Created 31/5/2000

ud=get(sl.baselist,'userdata');
if ~isempty(ud.selectfcn)
   switch lsttp
   case 'base'
      index=get(sl.baselist,'value');
      index=ud.unsel(index);
   case 'sel'
      index=get(sl.sellist,'value');
      index=ud.sel(index);
   end
   item=ud.reallist(index);
   
   i_firecb(sl,index,item);
end
return




function i_firecb(sl,index,item)

ud=get(sl.baselist,'userdata');
selectfcn=ud.selectfcn;

if ~isempty(selectfcn)
   if ischar(selectfcn)
      % parse for %INDEX% and %ITEM%
      pcs=findstr(selectfcn,'%');
      
      go=1;
      needitem=0;
      needind=0;
      while (go<=(length(pcs)-1))
         cmp=selectfcn(pcs(go)+1:pcs(go+1)-1);
         if strcmp(cmp,'INDEX')
            needind=1;
            selectfcn=[selectfcn(1:pcs(go)-1) 'XX_SLINDEX_XX' selectfcn(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+6;
         elseif strcmp(cmp,'ITEM')
            needitem=1;
            selectfcn=[selectfcn(1:pcs(go)-1) 'XX_SLITEM_XX' selectfcn(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+6;
         else
            go=go+1;
         end
      end
      
      if needitem
         assignin('base','XX_SLITEM_XX',item);
      end
      if needind
         assignin('base','XX_SLINDEX_XX',index);
      end
      evalin('base',selectfcn);
      
      % clear up base workspace  
      evalin('base','clear(''XX_SLITEM_XX'',''XX_SLINDEX_XX'');');
   else
      if ~iscell(selectfcn)
         selectfcn={selectfcn};
      end
      if length(selectfcn)>1
         feval(selectfcn{1},sl,[],selectfcn{2:end});
      else
         feval(selectfcn{1},sl,[]);
      end 
   end
end
return



