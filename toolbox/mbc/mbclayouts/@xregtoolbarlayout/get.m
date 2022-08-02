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
%          CENTER      :  returns the object contained in the frame
%          VISIBLE     :  Visible setting for frame
%          TOOLBAR     :  Handle to toolbar contained in layout
%          SPACERWIDTH :  Width in pixels of gap
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:23 $


cdata=get(obj.xregcontainer,'containerdata');
switch upper(parameter)
case 'CENTER'
   res=cdata.elements{1};
case 'VISIBLE'
   res=obj.tb.visible;
case 'TOOLBAR'
   res=obj.tb;
case 'SPACEWIDTH'
   res=obj.rtP.info.SpacerW;
case 'RESOURCELOCATION'
   res=obj.tb.ResourceLocation;
otherwise
   res = get(cdata,parameter);
end
