function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%
%  See Also
%     methods xregcontainer
%     methods xregringlayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:43 $

ud=obj.g.info;
switch upper(parameter)
case 'RADIUSRATION'
   res = ud.radiusratio;
case 'PHASE'
   res = ud.phase;
otherwise
   res = get(obj.xregcontainer,parameter);
end


