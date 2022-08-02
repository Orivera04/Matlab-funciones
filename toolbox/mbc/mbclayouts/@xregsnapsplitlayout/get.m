function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%  Example
%          SPLIT      :   Returns 2 element vector indicating fraction
%                         each half takes.  Sum ==1
%          ORIENTATION :  'lr' or 'ud' - indicates split orientation
%          STYLE      
%          SNAPSTYLE
%          STATE
%          CALLBACK   :   Callback string 
%          LEFT/TOP   :   object in pane 1
%          RIGHT/BOTTOM : object in pane 2
%          LEFTINNERBORDER } inner border for left/top pane
%          TOPINNERBORDER  }
%          RIGHTINNERBORDER  } inner border for right/bottom pane
%          BOTTOMINNERBORDER }
%          MINWIDTH       : Minimum width of L and R panes
%          MINWIDTHUNITS  : Units for above: 'pixels' or 'normalized'
%          ENABLE
%          SPLITENABLE
%          BARSTYLE       :0/1  0=raised, 1=flat
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:36:57 $

ud=get(obj.xregcontainer,'userdata');
switch upper(parameter)
case  'POSITION' 
   res = get(obj.xregcontainer,'position');
case 'BARSTYLE'
   res=ud.barstyle;
case 'SPLIT'
   res=ud.split;
case 'ORIENTATION'
   if ud.orientation
      res='ud';
   else
      res='lr';
   end   
case 'STYLE'
   if ud.orientation
      sts={'toleft','leftright','toright'};
   else
      sts={'totop','topbottom','tobottom'};
   end
   res=sts{ud.behaviour+1};
case 'SNAPSTYLE'
   sts={'tozero','tomiddle'};
   res=sts{ud.snapposition+1};
case 'STATE'
   if ud.orientation
      sts={'center','top','bottom'};
   else
      sts={'center','left','right'};
   end
   res=sts{ud.state+1};   
case 'CALLBACK'
   res=ud.callbackstr;
case {'LEFT','TOP'}
   h=get(obj.xregcontainer,'elements');
   if length(h)
      res=h{1};
   else 
      res=[];
   end
case {'RIGHT','BOTTOM'}
   h=get(obj.xregcontainer,'elements');
   if length(h)>1
      res=h{2};
   else 
      res=[];
   end
case 'PARENT'
   res=get(ud.rsbutton,'parent');
case {'LEFTINNERBORDER','TOPINNERBORDER'}
   res=ud.innerborders(1,:);
case {'RIGHTINNERBORDER','BOTTOMINNERBORDER'}
   res=ud.innerborder(2,:);
case 'MINWIDTH'
   res=ud.minwidth;
case 'MINWIDTHUNITS'
   res=ud.minwidthunits;
case 'ENABLE'
   res=ud.rsbutton.enable;
case 'SPLITENABLE'
   res=ud.rsbutton.enable;
otherwise
   res = get(obj.xregcontainer,parameter);
end

