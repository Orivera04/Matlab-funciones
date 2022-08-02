function cb_tabsel(obj,ind)
% CB_TABSEL  Tab callback
%
%   CB_TABSEL(OBJ,IND)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:37:01 $

ud=get(obj.whiteline,'userdata');
if ud.enabled(ind)
   indnow=get(obj.xregcardlayout,'currentcard');
   if indnow~=ind
      PR=xregGui.PointerRepository;
      ptrID=PR.stackSetPointer(get(obj.axes,'parent'),'watch');
      i_firecb(obj,'beforecallback');
      set(obj.xregcardlayout,'currentcard',ind);     
      pr_draw3D(obj);
      pr_drawlabels(obj,[indnow get(obj.xregcardlayout,'currentcard')])
      
      % activate callback
      i_firecb(obj,'callback');
      PR.stackRemovePointer(get(obj.axes,'parent'),ptrID);
   end
end
return



function i_firecb(obj,cb);

ud=get(obj.whiteline,'userdata');
cbstr= ud.(cb);

if ~isempty(cbstr)
   if ischar(cbstr)
      % parse for %CURRENTCARD% and %OBJECT%
      
      pcs=findstr(cbstr,'%');
      
      go=1;
      needobj=0;
      needval=0;
      while (go<=(length(pcs)-1))
         cmp=cbstr(pcs(go)+1:pcs(go+1)-1);
         if strcmp(cmp,'CARD')
            needval=1;
            cbstr=[cbstr(1:pcs(go)-1) 'XX_CARD_XX' cbstr(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+4;
         elseif strcmp(cmp,'OBJECT')
            needobj=1;
            cbstr=[cbstr(1:pcs(go)-1) 'XX_OBJECT_XX' cbstr(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+4;
         else
            go=go+1;
         end
      end
      
      if needobj
         assignin('base','XX_OBJECT_XX',obj);
      end
      if needval
         assignin('base','XX_CARD_XX',get(obj,'currentcard'));
      end
      evalin('base',cbstr);
      
      % clear up base workspace
      evalin('base','clear(''XX_OBJECT_XX'',''XX_CARD_XX'');');   
   elseif iscell(cbstr)
      feval(cbstr{1},obj,[],cbstr{2:end});   
   else
      feval(cbstr,obj,[]);   
   end
end
return
