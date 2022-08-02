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
%          RESIZABLE  :   'on' or 'off' - switch status for dynamic resizing
%          ORIENTATION :  'lr' or 'ud' - indicates split orientation
%          DIVIDERSTYLE : Style of divider - '3d' or 'flat'
%          DIVIDERWIDTH : Width of divider strip in pixels
%          CALLBACK   :   Callback string 
%          LEFT/TOP   :   object in pane 1
%          RIGHT/BOTTOM : object in pane 2
%          OUTERBORDER  : Outer border of layout object
%                          Note this property is obsolete: use the container
%                          BORDER property instead.
%          LEFTINNERBORDER } inner border for left/top pane
%          TOPINNERBORDER  }
%          RIGHTINNERBORDER  } inner border for right/bottom pane
%          BOTTOMINNERBORDER }
%          MINWIDTH       : Minimum width of L and R panes
%          MINWIDTHUNITS  : Units for above: 'pixels' or 'normalized'
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:07 $

ud=obj.datastore.info;
switch upper(parameter)
case  'POSITION' 
   res = get(obj.xregcontainer,'position');
case 'VISIBLE'
   if ud.visible
      res='on';
   else
      res='off';
   end
case 'SPLIT'
   res=ud.split;
case 'RESIZABLE'
   if ud.resizable
      res='on';
   else
      res='off';
   end
case 'ORIENTATION'
   if ud.orientation
      res='ud';
   else
      res='lr';
   end   
case 'DIVIDERWIDTH'
   if ud.divstyle
      res='3d';
   else
      res='flat';
   end      
case 'DIVIDERSTYLE'
   res=ud.divwidth;
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
   res=get(obj.rsbutton,'parent');
case 'OUTERBORDER'
   res=get(obj.container,'border');
   res=res(end:-1:1);
case {'LEFTINNERBORDER','TOPINNERBORDER'}
   res=ud.innerborderl;
case {'RIGHTINNERBORDER','BOTTOMINNERBORDER'}
   res=ud.innerborderr;
case 'MINWIDTH'
   res=ud.minwidth;
case 'MINWIDTHUNITS'
   res=ud.minwidthunits;
otherwise
   res = get(obj.xregcontainer,parameter);
end

