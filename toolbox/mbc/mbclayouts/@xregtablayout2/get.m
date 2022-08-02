function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%  Tablayout2 properties - see tablayout2/set for more information
%     BACKGROUNDCOLOR
%     FOREGROUNDCOLOR
%     TABLABELS
%     MINTABSIZE
%     INNERBORDER
%     ENABLE
%     

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:37:03 $ 

ud=get(obj.whiteline,'userdata');
switch upper(parameter)
case  'POSITION'
   if ud.buttonloc==0
      res = get(obj.xregcardlayout,'position')-[2 2 -4 -24]-ud.innerborder;
   elseif ud.buttonloc==1
      res = get(obj.xregcardlayout,'position')-[2 22 -4 -24]-ud.innerborder;
   end
case 'BACKGROUNDCOLOR'
   res=ud.bgcol;
case 'FOREGROUNDCOLOR'
   res=get(ud.tablabels(1),'foregroundcolor');
case 'VISIBLE'
   res=ud.visible;
case {'TABLABELS','LABELS'}
   res=get(ud.tablabels(:),'string')';
case 'MINTABSIZE'
   res=ud.mintabsize;
case 'CALLBACK'
   res=ud.callback;
case 'INNERBORDER'
   res=[-(ud.innerborder(4)+ud.innerborder(2)) -(ud.innerborder(3)+ud.innerborder(1)) ud.innerborder(2) ud.innerborder(1)];
case 'FIGURE'
   % euphemism for parent, used by tabobject's
   res=get(obj.xregcardlayout,'parent');
case 'ENABLE'
   if all(ud.enabled)
      res='on';
   elseif ~any(ud.enabled)
      res='off';
   else
      res=repmat({'off'},1,length(ud.enabled));
      res((ud.enabled~=0))={'on'}; 
   end
otherwise
   res = get(obj.xregcardlayout,parameter);
end

