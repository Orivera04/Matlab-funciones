function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:06 $

switch upper(parameter)
case 'INNERBORDER'
   res=obj.g.info.ib;
case 'NORTH'
   el=get(obj.xreggridlayout,'elements');
   res=el{4};
case 'EAST'
   el=get(obj.xreggridlayout,'elements');
   res=el{8};
case 'WEST'
   el=get(obj.xreggridlayout,'elements');
   res=el{2};
case 'SOUTH'
   el=get(obj.xreggridlayout,'elements');
   res=el{6};
case 'CENTER'
   el=get(obj.xreggridlayout,'elements');
   res=el{5};
otherwise
   res = get(obj.xreggridlayout,parameter);
end
