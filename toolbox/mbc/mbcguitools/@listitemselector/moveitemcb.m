function moveitemcb(sl,action)
% MOVEITEMCB   Callback for moving items between listboxes
%
%   MOVEITEMCB(SL,TYPE) activates the moveitem callback
%   action can be 'ADDONE', 'REMONE', 'ADDALL', 'REMALL'.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:06 $

% Created 3/2/2000

ud=get(sl.baselist,'userdata');
cb=0;
switch lower(action)
case 'addone'
   % get indices of selected items 
   ind=get(sl.baselist,'value');
   if ~isempty(ud.unsel)
      % use ind to index into remaining objs'
      ind2=ud.unsel(ind);
      ud.unsel(ind)=[];
      ud.sel=union(ud.sel,ind2);
      ind = ind(ind<=length(ud.charlist(ud.unsel)));
      if isempty(ind)
         ind=max(1,length(ud.charlist(ud.unsel)));
      end
      set(sl.baselist,'value',ind,'string',ud.charlist(ud.unsel));
      set(sl.sellist,'string',ud.charlist(ud.sel));
   end
   if ~isempty(ind)
      cb=1;
   end
case 'remone'
   % get indices of selected items 
   ind=get(sl.sellist,'value');
   if ~isempty(ud.sel)
      % use ind to index into remaining objs'
      ind2=ud.sel(ind);
      ud.sel(ind)=[];
      ud.unsel=union(ud.unsel,ind2);
      ind = ind(ind<=length(ud.charlist(ud.sel)));
      if isempty(ind)
         ind=max(1,length(ud.charlist(ud.sel)));
      end
      set(sl.baselist,'string',ud.charlist(ud.unsel));
      set(sl.sellist,'value',ind,'string',ud.charlist(ud.sel));
   end
   if ~isempty(ind)
      cb=1;
   end
case 'addall'
   if ~isempty(ud.unsel)
      cb=1;
   end
   ud.sel=[1:length(ud.reallist)];
   ud.unsel=[];
   set(sl.baselist,'value',1,'string','');
   set(sl.sellist,'value',1,'string',ud.charlist); 
case 'remall'
   if ~isempty(ud.sel)
      cb=1;
   end
   ud.unsel=[1:length(ud.reallist)];
   ud.sel=[];
   set(sl.sellist,'value',1,'string','');
   set(sl.baselist,'value',1,'string',ud.charlist);
end
set(sl.baselist,'userdata',ud);

h=[sl.remone;sl.remall; sl.addone;sl.addall];
en={'off';'off';'off';'off'};
if ~isempty(ud.sel)
   en(1:2)={'on'};
end
if ~isempty(ud.unsel)
   en(3:4)={'on'};
end
set(h,{'enable'},en);

if cb & ~isempty(ud.callback)
   i_firecb(sl);
end
return



function i_firecb(sl)

ud=get(sl.baselist,'userdata');
cb=ud.callback;
if ~isempty(cb)
   if ischar(cb)
      evalin('base',cb);
   else
      if ~iscell(cb)
         cb={cb};
      end
      if length(cb)>1
         feval(cb{1},sl,[],cb{2:end});
      else
         feval(cb{1},sl,[]);
      end 
   end  
end
return
