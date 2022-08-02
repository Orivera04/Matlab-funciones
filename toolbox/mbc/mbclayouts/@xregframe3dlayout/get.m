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
%          BORDERS    :   [NORTH EAST SOUTH WEST] border in pixels
%          BACKGROUND :   returns handle to the background axes
%          SELECTED   :   'on' or 'off'
%          BUTTONDOWNFCN : String
%          UICONTEXTMENU : HG handle of context menu attached to background
%          TAGTEXT    :   String on tag object
%          TAGCOLOR   :   Tag colour
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:36 $

ud=get(obj.blackline,'userdata');
switch upper(parameter)
case  'POSITION' 
   res = get(obj.xregcontainer,'position');%-[2 2 -4 -4];
case 'BORDERS'
   res=ud.borders;
case 'BACKGROUND'
   res=obj.background;
case 'BUTTONDOWNFCN'
   res=ud.buttondownfcn;
case 'UICONTEXTMENU'
   res=get(obj.cbobject,'uicontextmenu');
case 'SELECTED'
   if ud.sel
      res='on';
   else
      res='off';
   end
case 'PARENT'
   res=get(obj.axes,'parent');
case 'TAGTEXT'
   res=get(obj.tagtext,'string');
case 'TAGCOLOR'
   res=get(obj.tagback,'facecolor');
case 'VISIBLE'
   res=get(obj.blackline,'visible');
otherwise
   res = get(obj.xregcontainer,parameter);
end
